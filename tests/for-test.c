
for_test() {
  int i, j;
  println("Before no-iteration for loop");
  for(i = 3; i < 3; ++i) {
    println("This should never be printed.");
  }
  println("After no-iteration for loop");

  println("Before 4-iteration for loop");
  for(i = 5; i < 9; ++i) {
    print("Iteration "); println(itoa(i));
  }
  println("After 4-iteration backward for loop");

  println("Before 3-iteration backward for loop");
  for(i = -17; i > -20; i--) {
    print("Iteration "); println(itoa(i));
  }
  println("After 3-iteration backward for loop");

  println("Before 3-2-iteration nested for loops");
  for(i = 1; i <= 5; i += 2) {
    print("Outer iteration "); println(itoa(i));
    if (i == 3)
      continue;
    for(j = 2; j != 32; j <<= 2) {
      print("Inner iteration "); print(itoa(i));
      print(" , "); println(itoa(j));
      if (i == 5 && j == 8)
        break;
    }
  }
  println("After 3-2-iteration nested for loops");

  evaluateAsserts();
}
