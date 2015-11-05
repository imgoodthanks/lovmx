# setup a catch all data flow
%Data{}
|> Flow.match Data.code(fn data ->
  data = "index.html"
  |> Help.web
  |> Drive.read
  |> Pipe.page
  |> Flow.feed(data, Kind.html)
  |> Holo.boost("splash")
end)

# # a splash bot
# [%Data{}, %Data{thing: "splash"}]
# |> Flow.match Data.code(fn data ->
#   Flow.feed "hello", data, Kind.text
# end)
