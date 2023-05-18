class AuthParams {
  String clientSecret;
  String username;
  String password;
  int clientId;
  String grantType;

  AuthParams({
    this.clientId = 2,
    required this.username,
    required this.password,
    this.clientSecret = 'kyj1c9sVcksqGU4scMX7nLDalkjp2WoqQEf8PKAC',
    this.grantType = 'password',
  });
}
