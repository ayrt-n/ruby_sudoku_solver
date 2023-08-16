# frozen_string_literal: true

# Sudoku Solving Class
# Initialize with 2d array representation of sudoku board
class SudokuSolver
  attr_reader :board, :solution

  def initialize(board)
    @board = board
    @solution = board
    @solution_properties = create_board_properties_hash
  end

  # Attenpt to solve board using backtracking/dfs and return 2d array of solution
  def backtrack
    dfs(0)
    solution
  end

  private

  # Create and return hash containing properties of board for easy validation (row, col, and box values)
  def create_board_properties_hash
    board_properties = Hash.new { |h, k| h[k] = Array.new(9) { Array.new(10) } }

    board.each_index do |r|
      board[r].each_with_index do |value, c|
        next if value.zero?

        b = 3 * (r / 3) + (c / 3)
        board_properties[:row][r][value] = true
        board_properties[:col][c][value] = true
        board_properties[:box][b][value] = true
      end
    end

    board_properties
  end

  def dfs(index)
    return true if index >= 81

    row, col, box = index / 9
    col = index % 9
    box = 3 * (row / 3) + (col / 3)

    # Move to next square if already filled in
    return dfs(index + 1) unless solution[row][col].zero?

    # Attempt to solve using 1-9, return true if solution is found
    (1..9).each do |value|
      next unless valid_guess?(row, col, box, value)

      @solution_properties[:row][row][value] = true
      @solution_properties[:col][col][value] = true
      @solution_properties[:box][box][value] = true

      if dfs(index + 1)
        solution[row][col] = value
        return true
      end

      @solution_properties[:row][row][value] = false
      @solution_properties[:col][col][value] = false
      @solution_properties[:box][box][value] = false
    end

    false
  end

  def valid_guess?(row, col, box, value)
    return false if @solution_properties[:row][row][value] ||
                    @solution_properties[:col][col][value] ||
                    @solution_properties[:box][box][value]

    true
  end
end
