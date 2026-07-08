import java.util.ArrayList;
import java.util.List;

public class App {
  public static void main(String[] args) {
    Legacy legacy = new Legacy();
    System.out.println(legacy.oldGreeting()); // [deprecation] warning

    List raw = new ArrayList(); // [rawtypes] warning
    raw.add("unchecked call"); // [unchecked] warning
    System.out.println(raw);
  }
}
