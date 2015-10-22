require Logger

defmodule Wizard do

  @moduledoc """
  # Wizard
  ## Universal King. 
  ### A utility module for keeping everything else clean.
   
  Creating the illusion, the curtain, and the whole stage,
  from behind the scenes.
  """

  use GenServer

  @doc """
  Wizard - A Holographic Hail to the Wizard.king.
  """
  def king do
    Process.whereis WizardServer
  end
  
  @doc "Use `Holo.bang` to start Holospace."
  def bang(path \\ "README.magic", opts \\ []) do
    GenServer.cast WizardServer, {:bang, path, opts}

    self
  end

  @doc "Two beams. Both have purpose."
  def tick(wizard) do
    GenServer.cast WizardServer, :tick
    
    self
  end
  def tock(wizard) do
    GenServer.cast WizardServer, :tock
    
    self
  end

  @doc "Save Holospace to `priv/holospace.term`."
  def freeze do
    GenServer.cast WizardServer, :freeze
    
    self
  end
    
  @doc """
  WARNING: Destroy various parts of the Multiverse.
  
  *thundering sounds*
  
  Accepts an atom `:holospace` for destroying the dynamic Holospace and
  `:universe` for destroying the static file system Universe.
  """
  def reset(opts \\ []) do
    # TODO: add (an entire..) auth process (using player + stampcodes)
    destroy_holospace = Keyword.get opts, :holospace, false
    destroy_universe = Keyword.get opts, :universe, false
    
    GenServer.cast WizardServer, {:reset, destroy_holospace, destroy_universe}
    
    self
  end
  
  ## Callbacks
  
  def handle_cast({:bang, path, opts}, agent) do
    Logger.info "Wizard.bang // #{inspect path}"
    
    # are we reloading an existing Holospace?
    reboot = Keyword.get(opts, :reboot, false)
    
    if reboot and File.exists?(Lovmx.project ["priv", "holospace.term"]) do
      archive = Lovmx.thaw Tube.read Lovmx.path ["priv", "holospace.term"]
    end
    
    # compute the initial holospace network
    Cake.mix Lovmx.project path
    
    # Second Creation of Waitforit.
    Task.async fn -> 
      Wizard.tick(self) 
    end
    
    {:noreply, agent}
  end
  
  def handle_cast(:tick, agent) do
    #Logger.info "Wizard:tick"
    #Holo.x self, "wizard/tick"
    
    {:noreply, agent}
  end
  
  def handle_cast(:tock, agent) do
    #Logger.info "Wizard:tock"
    #Holo.x self, "wizard/tock"

    # TODO: "janitorial tasks"
    # - archive magic
    # - galaxy magic
    # - multiverse magic
    
    Task.async fn -> 
      Wizard.freeze 
    end
    
    {:noreply, agent}
  end
  
  def handle_cast(:freeze, agent) do
    Logger.info "Wizard.freeze"
    
    Holo.space
    |> Lovmx.freeze
    |> Tube.write(Lovmx.path ["priv", "holospace.term"])
    
    {:noreply, agent}
  end
  
  def handle_cast({:reset, destroy_holospace, destroy_universe}, agent) do
    Logger.info "Wizard.reset"
    
    ## DESTROY
    
    if destroy_holospace do
      GenServer.cast HoloServer, {:reset, destroy_holospace, destroy_universe}
    end

    if destroy_universe do
      # copy the boot folder over
      File.rm_rf Lovmx.project ["priv", "static"]
      # freshly copy static stuff no matter what
      File.cp_r  Lovmx.project(["lib", "base"]), Lovmx.project ["priv", "static"]

      Logger.info "!reset // #universe // #{inspect Moment.now}"
    end
    
    ## RECREATE

    path = Lovmx.project Lovmx.web "help"
    
    # We want docs/help to be everywhere in the project, 
    # so re-copy dev/docs to holospace.
    
    File.mkdir_p path
    File.cp_r Lovmx.project(["doc"]), path
    File.ln_s Lovmx.project(Lovmx.web "doc"), path

    Logger.info "!reset // #help // #{inspect Moment.now}"
    
    {:noreply, agent}
  end

  def start_link(_) do
    # wizard state
    {:ok, agent} = Agent.start_link fn -> Map.new end
    
    link = {:ok, wizard} = GenServer.start_link(Wizard, agent, name: WizardServer)
    Logger.info "Wizard.start_link #{inspect link}"

    link
  end
  
end
