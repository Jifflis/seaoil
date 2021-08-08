class Station implements Comparable<Station>{
  Station({
    this.id,
    this.code,
    this.mobileNum,
    this.area,
    this.province,
    this.city,
    this.name,
    this.businessName,
    this.address,
    this.lat,
    this.lng,
    this.type,
    this.dealerId,
    this.depotId,
});
  int? id;
  String? code;
  String? mobileNum;
  String? area;
  String? province;
  String? city;
  String? name;
  String? businessName;
  String? address;
  double? lat;
  double? lng;
  String? type;
  int? depotId;
  int? dealerId;
  double distance = 0;
  String distanceLabel='';

  static Station fromJson(Map<String,dynamic> map){
    return Station(
      id: map['id'],
      code: map['code'],
      mobileNum: map['mobileNum'],
      area: map['area'],
      province: map['province'],
      city: map['city'],
      name: map['name'],
      businessName: map['businessName'],
      address: map['address'],
      lat: double.parse(map['lat'].toString()),
      lng: double.parse(map['lng'].toString()),
      type: map['type'],
      depotId: map['depotId'],
      dealerId: map['dealerId'],
    );
  }

  @override
  int compareTo(Station other) {
    if(this.distance>other.distance) return 1;
    if(this.distance<other.distance) return -1;
    return 0;
  }
}