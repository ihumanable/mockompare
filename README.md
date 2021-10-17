# Mockompare

This repository serves as a companion project for [Patch](https://github.com/ihumanable/patch).

## Purpose

The purpose of this repository is to compare functionality between the following projects.

  - [meck](https://hex.pm/packages/meck)
  - [Mock](https://hex.pm/packages/mock)
  - [Mockery](https://hex.pm/packages/mockery)
  - [Mox](https://hex.pm/packages/mox)
  - [Patch](https://hex.pm/packages/patch)

## Expectations

Patch was written with a very simple concept of how a mock is meant to work.  When a test author mocks a function, public or private, they wish to replace that function with the mock for all callers.

Consider this example to see how the various libraries implement mocking.

```elixir
defmodule Example do
  def public_caller(a) do
    {:ok, public_function(a)}
  end

  def public_function(a) do
    {:public, a}
  end

  def private_caller(a) do
    {:ok, private_function(a)}
  end

  ## Private

  def private_function(a) do
    {:private, a}
  end
end
```

With this example we can then define 4 logical scenarios to see how the various libraries behave against our expectation that a mocked function should return the mock value to all callers.

### Scenario 1 - Mocking and calling a public function

In this scenario, mock `public_function/1` to return the value `:patched` then call `public_function/1`.  

The test author using the above definition of mocks would expect that calling `public_function/1` in a test should return `:patched`.

| Library | Result     |
|---------|------------|
| meck    | `:patched` |
| Mock    | `:patched` |
| Mockery | `:patched` |
| Mox     | `:patched` |
| Patch   | `:patched` |

This scenario is pretty straightforward and all the libraries produce the expected result.

### Scenario 2 - Mocking a public function and calling it as a collaborator

The `public_caller/1` function calls `public_function/1`, in testing terms we would say that `public_function/1` is a collaborator.  

In this scenario, mock `public_function/1` to return the value `:patched` and then call `public_caller/1` with the argument `:test`.  

The test author using the above definition of mocks would expect that calling `public_caller/1` would call `public_function/1` which is mocked and so `public_function/1` should return `:patched` and `public_caller/1` will wrap `:patched` with an `:ok` tuple returning `{:ok, :patched}`

| Library | Result                    | 
|---------|---------------------------|
| meck    | `{:ok, {:public, :test}}` |
| Mock    | `{:ok, {:public, :test}}` |
| Mockery | `{:ok, {:public, :test}}` |
| Mox     | `{:ok, {:public, :test}}` |
| Patch   | `{:ok, :patched}`         |

In this scenario Patch is the only library where the collaborator's mock is respected.  The reason for this is that the call in the module is a "local call" in BEAM parlance.  The other mocking libraries local calls end up in the original module and not in the mock.  This result is surprising for the definition of a mocked function as returning the mock value to all callers.

### Scenario 3 - Mocking a private function

In this scenario, mock `private_function/1` to return the value `:patched` and then call `private_function/1`.

The test author using the above definition of mocks would expect that calling `private_function/1` would return `:patched`

| Library | Result                                                                |
|---------|-----------------------------------------------------------------------|
| meck    | `ErlangError: {:undefined_function, {Example, :private_function, 1}}` |
| Mock    | `ErlangError: {:undefined_function, {Example, :private_function, 1}}` |
| Mockery | `UndefinedFunctionError`                                              |
| Mox     | `ArgumentError`                                                       |
| Patch   | `:patched`                                                            |

In this scenario only Patch provides the functionality to test a private function via it's `expose/2` function.  No other library provides an affordance for testing a private function so depending on their implementation they raise some kind of error.

### Scenario 4 - Mocking a private function and calling it as a collaborator

The `private_caller/1` function is a **public** function that calls `private_function/1`, in testing terms we would say that `private_function/1` is a collaborator.  

In this scenario, mock `private_function/1` to return the value `:patched` and then call `private_caller/1` with the argument `:test`

The test author using the above definition of mocks would expect that calling `private_caller/1` would call `private_function/1` which is mocked and so `private_function/1` should return `:patched` and `private_caller/1` will wrap `:patched` with an `:ok` tuple and return `{:ok, :patched}`

| Library | Result                                                                |
|---------|-----------------------------------------------------------------------|
| meck    | `ErlangError: {:undefined_function, {Example, :private_function, 1}}` |
| Mock    | `ErlangError: {:undefined_function, {Example, :private_function, 1}}` |
| Mockery | `UndefinedFunctionError`                                              |
| Mox     | `ArgumentError`                                                       |
| Patch   | `{:ok, :patched}`                                                     |

In this scenario Patch's ability to patch private functions combined with collaborator mocks being respected result in the mock being respected.

## Which Library is Right?

How mocks _should_ behave is a subjective question, there's no objective definition for which model is correct.  

Patch adopts a simple but powerful definition that is consistent and easy to reason about, patched functions always act like patched functions.

The other libraries adopt a different definition of mock, one that is more in line with the underlying mechanisms of BEAM.

## Reporting Issues

This comparison was assembled by following the documentation for each project to the best of my ability, but that's no guarantee that each test is implemented correctly.  If an issue in the tests is found, an issue or pull request is welcome.