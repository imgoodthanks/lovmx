# an index flow

# %Data{thing: "/"}
# |> Flow.feed("lol")

# %Data{thing: "/"}
# |> Flow.match Data.code(fn data ->
#   "index.html"
#   |> Help.web
#   |> Drive.read
#   |> Pipe.page
#   |> Flow.feed(data, Kind.html)
# end)
# |> Flow.push("splash")
# |> Flow.graph


# # a splash bot
# %Data{thing: "splash"}
# |> Flow.match Data.code(fn data ->
#   data
# end)
# |> Flow.beam