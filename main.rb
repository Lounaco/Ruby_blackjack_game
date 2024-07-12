# frozen_string_literal: true

class Card
  SUITS = ['♠', '♥', '♦', '♣'].freeze
  RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].freeze

  attr_accessor :suit, :rank

  # Initialize a card with suit and rank
  def initialize(suit,rank)
    @suit = suit
    @rank = rank
  end

  # Determine the value of the card
  def value
    case @rank
    when 'J', 'Q', 'K' then 10
    when 'A' then 11
    else @rank.to_i
    end
  end

  # Return the string representation of the card
  def to_s
    "#{@rank}-#{@suit}"
  end
end

class Deck
  # Initialize the deck with shuffled cards
  def initialize
    @cards = create_shuffled_deck
  end

  # Create a shuffled deck of cards
  def create_shuffled_deck
    deck = Card::SUITS.product(Card::RANKS).map do |suit, rank|
      Card.new(suit, rank)
    end
    deck.shuffle
  end

  # Draw a card from the deck
  def draw
    @cards.pop
  end

  # Check if the deck is empty and reshuffle if necessary
  def reshuffle_if_needed
    @cards = create_shuffled_deck if @cards.empty?
  end
end

# Player information management method
class Player
  attr_accessor :name, :bank, hand

  # Initialize a player with a name and default bank amount
  def initialize(name)
    @name = name
    @bank = 100
    @hand = []
  end

  # Add a card to the player's hand
  def add_card
    @hand << card
  end

  # Calculate the score of the player's hand
  def score
    sum = @hand.map(&:value).sum
    @hand.select{???}
  end

  # Clear the player's hand
  def clear_hand
    @hand = []
  end

  # Display the player's hand as a string
  def show_hand
    @hand.map(&:to_s).join(', ')
  end
end

class Dealer < Player
  def initialize
    super("Dealer")
  end
end

# The method controls the overall logic of the game
class Game
  #attr_accessor :player_name, :player_bank, :dealer_bank

  WELCOME_MESSAGE = "Welcome to the Blackjack game!"
  PROMPT_PLAYER_NAME = "Enter your name: "
  THANKS_FOR_PLAYING = "Thanks for playing!"
  PLAY_AGAIN_PROMPT = "Do you want to play again? (yes/no)"

  # Initialize player and dealer bank account with $100 each
  def initialize
    @deck = Deck.new
  end

  def start
    display_welcome_message
    initialize_players
    game_loop
    puts "Thanks for playing!"
  end

  private

  # Display the welcome message
  def display_welcome_message
    puts "Welcome to the Blackjack game!"
  end

  # Initialize the player and dealer
  def initialize_players
    @player = Player.new(prompt_player_name)
    @dealer = Dealer.new
    display_initial_message
  end

  # Display the initial message
  def display_initial_message
    puts "Hello, #{@player.name}! Both you and the dealer start with $100 in the bank."
  end

  # Method describing the main game loop
  def game_loop
    loop do
    break unless  
  end

  # Method for describing one round of the game
  def play_round
  end

  # Method for describing the end of the game
  def game_over
  end

end