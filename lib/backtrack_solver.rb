# frozen_string_literal: true

# Sudoku Solving Algorithm Implemented with Backtracking
# Initialized with sudoku board and then able to solve (if possible) using #solve
class BacktrackSolver
  attr_reader :sudoku

  def initialize(sudoku)
    @sudoku = sudoku
  end

  # Attempt to solve with DFS, return array with [is_solved, sudoku_board]
  def solve
    dfs(0) ? [true, @sudoku.board] : [false, @sudoku.initial_board]
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
