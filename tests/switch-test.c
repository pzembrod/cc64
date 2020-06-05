
switch_test() {
  int i;
  
  for (i = 0; i < 10; ++i) {
    switch(i) {
      case 1:
        print(itoa(i));
        println(": i is one.");
        break;
      case 3:
        print(itoa(i));
        println(": i is three.");
        /* fall-through */
      case 7:
        print(itoa(i));
        println(": i is three or seven.");
        break;
      default:
        print(itoa(i));
        println(": i is something else.");
        break;
      case 8:
        print(itoa(i));
        println(": i is eight.");
        break;
    }
  }
  evaluateAsserts();
}
