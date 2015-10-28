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
  Wizard - A Cloudgraphic Hail to the Wizard.king.
  """
  def king do
    Process.whereis WizardServer
  end
  
  @doc """
  Use `Cloud.bang` to start Holospace.
  """
  def bang(path \\ "README.magic", opts \\ []) do
    # hack/debug to reset everything each time the server starts
  if Mix.env == :dev do
    Wizard.reset_all!
  end
    
    GenServer.call WizardServer, {:bang, path, opts}, Help.long
  end

  @doc """
  Two beams. Both have purpose.
  """
  def tick(wizard) do
    GenServer.cast WizardServer, :tick
    
    self
  end
  def tock(wizard) do
    GenServer.cast WizardServer, :tock
    
    self
  end

  @doc """
  Save Holospace to `priv/holospace.term`.
  """
  def freeze do
    GenServer.cast WizardServer, :freeze
    
    self
  end
    
  @doc """
  WARNING: Destroy various parts of the Universe + Holospace.
  
  *thundering sounds*
  
  Accepts an atom `:holospace` for destroying the dynamic Holospace and
  `:universe` for destroying the static file system Universe.
  """
  def reset(opts \\ []) do
    # TODO: add (an entire..) auth process (using player + stampcodes)
    destroy_holospace = Keyword.get opts, :holospace, false
    destroy_universe = Keyword.get opts, :universe, false
    
    GenServer.call WizardServer, {:reset, destroy_holospace, destroy_universe}, Help.long
  end
  
  def reset_all! do
    reset holospace: true, universe: true
  end
  
  ## Callbacks
  
  def handle_call({:bang, path, opts}, source, agent) do
    Logger.info "Wizard.bang // #{inspect Help.project path}"

    # are we reloading an existing Holospace?
    reboot = Keyword.get(opts, :reboot, false)
    
    if reboot and File.exists?(Help.project ["priv", "holospace.term"]) do
      archive = Help.thaw Drive.read Help.path ["priv", "holospace.term"]
    end
    
    # First creation of the initial holospace network
    "README.magic"
    |> Drive.read # read the file
    |> Cake.magic # compile magicdown (markdown+) into data/bot
    |> Holo.boost "help"# send it into holospace

    
    # Second Creation of Waitforit.
    Task.async fn -> 
      Wizard.tick(self) 
    end

    {:reply, self, agent}
  end
  
  def handle_cast(:tick, agent) do
    #Logger.info "Wizard:tick"
    
    {:noreply, agent}
  end
  
  def handle_cast(:tock, agent) do
    #Logger.info "Wizard:tock"

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
    |> Help.freeze
    |> Drive.write(Help.path ["priv", "holospace.term"])
    
    {:noreply, agent}
  end
  
  def handle_call({:reset, destroy_holospace, destroy_universe}, source, agent) do
    Logger.info "Wizard.reset"
    
    ## DESTROY
    
    if destroy_holospace do
      GenServer.cast HoloServer, {:drop}
    end

    if destroy_universe do
      # copy the boot folder over
      File.rm_rf Help.project ["priv", "static"]
      # freshly copy static stuff no matter what
      File.cp_r  Help.project(["lib", "base"]), Help.project ["priv", "static"]

      Logger.info "!reset // #universe // #{inspect Moment.now}"
    end
    
    ## RECREATE

    path = Help.project Help.web "help"
    
    # We want docs/help to be everywhere in the project, 
    # so re-copy dev/docs to holospace.
    
    File.mkdir_p path
    File.cp_r Help.project(["doc"]), path
    File.ln_s Help.project(Help.web "doc"), path
    
    Logger.info "!reset // #help // #{inspect Moment.now}"
    
    {:reply, self, agent}
  end
  
  def start_link(_) do
    # wizard state
    {:ok, agent} = Agent.start_link fn -> Map.new end
    
    link = {:ok, wizard} = GenServer.start_link(Wizard, agent, name: WizardServer)
    Logger.info "Wizard.start_link #{inspect link}"

    link
  end
  
end
