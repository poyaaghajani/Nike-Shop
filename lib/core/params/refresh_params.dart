class RefreshParams {
  String grantType;
  String token;
  String clientSecret;
  int clientId;

  RefreshParams({
    this.grantType = 'refresh_token',
    required this.token,
    this.clientSecret = 'kyj1c9sVcksqGU4scMX7nLDalkjp2WoqQEf8PKAC',
    this.clientId = 2,
  });
}
