abstract class IBLoC {

  /// all BLoCs should implement the IBLoc interface
  /// in order to prevent memory leaks
  void dispose();
}