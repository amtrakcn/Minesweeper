class Board
  attr_accessor :board
  attr_reader :remaining_mines
  def initialize
    @board = []
    create_board(9)
    deploy_mines(10)
    remaining_mines = 10
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
    human = HumanPlayer.new()


  end

  def explore(neighbors)

  end

  def reveal_tile(coord)
    neighbors = check_neighbors(coord)
    if neighbors.length > 0
      board[coord[0][coord[1]].display_value = neighbors.length
    else
      board[coord[0][coord[1]].display_value = "_"
      explore(neighbors)
    end

  end

  def flag_tile(coord)
    board[coord[0]][coord[1]].display_value = ("F")
    remaining_mines -= 1 if board[coord[0]][coord[1]].has_mine
  end

  def check_neighbors(coord)
    neighbor_bombs = []
    (-1..1).to_a.each do |index1|
      (-1..1).to_a.each do |index2|
        next if index1 == 0  && index2 == 0
        new_coord = [coord[0]+index1, coord[1]+index2]

        if is_valid?(new_coord)
          neighbor_bombs << new_coord if board[new_coord[0]][new_coord[1]].has_bomb
        end
      end
    end

    neighbor_bombs
  end

  def is_valid?(coord)
    if coord[0] >= 0 && coord[0] < board.length - 1
      if coord[1] >= 0 && coord[1] < board.length - 1
        return true
      end
    end
    false
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

  def get_move
    user_move = {}

    puts "What tile would you like to select (Separate x and y coordinate with a space)?"
    coords_input = gets.chomp
    coord = coords_input.split(" ")
    coord.map! { |el| el.to_i }

    puts "Would you like to reveal or flag the tile (f or r)?"
    move = gets.chomp
    user_move[move] = coord

    user_move
  end
end