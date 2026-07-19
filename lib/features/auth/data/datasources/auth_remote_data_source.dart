import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../shared/models/user.dart';
import '../models/auth_models.dart';
import '../models/otp_models.dart';

class AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSource(this._dioClient);

  Future<ApiResponse<User>> getCurrentUser() async {
    final response = await _dioClient.get('/users/me');
    return ApiResponse<User>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => User.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    final response = await _dioClient.post(
      '/auth/login',
      data: request.toJson(),
    );
    return ApiResponse<AuthResponse>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<RegisterChallenge>> register(
    RegisterRequest request,
  ) async {
    final response = await _dioClient.post(
      '/auth/register',
      data: request.toJson(),
    );
    return ApiResponse<RegisterChallenge>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => RegisterChallenge.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<AuthResponse>> verifyOtp(VerifyOtpRequest request) async {
    final response = await _dioClient.post(
      '/auth/otp/verify',
      data: request.toJson(),
    );
    return ApiResponse<AuthResponse>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<RegisterChallenge>> resendOtp(String identifier) async {
    final response = await _dioClient.post(
      '/auth/otp/resend',
      data: {'identifier': identifier},
    );
    return ApiResponse<RegisterChallenge>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => RegisterChallenge.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<void>> verifyForgotPasswordOtp(
    VerifyOtpRequest request,
  ) async {
    final response = await _dioClient.post(
      '/auth/otp/verify',
      data: request.toJson(),
    );
    return ApiResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (_) {},
    );
  }

  Future<ApiResponse<void>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    final response = await _dioClient.post(
      '/auth/forgot-password',
      data: request.toJson(),
    );
    return ApiResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (_) {},
    );
  }

  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    final response = await _dioClient.post(
      '/auth/reset-password',
      data: request.toJson(),
    );
    return ApiResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (_) {},
    );
  }
}
