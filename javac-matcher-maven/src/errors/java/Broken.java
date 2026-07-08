public class Broken {
  public static void main(String[] args) {
    int x = y + 1; // error: cannot find symbol (y is undefined)
    String s = 123; // error: incompatible types
    System.out.println(x + s);
  }
}
