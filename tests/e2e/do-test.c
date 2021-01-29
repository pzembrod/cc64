
do_test() {
  int i, j;
  println("Before false-condition do loop");
  do {
    println("This should be printed once.");
  } while(0);
  println("After false-condition do loop");
  
  i = 4;
  println("Before 4-iteration do loop");
  do {
    print("Iteration "); println(itoa(i));
    --i;
  } while(i);
  println("After 4-iteration do loop");

  i = 3;
  println("Before 3-2-iteration nested do loops");
  do {
    print("Outer iteration "); println(itoa(i));
    if (i == 2) {
      --i;
      continue;
    }
    j = 2;
    do {
      print("Inner iteration "); print(itoa(i));
      print(" , "); println(itoa(j));
      if (i == 1 && j == 2)
        break;
      j--;
    } while(j);
    --i;
  } while(i);
  println("After 3-2-iteration nested do loops");

  evaluateAsserts();
}
