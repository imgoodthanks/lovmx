ExUnit.start()

Holo.reset(nubspace: true, universe: true)

defmodule IT do
  use ExUnit.Case

  def web(path \\ "") do
    "https://localhost:8443#{ path }"
  end

  def assert_keycode(uuid) do
    assert Regex.match? Lovmx.keycode_regex, uuid
  end

  def assert_web_page(binary) do
    assert Regex.match? ~r/html/i, binary
  end
end
