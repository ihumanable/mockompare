defmodule Mockompare.MockeryTest do
  use ExUnit.Case
  import Mockery

  alias Mockompare.{MockeryTarget, MockeryImpl}

  test "mocking a public function" do
    assert MockeryTarget.public_function(:test) == {:public, :test}

    mock MockeryImpl, [public_function: 1], fn arg -> {:mock, arg} end

    assert MockeryTarget.public_function(:test) == {:mock, :test}
  end

  test "mocking a public collaborator" do
    assert MockeryTarget.public_function(:test) == {:public, :test}
    assert MockeryTarget.public_caller(:test) == {:original, {:public, :test}}

    mock MockeryImpl, [public_function: 1], fn arg -> {:mock, arg} end

    assert MockeryTarget.public_function(:test) == {:mock, :test}
    assert MockeryTarget.public_caller(:test) == {:original, {:mock, :test}}
  end

  test "mocking a private function" do
    assert_raise UndefinedFunctionError, fn ->
      MockeryTarget.private_function(:test)
    end

    mock MockeryImpl, [private_function: 1], fn arg -> {:mock, arg} end

    assert MockeryTarget.private_function(:test) == {:mock, :test}
  end

  test "mocking a private collaborator" do
    assert MockTarget.private_caller(:test) == {:original, {:private, :test}}

    mock MockeryImpl, [private_function: 1], fn arg -> {:mock, arg} end

    assert MockeryTarget.private_caller(:test) == {:original, {:mock, :test}}
  end
end
