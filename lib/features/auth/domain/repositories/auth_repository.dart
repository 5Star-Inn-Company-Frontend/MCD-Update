import 'package:dartz/dartz.dart';
import 'package:mcd/core/network/errors.dart';
import 'package:mcd/features/auth/domain/entities/auth_result_entity.dart';
import 'package:mcd/features/auth/domain/entities/user_signup_data.dart';
import 'package:mcd/features/home/data/model/dashboard_model.dart';
import 'package:mcd/features/home/data/model/referral_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> sendCode(String email);
  Future<Either<Failure, AuthResultEntity>> signup(UserSignupData data, String otp);
  Future<Either<Failure, Map<String, dynamic>>> login(String username, String password);
  Future<void> logout();
  Future<Either<Failure, Map<String, dynamic>>> pinAuth(String username, String pin);
  Future<Either<Failure, Map<String, dynamic>>> verifyNewDevice(String username, String code);
  Future<Either<Failure, Map<String, dynamic>>> biometricLogin();
  Future<Either<Failure, Map<String, dynamic>>> socialLogin(String email, String name, String avatar, String accesstoken, String source);
  Future<Either<Failure, DashboardModel>> dashboard();
  Future<Either<Failure, List<ReferralModel>>> referrals();
  Future<Either<Failure, Map<String, dynamic>>> resetPassword(String email);
  Future<Either<Failure, Map<String, dynamic>>> resetPasswordCheck(String email, String code);
  Future<Either<Failure, Map<String, dynamic>>> changeResetPassword(String email, String code, String password);
  Future<Either<Failure, Map<String, dynamic>>> sendEmailVerifyCode(String email);
  Future<Either<Failure, Map<String, dynamic>>> emailVerifyConfirm(String email, String code);
  Future<Either<Failure, Map<String, dynamic>>> kycUpdate(String bvn, String image);
  Future<Either<Failure, Map<String, dynamic>>> kycCheck(String bvn);
  Future<Either<Failure, Map<String, dynamic>>> kycValidate(String bvn, String reference, String imageUrl);
}
