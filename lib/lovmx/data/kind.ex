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
  
  ## Signal             # Magic         # Abstract
                        
  def boot, do: :boot   # Flow.beam     # new/fresh
  def data, do: :data   # Data.thing    # object/data/json
  def meta, do: :meta   # Data.meta     # meta/control
  def lock, do: :lock   # Castle.lock   # lock/secret
  def list, do: :list   # Drive.list    # show/head/etc
  def pull, do: :pull   # Flow.pull     # pull/get/read 
  def code, do: :code   # Data.code     # source/code
  def flow, do: :flow   # Holo.graph    # run/exe/produce
  def push, do: :push   # Flow.push     # push/once/post/update
  def wait, do: :wait   # Flow.wait     # promise/future    
  def drop, do: :drop   # Pipe.drop     # nil/nada/noop/drop
  
  ## Prototypes         # Default       # Abstract
                        
  def text, do: :text   # Pipe.text     # binary/text
  def link, do: :link   # Data.address  # a path/URI/link
  def html, do: :html   # Pipe.html     # an html snippet
  def blob, do: :blob   # Freezer.put   # static/binary
  def cake, do: :cake   # Cake.magic    # cake/magic/markdown+
  ## ^^^ cake is first class ^^^ 
  
  ## Exception
  def boom, do: :boom # error/exception/
    
end