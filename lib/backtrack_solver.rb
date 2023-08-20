# frozen_string_literal: true

# Sudoku solving algorithm implemented using backtracking
class BacktrackSolver
  attr_reader :sudoku

  def initialize(sudoku)
    @sudoku = sudoku
  end

  def solve
    [dfs(0), @sudoku.board]
  end

  private

  def dfs(index)
    return true if index >= 81

    row = index / 9
    col = index % 9

    # Move to next square if already filled in
    return dfs(index + 1) unless @sudoku.empty_cell?(row, col)

    # Attempt to solve using 1-9, return true if solution is found
    (1..9).each do |value|
      next unless @sudoku.valid_guess?(row, col, value)

      @sudoku.guess(row, col, value)
      return true if dfs(index + 1)

      @sudoku.remove_guess(row, col)
    end

    false
  end
end
