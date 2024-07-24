# frozen_string_literal: true

require_relative 'card'

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
