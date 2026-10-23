///|
test "catch internal error through public facade" {
  try @y.fail_resolution() catch {
    @y.ResolveError::CurrentDirectoryUnavailable =>
      inspect("caught", content="caught")
  } noraise {
    _ => fail("expected an error")
  }
}
