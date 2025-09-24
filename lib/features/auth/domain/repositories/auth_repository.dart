import 'package:dartz/dartz.dart';
import 'package:mcd/core/network/errors.dart';
import 'package:mcd/features/auth/domain/entities/auth_result_entity.dart';
import 'package:mcd/features/auth/domain/entities/user_signup_data.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> sendCode(String email);

  Future<Either<Failure, AuthResultEntity>> signup(UserSignupData data, String otp);

  // Future<Either<Failure, AuthResultEntity>> login(String email, String password);

}
