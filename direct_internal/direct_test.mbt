///|
test "direct import of internal owner" {
  let value = @x.TypeA::VariantA
  inspect(value.method1(), content="42")
}
