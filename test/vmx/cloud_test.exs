defmodule Cloud.Test do
  use ExUnit.Case

  test "Cloud.port", do:
    assert is_number Cloud.port
  
  test "Cloud.kick(secure: true)" do
    server_path = Cloud.kick secure: true

    IT.assert_web_page Cloud.get "https://localhost:8443/"
  end

  test "Cloud serves `base` objects." do
    assert 200 == HTTPotion.get(IT.web "/").status_code

    assert 200 == HTTPotion.get(IT.web "/js/app.js").status_code

    assert 200 == HTTPotion.get(IT.web "/img/cursor.png").status_code
    assert 200 == HTTPotion.get(IT.web "/img/logo.png").status_code
    assert 200 == HTTPotion.get(IT.web "/img/magic-logo.png").status_code

    assert 200 == HTTPotion.get(IT.web "/css/default.css").status_code
    assert 200 == HTTPotion.get(IT.web "/css/default-font.css").status_code

    assert 200 == HTTPotion.get(IT.web "/data/words").status_code
  end

  # test "Cloud.kick(secure: false)" do
  #   Cloud.kick secure: false
  #
  #   IT.assert_web_page Cloud.get "http://localhost:8443/"
  # end

  test "Use `Cloud.get` to return a [list] of things at `holospace`.", do:
      assert is_list Cloud.get "img"

end
