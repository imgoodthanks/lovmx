require Logger

use Magic

# LovMx + ILvMx.
## Orbital Magic for Cloud Apps.
### Internet LoveMx + Internet Love and #virtual Magic #exchange

LovMx + ILvMx are free and open source nonprofit 
global projects to host a namespace of code/data/datas.

We are a fun (silljays.com).
We develop a cloud app server (this project).
We created a reference cloud app client (lolnub.app). 
We host a public data service (ilvmx.com).
We give away the best Web Theme Park on the net. (lolnub.com)

In a nutshell, we wanna build: 
 
An Elixir-based Wolfram Language 
powered by a Twitter like network 
of Markdown-style documents 
for Clients connected to their own private VPN/VM
running an Orbital Magic framework written in the 
sexiest language/runtime in the world, oh my dear love Erlang/Elixir, 
for the purpose of creating a grassroots network
of Code + Data + Data storage aka Cake Apps 
written by commerce and community 
in a *meticulously* namespaced 
v2v storage-based network made 
completely open source and transparent.

Yeah that sounds right.

Welcome to #nubspace. Here, take this map...

# Chapter 1. LovMx Tree of Life.

Generally speaking, the Multiverse has three parts above,
three below, and only really a few things in the middle we 
need to actually care about.

# graph/higher

- Data // both a particle (code/data) and a wave (roll/jump)
- Flow // push/pull data from other `nubspace` and `data`
- Pipe // push one-way `data` to other parts of `nubspace`

# universe
- Bot // easily create code + data components w/ a variety of data
- Bridge // default HTTPS API server and NoFlo gateway
- Player // user agents

# vmx
- Holo // global namespace of code + data storage
- Machine // the virtual/physical code/server object 
- Tube // input/output API endpoints

# hyperverse
- Cake // All energy/matter/movement
- Wizard // like a galactic nuclear janitor


## LovMx - Multiverse
```
–––––––––––––––––––
[universe]
–––––––––––––––––––
[vmx/holo]
[vmx/machine]
[vmx/tube]
–––––––––––––––––––
[server/multiverse]
–––––––––––––––––––
```
## Virtual Machine eXchange
#############################################################

```
pattern |  in              out   | side effects
––––––––|––––––––––––––––––––––––|–––––––––––––––––––––––––
data    |  Holo \       / Tube   | output |> html/json/etc
––––––––|––––––––––––––––––––––––|–––––––––––––––––––––––––
actual  |        Machine         | files/sockets/https
––––––––|––––––––––––––––––––––––|–––––––––––––––––––––––––
```

# Chapter 2. Data is All.

 Data is nice for storing objects to disk,
 but let's play with dynamic data too. Here
 we will capture a flow of data or a data flow.

### Creating static objects (a Data-based Data flow) inside your head.
data = Data.new "hi, this is your ai speaking.", Kind.auto

### Save it to the Db
### todo: write Db layer.
data = Fridge.push data

### Push it to the Web.
data = Tube.post data, "a/test/file"


# Chapter 3. Flowing Data

```
## Setup the README.
"README.magic"
|> read # read the file
|> magic # compile magicdown (markdown+) into data/bot
|> move "help" # move the bot into the `help` nubspace
|> rate "fuzzy" # rate it as here but not critical
|> orbit # send it into nubspace


# create a forward secrecy style page
"/"
|> pull "visitors"
|> push "login"
|> page "secrets/923/player/anonymous"


new "core/Kick"
|> data "Serverside4"
|> pull "webserver/Server"
|> pull "websocket/ListenConnections"
|> page "core/Split"



# Start a Reddit Bot
"reddit"
|> code(fn data ->
  "https://reddit.com/r/news"
  |> compile
  |> code(fn post_from_reddit -> 
    Pipe.email "mike@silljays.com"
  end)
  |> x
end
|> orbit


## A counter bot
"/"
|> new(0)
|> code(fn b -> pull b, (b.pull + 1) end)
|> x "counter"


"frameworks are cool"
|> Data.new(Kind.auto)
|> Flow.x("#create a data/flow that we can push/pull/animate with")
|> Flow.r("#pipe a magic down (markdown+) like file at `data.pull.magic`")
|> Flow.i(Kind.magic, Pipe.down Holo.read "README.magic")
|> Flow.i(Kind.text, "checkout `Data#types` or just use custom data here to works"),
|> Flow.i(Kind.html, Holo.compile)
|> Flow.i(Kind.code, Bot.code do
  bot
  |> Flow.r("#pipe a magic down (markdown+) like file at `data.pull.magic`")
  |> Bot.pull(Kind.html, Pipe.down)
end
|> Flow.r("#text", "ok see how it works? create data, then change it..")
|> Flow.r("#text", "now we need to Pipe the `data` flow somewhere in order to process it")
|> Flow.i(Kind.code, Bot.code)
|> Flow.r("#text", "let's create a web page first")
|> Flow.o(Web.post)
|> Holo.x

# That should be fairly clear.

Now let's store and secret something in a private Castle.

%Data{native: TodoEncryption} = Castle.secret Data.new("hide stuff here.."), "secretpassword"

# Using a Fridge.

%Data{native: TodoDb} = Fridge.pull "something", "password"


# Writing files.

%Data{} = Data.write Data.new, "something", "password"

# Reading files.

%Data{} = Data.read "<nubspace>", "password"

# Storing stuff publically from the Computer or server."

Holo.push "about", Holo.read "README.magic"

# Reading stuff from the public Computer or server drives."

Holo.pull "about"

# Creating stuff in memory only.

fn bot -> Holo.compile "https://reddit.com/r/#{bot.pull.uri}" end
|> Bot.code
|> Holo.x
|> Holo.x "whateverpath", "whateverpassword"

# Reading all scenes from private memory.
Holo.y

# Exe *all* `data.code` for *all* lower nubspace.
Holo.z "whateverpath", "whateverpassword"

# Any memories there or that exist?
Holo.p "whateverpath"

# *WHAT* is there exactly?
Holo.d "whateverpath"

# Create web pages and JSON stuff

"hi"
|> Data.new
|> Flow.x("create hi pagte")
|> Flow.i(Kind.code, Data.new)
|> Flow.o(Web.post("hi.html")
|> Data.new("hi.html", Kind.link)

```

# Chapter 4. Maru Routers for advanced data flows.

Working Code showing how to process routes in Nubspace + add content.
########################################################################

```
Holo.x "Chapter 4. // basically do all of the stuff above.."

defmodule Readme.Web do

  @moduledoc """
   # Galaxy
  ## Lovmx-level public data and data storage Container and Data Map.

  Galaxy is a global map of: <nubspace> -> [things] and are
  superpowered by Maru-brand Routers which are awesome. Ask an
  associate for more information.

  https://maru.readme.io

  Galaxy(s) are the *center* of `Holo.Nubspace` where all
  *UNIQUE* code/data/flows are *merged* into a single cohesive
  Galaxy-wide hologram to be namespaced, stored, and experienced.

  Galaxy(s) host all *PUBLIC* static/dynamic content, which
  means a Galaxy is primarily responsible for creating and
  maintaining the global object graph + all dynamic content
  and updates that happen during normal usage.
  """

  # include Maru + other helpful modules
  use OrbitalMagic

  namespace do
    route_param :nubspace do
      get do
        nubspace = Lovmx.path params[:nubspace]
        
        data
        Holo.fuzzy params[:nubspace]
      end
      route_param :subpath do
        get do
          nubspace = Lovmx.path [params[:nubspace], params[:subpath]]
          
          spawn(params[:nubspace], params[:subpath], Data.new nubspace)

          Holo.fuzzy params[:nubspace]
        end
      end
    end
  end

  # A stub into the Universe below...
  get do
    Holo.read "README.magic"
  end

end
```

## NOTES
#############################################################

 Check out Bridge for a standard LovMx module, it also
 works well as an example `Application` (aka Elixir 
 Module) you would need to write to use the LovMx on
 your own.

 This Bridge uses the server flavor of OrbitalMagic 
 but we also have an awesome Maru based include for
 building data APIs.. check out `lib/cake.ex` to see 
 more about and how other Orbital Magic works.

 The LovMx also works well inside a Phoenix app
 (see www.ilvmx.com or github.com/silljays/ilvmx)
 because the LovMx loves to flip the Bird. Phoenix 
 channels plus <3 this universe.

 Finally, the server can be started from the command
 line (aka standalone) optionally initated into the 
 the ilvmx/galaxy/:whatever

 In Galaxy mode the server will search #todo for other 
 LovMx nodes and automatically begin participating
 in the network via establishing Holo + Tube links.

 todo: much of the networking, discovery/propgation, and
 auth parts and in need of good love. But the ideas and
 proof of concepts should be mostly stubbed.