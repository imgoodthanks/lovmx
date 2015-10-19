defmodule Mix.Test do 
  use ExUnit.Case
  
  test ":help returned by option parsing with -h and --help options" do
    assert Unix.parse_args(["-h", "anything"]) == :help
    assert Unix.parse_args(["--help", "anything"]) == :help
    
    assert is_tuple System.cmd "/usr/local/bin/mix", ["lovmx", "--cake README.magic"]
  end

end