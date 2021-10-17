defmodule Mockompare.PatchTest do
  use ExUnit.Case
  use Patch

  alias Mockompare.PatchTarget

  test "mocking a public function" do
    assert PatchTarget.public_function(:test) == {:public, :test}

    patch(PatchTarget, :public_function, fn arg -> {:mock, arg} end)

    assert PatchTarget.public_function(:test) == {:mock, :test}
  end

  test "mocking a public collaborator" do
    assert PatchTarget.public_function(:test) == {:public, :test}
    assert PatchTarget.public_caller(:test) == {:original, {:public, :test}}

    patch(PatchTarget, :public_function, fn arg -> {:mock, arg} end)

    assert PatchTarget.public_function(:test) == {:mock, :test}
    assert PatchTarget.public_caller(:test) == {:original, {:mock, :test}}
  end

  test "mocking a private function" do
    assert_raise UndefinedFunctionError, fn ->
      PatchTarget.private_function(:test)
    end

    patch(PatchTarget, :private_function, fn arg -> {:mock, arg} end)
    expose(PatchTarget, private_function: 1)

    assert private(PatchTarget.private_function(:test)) == {:mock, :test}
  end

  test "mocking a private collaborator" do
    assert PatchTarget.private_caller(:test) == {:original, {:private, :test}}

    patch(PatchTarget, :private_function, fn arg -> {:mock, arg} end)

    assert PatchTarget.private_caller(:test) == {:original, {:mock, :test}}
  end
end
