class Board
  def initialize
    @mine_board = []
  end
end

class Tile
  attr_accessor :, :display_value

  def initialize
    @display_value = "*"
    @has_bomb = false
  end
end