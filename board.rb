class Board
  attr_accessor :board

  def initialize(populate=true)
    @board = Array.new(8) {Array.new(8)}
    setup_board if populate
  end

  def setup_board
    setup_pawns
    setup_back
  end

  def setup_pawns
    board.each_index do |row|
      self[[row, 1]] = Pawn.new([row,1], self, :W)
      self[[row, 6]] = Pawn.new([row,6], self, :B)
    end
  end

  def setup_back
    [0,7].each do |col|
      colour = (col == 0 ? :W : :B)
      self[[0, col]] = Rook.new(  [0, col], self, colour)
      self[[7, col]] = Rook.new(  [7, col], self, colour)
      self[[1, col]] = Knight.new([1, col], self, colour)
      self[[6, col]] = Knight.new([6, col], self, colour)
      self[[2, col]] = Bishop.new([2, col], self, colour)
      self[[5, col]] = Bishop.new([5, col], self, colour)
      self[[3, col]] = King.new(  [3, col], self, colour)
      self[[4, col]] = Queen.new( [4, col], self, colour)
    end
  end

  def in_check?(colour)
    king_pos = find_king(colour)
    check_enemy_moves(colour, king_pos)
  end

  def find_king(colour)
    board.flatten.each do |square|
      next if square.nil?
      if square.class == King && square.colour == colour
        return square.position
      end
    end
    nil
  end

  def check_enemy_moves(colour, position)
    enemy_colour = (colour== :W ? :B : :W)

    board.flatten.each do |square|
      next if square.nil?
      if square.class != King && square.colour == enemy_colour
        return true if square.moves.include?(position)
      end
    end
    false
  end

  def move(start, end_pos)
    start_pos_piece = self[start]
    end_pos_piece = self[end_pos]

    if start_pos_piece.nil?
      puts "nothing there"
      return
    end

    if start_pos_piece.moves.include?(end_pos)
      if start_pos_piece.move_into_check?(end_pos)
        puts "Into check"
        return
      end

      if !end_pos_piece.nil?
        puts "The #{start_pos_piece.render} captured the #{end_pos_piece.render}"
        remove_piece(end_pos)
      end

      add_piece(start_pos_piece, end_pos)
      remove_piece(start)

    end
    render
  end

  def checkmate?(colour)
    return false unless in_check?(colour)

    valid_moves = []
    # iterate through all of that colours pieces
    # => add their moves to an array
    # =>  if array is empty (no valid moves) the checkmate

    #if pieces.each.moves each,move_into_check.any? == true
    allies = find_allies(colour)

    allies.each do |piece|
      piece.moves.each do |move|
        return false if !piece.move_into_check?(move)
      end
    end
    true
  end

  def find_allies(colour)
    allies = []

    board.flatten.each do |square|
      next if square.nil?
      allies << square if square.colour == colour
    end
    allies
  end

  def add_piece(piece, pos)
    self[pos] = piece.class.new(pos, self, piece.colour)
  end

  def remove_piece(pos)
    self[pos] = nil
  end


  def render
    board.each_with_index do |row,idx1|
      render_string = ""
      row.each_index do |idx2|
        piece = self[[idx1, idx2]]
        if piece.nil?
          render_string += "[___]"
        else
          render_string += piece.render
        end
      end
      puts render_string
    end
    nil
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @board[row][col] = value
  end

end