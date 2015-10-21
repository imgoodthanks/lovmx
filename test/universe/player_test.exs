defmodule Player.Test do
  use ExUnit.Case

  test "Player.anon", do:
		assert Player.anon

  # test "Player.tripcode" do
  #   samples = %{
  #     "Anonymous"             => "Anonymous",
  #     "user#famous"           => "user!yCLWkJGpRg",
  #     'user#21x!#nx&9;;"'     => "user!0dB1Qgl3Rk",
  #     "#tripcode"             => "!3GqYIJ3Obs",
  #     "anon#tripcode"         => "anon!3GqYIJ3Obs",
  #     #"##tripcode"            => "!!yIk1wB2J*",
  #     #"#tripcode#tripcode"    => "!3GqYIJ3Obs!!yIk1wB2J",
  #     #"#kami"                 => "!yGAhoNiShI",
  #     "MODD#withtripcode"     => "MODD!5JrU4QOlH6"
  #   }
  #
  #   samples |> Enum.each fn {trip, code} -> assert trip == Player.tripcode(code) end
  # end

end