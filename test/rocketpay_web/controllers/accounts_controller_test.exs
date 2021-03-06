defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Testee",
        password: "testee",
        nickname: "Testee",
        email: "teste@hotmail.com",
        age: 20
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic cm9ja2V0cGF5OnJvY2tldHBheQ==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "500.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "500.00", "id" => _id},
               "message" => "Ballance changed successfully"
             } = response
    end

    test "when there are valid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "No value"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

        expected_response = %{"message" => "Invalid deposit value!"}

      assert response == expected_response
    end
  end
end
