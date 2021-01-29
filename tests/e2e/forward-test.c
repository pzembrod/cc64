
extern forward_declared();

int prototype_address;
int final_address;

middle_function(i)
int i;
{
  prototype_address = forward_declared;
  forward_declared(i);
}

forward_declared(i)
int i;
{
  print("forward "); println(itoa(i));
}

forward_test()
{
  final_address = forward_declared;
  middle_function(1);
  forward_declared(2);

  assertTrue(prototype_address - middle_function < 0,
      "prototype function address < muddle function address");
  assertTrue(final_address - middle_function > 0,
      "final function address > muddle function address");

  evaluateAsserts();
}
