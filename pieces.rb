class Piece
  attr_accessor :position
  attr_reader :colour, :board, :moves

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

  def render
    return "[#{colour},K]" if self.class == King
    return "[#{colour},Q]" if self.class == Queen
    return "[#{colour},p]" if self.class == Pawn
    return "[#{colour},b]" if self.class == Bishop
    return "[#{colour},k]" if self.class == Knight
    return "[#{colour},r]" if self.class == Rook
  end

  def deltas
    self.class::DELTAS
  end

end

# myboard[0,2] would return the piece at that position on the board

class SlidingPiece < Piece
#method that gets HOW the piece moves, intakes "move_dirs"

#method that determines if other pieces are in the way
# => filters the move set

  def moves
    moves = []

    deltas.each do |direction|
      dx, dy = direction[0], direction[1]
      x, y = @position[0], @position[1]
      move = [x + dx, y + dy]

      until !on_board?(move) || allied_collision?(move)
        moves << move
        break if capture_opportunity?(move)
        move  = [move[0] + dx, move[1] + dy]
      end
    end

    moves
  end
end

class Bishop < SlidingPiece
  DELTAS = [
    [1 , 1],
    [1 ,-1],
    [-1, 1],
    [-1,-1]
  ]
end

class Rook < SlidingPiece
  DELTAS = [
    [1, 0],
    [0, 1],
    [-1,0],
    [0,-1]
  ]

end

class Queen < SlidingPiece
  DELTAS = [
    [1, 0],
    [0, 1],
    [-1,0],
    [0,-1],
    [1 , 1],
    [1 ,-1],
    [-1, 1],
    [-1,-1]
  ]

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
    x, y = @position[0], @position[1]
    all_pos_moves = []
    deltas.each do |delta|
      dx, dy = delta[0], delta[1]
      all_pos_moves << [x+ dx, y + dy]
    end

    all_pos_moves
  end

end

class King < SteppingPiece
  DELTAS = [
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

class Knight < SteppingPiece
  DELTAS = [
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
    if @colour == :W
      moves += white_moves(x,y)
    else
      moves += black_moves(x,y)
    end
    moves
  end

  def white_moves(x,y)
    moves = []
    if y == 1  #leap forwards
      move = [x, y + 2]
      moves << move if board[[x, y + 1]].nil? && board[move].nil?
    end

    move_1 = [x, y + 1]
    if ([on_board?(move_1), board[move_1].nil?].all?)
      moves << move_1
    end

    cap_1 = [x + 1, y + 1]
    if ([on_board?(cap_1), !board[cap_1].nil?, !allied_collision?(cap_1)].all?)
      moves << cap_1
    end

    cap_2 = [x - 1, y + 1]
    if ([on_board?(cap_2), !board[cap_2].nil?, !allied_collision?(cap_2)].all?)
      moves << cap_2
    end
    moves
  end

  def black_moves(x,y)
    moves = []
    if y == 6  #leap forwards
      move = [x, y - 2]
      moves << move if board[[x, y - 1]].nil? && board[move].nil?
    end

    move_1 = [x, y - 1]
    if ([on_board?(move_1), board[move_1].nil?].all?)
      moves << move_1
    end

    cap_1 = [x + 1, y - 1]
    if ([on_board?(cap_1), !board[cap_1].nil?, !allied_collision?(cap_1)].all?)
      moves << cap_1
    end

    cap_2 = [x - 1, y - 1]
    if ([on_board?(cap_2), !board[cap_2].nil?, !allied_collision?(cap_2)].all?)
      moves << cap_2
    end
    moves
  end


end


