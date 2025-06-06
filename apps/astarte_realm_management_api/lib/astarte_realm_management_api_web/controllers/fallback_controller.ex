#
# This file is part of Astarte.
#
# Copyright 2017 - 2023 SECO Mind Srl
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

defmodule Astarte.RealmManagement.APIWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use Astarte.RealmManagement.APIWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(Astarte.RealmManagement.APIWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, :invalid_major}) do
    conn
    |> put_status(:not_found)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:invalid_major)
  end

  def call(conn, {:error, :realm_not_found}) do
    conn
    |> put_status(:forbidden)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:"403")
  end

  def call(conn, {:error, :interface_major_version_does_not_exist}) do
    conn
    |> put_status(:not_found)
    |> put_view(Astarte.RealmManagement.APIWeb.InterfaceView)
    |> render(:interface_major_version_does_not_exist)
  end

  def call(conn, {:error, :interface_not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:interface_not_found)
  end

  def call(conn, {:error, :trigger_not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:trigger_not_found)
  end

  def call(conn, {:error, :overlapping_mappings}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:overlapping_mappings)
  end

  def call(conn, {:error, :maximum_database_retention_exceeded}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:maximum_database_retention_exceeded)
  end

  def call(conn, {:error, :trigger_policy_not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:trigger_policy_not_found)
  end

  def call(conn, {:error, :trigger_policy_already_present}) do
    conn
    |> put_status(:conflict)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:trigger_policy_already_present)
  end

  def call(conn, {:error, :cannot_delete_currently_used_trigger_policy}) do
    conn
    |> put_status(:conflict)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:cannot_delete_currently_used_trigger_policy)
  end

  def call(conn, {:error, :invalid_device_id}) do
    conn
    |> put_status(:bad_request)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:invalid_device_id)
  end

  def call(conn, {:error, :device_not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:device_not_found)
  end

  # Invalid authorized path
  def call(conn, {:error, :invalid_auth_path}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:invalid_auth_path)
  end

  # This is called when no JWT token is present
  def auth_error(conn, {:unauthenticated, :unauthenticated}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:missing_token)
  end

  # Invalid JWT token
  def auth_error(conn, {:invalid_token, :invalid_token}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:invalid_token)
  end

  # Path not authorized
  def auth_error(conn, {:unauthorized, :authorization_path_not_matched}, _opts) do
    conn
    |> put_status(:forbidden)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:authorization_path_not_matched, %{method: conn.method, path: conn.request_path})
  end

  def auth_error(conn, {:unauthenticated, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:"401")
  end

  # In all other cases, we reply with 403
  def auth_error(conn, _reason, _opts) do
    conn
    |> put_status(:forbidden)
    |> put_view(Astarte.RealmManagement.APIWeb.ErrorView)
    |> render(:"403")
  end
end
