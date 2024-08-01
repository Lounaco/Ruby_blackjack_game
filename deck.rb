# frozen_string_literal: true

require_relative 'card'

# Class representing a deck of cards
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
    reshuffle_if_needed
    @cards.pop
  end

  # Check if the deck is empty and reshuffle if necessary
  def reshuffle_if_needed
    @cards = create_shuffled_deck if @cards.empty?
  end
end
