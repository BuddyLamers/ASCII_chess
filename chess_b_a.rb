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

class Board
  attr_accessor :board



  def initialize
    @board = Array.new(8) {Array.new(8)}
    setup_board
  end

  def setup_board
    #set up pawns
    @board.each_index do |row|
      row[1] = Pawn.new([row,1], self , :W)
      row[6] = Pawn.new([row,6], self , :B)
    end
    setup_white
    setup_black
  end

  def setup_white
    @board[0,0] = Rook.new([0,0], self, :W)
    @board[7,0] = Rook.new([7,0], self, :W)
    @board[1,0] = Knight.new([1,0], self, :W)
    @board[6,0] = Knight.new([6,0], self, :W)
    @board[2,0] = Bishop.new([2,0], self, :W)
    @board[5,0] = Bishop.new([5,0], self, :W)
    @board[3,0] = King.new([3,0], self, :W)
    @board[4,0] = Queen.new([4,0], self, :W)
  end

  def setup_black
    @board[0,7] = Rook.new([0,7], self, :B)
    @board[7,7] = Rook.new([7,7], self, :B)
    @board[1,7] = Knight.new([1,7], self, :B)
    @board[6,7] = Knight.new([6,7], self, :B)
    @board[2,7] = Bishop.new([2,7], self, :B)
    @board[5,7] = Bishop.new([5,7], self, :B)
    @board[3,7] = King.new([3,7], self, :B)
    @board[4,7] = Queen.new([4,7], self, :B)
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end
end

