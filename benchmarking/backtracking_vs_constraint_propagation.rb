# frozen_string_literal: true

require 'benchmark'
require_relative '../lib/sudoku_board'
require_relative '../lib/backtrack_solver'
require_relative '../lib/constraint_propagation_solver'

# Sample size
n = 1_000

# Benchmarking using easy/medium/hard sudoku
puts "\nEasy Sudoku Puzzle"
Benchmark.bm do |benchmark|
  benchmark.report('Backtrack') do
    n.times do
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
      BacktrackSolver.new(SudokuBoard.new(board)).solve
    end
  end

  benchmark.report('Constraint') do
    n.times do
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
      ConstraintPropagationSolver.new(SudokuBoard.new(board)).solve
    end
  end
end

puts "\nMedium Sudoku Puzzle"
Benchmark.bm do |benchmark|
  benchmark.report('Backtrack') do
    n.times do
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
      BacktrackSolver.new(SudokuBoard.new(board)).solve
    end
  end

  benchmark.report('Constraint') do
    n.times do
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
      ConstraintPropagationSolver.new(SudokuBoard.new(board)).solve
    end
  end
end

puts "\nHard Sudoku Puzzle"
Benchmark.bm do |benchmark|
  benchmark.report('Backtrack') do
    n.times do
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
      BacktrackSolver.new(SudokuBoard.new(board)).solve
    end
  end

  benchmark.report('Constraint') do
    n.times do
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
      ConstraintPropagationSolver.new(SudokuBoard.new(board)).solve
    end
  end
end
