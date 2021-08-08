class LocationDeniedForever{
  LocationDeniedForever(this.error);
  final String error;

  @override
  String toString() => error;
}