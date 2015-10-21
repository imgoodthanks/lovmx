# defmodule Bridge.Test do
#   use ExUnit.Case
#
#   test "Use `Bridge` to do stuff", do:
#     assert Bridge
#
#   test "Bridge.port", do:
#     assert is_number Bridge.port
#
#   test "static objects are cool" do
#     assert 200 == HTTPotion.get(IT.web "/").status_code
#     # assert 200 == HTTPotion.get(IT.web "/js/app.js").status_code
#     # assert 200 == HTTPotion.get(IT.web "/img/ilvmx.png").status_code
#     # assert 200 == HTTPotion.get(IT.web "/css/default.css").status_code
#   end
#
#   # test "invalids are safe" do
#   #   assert 200 == HTTPotion.get(IT.web "./^/somethinga/$5").status_code
#   #   assert 200 == HTTPotion.get(IT.web "./somethinga/$5").status_code
#   #   assert 200 == HTTPotion.get(IT.web "../something:else").status_code
#   #   assert 200 == HTTPotion.get(IT.web "../something").status_code
#   # end
#   #
#   # test "Bridge.pull to get `webspace` pages.",
#   # do: IT.assert_web_page Tube.get(IT.web)
#
#   test "Bridge.kick(secure: true)" do
#     server_path = Bridge.kick secure: true
#
#     IT.assert_web_page Tube.get "https://localhost:8443/"
#   end
#
#   test "Bridge.kick(secure: false)" do
#     Bridge.kick secure: false
#
#     IT.assert_web_page Tube.get "http://localhost:8443/"
#   end
#
# end
