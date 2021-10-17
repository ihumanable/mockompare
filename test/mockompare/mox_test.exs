defmodule Mockompare.MoxTest do
  use ExUnit.Case, async: true
  import Mox

  alias Mockompare.{MockMoxImpl, MoxImpl, MoxTarget}

  setup :verify_on_exit!

  setup do
    Mox.defmock(Mockompare.MockMoxImpl, for: Mockompare.MoxContract)
    Mox.stub_with(MockMoxImpl, MoxImpl)
    Application.put_env(:mockompare, :mox_impl, Mockompare.MockMoxImpl)
  end

  test "mocking a public function" do
    assert MoxTarget.public_function(:test) == {:public, :test}

    expect(MockMoxImpl, :public_function, fn arg -> {:mock, arg} end)

    assert MoxTarget.public_function(:test) == {:mock, :test}
  end

  test "mocking a public collaborator" do
    assert MoxTarget.public_function(:test) == {:public, :test}
    assert MoxTarget.public_caller(:test) == {:original, {:public, :test}}

    expect(MockMoxImpl, :public_function, fn arg -> {:mock, arg} end)

    assert MoxTarget.public_function(:test) == {:mock, :test}
    assert MoxTarget.public_caller(:test) == {:original, {:mock, :test}}
  end

  test "mocking a private function" do
    assert_raise UndefinedFunctionError, fn ->
      MoxTarget.private_function(:test)
    end

    expect(MockMoxImpl, :private_function, fn arg -> {:mock, arg} end)

    assert MoxTarget.private_function(:test) == {:mock, :test}
  end

  test "mocking a private collaborator" do
    assert MoxTarget.private_caller(:test) == {:original, {:private, :test}}

    expect(MockMoxImpl, :private_function, fn arg -> {:mock, arg} end)

    assert MoxTarget.private_caller(:test) == {:original, {:mock, :test}}
  end
end
