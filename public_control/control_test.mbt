///|
test "construct public enum through facade" {
  let value = @y.TypeA::VariantA
  match value {
    VariantA => inspect("constructed", content="constructed")
  }
}

///|
test "call public method through facade" {
  let value : @y.TypeA = @y.make()
  inspect(value.method1(), content="42")
}

///|
test "catch public error through facade" {
  try @y.fail_resolution() catch {
    @y.ResolveError::CurrentDirectoryUnavailable =>
      inspect("caught", content="caught")
  } noraise {
    _ => fail("expected an error")
  }
}
