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

  # Solve board using backtracking - Returns 2d array of solution
  def backtrack
    return solution if solved

    dfs(0)
    solution
  end

  private

  def dfs(index)
    return true if index >= 81

    row = index / 9
    col =  index % 9
    return dfs(index + 1) unless solution[row][col].zero?

    # Attempt to solve using 1-9, return true if solution is found
    (1..9).each do |v|
      next unless valid_guess?(row, col, v)

      solution[row][col] = v
      return true if dfs(index + 1)

      solution[row][col] = 0
    end

    false
  end

  def valid_guess?(row, col, value)
    # Check row
    return false if solution[row].include?(value)

    # Check col
    9.times do |r|
      return false if solution[r][col] == value
    end

    # Check box
    row_start = 3 * (row / 3)
    col_start = 3 * (col / 3)
    (row_start...row_start + 3).each do |r|
      (col_start...col_start + 3).each do |c|
        return false if solution[r][c] == value
      end
    end

    true
  end
end
