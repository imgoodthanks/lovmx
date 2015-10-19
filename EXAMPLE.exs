# Welcome to the LovMx

use Magic

# A simple example
# - create a bot
# - cast magic on README.magic
# - that we flow into data, with the :cake type
# - then Pipe it to create a page
# - then we compile/compute the data
# - then we put it online in nubspace at `readme`

code(fn data ->
  "README.magic"
  |> read
  |> into data, Kind.cake
  |> magic
  |> page "readme.html"
end)
|> take "See `README.magic` for more info."
|> x
|> orbit "readme"
