
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

  assert(prototype_address - middle_function < 0, -1,
      "prototype function address < muddle function address");
  assert(final_address - middle_function > 0, -1,
      "final function address > muddle function address");

  evaluateAsserts();
}
