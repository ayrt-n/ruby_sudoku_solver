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
    solved = 0
    constraints = Array.new(9) { Array.new(9) { Set.new((1..9).to_a) } }

    # while progress_made
      sudoku.board.each_index do |r|
        sudoku.board[r].each_with_index do |value, c|
          if value.zero? && !constraints[r][c].empty?
            constraints[r][c] = Set.new([])
            solved += 1 + propogate_constraints(constraints, r, c, value)
          else
            # propogate_sets(constraints, r, c)
          end
        end
      end
    # end

    solved
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

  def propogate_constraints(matrix, row, col, value)
    solved = 0

    # Propogate constraint across row
    matrix[row].each_index do |c|
      next unless matrix[row][c].size > 1

      matrix[row][c].delete(value)
      if matrix[row][c].size == 1
        sudoku.guess(row, c, matrix[row][c].take(1)[0])
        solved += 1
      end
    end

    # Propogate constraint across column
    matrix.each_index do |r|
      next unless matrix[r][col].size > 1

      matrix[r][col].delete(value)
      if matrix[r][col].size == 1
        sudoku.guess(r,col, matrix[r][col].take(1)[0])
        solved += 1
      end
    end

    # Propogate constraint across box
    box_row_start = (row / 3) * 3
    box_col_start = (col / 3) * 3
    (box_row_start...box_row_start + 3).each do |r|
      (box_col_start...box_col_start + 3).each do |c|
        next unless matrix[r][c].size > 1

        matrix[r][c].delete(value)
        if matrix[r][c].size == 1
          sudoku.guess(r, c, matrix[r][c].take(1)[0])
          solved += 1
        end
      end
    end

    solved
  end
end

board = [
  [5, 3, 0, 0, 7, 0, 0, 0, 0],
  [6, 0, 0, 1, 9, 5, 0, 0, 0],
  [0, 9, 8, 0, 0, 0, 0, 6, 0],
  [8, 0, 0, 0, 6, 0, 0, 0, 3],
  [4, 0, 0, 8, 0, 3, 0, 0, 1],
  [7, 0, 0, 0, 2, 0, 0, 0, 6],
  [0, 6, 0, 0, 0, 0, 2, 8, 0],
  [0, 0, 0, 4, 1, 9, 0, 0, 5],
  [0, 0, 0, 0, 8, 0, 0, 7, 9]
]

solver = SudokuSolver.new(board)
solver.constraint_solve
solver.sudoku.board.each { |r| p r }