class Location {
  Location(
      {this.as,
      this.city,
      this.country,
      this.countryCode,
      this.isp,
      this.lat,
      this.lon,
      this.org,
      this.query,
      this.region,
      this.regionName,
      this.status,
      this.timezone,
      this.zip});

  Location.fromJson(Map<String, dynamic> json) {
    as = json['as'];
    city = json['city'];
    country = json['country'];
    countryCode = json['countryCode'];
    isp = json['isp'];
    lat = json['lat'];
    lon = json['lon'];
    org = json['org'];
    query = json['query'];
    region = json['region'];
    regionName = json['regionName'];
    status = json['status'];
    timezone = json['timezone'];
    zip = json['zip'];
  }

  String as;
  String city;
  String country;
  String countryCode;
  String isp;
  double lat;
  double lon;
  String org;
  String query;
  String region;
  String regionName;
  String status;
  String timezone;
  String zip;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['as'] = as;
    data['city'] = city;
    data['country'] = country;
    data['countryCode'] = countryCode;
    data['isp'] = isp;
    data['lat'] = lat;
    data['lon'] = lon;
    data['org'] = org;
    data['query'] = query;
    data['region'] = region;
    data['regionName'] = regionName;
    data['status'] = status;
    data['timezone'] = timezone;
    data['zip'] = zip;
    return data;
  }
}
