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

    progress = true
    while progress
      progress = false

      constraints.each_index do |r|
        constraints[r].each_with_index do |constraint, c|
          next unless constraint.size == 1

          progress = true
          sudoku.guess(r, c, constraint.take(1)[0])
          propogate_constraint(constraints, r, c, constraint)
        end
      end

      propogate_sets(constraints)
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

  def propogate_constraint(constraints, row, col, constraint)
    # Propogate constraint across row
    constraints[row].each_index { |c| constraints[row][c] -= constraint }

    # Propogate constraint across column
    constraints.each_index { |r| constraints[r][col] -= constraint }

    # Propogate constraint across box
    box_row_start = (row / 3) * 3
    box_col_start = (col / 3) * 3
    (box_row_start...box_row_start + 3).each do |r|
      (box_col_start...box_col_start + 3).each do |c|
        constraints[r][c] -= constraint
      end
    end
  end

  def propogate_sets(constraints)
    propogate_row_constraints(constraints)
    propogate_col_constraints(constraints)
    propogate_box_constraints(constraints)
  end

  def propogate_row_constraints(constraints)
    constraints.each do |row|
      sets = row.group_by { |constraint| constraint }
      sets.each do |constraint, group|
        next if constraint.size < 2 || constraint.size > 4 || constraint.size != group.size

        row.map! { |cons| cons == constraint ? cons : cons - constraint }
      end
    end
  end

  def propogate_col_constraints(constraints)
    constraints[0].each_index do |col|
      sets = Hash.new { |h, k| h[k] = [] }
      constraints.each_index { |row| sets[constraints[row][col]] << constraints[row][col] }

      sets.each do |constraint, group|
        next if constraint.size < 2 && constraint.size > 4 || constraint.size != group.size

        constraints.each_index do |row|
          next if constraints[row][col] == constraint

          constraints[row][col] -= constraint
        end
      end
    end
  end

  def propogate_box_constraints(constraints)
    box_ranges = [(0..2), (3..5), (6..8)]

    box_ranges.each do |rows|
      box_ranges.each do |cols|
        sets = Hash.new { |h, k| h[k] = [] }
        rows.each do |row|
          cols.each do |col|
            sets[constraints[row][col]] << constraints[row][col]

            sets.each do |constraint, group|
              next if constraint.size < 2 && constraint.size > 4 || constraint.size != group.size

              rows.each do |r|
                cols.each do |c|
                  next if constraints[r][c] == constraint

                  constraints[r][c] -= constraint
                end
              end
            end
          end
        end
      end
    end
  end
end
