defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  @doc """
    Returns a list of strings with all the cards in a deck
  """
  def create_deck do
    values = ["Ace","Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubes", "Hearts", "Diamonds"]

    for value <- values, suit <- suits do
        "#{value} of #{suit}"
    end

  end

  def shuffle_deck(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end
  @doc """
    Returns two lists: one with the first `num_of_cards` cards and other with the rest.
    We can use it like the following:

  ## Examples

      iex> deck = Cards.create_deck
      iex> {hand,deck} = Cards.deal(deck, 1)
      iex> hand 
      ["Ace of Spades"]
  """
  def deal(deck, num_of_cards) do
    Enum.split(deck, num_of_cards) 
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do 
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _message} -> "File couldn't be loaded properly"
    end
  end

  def create_hand(hand_size) do
    Cards.create_deck
    |> Cards.shuffle_deck
    |> Cards.deal(hand_size)
  end
end
 
