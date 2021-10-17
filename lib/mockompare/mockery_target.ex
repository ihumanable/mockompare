defmodule Mockompare.MockeryTarget do
  import Mockery.Macro
  alias Mockompare.MockeryImpl

  def public_caller(a) do
    mockable(MockeryImpl).public_caller(a)
  end

  def public_function(a) do
    mockable(MockeryImpl).public_function(a)
  end

  def private_caller(a) do
    mockable(MockeryImpl).private_caller(a)
  end
end
