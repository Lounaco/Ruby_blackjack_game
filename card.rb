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
