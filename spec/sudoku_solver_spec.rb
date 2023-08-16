# frozen_string_literal: true

require 'sudoku_solver'

describe SudokuSolver do
  describe '#backtrack' do
    it 'returns the sudoku board solved (easy)' do
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
      solution = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 9]
      ]

      solver = SudokuSolver.new(board)
      expect(solver.backtrack).to eq(solution)
    end

    it 'returns the sudoku board solved (medium)' do
      board = [
        [0, 0, 0, 8, 3, 2, 0, 9, 0],
        [0, 0, 0, 0, 0, 5, 7, 0, 6],
        [1, 0, 0, 6, 0, 0, 0, 0, 0],
        [3, 0, 0, 0, 0, 0, 0, 0, 0],
        [6, 7, 4, 0, 0, 0, 8, 5, 1],
        [0, 0, 0, 0, 0, 0, 0, 0, 7],
        [0, 0, 0, 0, 0, 1, 0, 0, 5],
        [9, 0, 2, 5, 0, 0, 0, 0, 0],
        [0, 3, 0, 2, 7, 6, 0, 0, 0]
      ]
      solution = [
        [7, 5, 6, 8, 3, 2, 1, 9, 4],
        [2, 9, 3, 4, 1, 5, 7, 8, 6],
        [1, 4, 8, 6, 9, 7, 5, 2, 3],
        [3, 8, 1, 7, 5, 4, 9, 6, 2],
        [6, 7, 4, 3, 2, 9, 8, 5, 1],
        [5, 2, 9, 1, 6, 8, 3, 4, 7],
        [4, 6, 7, 9, 8, 1, 2, 3, 5],
        [9, 1, 2, 5, 4, 3, 6, 7, 8],
        [8, 3, 5, 2, 7, 6, 4, 1, 9]
      ]

      solver = SudokuSolver.new(board)
      expect(solver.backtrack).to eq(solution)
    end

    it 'returns the sudoku board solved (hard)' do
      board = [
        [0, 1, 0, 0, 0, 0, 0, 4, 0],
        [3, 9, 0, 6, 0, 5, 0, 1, 8],
        [0, 0, 0, 0, 9, 0, 0, 0, 0],
        [0, 5, 0, 3, 0, 4, 0, 6, 0],
        [0, 0, 0, 0, 5, 0, 0, 0, 0],
        [0, 7, 0, 9, 0, 1, 0, 5, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0],
        [5, 4, 0, 8, 0, 2, 0, 9, 6],
        [0, 6, 0, 0, 0, 0, 0, 3, 0]
      ]
      solution = [
        [6, 1, 5, 7, 2, 8, 3, 4, 9],
        [3, 9, 2, 6, 4, 5, 7, 1, 8],
        [7, 8, 4, 1, 9, 3, 6, 2, 5],
        [1, 5, 9, 3, 8, 4, 2, 6, 7],
        [4, 3, 6, 2, 5, 7, 9, 8, 1],
        [2, 7, 8, 9, 6, 1, 4, 5, 3],
        [9, 2, 3, 5, 1, 6, 8, 7, 4],
        [5, 4, 7, 8, 3, 2, 1, 9, 6],
        [8, 6, 1, 4, 7, 9, 5, 3, 2]
      ]

      solver = SudokuSolver.new(board)
      expect(solver.backtrack).to eq(solution)
    end
  end
end
