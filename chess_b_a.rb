class Piece
  attr_accessor :position, :board, :colour

  def initialize(position, board, colour)
    @position, @board, @colour = position, board, colour
  end

  def moves(move_dirs) #how the piece can move
    moves = []
    move_dirs.each do |pos|
      moves << pos if on_board?(pos) && !collision?(pos)
    end

    moves
  end

  def on_board?(position)
    position.all? do |coord|
      coord.between?(0,7)
    end
  end

  def collision?(position)
    return false if @board[pos].nil?
    @board[pos].colour == @colour
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
end

class Bishop < SlidingPiece
  #has method "move_dirs"
end

class Rook < SlidingPiece
  #has method "move_dirs"
end

class Queen < SlidingPiece
  #has access to

  #has method "move_dirs"
end


class SteppingPiece < Piece

  #method that gets HOW the piece moves, intakes "move_dirs"
  def move_dirs
    x, y = @position[0], @postion[1]
    move_dirs = []

    @deltas.each do |delta|
      @delta[0], @delta[1] = dx, dy
      move_dirs << [x+ dx1, y + dy]
    end

    move_dirs
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
end


class Pawn < Piece
  #has it's own weirdness
end

