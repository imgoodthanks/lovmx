require Logger

defmodule Kind do
  
  @moduledoc """
  # Kind
  ## Data Types / Data Signals

  # We use the module Kind to get one useful namespace word
  # that flows well in source code and natural language. Kind is
  # an abstract signal-like query notion. A `Freezer.list` may look 
  # differently then what a `News.list` result would be and
  # certainly different than a `html([results], Kind.list)` call
  # may use. So if we think about `Data` as being *unmanifested*
  # energy (all potential flowing data) then Kind almost becomes 
  # the first query/tag/category we can put on `Data` before
  # collecting it.
  
  # From the start of `Kind` module usage we always work toward natural
  # language and common sense naming. Take great, great care
  # in naming.
  """
  
  ## Controls
  
  def boot, do: :boot # new/fresh
  def data, do: :data # object/data/json
  def meta, do: :meta # meta/control
  def lock, do: :lock # lock/secret
  def list, do: :list # show/head/etc
  def pull, do: :pull # pull/get/read 
  def code, do: :code # source/code
  def flow, do: :flow # run/exe/produce
  def push, do: :push # push/once/post/update
  def wait, do: :wait # promise/future    
  def drop, do: :drop # nil/nada/noop/drop
  
  ## Prototypes
  
  def text, do: :text # binary/text
  def link, do: :link # a path/URI/link
  def html, do: :html # an html snippet
  def blob, do: :blob # static/binary
  def cake, do: :cake # cake/magic/markdown+
  ## ^^^ cake is first class ^^^ 
  
  ## Exception
  def boom, do: :boom # error/exception/
    
end