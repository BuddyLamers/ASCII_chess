class Piece
  attr_accessor :position
  attr_reader :colour, :board

  def initialize(position, board, colour)
    @position, @board, @colour = position, board, colour
  end

  def moves
    #make in sublasses and raise error in superclass
  end

  def on_board?(pos)
    pos.all? do |coord|
      coord.between?(0,7)
    end
  end

  def allied_collision?(pos)
    return false if @board[pos].nil?
    @board[pos].colour == @colour
  end

  def capture_options(moves)
    capture_options = []
    moves.each { |pos| capture_options << pos if capture_opportunity?(pos) }
    capture_options
  end

  def capture_opportunity?(pos)
    square = @board[pos]
    return false if square.nil?
    square.colour != @colour #returns true if enemy
  end

end

# myboard[0,2] would return the piece at that position on the board

class Board
  def [](pos)
    row, col = pos
    @board[row][col]
  end
end


class SlidingPiece < Piece
  #method that gets HOW the piece moves, intakes "move_dirs"

  #method that determines if other pieces are in the way
  # => filters the move set

  def moves
    moves = []

    @delta.each do |direction|
      @delta[0], @delta[1] = dx, dy
      @position[0], @position[1] = x, y
      move = [x + dx, y + dy]

      until !allied_collision(move) || !on_board?(move)
        moves << move
        break if capture_opportunity?(move)
        move  = [move[0] + dx, move[1] + dy]
      end
    end

    moves
  end


  # def capture_opportunity?(pos)
  #   square = @board[pos]
  #   return false if square.nil?
  #   square.colour != @colour #returns true if enemy
  # end

end

class Bishop < SlidingPiece
  #has method "move_dirs"
  # def move_dir
  #   :diagonal = true
  #
  # end
  @delta = [
    [1 , 1],
    [1 ,-1],
    [-1, 1],
    [-1,-1]
    ]
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
  @delta = [
    [1, 0],
    [0, 1],
    [-1,0],
    [0,-1],
    [1 , 1],
    [1 ,-1],
    [-1, 1],
    [-1,-1]
  ]
  #has method "move_dirs"
end


class SteppingPiece < Piece

  def moves
    moves = []
    all_moves = all_pos_moves
    all_moves.each do |pos|
      moves << pos if on_board?(pos) && !allied_collision?(pos)
    end

    moves
  end

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

  def moves
    moves = []
    x, y = @position[0], @position[1]

    if x == 1 || 6 #leap forwards
      move = [x, y + 2]
      moves << move if [x, y + 1].nil? && move.nil?
    end
    moves << [x, y + 1] if [x, y + 1].nil? #one step
    moves << [x+1, y+1] if capture_opportunity?([x+1, y+1]) #cap r
    moves << [x-1, y+1] if capture_opportunity?([x-1, y+1]) #cap l

  end

end

