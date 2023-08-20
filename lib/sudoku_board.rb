# frozen_string_literal: true

# Class representation of sudoku board
class SudokuBoard
  attr_reader :initial_board, :board, :board_properties

  def initialize(board)
    # Create board instance variable and board properties hash
    @board = board
    @board_properties = create_board_properties_hash

    # Create deep copy of initial board to keep track of original values
    @initial_board = Marshal.load(Marshal.dump(board))
  end

  # Place guess on board and return bool if successful (can not change initial board values)
  def guess(row, col, value)
    return false unless @initial_board[row][col].zero?

    remove_guess(row, col) unless @board[row][col].zero?

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

  # Return bool if guess is valid. In this case, valid means the value does not yet exist in the same row/col/box
  def valid_guess?(row, col, value)
    return false if @board_properties[:row][row][value] ||
                    @board_properties[:col][col][value] ||
                    @board_properties[:box][3 * (row / 3) + (col / 3)][value]

    true
  end

  # Return bool if cell is empty
  def empty_cell?(row, col)
    board[row][col].zero?
  end

  # Return bool if board is complete and valid
  def complete?
    validation = Hash.new { |h, k| h[k] = Array.new(9) { Array.new(10) } }

    board.each_index do |r|
      board[r].each_with_index do |value, c|
        b = 3 * (r / 3) + (c / 3)
        return false if value.zero? || validation[:row][r][value] ||
                        validation[:col][c][value] || validation[:box][b][value]

        validation[:row][r][value], validation[:col][c][value], validation[:box][b][value] = [true] * 3
      end
    end

    true
  end

  # Reset board to original values
  def reset
    @board = Marshal.load(Marshal.dump(@initial_board))
  end

  private

  # Create and return hash containing properties of board for easy validation (row, col, and box values)
  def create_board_properties_hash
    properties = Hash.new { |h, k| h[k] = Array.new(9) { Array.new(10) } }

    board.each_index do |r|
      board[r].each_with_index do |value, c|
        next if value.zero?

        b = 3 * (r / 3) + (c / 3)
        properties[:row][r][value], properties[:col][c][value], properties[:box][b][value] = [true] * 3
      end
    end

    properties
  end
end
