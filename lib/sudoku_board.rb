# frozen_string_literal: true

# Class representation of sudoku board
class SudokuBoard
  attr_reader :board, :board_properties

  def initialize(board)
    @board = board
    @board_properties = create_board_properties_hash
    @initial_board = Marshal.load(Marshal.dump(board))
  end

  # Place guess on board and return bool if successful (can not change initial board values)
  def guess(row, col, value)
    return false unless @initial_board[row][col].zero?

    @board[row][col] = value
    @board_properties[:row][row][value] = true
    @board_properties[:col][col][value] = true
    @board_properties[:box][3 * (row / 3) + (col / 3)][value] = true
  end

  # Place guess on board and return bool if successful (can not change initial board values)
  def remove_guess(row, col)
    return false unless @initial_board[row][col].zero?

    value = @board[row][col]
    @board[row][col] = 0
    @board_properties[:row][row][value] = nil
    @board_properties[:col][col][value] = nil
    @board_properties[:box][3 * (row / 3) + (col / 3)][value] = nil

    true
  end

  # Check if valid guess and return bool
  def valid_guess?(row, col, value)
    return false if @board_properties[:row][row][value] ||
                    @board_properties[:col][col][value] ||
                    @board_properties[:box][3 * (row / 3) + (col / 3)][value]

    true
  end

  def empty_cell?(row, col)
    board[row][col].zero?
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
end
