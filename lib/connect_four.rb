class Game

  attr_accessor :board, :players, :winner

  def initialize(board=empty_board, players, winner)
    @board = board
    @players = players
    @winner = winner
  end

  def empty_board
    create_board
  end

  def turn(player)
    move = 0
    valid = false
    display_board
    until(move.between?(1,7) && valid) do
      move = get_move
      valid = board[0][move - 1] == 0
    end
    player.move(move, player.color, board)
  end

  def draw
    display_board
    puts "It's a draw! Play again??".rjust(55)
  end

  def check_winning_conditions(player)
    chip = player.color
    i = player.placed_move
    i[1] - 3 >= 0 ? left = i[1] - 3 : left = 0
    right = i[1] + 3
    # Horizontal
    count = 0
    board.reverse[i[0]][left..right].each do |slot|
      slot == chip ? count += 1 : count = 0
      @winner = player if count == 4
    end
    # Vertical
    count = 0
    board.reverse[0..i[0]].each do |row|
      row[i[1]] == chip ? count += 1 : count = 0
      @winner = player if count == 4
    end
    # Right Diagonal
    count = 0
    board.reverse.each_with_index do |row, ind|
      row[ind + i[1] - i[0]] == chip ? count += 1 : count = 0
      @winner = player if count == 4
    end
    # Left Diagonal
    count = 0
    board.reverse.each_with_index do |row, ind|
      row[i[0] + i[1] - ind] == chip ? count += 1 : count = 0
      @winner = player if count == 4
    end
  end

  def complete
    display_board
    puts "#{winner.color.include?("1") ? "Red" : "Brown"} is the winner"
  end

  private

  def create_board
    board = []
    6.times {|y| board << []; 7.times {|x| board[y] << 0 }}
    board
  end

  def display_board
    system("clear")
    puts "_______________".rjust(50)
    board.each do |row|
      output = "".rjust(35)
      row.each do |grid|
        output << "|#{grid}"
      end
      puts "#{output}|"
    end
    puts "_|#{"\u203e".encode('utf-8') * 13}|_".rjust(51)
  end

  def get_move
    puts "".rjust(60)
    puts "Please enter a number between 1-7".rjust(60)
    gets.chomp.to_i
  end

end

class Player

  attr_accessor :color
  attr_reader :placed_move

  def initialize(color)
    @color = "\e[#{color}m0\e[0m"
  end

  def move(x, color, board)
    return nil if (x < 1 || x > 7) || !x.integer?
    board.reverse.each_with_index do |e, i|
      if e[x-1] == 0
        @placed_move = [i, x-1]
        return e[x-1] = "#{color}" 
      end
    end
  end

end

def init
  player_one = Player.new(31)
  player_two = Player.new(33)
  current_player = player_one
  game = Game.new([ player_one, player_two ], nil)
  until(game.winner || !game.board[0].include?(0)) do
    game.turn(current_player)
    game.check_winning_conditions(current_player)
    current_player == player_one ? current_player = player_two : current_player = player_one
  end
  game.winner ? game.complete : game.draw
end
# Comment below before testing with rspec
init