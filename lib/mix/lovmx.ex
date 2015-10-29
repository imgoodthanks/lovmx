require Logger

defmodule Mix.Tasks.Lovmx do
  use Mix.Task

  def run(argv \\ nil) do
    # start the hologram
    Application.ensure_started :lovmx
    
    Logger.info "Platform.Unix.run #{inspect self}"
    
    Platform.Unix.run(argv)
  end
  
end

defmodule Platform do
  
  defmodule Unix do
    
    @moduledoc """
    # Unix
    ## Command line Love.
    """
  
    def run(argv) do
      # start the hologram
      Application.ensure_started :lovmx
    
      Lovmx.start(nil, nil)
    
      parse_args(argv)
    end
  
    @doc """
    `argv` can be -h or --help, which returns :help.
    `argv` can be --magic <path>
    `argv` can be --grab  <path>
    `argv` can be --auto  <path>
    """
    def parse_args(argv) do
      parse = OptionParser.parse(argv, switches: [help: :boolean, magic: :string, grab: :string, auto: :string], aliases: [h: :help])
    
      Logger.info inspect parse
    
      case parse do
        {[help: true ], _, _} -> 
          :help

        {[mix: path], _, _} -> 
          path
          |> Cake.mix
          |> inspect
          |> IO.write
        
        {[magic: path], _, _} ->
          data = path
          |> Drive.read
          |> Cake.magic
          |> Pipe.page("#{path}.boot.html")
        
          data
          |> Pipe.text
          |> Logger.info
        
        _ -> :help
      end
    end
  
    ## todo: add directory/spider support for crawling and analzying file systems
  
    ## todo: add full repl support from the command line
  
    ## todo: add a Screen buffer aka htop for watchers
  
  end

  defmodule Mac do
  
    # todo: launch Desktop Services for any listening Mac apps.

  end

  defmodule Windows do
  
    # todo: launch whatever clusterfuck MS is pushing this week.
  
  end
  
end
