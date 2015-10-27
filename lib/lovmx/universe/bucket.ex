require Logger

defmodule Bucket do

  @moduledoc """
  # Bucket
  ## Extensible Storage/Transport Component(s)

  Bucket(s) read/write/store Data directly to the Cloud drive.
  Bucket(s) also mutate and forward data. For example the Mac
  client uses an Obj-C Class SparseBundleFreezer for it's
  storage needs so we need to have a server-side Bucket/map
  of that data store and the Unix and Windows versions
  will need a map too at some point.
  """

  ## Types

  def folder_bucket do
    Data.new
  end

  def sparse_bundle_bucket do
    Data.new
  end

end