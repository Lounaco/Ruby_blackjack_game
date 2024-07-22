# frozen_string_literal: true

class Card
  SUITS = ['♠', '♥', '♦', '♣'].freeze
  RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].freeze

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

class Deck
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

  # Reshuffle the deck if it's empty
  def reshuffle_if_needed
    @cards = create_shuffled_deck if @cards.empty?
  end
end

class Player
  attr_accessor :name, :bank, :hand

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

class Dealer < Player
  def initialize
    super("Dealer")
  end

  # Display the dealer's hand with hidden cards
  def show_hidden_hand
    @hand.map { '*' }.join(', ')
  end
end

class Game
  WELCOME_MESSAGE = "Welcome to the Blackjack game!"
  PROMPT_PLAYER_NAME = "Enter your name: "
  THANKS_FOR_PLAYING = "Thanks for playing!"
  PLAY_AGAIN_PROMPT = "Do you want to play again? (yes/no): "

  def initialize
    @deck = Deck.new
  end

  # Start the game
  def start
    display_welcome_message
    initialize_players
    game_loop
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
      reset_hands
    end
    puts THANKS_FOR_PLAYING
  end

  # Play one round of the game
  def play_round
    deal_initial_cards
    place_bets
    player_turn
    dealer_turn unless @player.score > 21
    reveal_cards
    determine_winner
  end

  # Deal initial cards to player and dealer
  def deal_initial_cards
    2.times do
      @player.add_card(@deck.draw)
      @dealer.add_card(@deck.draw)
    end
    show_initial_hands
  end

  # Place initial bets
  def place_bets
    @player.bank -= 10
    @dealer.bank -= 10
    @pot = 20
  end

  # Handle the player's turn
  def player_turn
    loop do
      puts "Your hand: #{@player.show_hand} (Score: #{@player.score})"
      puts "Dealer's hand: #{@dealer.show_hidden_hand}"

      if @player.score >= 21
        puts "You cannot take more actions."
        break
      end

      puts "Choose an action: 1) Pass 2) Add card 3) Open cards"
      action = gets.chomp.to_i
      case action
      when 1
        break
      when 2
        if @player.hand.size == 2
          @player.add_card(@deck.draw)
          break
        else
          puts "You can only add one card."
        end
      when 3
        break
      else
        puts "Invalid choice. Please try again."
      end
    end
  end

  # Handle the dealer's turn
  def dealer_turn
    loop do
      break if @dealer.score >= 17
      @dealer.add_card(@deck.draw)
    end
  end

  # Reveal both player's and dealer's cards
  def reveal_cards
    puts "Dealer's hand: #{@dealer.show_hand} (Score: #{@dealer.score})"
    puts "Your hand: #{@player.show_hand} (Score: #{@player.score})"
  end

  # Determine the winner of the round
  def determine_winner
    player_score = @player.score
    dealer_score = @dealer.score

    if player_score > 21
      puts "You busted! Dealer wins."
      @dealer.bank += @pot
    elsif dealer_score > 21 || player_score > dealer_score
      puts "You win!"
      @player.bank += @pot
    elsif dealer_score > player_score
      puts "Dealer wins."
      @dealer.bank += @pot
    else
      puts "It's a tie!"
      @player.bank += @pot / 2
      @dealer.bank += @pot / 2
    end
    show_banks
  end

  # Display the current bank amounts
  def show_banks
    puts "#{@player.name}'s bank: $#{@player.bank}"
    puts "Dealer's bank: $#{@dealer.bank}"
  end

  # Prompt the player to play again
  def play_again?
    print PLAY_AGAIN_PROMPT
    gets.chomp.downcase == 'yes'
  end

  # Reset the hands of both player and dealer
  def reset_hands
    @player.clear_hand
    @dealer.clear_hand
    @deck.reshuffle_if_needed
  end

  # Display initial hands of the player and the dealer (with one hidden card)
  def show_initial_hands
    puts "Your initial hand: #{@player.show_hand} (Score: #{@player.score})"
    puts "Dealer's initial hand: #{@dealer.hand[0]} and *"
  end
end
