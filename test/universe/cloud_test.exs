defmodule Cloud.Test do
  use ExUnit.Case

  test "Cloud.port", do:
    assert is_number Cloud.port
  
  test "Cloud.kick(secure: true)" do
    server_path = Cloud.kick secure: true

    IT.assert_web_page HTTPotion.get("https://localhost:8443/").body
  end
  
  # test "Cloud.kick(secure: false)" do
  #   Cloud.kick secure: false
  #
  #   IT.assert_web_page HTTPotion.get("http://localhost:8888/").body
  # end

end
