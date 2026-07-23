/// Lightweight admin user model (no freezed, no build_runner needed)
class AdminUser {
  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String role;
  final bool isActive;
  final DateTime? createdAt;

  const AdminUser({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    required this.role,
    this.isActive = true,
    this.createdAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
        id: json['id'] as String,
        fullName: json['fullName'] as String? ?? '',
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        role: json['role'] as String? ?? 'CUSTOMER',
        isActive: json['isActive'] as bool? ?? true,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
      );
}