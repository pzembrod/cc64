
while_test() {
  int i, j;
  println("Before no-iteration while loop");
  while(0) {
    println("This should never be printed.");
  }
  println("After no-iteration while loop");
  
  i = 4;
  println("Before 4-iteration while loop");
  while(i) {
    print("Iteration "); println(itoa(i));
    --i;
  }
  println("After 4-iteration while loop");

  i = 3;
  println("Before 3-2-iteration nested while loops");
  while(i) {
    print("Outer iteration "); println(itoa(i));
    if (i == 2) {
      i--;
      continue;
    }
    j = 2;
    while(j) {
      print("Inner iteration "); print(itoa(i));
      print(" , "); println(itoa(j));
      if (i == 1 && j == 2)
        break;
      j--;
    }
    --i;
  }
  println("After 3-2-iteration nested while loops");

  evaluateAsserts();
}
