defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create a deck makes 20 cards" do
    deck_lenght = length(Cards.create_deck)
    assert deck_lenght == 20
  end
end
