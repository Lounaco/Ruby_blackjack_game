# frozen_string_literal: true

require_relative 'player'

# Class representing the dealer in the game, inherits from Player
class Dealer < Player
  def initialize
    super('Dealer')
  end
end
