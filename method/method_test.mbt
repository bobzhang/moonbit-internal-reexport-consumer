///|
test "call internal method through public facade" {
  let value : @y.TypeA = @y.make()
  inspect(value.method1(), content="42")
}
