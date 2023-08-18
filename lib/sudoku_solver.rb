# frozen_string_literal: true

require 'set'
require_relative './sudoku_board'

# Sudoku Solving Class
# Initialize with 2d array representation of sudoku board
class SudokuSolver
  attr_reader :sudoku

  def initialize(board)
    @sudoku = SudokuBoard.new(board)
  end

  # Attempt to solve board using backtracking/dfs and return bool if successful and (un)solved board
  def backtrack_solve
    [dfs(0), sudoku.board]
  end

  def constraint_solve
    constraints = sudoku.board.map do |row|
      row.map { |value| value.zero? ? Set.new((1..9)) : Set.new([value]) }
    end

    continue = true
    while continue
      continue = false

      constraints.each_index do |r|
        constraints[r].each_with_index do |constraint, c|
          next unless constraint.size == 1

          continue = true
          sudoku.guess(r, c, constraint.take(1)[0])
          propagate_constraint(constraints, r, c, constraint)
        end
      end

      continue ||= propagate_sets(constraints)
    end

    [true, sudoku.board]
  end

  private

  def dfs(index)
    return true if index >= 81

    row = index / 9
    col = index % 9

    # Move to next square if already filled in
    return dfs(index + 1) unless sudoku.empty_cell?(row, col)

    # Attempt to solve using 1-9, return true if solution is found
    (1..9).each do |value|
      next unless sudoku.valid_guess?(row, col, value)

      sudoku.guess(row, col, value)
      return true if dfs(index + 1)

      sudoku.remove_guess(row, col)
    end

    false
  end

  def propagate_constraint(constraints, row, col, constraint)
    # Propagate constraint across row
    9.times { |c| constraints[row][c] -= constraint }

    # Propagate constraint across column
    9.times { |r| constraints[r][col] -= constraint }

    # Propagate constraint across box
    box_row_start = (row / 3) * 3
    box_col_start = (col / 3) * 3
    (box_row_start...box_row_start + 3).each do |r|
      (box_col_start...box_col_start + 3).each do |c|
        constraints[r][c] -= constraint
      end
    end
  end

  def propagate_sets(constraints)
    propagate_row_constraints(constraints)   ||
      propagate_col_constraints(constraints) ||
      propagate_box_constraints(constraints)
  end

  def propagate_row_constraints(constraints)
    # Flag if constraints were able to be reduced
    constraints_reduced = false

    9.times do |row|
      sets = Hash.new { |h, k| h[k] = [] }
      9.times { |col| sets[constraints[row][col]] << constraints[row][col] }

      sets.each do |constraint, group|
        next if constraint.size < 2 || constraint.size > 4 || constraint.size != group.size

        9.times do |col|
          next if constraints[row][col] == constraint || !constraints[row][col].intersect?(constraint)

          constraints_reduced = true
          constraints[row][col] -= constraint
        end
      end
    end

    constraints_reduced
  end

  def propagate_col_constraints(constraints)
    # Flag if constraints were able to be reduced
    constraints_reduced = false

    9.times do |col|
      sets = Hash.new { |h, k| h[k] = [] }
      9.times { |row| sets[constraints[row][col]] << constraints[row][col] }

      sets.each do |constraint, group|
        next if constraint.size < 2 || constraint.size > 4 || constraint.size != group.size

        9.times do |row|
          next if constraints[row][col] == constraint || !constraints[row][col].intersect?(constraint)

          constraints_reduced = true
          constraints[row][col] -= constraint
        end
      end
    end

    constraints_reduced
  end

  def propagate_box_constraints(constraints)
    # Flag if constraints were able to be reduced
    constraints_reduced = false
    box_ranges = [(0..2), (3..5), (6..8)]

    box_ranges.each do |rows|
      box_ranges.each do |cols|
        sets = Hash.new { |h, k| h[k] = [] }
        rows.each do |row|
          cols.each do |col|
            sets[constraints[row][col]] << constraints[row][col]

            sets.each do |constraint, group|
              next if constraint.size < 2 || constraint.size > 4 || constraint.size != group.size

              rows.each do |r|
                cols.each do |c|
                  next if constraints[r][c] == constraint || !constraints[row][col].intersect?(constraint)

                  constraints[r][c] -= constraint
                end
              end
            end
          end
        end
      end
    end

    constraints_reduced
  end
end

board = [
  [0, 0, 0, 8, 3, 2, 0, 9, 0],
  [0, 0, 0, 0, 0, 5, 7, 0, 6],
  [1, 0, 0, 6, 0, 0, 0, 0, 0],
  [3, 0, 0, 0, 0, 0, 0, 0, 0],
  [6, 7, 4, 0, 0, 0, 8, 5, 1],
  [0, 0, 0, 0, 0, 0, 0, 0, 7],
  [0, 0, 0, 0, 0, 1, 0, 0, 5],
  [9, 0, 2, 5, 0, 0, 0, 0, 0],
  [0, 3, 0, 2, 7, 6, 0, 0, 0]
]
solution = [
  [7, 5, 6, 8, 3, 2, 1, 9, 4],
  [2, 9, 3, 4, 1, 5, 7, 8, 6],
  [1, 4, 8, 6, 9, 7, 5, 2, 3],
  [3, 8, 1, 7, 5, 4, 9, 6, 2],
  [6, 7, 4, 3, 2, 9, 8, 5, 1],
  [5, 2, 9, 1, 6, 8, 3, 4, 7],
  [4, 6, 7, 9, 8, 1, 2, 3, 5],
  [9, 1, 2, 5, 4, 3, 6, 7, 8],
  [8, 3, 5, 2, 7, 6, 4, 1, 9]
]

board.each { |r| p r }
p ''
solver = SudokuSolver.new(board)
solver.constraint_solve
solver.sudoku.board.each { |r| p r }
p ''
solution.each { |r| p r }