use Magic
require Logger

Cloud.share Data.new "WHY"
Logger.debug "BOOT.exs"

# Chapter 3. Flowing Data
## Setup the README.

# # LovMx + ILvMx.
# ## Welcome to Cloudspace.
# ### Orbital Magic for Cloud Apps.
#
# LovMx + ILvMx are free and open source nonprofit projects
# to host a global namespace of code/data/blobs.
#
# We are fun (silljays.com).
# We develop a cloud app server (this project).
# We develop a reference cloud app client (lolnub.app).
# We host a public data service (ilvmx.com).
# We give away the best Web Theme Park on the net. (lolnub.com)
#
# In a nutshell, we wanna build:
#
# *An Elixir-based Wolfram Language
# powered by a Twitter like network
# of Markdown-style documents
# for Clients connected to their own private VPN/VM
# running an Orbital Magic framework written in the
# sexiest language/runtime in the world, oh my dear love Erlang/Elixir,
# for the purpose of creating a grassroots network
# of Code + Data + Data storage aka Cake Apps
# written by commerce and community
# in a *meticulously* namespaced
# v2v storage-based network made
# completely open source and transparent.*
#
# Yeah that sounds right.
#
# Welcome to Cloudspace. Here, take this map...
#
# # Chapter 1. LovMx Tree of Life.
#
# Generally speaking, the Multiverse has three parts above,
# three below, and only really a few things in the middle we
# need to actually care about.
#
# # graph/higher
# - Data // both a particle (code/data) and a wave (roll/jump)
# - Flow // push/pull data from other `holospace` and `data`
# - Pipe // push one-way `data` to other parts of `holospace`
#
# # universe
# - Bot // easily create code + data components w/ a variety of data
# - Bridge // default HTTPS API server and NoFlo gateway
# - Player // user agents
#
# # vmx
# - Cloud // global namespace of code + data storage
# - Machine // the virtual/physical code/server object
# - Cloud // input/output API endpoints
#
# # hyperverse
# - Cake // All energy/matter/movement
# - Wizard // like a galactic nuclear janitor
#
#
# ## LovMx - Multiverse
# ```
# –––––––––––––––––––
# [universe]
# –––––––––––––––––––
# [vmx/holo]
# [vmx/machine]
# [vmx/tube]
# –––––––––––––––––––
# [server/multiverse]
# –––––––––––––––––––
# ```
# ## Virtual Machine eXchange
# #############################################################
#
# ```
# pattern |  in              out   | side effects
# ––––––––|––––––––––––––––––––––––|–––––––––––––––––––––––––
# data    |  Cloud \       / Cloud   | output |> html/json/etc
# ––––––––|––––––––––––––––––––––––|–––––––––––––––––––––––––
# actual  |        Machine         | files/sockets/https
# ––––––––|––––––––––––––––––––––––|–––––––––––––––––––––––––
# ```
#
# # Chapter 2. Data is All.
#
#  Data is nice for storing objects to disk,
#  but let's play with dynamic data too. Here
#  we will capture a flow of data or a data flow.
#
# ### Creating static objects (a Data-based Data flow) inside your head.
# data = Data.new "hi, this is your ai speaking.", Kind.auto
#
# ### Save it to the Db
# ### todo: write Db layer.
# data = Fridge.push data
#
# ### Push it to the Web.
# data = Cloud.post data, "a/test/file"
#
#
# # Chapter 3. Flowing Data
#
# ```
# ## Setup the README.
# "README.magic"
# |> read # read the file
# |> magic # compile magicdown (markdown+) into data/bot
# |> move "help" # move the bot into the `help` holospace
# |> rate "fuzzy" # rate it as here but not critical
# |> orbit # send it into holospace
#
#
# # create a forward secrecy style page
# "/"
# |> pull "visitors"
# |> push "login"
# |> page "secrets/923/player/anonymous"
#
#
# new "core/Kick"
# |> data "Serverside4"
# |> pull "webserver/Server"
# |> pull "websocket/ListenConnections"
# |> page "core/Split"
#
#
#
# # Start a Reddit Bot
# "reddit"
# |> code(fn data ->
#   "https://reddit.com/r/news"
#   |> compile
#   |> code(fn post_from_reddit ->
#     Pipe.email "mike@silljays.com"
#   end)
#   |> x
# end
# |> orbit
#
#
# ## A counter bot
# "/"
# |> new(0)
# |> code(fn b -> pull b, (b.thing + 1) end)
# |> x "counter"
#
#
# "frameworks are cool"
# |> Data.new(Kind.auto)
# |> Flow.x("#create a data/flow that we can push/pull/animate with")
# |> Flow.r("#pipe a magic down (markdown+) like file at `data.pull.magic`")
# |> Flow.i(Kind.magic, Pipe.down Cloud.read "README.magic")
# |> Flow.i(Kind.text, "checkout `Data#types` or just use custom data here to works"),
# |> Flow.i(Kind.html, Cloud.compile)
# |> Flow.i(Kind.code, Data.code do
#   bot
#   |> Flow.r("#pipe a magic down (markdown+) like file at `data.pull.magic`")
#   |> Bot.pull(Kind.html, Pipe.down)
# end
# |> Flow.r("#text", "ok see how it works? create data, then change it..")
# |> Flow.r("#text", "now we need to Pipe the `data` flow somewhere in order to process it")
# |> Flow.i(Kind.code, Data.code)
# |> Flow.r("#text", "let's create a web page first")
# |> Flow.o(Web.post)
# |> Cloud.x
#
# # That should be fairly clear.
#
# Now let's store and secret something in a private Castle.
#
# %Data{thing: TodoEncryption} = Castle.secret Data.new("hide stuff here.."), "secretpassword"
#
# # Using a Fridge.
#
# %Data{thing: TodoDb} = Fridge.pull "something", "password"
#
#
# # Writing files.
#
# %Data{} = Data.write Data.new, "something", "password"
#
# # Reading files.
#
# %Data{} = Data.read "<holospace>", "password"
#
# # Storing stuff publically from the Computer or server."
#
# Cloud.push "about", Cloud.read "README.magic"
#
# # Reading stuff from the public Computer or server drives."
#
# Cloud.space "about"
#
# # Creating stuff in memory only.
#
# fn bot -> Cloud.compile "https://reddit.com/r/#{bot.pull.uri}" end
# |> Data.code
# |> Cloud.x
# |> Cloud.x "whateverpath", "whateverpassword"
#
# # Reading all scenes from private memory.
# Cloud.y
#
# # Exe *all* `data.code` for *all* lower holospace.
# Cloud.z "whateverpath", "whateverpassword"
#
# # Any memories there or that exist?
# Cloud.p "whateverpath"
#
# # *WHAT* is there exactly?
# Cloud.d "whateverpath"
#
# # Create web pages and JSON stuff
#
# "hi"
# |> Data.new
# |> Flow.x("create hi pagte")
# |> Flow.i(Kind.code, Data.new)
# |> Flow.o(Web.post("hi.html")
# |> Data.new("hi.html", Kind.link)
#
# ```
#
# # Chapter 4. Maru Routers for advanced data flows.
#
# Working Code showing how to process routes in Cloudspace + add content.
# ########################################################################
#
# ```
# Cloud.x "Chapter 4. // basically do all of the stuff above.."
#
# defmodule Readme.Web do
#
#   @moduledoc """
#    # Universe
#   ## Lovmx-level public data and data storage Container and Data Map.
#
#   Universe is a global map of: <holospace> -> [things] and are
#   superpowered by Maru-brand Routers which are awesome. Ask an
#   associate for more information.
#
#   https://maru.readme.io
#
#   Universe(s) are the *center* of `Cloud.Cloudspace` where all
#   *UNIQUE* code/data/flows are *merged* into a single cohesive
#   Universe-wide hologram to be namespaced, stored, and experienced.
#
#   Universe(s) host all *PUBLIC* static/dynamic content, which
#   means a Universe is primarily responsible for creating and
#   maintaining the global object graph + all dynamic content
#   and updates that happen during normal usage.
#   """
#
#   # include Maru + other helpful modules
#   use OrbitalMagic
#
#   namespace do
#     route_param :holospace do
#       get do
#         holospace = Help.path params[:holospace]
#
#         data
#         Cloud.fuzzy params[:holospace]
#       end
#       route_param :subpath do
#         get do
#           holospace = Help.path [params[:holospace], params[:subpath]]
#
#           spawn(params[:holospace], params[:subpath], Data.new holospace)
#
#           Cloud.fuzzy params[:holospace]
#         end
#       end
#     end
#   end
#
#   # A stub into the Universe below...
#   get do
#     Cloud.read "README.magic"
#   end
#
# end
# ```
