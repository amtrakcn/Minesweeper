class Board
  attr_accessor :board

  def initialize
    @board = []
    create_board(9)
    deploy_mines(10)
  end

  def create_board(grid_size)
    grid_size.times do |i|
      row = []
      grid_size.times do
        new_tile = Tile.new()
        row << new_tile
      end
      board[i] = row
    end
  end

  def deploy_mines(num_mines)
    mines_deployed = 0

    until mines_deployed == num_mines
      x_coord = (0..8).to_a.sample
      y_coord = (0..8).to_a.sample

      unless board[x_coord][y_coord].has_bomb
        @board[x_coord][y_coord].has_bomb = true
        mines_deployed += 1
      end
    end
  end

  def play

  end
end

class Tile
  attr_accessor :has_bomb, :display_value

  def initialize
    @display_value = "*"
    @has_bomb = false
  end

end

class HumanPlayer
  def display_board(board)
    board.each do |line|
      row = []
      line.each do |tile|
        row << tile.display_value
      end

      puts row.join(" ")
    end
  end
end