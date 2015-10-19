require Logger

defmodule Wizard do

  @moduledoc """
  # Wizard
  
  Creating the illusion, the curtain, and the whole stage,
  from behind the scenes.
  """

  use GenServer

  @doc "You called?"
  def start_link(lovmx) do
    # wizard state
    link = {:ok, wizard} = GenServer.start_link(Wizard, %{}, name: WizardKing)
    #Logger.debug "Wizard.start_link #{inspect link}"

    # Kickoff the First Creation of Init.
    wizard |> wake

    # Second Creation of Waitforit.
    Task.async fn -> Wizard.tick(self) end

    link
  end

  @doc "Hail to the Wizard.king."
  def king do
    Process.whereis WizardKing
  end

  @doc "Two beams. Both have purpose."
  def wake(wizard) do
    # return
    self
  end

  @doc "Two beams. Both have purpose."
  def tick(wizard) do
    #Holo.orbit self, "wizard/tick"

    self
  end
  def tock(wizard) do
    #Holo.orbit self, "wizard/tick"

    #todo: "janitorial tasks"
    # - archive magic
    # - galaxy magic
    # - multiverse magic

    Task.async fn -> Holo.freeze end
    
    self
  end
  
end
