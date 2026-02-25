class AppUser {
  String name;
  String email;
  String password;
  double balance;

  AppUser({
    required this.name,
    required this.email,
    required this.password,
    this.balance = 5000.0,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'password': password,
        'balance': balance,
      };

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        name: map['name'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
        balance: (map['balance'] as num).toDouble(),
      );
}
