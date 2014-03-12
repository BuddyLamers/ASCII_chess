class HumanPlayer

  attr_reader :colour

  def initialize(colour)
    @colour = colour
  end

    #CLEAN UP!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  def play_turn
    puts "Please input move, in this form: "
    puts " 3 4 to 7 8 :: (That piece can teleport.)"
    return parse(gets.chomp)
  end

  def parse(string)
    sets = string.gsub(" to ", ' ').split(' ')

    sets.each_with_index do |string, index|
      sets[index] = string.to_i
    end

    return [ [ sets[0], sets[1]] , [sets[2], sets[3] ] ]
    #returns an array of two arrays (coordinates)

  end

end