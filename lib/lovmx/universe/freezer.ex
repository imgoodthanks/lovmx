require Logger

defmodule Freezer do

  @moduledoc """
  # Freezer
  ## Static Object Storage Component.

  You'll need a `secret` or an `unsecret` message
  to use this object.

  # todo: write an encrypted storage layer here
  """

  # todo: stub mimetype support.
  @static %{
    "image/jpeg"  => %{ kind: "#jpg",       extension: ".jpg"},
    "image/png"   => %{ kind: "#png",       extension: ".png"},
    "image/gif"   => %{ kind: "#gif",       extension: ".gif"},
    "unknown"     => %{ kind: "#unknown",   extension: ".x"},
  }
  
  @doc "Create a Binary box (aka large file)."
  def put(path, kind, name) do
  	{binsum, _}   = System.cmd("/usr/bin/shasum", ["-a", "512224", Lovmx.path?(path)])
    binsum        = String.split(binsum, "  ", parts: 2) |> List.first

    # the public path
    binspace = Lovmx.path ["bin", "#{ binsum }#{ ext(kind) }"]
    
    # write the file..
    File.write! (Lovmx.root Lovmx.web binspace), File.read!(path), [:write]
    #Logger.debug "Freezer.putsum: #{path} kind: #{kind} name: #{name}]"
    
    # create the box
    box = Data.new(name, kind)
    box = Holo.move(box, binspace)
  end
  
  # Custom Freezer stuff.
  
  @doc "Freezer type/file extension accessor."
  def ext(kind) do
    box = @static[kind]
    
    #if box and Map.has_key? box.meta, kind do
    #  box.meta.extension
    #else
      @static["unknown"].extension
      #end
  end

end