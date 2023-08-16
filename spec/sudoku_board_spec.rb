# frozen_string_literal: true

require 'sudoku_board'

describe SudokuBoard do
  describe '#guess' do
    context 'when valid move' do
      it 'adds value to board and updates board properties' do
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
        board_with_guess = [
          [5, 3, 9, 0, 7, 0, 0, 0, 0],
          [6, 0, 0, 1, 9, 5, 0, 0, 0],
          [0, 9, 8, 0, 0, 0, 0, 6, 0],
          [8, 0, 0, 0, 6, 0, 0, 0, 3],
          [4, 0, 0, 8, 0, 3, 0, 0, 1],
          [7, 0, 0, 0, 2, 0, 0, 0, 6],
          [0, 6, 0, 0, 0, 0, 2, 8, 0],
          [0, 0, 0, 4, 1, 9, 0, 0, 5],
          [0, 0, 0, 0, 8, 0, 0, 7, 9]
        ]

        sudoku = SudokuBoard.new(board)
        sudoku.guess(0, 2, 9)

        expect(sudoku.board).to eq(board_with_guess)
        expect(sudoku.board_properties[:row][0][9]).to eq(true)
        expect(sudoku.board_properties[:col][2][9]).to eq(true)
        expect(sudoku.board_properties[:box][0][9]).to eq(true)
      end
    end

    context 'when invalid move' do
      it 'does not add value to board or update board properties' do
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

        sudoku = SudokuBoard.new(board)
        sudoku.guess(0, 0, 1)

        expect(sudoku.board).to eq(board)
        expect(sudoku.board_properties[:row][0][1]).to eq(nil)
        expect(sudoku.board_properties[:col][0][1]).to eq(nil)
        expect(sudoku.board_properties[:box][0][1]).to eq(nil)
      end
    end
  end

  describe '#remove_guess' do
    context 'when valid move' do
      it 'removes the guess from the board and board properties' do
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

        sudoku = SudokuBoard.new(board)
        sudoku.guess(0, 2, 9)
        sudoku.remove_guess(0, 2)

        expect(sudoku.board).to eq(board)
        expect(sudoku.board_properties[:row][0][9]).to eq(nil)
        expect(sudoku.board_properties[:col][2][9]).to eq(nil)
        expect(sudoku.board_properties[:box][0][9]).to eq(nil)
      end
    end

    context 'when invalid move' do
      it 'does not remove the guess from the board or board properties' do
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

        sudoku = SudokuBoard.new(board)
        sudoku.remove_guess(0, 0)

        expect(sudoku.board).to eq(board)
        expect(sudoku.board_properties[:row][0][5]).to eq(true)
        expect(sudoku.board_properties[:col][0][5]).to eq(true)
        expect(sudoku.board_properties[:box][0][5]).to eq(true)
      end
    end
  end
end
