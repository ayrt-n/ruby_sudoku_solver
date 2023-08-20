# frozen_string_literal: true

require 'set'

# Sudoku Solving Algorithm Implemented with Constraint Propagation
# Initialized with sudoku board and then able to solve (if possible) using #solve
class ConstraintPropagationSolver
  attr_reader :sudoku

  def initialize(sudoku)
    @sudoku = sudoku
    build_constraints_matrix(sudoku)
  end

  # Main algorithm, attempts to solve using constraint propagation until no more progress can be made
  # If not solvable with constraint propagation, switch to backtracking to complete
  def solve
    progress = [true]
    while progress.any?
      progress = [propagate_single_constraints,
                  propagate_row_constraints,
                  propagate_col_constraints,
                  propagate_box_constraints]
    end

    [dfs(0), @sudoku.board]
  end

  private

  # Builds intiial constraints matrix using provided sudoku board
  def build_constraints_matrix(sudoku)
    @constraints = sudoku.board.map do |row|
      row.map { |value| value.zero? ? Set.new((1..9)) : Set.new([value]) }
    end

    @constraints.each_index do |r|
      @constraints[r].each_with_index do |constraint, c|
        next unless constraint.size == 1

        propagate_single_constraint(constraint, r, c)
      end
    end
  end

  # Attempt to solve sudoku using DFS and constraints matrix, return bool if solved
  def dfs(index)
    return true if index >= 81

    row = index / 9
    col = index % 9

    # Move to next square if already filled in
    return dfs(index + 1) unless @sudoku.empty_cell?(row, col)

    # Attempt to solve using remaining constrained values, return true if solution is found
    @constraints[row][col].each do |value|
      next unless @sudoku.valid_guess?(row, col, value)

      @sudoku.guess(row, col, value)
      return true if dfs(index + 1)

      @sudoku.remove_guess(row, col)
    end

    false
  end

  # Iterates through constraints matrix and fills in sudoku board if position found with only one possible value
  # After filling in the board, propagate constraint by removing this value from all other cells in row/col/box
  def propagate_single_constraints
    changes_made = false

    @constraints.each_index do |r|
      @constraints[r].each_with_index do |constraint, c|
        next if constraint.size > 1 || @sudoku.board[r][c].positive? ||
                !@sudoku.valid_guess?(r, c, constraint.take(1)[0])

        changes_made = true
        @sudoku.guess(r, c, constraint.take(1)[0])
        propagate_single_constraint(constraint, r, c)
      end
    end

    changes_made || false
  end

  # Find naked sets (doubles, triples, and quads) in row and propagate constraint 
  def propagate_row_constraints
    changes_made = false

    9.times do |row|
      sets = Hash.new { |h, k| h[k] = [] }
      9.times { |col| sets[@constraints[row][col]] << @constraints[row][col] }

      sets.each do |constraint, group|
        next if constraint.size < 2 || constraint.size > 4 || constraint.size != group.size

        changes_made = true if propagate_row_constraint(constraint, row)
      end
    end

    changes_made
  end

  # Find naked sets (doubles, triples, and quads) in col and propagate constraint
  def propagate_col_constraints
    changes_made = false

    9.times do |col|
      sets = Hash.new { |h, k| h[k] = [] }
      9.times { |row| sets[@constraints[row][col]] << @constraints[row][col] }

      sets.each do |constraint, group|
        next if constraint.size < 2 || constraint.size > 4 || constraint.size != group.size

        changes_made = true if propagate_col_constraint(constraint, col)
      end
    end

    changes_made
  end

  # Find naked sets (doubles, triples, and quads) in box and propagate constraint
  def propagate_box_constraints
    changes_made = false
    box_ranges = [(0..2), (3..5), (6..8)]

    box_ranges.each do |rows|
      box_ranges.each do |cols|
        sets = Hash.new { |h, k| h[k] = [] }
        rows.each do |row|
          cols.each do |col|
            sets[@constraints[row][col]] << @constraints[row][col]

            sets.each do |constraint, group|
              next if constraint.size < 2 || constraint.size > 4 || constraint.size != group.size

              changes_made = true if propagate_box_constraint(constraint, row, col)
            end
          end
        end
      end
    end

    changes_made
  end

  # Propagate a single constraint across row, col, and box
  def propagate_single_constraint(constraint, row, col)
    propagate_row_constraint(constraint, row)
    propagate_col_constraint(constraint, col)
    propagate_box_constraint(constraint, row, col)
  end

  # For a given constraint, iterate through a box and propagate that constraint across the box to other values
  def propagate_box_constraint(constraint, row, col)
    changes_made = false

    box_row_start = (row / 3) * 3
    box_col_start = (col / 3) * 3
    (box_row_start...box_row_start + 3).each do |r|
      (box_col_start...box_col_start + 3).each do |c|
        next if @constraints[r][c] == constraint || !@constraints[r][c].intersect?(constraint)

        changes_made = true
        @constraints[r][c] -= constraint
      end
    end

    changes_made
  end

  # For a given constraint, iterate through row and propagate that constraint across the row to other values
  def propagate_row_constraint(constraint, row)
    changes_made = false

    9.times do |col|
      next if @constraints[row][col] == constraint || !@constraints[row][col].intersect?(constraint)

      changes_made = true
      @constraints[row][col] -= constraint
    end

    changes_made
  end

  # For a given constraint, iterate through col and propagate that constraint across the col to other values
  def propagate_col_constraint(constraint, col)
    changes_made = false

    9.times do |row|
      next if @constraints[row][col] == constraint || !@constraints[row][col].intersect?(constraint)

      changes_made = true
      @constraints[row][col] -= constraint
    end

    changes_made
  end
end
