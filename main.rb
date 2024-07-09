# frozen_string_literal: true

class Player
  attr_accessor :name, :bank
  def initialize(name)
    @name = name
    @bank = 100
end

class Dealer < Player
  def initialize
    super("Dealer")
end

class Game
  attr_accessor :player_name, :player_bank, :dealer_bank

  # Initialize player and dealer bank account with $100 each
  def initialize
    @player_bank = 100
    @dealer_bank = 100
  end

  def start
    welcome_message
    get_player_name
    game_loop
  end

  private

  # Display welcome message
  def welcome_message
    puts "Welcome to the game!"
  end

  # Prompt the user to enter name
  def get_player_name
    print "Enter your name: "
    @player_name = gets.chomp
    puts " Hello, #{@player_name}! You and the dealer each have $100 in the bank."
  end

  # Method describing the main game loop
  def game_loop
  end

  # Method for describing one round of the game
  def play_round
  end

  # Method for describing the end of the game
  def game_over
  end

end