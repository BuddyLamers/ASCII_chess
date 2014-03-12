class Game
  attr_accessor :board
  attr_reader :player_1, :player_2
  def initialize(player_1 = HumanPlayer.new(:W), player_2 = HumanPlayer.new(:B))
    @board = Board.new
    @player_1 = player_1
    @player_2 = player_2
  end

  def run
    intro
    board.render

    #CLEAN UP!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    loop do
      begin
        w_start, w_end = player_1.play_turn
        board.move(w_start, w_end, player_1.colour)
      rescue
        puts "WRONG!!!!!!"
        retry
      end

      if board.checkmate?(:B)
        end_game(:W)
        break
      end

      begin
        b_start, b_end = player_2.play_turn
        board.move(b_start, b_end, player_2.colour)
      rescue
        puts "WRONG!!!!!"
        retry
      end

      if board.checkmate?(:W)
        end_game(:B)
        break
      end
    end
    nil
  end

  def intro
    puts ""
    puts "    Welcome to AWESOME_CHESS"
    puts ""
    puts ">.......all hail DELTAS........<"
    puts ""

  end

  def end_game(winner)
    puts ""
    puts "Congradulations! #{winner} wins!!"
    puts ""
    puts ">......DELTAS is pleased......<"
  end

end