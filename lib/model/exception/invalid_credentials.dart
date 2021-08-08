class InvalidCredentials{
  InvalidCredentials(this.error);
  final String error;

  @override
  String toString() => error;
}