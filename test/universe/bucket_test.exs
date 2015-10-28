defmodule Bucket.Test do
  use ExUnit.Case

  ## API

  test "Bucket.folder_bucket to make an empty box w/ data", do:
    assert %Data{} = Bucket.folder_bucket

  test "Bucket.sparse_bundle_bucket to make an empty box w/ data", do:
    assert %Data{} = Bucket.sparse_bundle_bucket

end