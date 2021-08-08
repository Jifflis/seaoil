class LocationDenied{
  LocationDenied(this.error);
  final String error;

  @override
  String toString() => error;
}