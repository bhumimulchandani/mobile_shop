class BrandReport {
  String? brand, qty, amt;
  // purchaseExecutive,saleExecutive;

  BrandReport({
    this.brand,
    this.qty,
    this.amt,
    // this.purchaseExecutive,
    // this.saleExecutive,
  });

  factory BrandReport.fromJson(Map<String, dynamic> json) {
    return BrandReport(
      brand: json['brand'].toString(),
      amt: json['amt'].toString(),
      qty: json['qty'].toString(),
    );
  }
}
