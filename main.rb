# frozen_string_literal: true

# Class representing a single card in the deck
class Card
  SUITS = ['♠', '♥', '♦', '♣'].freeze  # Suits of the cards
  RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].freeze  # Ranks of the cards

  attr_accessor :suit, :rank

  # Initialize a card with suit and rank
  def initialize(suit, rank)
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
    "#{@rank}#{@suit}"
  end
end

# Class representing a deck of cards
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
    reshuffle_if_needed
    @cards.pop
  end

  # Check if the deck is empty and reshuffle if necessary
  def reshuffle_if_needed
    @cards = create_shuffled_deck if @cards.empty?
  end
end

# Class representing a player (or dealer) in the game
class Player
  attr_accessor :name, :bank, :hand

  # Initialize a player with a name and default bank amount
  def initialize(name)
    @name = name
    @bank = 100
    @hand = []
  end

  # Add a card to the player's hand
  def add_card(card)
    @hand << card
  end

  # Calculate the score of the player's hand
  def score
    sum = @hand.map(&:value).sum
    aces = @hand.select { |card| card.rank == 'A' }
    aces.count.times { sum -= 10 if sum > 21 }
    sum
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

# Class representing the dealer in the game, inherits from Player
class Dealer < Player
  def initialize
    super('Dealer')
  end
end

# Class containing the main logic of the Blackjack game
class Game
  WELCOME_MESSAGE = "Welcome to the Blackjack game!"
  PROMPT_PLAYER_NAME = "Enter your name: "
  THANKS_FOR_PLAYING = "Thanks for playing!"
  PLAY_AGAIN_PROMPT = "Do you want to play again? (yes/no)"

  def initialize
    @deck = Deck.new
  end

  # Start the game
  def start
    display_welcome_message
    initialize_players
    game_loop
    puts THANKS_FOR_PLAYING
  end

  private

  # Display the welcome message
  def display_welcome_message
    puts WELCOME_MESSAGE
  end

  # Prompt the player for their name
  def prompt_player_name
    print PROMPT_PLAYER_NAME
    gets.chomp
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

  # Main game loop
  def game_loop
    loop do
      play_round
      break unless play_again?
    end
  end

  # Play a single round of the game
  def play_round
    puts "Starting a new round..."
    deal_initial_cards
    player_turn
    dealer_turn unless @player.hand.size == 3
    show_final_hands
    determine_winner
    reset_hands
  end

  # Deal initial cards to player and dealer
  def deal_initial_cards
    @player.add_card(@deck.draw)
    @player.add_card(@deck.draw)
    @dealer.add_card(@deck.draw)
    @dealer.add_card(@deck.draw)
    show_initial_hands
  end

  # Show initial hands of player and dealer (with one dealer card hidden)
  def show_initial_hands
    puts "Your initial hand: #{@player.show_hand} (Score: #{@player.score})"
    puts "Dealer's initial hand: #{@dealer.hand.first} and *"
  end

  # Handle player's turn
  def player_turn
    puts "Choose an action: 1) Pass 2) Add card 3) Open cards"
    action = gets.chomp.to_i
    case action
    when 1
      puts "You chose to pass."
    when 2
      if @player.hand.size == 2
        @player.add_card(@deck.draw)
        puts "You drew a card. Your hand: #{@player.show_hand} (Score: #{@player.score})"
      else
        puts "You cannot add more cards."
      end
    when 3
      puts "You chose to open cards."
    else
      puts "Invalid choice. Passing turn."
    end
  end

  # Handle dealer's turn
  def dealer_turn
    while @dealer.score < 17
      @dealer.add_card(@deck.draw)
      puts "Dealer drew a card."
    end
  end

  # Show final hands of player and dealer
  def show_final_hands
    puts "Your final hand: #{@player.show_hand} (Score: #{@player.score})"
    puts "Dealer's final hand: #{@dealer.show_hand} (Score: #{@dealer.score})"
  end

  # Determine the winner of the round
  def determine_winner
    player_score = @player.score
    dealer_score = @dealer.score
    if player_score > 21
      puts "You busted! Dealer wins."
      @dealer.bank += 20
    elsif dealer_score > 21 || player_score > dealer_score
      puts "You win!"
      @player.bank += 20
    elsif player_score < dealer_score
      puts "Dealer wins."
      @dealer.bank += 20
    else
      puts "It's a tie!"
      @player.bank += 10
      @dealer.bank += 10
    end
    puts "Your bank: #{@player.bank}"
    puts "Dealer's bank: #{@dealer.bank}"
  end

  # Ask player if they want to play again
  def play_again?
    print PLAY_AGAIN_PROMPT
    gets.chomp.downcase == 'yes'
  end

  # Reset hands of player and dealer for a new round
  def reset_hands
    @player.clear_hand
    @dealer.clear_hand
  end
end

# Instantiate and start the game
game = Game.new
game.start
