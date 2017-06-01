
require "byebug"

class Minesweeper

  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def run
    until win? || lose?
      board.render
      play_turn
    end
  end

  def play_turn
    puts "Do you want to flag or move?"
    answer = gets.chomp.downcase
    if answer == "flag"
      puts "Which tile do you want to flag?"
      tile_pos = get_user_pick
      tile = board[tile_pos.first, tile_pos.last]
      tile.is_flagged = true unless tile_pos.nil?
    end

    if answer == "move"
      puts "Which tile do you want to move on."
      tile_pos = get_user_pick
      tile = board[tile_pos.first, tile_pos.last]
      if tile.is_mined
      end
    end
  end

  def get_user_pick
    tile_pos = gets.chomp
    tile_pos = parse_pos(tile_pos)
    puts "That is not a valid tile location!" if tile_pos == nil
    tile_pos
  end

  def parse_pos(string)
    pos_array = string.split(",").map{|el| Integer(el)}
    return nil if pos_array.length != 2
    return nil unless pos_array.all?{|el| board.is_valid_location?(pos_array.first,pos_array.last)}
    pos_array
  end

  def lose?
    #TODO Implement loss condition
    return false
  end

  def win?
    #TODO Implement win condition
    return false
  end

end

class Board
  attr_reader :width, :height

  #all possible adjacencies to a given tile
  ADJ_TYPES = [[-1,-1], [0,-1], [1,-1], [-1,0], [1,0], [-1,1], [0,1], [1,1]]

  def initialize(x = 9, y = 9, mines = 20)
    @grid = Array.new(x){Array.new(y) {Tile.new}}
    @width = x
    @height = y
    populate_mines(mines)
    assign_all_adjacents
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, mark)
    @grid[row][col] = mark
  end

  def populate_mines(count)
    if count > width * height
      raise "Invalid mine count."
    end
    while count > 0
      x_pos = rand(width)
      y_pos = rand(height)
      picked_tile = self[x_pos, y_pos]
      unless picked_tile.is_mined
        count -= 1
        picked_tile.is_mined = true
      end
    end
  end

  def assign_all_adjacents
    @width.times do |x_pos|
      @height.times do |y_pos|
        assign_adjacents(x_pos, y_pos)
      end
    end
  end

  def assign_adjacents(tile_x, tile_y)
    count = 0
    ADJ_TYPES.each do |type|
        working_x, working_y = tile_x, tile_y
        working_x += type.first
        working_y += type.last
        # byebug
      if is_valid_location?(working_x, working_y)
        count += 1 if self[working_x, working_y].is_mined
      end
    end
    self[tile_x, tile_y].adjacent = count
  end

  def is_valid_location?(x_pos, y_pos)
    return false if x_pos < 0 || y_pos < 0
    return false if x_pos >= width || y_pos >= height
    true
  end

  def render
    @grid.each do |row|
      array = row.map{|tile| render_helper(tile)}
      p array.join(" ")
    end
  end

  def render_helper(tile)
    unless tile.revealed == false
      tile.is_flagged ? :f : :*
    else
      tile.mined ? :m : tile.adjacencies
    end
  end

end

class Tile
  attr_accessor :is_mined, :is_flagged, :adjacent, :revealed
end

game=Minesweeper.new
game.run
