defmodule Mockompare.MeckTest do
  use ExUnit.Case

  alias Mockompare.MeckTarget

  setup do
    on_exit(fn ->
      :meck.unload
    end)
  end

  test "mocking a public function" do
    assert MeckTarget.public_function(:test) == {:public, :test}

    :meck.new(MeckTarget, [:passthrough])
    :meck.expect(MeckTarget, :public_function, fn arg -> {:mock, arg} end)

    assert MeckTarget.public_function(:test) == {:mock, :test}
  end

  test "mocking a public collaborator" do
    assert MeckTarget.public_function(:test) == {:public, :test}
    assert MeckTarget.public_caller(:test) == {:original, {:public, :test}}

    :meck.new(MeckTarget, [:passthrough])
    :meck.expect(MeckTarget, :public_function, fn arg -> {:mock, arg} end)

    assert MeckTarget.public_function(:test) == {:mock, :test}
    assert MeckTarget.public_caller(:test) == {:original, {:mock, :test}}
  end

  test "mocking a private function" do
    assert_raise UndefinedFunctionError, fn ->
      MeckTarget.private_function(:test)
    end

    :meck.new(MeckTarget, [:passthrough])
    :meck.expect(MeckTarget, :private_function, fn arg -> {:mock, arg} end)

    assert MeckTarget.private_function(:test) == {:mock, :test}
  end

  test "mocking a private collaborator" do
    assert MeckTarget.private_caller(:test) == {:original, {:private, :test}}

    :meck.new(MeckTarget, [:passthrough])
    :meck.expect(MeckTarget, :private_function, fn arg -> {:mock, arg} end)

    assert MeckTarget.private_caller(:test) == {:original, {:mock, :test}}
  end
end
