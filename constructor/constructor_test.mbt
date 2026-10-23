///|
test "construct internal enum through public facade" {
  let value = @y.TypeA::VariantA
  match value {
    VariantA => inspect("constructed", content="constructed")
  }
}
