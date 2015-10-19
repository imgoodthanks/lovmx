defmodule Wizard.Test do
  use ExUnit.Case

  test "Wizard.king cooks the eggs.",
  do: assert is_pid Wizard.king

  test "Wizard.wakeup cooks the eggs.",
  do: assert is_pid Wizard.wake Wizard.king
  
  test "Wizard.tick cooks the eggs.",
  do: assert is_pid Wizard.tick self
  
  test "Wizard.tock cooks the eggs.",
  do: assert is_pid Wizard.tock self

end