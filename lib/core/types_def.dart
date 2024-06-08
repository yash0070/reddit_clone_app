import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/core/failure.dart';


/// Here is simple package we user for the error handling ,
/// like when we get any kind of error we can get the error from the left side like Either
/// like there is any kind of data or there should be any error
typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;