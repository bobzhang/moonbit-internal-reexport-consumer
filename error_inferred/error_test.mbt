///|
test "catch internal error with inferred constructor" {
  try @y.fail_resolution() catch {
    CurrentDirectoryUnavailable => inspect("caught", content="caught")
  } noraise {
    _ => fail("expected an error")
  }
}
