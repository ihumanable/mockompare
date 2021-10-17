defmodule Mockompare.MoxTarget do
  def impl do
    Application.get_env(:mockompare, :mox_impl)
  end

  def public_caller(a) do
    impl().public_caller(a)
  end

  def public_function(a) do
    impl().public_function(a)
  end

  def private_caller(a) do
    impl().private_caller(a)
  end
end
