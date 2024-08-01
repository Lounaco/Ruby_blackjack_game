# frozen_string_literal: true

require_relative 'deck'
require_relative 'player'
require_relative 'dealer'

# Class containing the main logic of the Blackjack game
class Game
  WELCOME_MESSAGE = "Welcome to the Blackjack game!"
  PROMPT_PLAYER_NAME = "Enter your name: "
  THANKS_FOR_PLAYING = "Thanks for playing!"
  PLAY_AGAIN_PROMPT = "Do you want to play again? (yes/no)"

  def initialize
    @deck = Deck.new
    @player = nil
    @dealer = nil
    @player_bank = 100
    @dealer_bank = 100
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
      # Reset bank values for each new game
      @player.bank = @player_bank
      @dealer.bank = @dealer_bank
      
      play_round
      break unless play_again?
    end
  end

  # Play a single round of the game
  def play_round
    puts "Starting a new round..."
    make_bets
    deal_initial_cards
    player_turn
    dealer_turn unless @player.hand.size == 3
    show_final_hands
    determine_winner
    reset_hands
  end

  # Deduct bets from player's and dealer's bank
  def make_bets
    @player.bank -= 10
    @dealer.bank -= 10
    @bank = 20
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
    puts 'Choose an action: 1) Pass 2) Add card 3) Open cards'
    action = gets.chomp.to_i
    case action
    when 1
      puts 'You chose to pass.'
    when 2
      if @player.hand.size == 2
        @player.add_card(@deck.draw)
        puts "You drew a card. Your hand: #{@player.show_hand} (Score: #{@player.score})"
      else
        puts 'You cannot add more cards.'
      end
    when 3
      puts 'You chose to open cards.'
    else
      puts 'Invalid choice. Passing turn.'
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

    if player_score > 21 && dealer_score > 21
      puts "Both you and the dealer busted! It's a tie."
      @player.bank += 10
      @dealer.bank += 10
    elsif player_score > 21
      puts 'You busted! Dealer wins.'
      @dealer.bank += 20
    elsif dealer_score > 21
      puts 'Dealer busted! You win.'
      @player.bank += 20
    elsif player_score > dealer_score
      puts 'You win!'
      @player.bank += 20
    elsif player_score < dealer_score
      puts 'Dealer wins.'
      @dealer.bank += 20
    else
      puts "It's a tie!"
      @player.bank += 10
      @dealer.bank += 10
    end

    puts "Before determining winner: Player bank: #{@player_bank}, Dealer bank: #{@dealer_bank}"
    puts "After determining winner: Player bank: #{@player.bank}, Dealer bank: #{@dealer.bank}"
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
