class Piece
  attr_accessor :position, :board, :colour

  def initialize(position, board, colour)
    @position, @board, @colour = position, board, colour
  end

  def moves
  end

  def on_board?(position)
    position.all? do |coord|
      coord.between?(0,7)
    end
  end

  def allied_collision?(pos)
    return false if @board[pos].nil?
    @board[pos].colour == @colour
  end

  # def piece_in_way(pos)
  #   #if allied_collision, remove all possible further moves on that delta
  #   # => same for capture
  #
  #
  # end

  def capture_options(moves)
    capture_options = []
    moves.each do |pos|
      square = @board[pos]
      capture_options << !square.nil? && square.colour != @colour
    end

    capture_options
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

end


class SlidingPiece < Piece
  #method that gets HOW the piece moves, intakes "move_dirs"

  #method that determines if other pieces are in the way
  # => filters the move set

  def moves(move_dir)
    #distinguish if diagonal/horizontal/vertical

    #until collision || capture || off_board keep adding each delta
    # moves << the retults of above line
  end

  def capture?(pos)
  end

end

class Bishop < SlidingPiece
  #has method "move_dirs"
  # def move_dir
  #   :diagonal = true
  #
  # end

end

class Rook < SlidingPiece
  @delta = [
    [1, 0],
    [0, 1],
    [-1,0],
    [0,-1]
  ]
  #has method "move_dirs"
end

class Queen < SlidingPiece
  #has access to

  #has method "move_dirs"
end


class SteppingPiece < Piece

  def moves(all_pos_moves) #calculates collisions and off board
    #should take in all possible moves/move_dir
    moves = []
    all_pos_moves.each do |pos|
      moves << pos if on_board?(pos) && !allied_collision?(pos)
      #&& !piece_in_way(pos)
    end

    moves
  end

  #method that gets HOW the piece moves, intakes "move_dirs"
  def all_pos_moves
    x, y = @position[0], @postion[1]
    all_pos_moves = []

    @deltas.each do |delta|
      @delta[0], @delta[1] = dx, dy
      all_pos_moves << [x+ dx1, y + dy]
    end

    all_pos_moves
  end

end

class King < SteppingPiece
  #has method "move_dirs"
  def initialize
    @deltas = [
      [-1, -1],
      [-1,  0],
      [-1,  1],
      [ 0, -1],
      [ 0,  1],
      [ 1, -1],
      [ 1,  0],
      [ 1,  1]
      ]
  end

end

class Knight < SteppingPiece
  #has method "move_dirs"

  @deltas = [
  [-2, -1],
  [-2,  1],
  [-1, -2],
  [-1,  2],
  [ 1, -2],
  [ 1,  2],
  [ 2, -1],
  [ 2,  1]
  ]
end


class Pawn < Piece
  #has it's own weirdness
end
