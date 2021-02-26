defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "whe all params are valid, returns an user" do
      params = %{
        name: "Testee",
        password: "testee",
        nickname: "Testee",
        email: "teste@hotmail.com",
        age: 20
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Testee", age: 20, id: ^user_id} = user
    end

    test "whe there are invalid params, returns an error" do
      params = %{
        name: "Testee",
        nickname: "Testee",
        email: "teste@hotmail.com",
        age: 18
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
