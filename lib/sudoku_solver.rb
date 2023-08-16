# frozen_string_literal: true

require 'sudoku_board'

# Sudoku Solving Class
# Initialize with 2d array representation of sudoku board
class SudokuSolver
  attr_reader :sudoku

  def initialize(board)
    @sudoku = SudokuBoard.new(board)
  end

  # Attempt to solve board using backtracking/dfs and return 2d array of solution
  def backtrack
    dfs(0)
    sudoku.board
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
end
