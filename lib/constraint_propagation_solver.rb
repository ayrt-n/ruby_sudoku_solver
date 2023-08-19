# frozen_string_literal: true

# Sudoku solving algorithm implemented using constraint propagation and backtracking
class ConstraintPropagationSolver
  def solve(sudoku)
    constraints = sudoku.board.map do |row|
      row.map { |value| value.zero? ? Set.new((1..9)) : Set.new([value]) }
    end

    continue = true
    while continue
      continue = false

      constraints.each_index do |r|
        constraints[r].each_with_index do |constraint, c|
          next unless constraint.size == 1

          continue = true
          sudoku.guess(r, c, constraint.take(1)[0])
          propagate_constraint(constraints, r, c, constraint)
        end
      end

      continue ||= propagate_sets(constraints)
    end

    [true, sudoku.board]
  end

  private

  def propagate_constraint(constraints, row, col, constraint)
    # Propagate constraint across row
    9.times { |c| constraints[row][c] -= constraint }

    # Propagate constraint across column
    9.times { |r| constraints[r][col] -= constraint }

    # Propagate constraint across box
    box_row_start = (row / 3) * 3
    box_col_start = (col / 3) * 3
    (box_row_start...box_row_start + 3).each do |r|
      (box_col_start...box_col_start + 3).each do |c|
        constraints[r][c] -= constraint
      end
    end
  end

  def propagate_sets(constraints)
    propagate_row_constraints(constraints)   ||
      propagate_col_constraints(constraints) ||
      propagate_box_constraints(constraints)
  end

  def propagate_row_constraints(constraints)
    # Flag if constraints were able to be reduced
    constraints_reduced = false

    9.times do |row|
      sets = Hash.new { |h, k| h[k] = [] }
      9.times { |col| sets[constraints[row][col]] << constraints[row][col] }

      sets.each do |constraint, group|
        next if constraint.size < 2 || constraint.size > 4 || constraint.size != group.size

        9.times do |col|
          next if constraints[row][col] == constraint || !constraints[row][col].intersect?(constraint)

          constraints_reduced = true
          constraints[row][col] -= constraint
        end
      end
    end

    constraints_reduced
  end

  def propagate_col_constraints(constraints)
    # Flag if constraints were able to be reduced
    constraints_reduced = false

    9.times do |col|
      sets = Hash.new { |h, k| h[k] = [] }
      9.times { |row| sets[constraints[row][col]] << constraints[row][col] }

      sets.each do |constraint, group|
        next if constraint.size < 2 || constraint.size > 4 || constraint.size != group.size

        9.times do |row|
          next if constraints[row][col] == constraint || !constraints[row][col].intersect?(constraint)

          constraints_reduced = true
          constraints[row][col] -= constraint
        end
      end
    end

    constraints_reduced
  end

  def propagate_box_constraints(constraints)
    # Flag if constraints were able to be reduced
    constraints_reduced = false
    box_ranges = [(0..2), (3..5), (6..8)]

    box_ranges.each do |rows|
      box_ranges.each do |cols|
        sets = Hash.new { |h, k| h[k] = [] }
        rows.each do |row|
          cols.each do |col|
            sets[constraints[row][col]] << constraints[row][col]

            sets.each do |constraint, group|
              next if constraint.size < 2 || constraint.size > 4 || constraint.size != group.size

              rows.each do |r|
                cols.each do |c|
                  next if constraints[r][c] == constraint || !constraints[row][col].intersect?(constraint)

                  constraints[r][c] -= constraint
                end
              end
            end
          end
        end
      end
    end

    constraints_reduced
  end
end
