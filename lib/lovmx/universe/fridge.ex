require Logger

defmodule Fridge do

  @moduledoc """
  # Fridge
  ## Database Storage Component(s)

  todo: write ecto driver
  """

  import Ecto.Query

  @doc "Insert data from `holospace`."
  def get(holospace \\ nil, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    # todo: insert..

    Data.new
  end

  @doc "Return all data from `holospace`."
  def set(data, secret \\ nil) do
    query = from things in Fridge.Model, select: things

    Fridge.Ecto.all(query)
  end

end


defmodule Fridge.Model do

  use Ecto.Model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "data" do
    field :key,                :string  #   :length => 40,    :key => true,   :auto_validation => false
    field :data,               :binary  #   :length => 80
  end

end


defmodule Fridge.Repo do

  use Ecto.Repo,
    otp_app: :lovmx,
    adapter: Mongo.Ecto

end
