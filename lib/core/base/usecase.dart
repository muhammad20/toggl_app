abstract class IUseCase<Params, T> {

  /// for every usecase, the interface should be implemented 
  /// with params object of type `Params` and returns a stream of type `T`.
  Stream<T> execute(Params input);
}