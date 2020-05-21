
extern forward_declared();

int prototype_address;
int final_address;

middle_function()
{
  prototype_address = forward_declared;
  forward_declared();
}

forward_declared()
{
  println("forward");
}

forward_test()
{
  final_address = forward_declared;
  middle_function();
  forward_declared();

  assertTrue(prototype_address - middle_function < 0,
      "prototype function address < muddle function address");
  assertTrue(final_address - middle_function > 0,
      "final function address > muddle function address");

  evaluateAsserts();
}
