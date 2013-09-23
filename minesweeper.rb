class Board
  attr_accessor :board
  attr_reader :remaining_mines
  def initialize
    @board = []
    create_board(9)
    deploy_mines(10)
    @remaining_mines = 10
    play
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

    until remaining_mines == 0
      human.display_board(board)

      user_move = human.get_move
      if user_move.has_key?("r")
        reveal_tile(user_move["r"])
      else
        flag_tile(user_move["f"])
      end

      if game_lost?
        puts "sorry you lose"
        exit
      end
    end

    puts "congratulations you win"
  end

  def game_lost?
    board.each do |row|
      row.each do |element|
        return true if element.display_value == "B"
      end
    end
    false
  end

  def reveal_tile(coord)
    if board[coord[0]][coord[1]].has_bomb
      board[coord[0]][coord[1]].display_value = "B"
    else
      unexplored_tiles = [coord]

      until unexplored_tiles.length == 0
        curr_coord = unexplored_tiles.shift

        neighbors = check_neighbors(curr_coord)
        bombs = neighbors[:unsafe].length

        if bombs > 0
          board[curr_coord[0]][curr_coord[1]].display_value = bombs
        else
          board[curr_coord[0]][curr_coord[1]].display_value = "_"
          neighbors[:safe].each do |el|
            if board[el[0]][el[1]].display_value == "*"
              unexplored_tiles << el unless unexplored_tiles.include?(el)
            end
          end
        end
      end
    end
  end

  def flag_tile(coord)
    board[coord[0]][coord[1]].display_value = ("F")
    @remaining_mines -= 1 if board[coord[0]][coord[1]].has_bomb
  end

  def check_neighbors(coord)
    neighbors = {}
    neighbors[:safe] = []
    neighbors[:unsafe] = []

    (-1..1).to_a.each do |index1|
      (-1..1).to_a.each do |index2|
        next if index1 == 0  && index2 == 0
        new_coord = [coord[0]+index1, coord[1]+index2]

        if is_valid?(new_coord)
          if board[new_coord[0]][new_coord[1]].has_bomb
            neighbors[:unsafe] << new_coord
          else
            neighbors[:safe] << new_coord if not_flagged?(new_coord)
          end
        end
      end
    end

    neighbors
  end

  def not_flagged?(coord)
    return true unless board[coord[0]][coord[1]].display_value == "F"
    false
  end

  def is_valid?(coord)
    if coord[0] >= 0 && coord[0] < board.length
      if coord[1] >= 0 && coord[1] < board.length
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