
partialfor_test() {
  int i;
  println("Before no-iteration for loop");
  for(;0;) {
    println("This should never be printed.");
  }
  println("After no-iteration for loop");

  println("Before for(;;) loop");
  i = 3;
  for(;;) {
    print("Iteration "); println(itoa(i));
    --i;
    if (!i) {
      break;
    }
  }
  println("After for(;;) loop");

  println("Before for(;;--i) loop");
  i = 2;
  for(;;--i) {
    print("Iteration "); println(itoa(i));
    if (!i) {
      break;
    }
  }
  println("After for(;;--i) loop");

  println("Before for(;i;) loop");
  i = 3;
  for(;i;) {
    print("Iteration "); println(itoa(i));
    --i;
  }
  println("After for(;i;) loop");

  println("Before for(i = 3;;) loop");
  for(i = 3;;) {
    print("Iteration "); println(itoa(i));
    --i;
    if (!i) {
      break;
    }
  }
  println("After for(i = 3;;) loop");

  evaluateAsserts();
}
