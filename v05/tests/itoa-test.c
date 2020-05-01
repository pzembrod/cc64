
itoa_test()
{
  puts(itoa(13)); putc(13);
  puts(itoa(0)); putc('\n');
  println(itoa(100));
  println(itoa(-12345));
  println(itoa(32767));
  println(itoa(-32767));
  println(itoa(-0));
  println(itoa(-32768));
}
