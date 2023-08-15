# frozen_string_literal: true

# Sudoku Solving Class
# Initialize with 2d array representation of sudoku board
class SudokuSolver
  attr_reader :board, :solution, :solved

  def initialize(board)
    @board = board
    @solution = board
    @solved = false
  end
end
