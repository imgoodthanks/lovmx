defmodule Bridge.Test do
  use ExUnit.Case

  test "Bridge.port", do:
    assert is_number Bridge.port

  test "Bridge serves Base blobs." do
    assert 200 == HTTPotion.get(IT.web "/").status_code
    
    assert 200 == HTTPotion.get(IT.web "/js/app.js").status_code
    
    assert 200 == HTTPotion.get(IT.web "/img/cursor.png").status_code
    assert 200 == HTTPotion.get(IT.web "/img/logo.png").status_code
    assert 200 == HTTPotion.get(IT.web "/img/magic-logo.png").status_code
    
    assert 200 == HTTPotion.get(IT.web "/css/default.css").status_code
    assert 200 == HTTPotion.get(IT.web "/css/default-font.css").status_code
    
    assert 200 == HTTPotion.get(IT.web "/data/words").status_code
  end

  test "Bridge.kick(secure: true)" do
    server_path = Bridge.kick secure: true

    IT.assert_web_page Tube.get "https://localhost:8443/"
  end
  
  # test "Bridge.kick(secure: false)" do
  #   Bridge.kick secure: false
  #
  #   IT.assert_web_page Tube.get "http://localhost:8443/"
  # end

end
