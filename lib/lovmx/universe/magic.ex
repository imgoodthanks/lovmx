require Logger

defmodule Magic do
  
  @moduledoc "Use `Magic` for easy Elixir."
  
  defmacro __using__(opts \\ []) do
    
    quote do
      
      # data
      
      Code.ensure_loaded Data
      import Data

      Code.ensure_loaded Flow
      import Flow
      
      Code.ensure_loaded Pipe
      import Pipe
      
      # magic
      
      Code.ensure_loaded Cake
      import Cake
      
      Code.ensure_loaded Help
      import Help
      
      # VMX
          
      Code.ensure_loaded Drive
      import Drive
      
      Code.ensure_loaded Holo
      import Holo
      
    end
  
  end

end

defmodule OrbitalMagic do
  
  @moduledoc "Use `OrbitalMagic` for easy Plugs in Elixir."
  
  defmacro __using__(opts \\ []) do
    
    quote do
      
      import Plug.Conn

      use Plug.Router
      use Plug.Builder

      plug :match
      plug :dispatch

      use WebAssembly

    end
    
  end
  
end

defmodule MaruMagic do
  
  @moduledoc "Use `MaruMagic` for easy APIs in Elixir."
  
  defmacro __using__(opts \\ []) do
    
    quote do

      import Plug.Conn
      use Maru.Router
      plug Plug.Logger

      use WebAssembly

    end
    
  end
  
end