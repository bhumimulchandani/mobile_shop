class ModelReport {
  String? modelID,modelname, qty, amt;
  // purchaseExecutive,saleExecutive;

  ModelReport({
    this.modelID,
    this.modelname,
    this.qty,
    this.amt,
    // this.purchaseExecutive,
    // this.saleExecutive,
  });

  factory ModelReport.fromJson(Map<String, dynamic> json) {
    return ModelReport(
      modelID: json['modelID'].toString(),
      modelname: json['modelname'].toString(),
      amt: json['amt'].toString(),
      qty: json['qty'].toString(),
    );
  }
}
