# frozen_string_literal: true

require 'set'
require_relative './sudoku_board'

# Sudoku Solving Class - Implemented via Strategy Pattern
# Solving of puzzle delegated to underlying algorithm provided on initialization
class SudokuSolver
  attr_reader :sudoku

  def initialize(board, solver)
    @sudoku = SudokuBoard.new(board)
    @solver = solver
  end

  def solve
    @solver.solve(sudoku)
  end
end