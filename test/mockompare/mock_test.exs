defmodule Mockompare.MockTest do
  use ExUnit.Case
  import Mock

  alias Mockompare.MockTarget

  test "mocking a public function" do
    assert MockTarget.public_function(:test) == {:public, :test}


    with_mock MockTarget, [:passthrough], [public_function: fn arg -> {:mock, arg} end] do
      assert MockTarget.public_function(:test) == {:mock, :test}
    end
  end

  test "mocking a public collaborator" do
    assert MockTarget.public_function(:test) == {:public, :test}
    assert MockTarget.public_caller(:test) == {:original, {:public, :test}}

    with_mock MockTarget, [:passthrough], [public_function: fn arg -> {:mock, arg} end] do
      assert MockTarget.public_function(:test) == {:mock, :test}
      assert MockTarget.public_caller(:test) == {:original, {:mock, :test}}
    end
  end

  test "mocking a private function" do
    assert_raise UndefinedFunctionError, fn ->
      MockTarget.private_function(:test)
    end

    with_mock MockTarget, [:passthrough], [private_function: fn arg -> {:mock, arg} end] do
      assert MockTarget.private_function(:test) == {:mock, :test}
    end
  end

  test "mocking a private collaborator" do
    assert MockTarget.private_caller(:test) == {:original, {:private, :test}}

    with_mock MockTarget, [:passthrough], [private_function: fn arg -> {:mock, arg} end] do
      assert MockTarget.private_caller(:test) == {:original, {:mock, :test}}
    end
  end

end
