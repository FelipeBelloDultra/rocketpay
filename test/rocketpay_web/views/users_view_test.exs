defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase

  import Phoenix.View

  alias RocketpayWeb.UsersView
  alias Rocketpay.{Account, User}

  test "renders create.json" do
    params = %{
      name: "Testee",
      password: "testee",
      nickname: "Testee",
      email: "teste@hotmail.com",
      age: 20
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
      Rocketpay.create_user(params)

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        account: %{
          balance: Decimal.new("0.00"),
          id: account_id
        },
        id: user_id,
        name: "Testee",
        nickname: "Testee"
      }
    }

    assert expected_response == response
  end
end
