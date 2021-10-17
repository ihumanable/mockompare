defmodule Mockompare.MoxContract do
  @callback public_caller(term()) :: {atom(), {atom(), term()}}
  @callback public_function(term()) :: {atom(), term()}
  @callback private_caller(term()) :: {atom(), {atom(), term()}}
end
