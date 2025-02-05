class LicenseInfo {
  String? name;
  DateTime? expiryDate;

  LicenseInfo(
      {
      this.name,
      this.expiryDate,
      });

  factory LicenseInfo.fromJson(Map<String, dynamic> data) {
    return LicenseInfo(
      name: data['business_name'].toString(),
      expiryDate: DateTime.tryParse(data['end'].toString()) ?? DateTime.now(),
    );
  }
}
