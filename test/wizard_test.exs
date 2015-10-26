defmodule Wizard.Test do
  use ExUnit.Case

  test "Wizard.king returns the WizardServer singleton.", do: 
    assert is_pid Wizard.king

  test "Use `Wizard.bang` to start Cloudspace", do: 
    assert is_pid Wizard.bang
  
  test "Wizard.tick cooks the eggs.", do: 
    assert is_pid Wizard.tick Wizard.king
  
  test "Wizard.tock cooks the eggs.", do: 
    assert is_pid Wizard.tock Wizard.king

  test "Wizard.freeze saves the eggs.", do: 
    assert is_pid Wizard.freeze
  
  test "Wizard.reset nukes the eggs.", do: 
    assert is_pid Wizard.reset
    
end