require './lib/connect_four.rb'

describe Game do 

  subject { Game.new(['player1', 'player2'], nil) }
  
  describe ".empty_board" do
    it "should use a 7 x 6 board filled with 0's at start of game" do 
      expect(subject.board).to eql(subject.empty_board)
    end 
  end

  describe ".display_board" do
    it "should display the current state of the board" do
      expect(subject.display).to be_nil
    end
  end

  describe ".players" do
    it "should have two players" do 
      expect(subject.players.size).to eql(2)
    end
  end

  it "should accept a move from (either) player" do
    player_one = Player.new(31)
    player_two = Player.new(33)
    player_one.move(7, player_one.color, subject.board)
    player_two.move(7, player_two.color, subject.board)
    expect(subject.board.last.last).to eql("\e[31m0\e[0m")
    expect(subject.board[4].last).to eql("\e[33m0\e[0m")
  end

  it "should not accept any more moves for a full column" do
    player_one = Player.new(31)
    player_two = Player.new(33)
    3.times { player_one.move(7, player_one.color, subject.board) }
    3.times { player_two.move(7, player_two.color, subject.board) }
    expect(player_one.move(7, player_one.color, subject.board)).to eql(
      [[0,0,0,0,0,0,"\e[33m0\e[0m"],
      [0,0,0,0,0,0,"\e[33m0\e[0m"],
      [0,0,0,0,0,0,"\e[33m0\e[0m"],
      [0,0,0,0,0,0,"\e[31m0\e[0m"],
      [0,0,0,0,0,0,"\e[31m0\e[0m"],
      [0,0,0,0,0,0,"\e[31m0\e[0m"]].reverse
      )
  end

  it "should not accept moves out of the range of horizontal moves" do
    player_one = Player.new(31)
    player_one.move(8, player_one.color, subject.board)
    player_one.move(-6, player_one.color, subject.board)
    player_one.move(0.2, player_one.color, subject.board)
    player_one.move(0, player_one.color, subject.board)
    expect(subject.board).to eql(subject.empty_board)
  end

  describe ".winner" do

    context "returns the victor with four consecutive checkers" do

      let(:player_one) { Player.new(31) }
      let(:player_two) { Player.new(33) }

      it "returns the winner of the game with four consecutively placed vertical checkers" do
        4.times { player_one.move(7, player_one.color, subject.board) }
        subject.check_winning_conditions(player_one)
        expect(subject.winner).to eql(player_one)
      end
      it "returns the winner of the game with four consecutively placed horizontal checkers" do
        player_one.move(7, player_one.color, subject.board)
        player_one.move(6, player_one.color, subject.board)
        player_one.move(5, player_one.color, subject.board)
        player_one.move(4, player_one.color, subject.board)
        subject.check_winning_conditions(player_one)
        expect(subject.winner).to eql(player_one)
      end
      it "returns the winner of the game with four consecutively placed diagonal checkers" do
        player_one.move(7, player_one.color, subject.board)
        player_two.move(6, player_two.color, subject.board)
        player_one.move(6, player_one.color, subject.board)
        player_two.move(5, player_two.color, subject.board)
        player_two.move(5, player_two.color, subject.board)
        player_one.move(5, player_one.color, subject.board)
        player_two.move(4, player_two.color, subject.board)
        player_two.move(4, player_two.color, subject.board)
        player_two.move(4, player_two.color, subject.board)
        player_one.move(4, player_one.color, subject.board)
        subject.check_winning_conditions(player_one)
        expect(subject.winner).to eql(player_one)
      end
    end
  end

end