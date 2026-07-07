public class Legacy {
  /** @deprecated use {@link #greeting()} instead. */
  @Deprecated
  public String oldGreeting() {
    return "hi";
  }

  public String greeting() {
    return "hello";
  }
}
