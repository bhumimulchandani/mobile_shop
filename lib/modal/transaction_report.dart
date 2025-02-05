class TransactionReport {
  String? saleID,
      purchaseID,
      brand,
      model,
      imeiNo,
      supplierName,
      supplierMobile,
      purchaseNo,
      saleNo,
      customerName,
      customerMobile,
      colourName,
      warranty,
      box,
      charger,
      bill,
      paymentType,
      purchaseExecutive,saleExecutive;

  DateTime? purchaseDate, saleDate;
  double? purchaseRate, saleRate, diffAmt;

  TransactionReport({
    this.purchaseID,
    this.saleID,
    this.brand,
    this.model,
    this.imeiNo,
    this.supplierName,
    this.supplierMobile,
    this.purchaseNo,
    this.purchaseDate,
    this.purchaseRate,
    this.saleRate,
    this.diffAmt,
    this.saleNo,
    this.saleDate,
    this.customerName,
    this.customerMobile,
    this.colourName,
    this.warranty,
    this.box,
    this.charger,
    this.bill,
    this.paymentType,
    this.purchaseExecutive,
    this.saleExecutive,
  });

  factory TransactionReport.fromJson(Map<String, dynamic> json) {
    return TransactionReport(
      purchaseID: json['purchaseID'].toString(),
      saleID: json['saleID'].toString(),
      brand: json['brand'].toString(),
      model: json['model'].toString(),
      imeiNo: json['imeiNo'].toString(),
      supplierName: json['supplierName'].toString(),
      supplierMobile: json['supplierMobile'].toString(),
      purchaseNo: json['purchaseNo'].toString(),
      purchaseDate: json['purchaseDate'].toString() == 'null'
          ? null
          : DateTime.parse([
              json['purchaseDate'].toString().split('-').last,
              json['purchaseDate'].toString().split('-')[1],
              json['purchaseDate'].toString().split('-').first
            ].join('-')),
      purchaseRate: double.parse(json['purchaseRate'].toString()),
      saleRate: double.parse(json['saleRate'].toString()),
      diffAmt: double.parse(json['diffAmt'].toString()),
      saleNo: json['saleNo'].toString(),
      saleDate: json['saleDate'].toString() == 'null'
          ? null
          : DateTime.parse([
              json['saleDate'].toString().split('-').last,
              json['saleDate'].toString().split('-')[1],
              json['saleDate'].toString().split('-').first
            ].join('-')),
      customerName: json['customerName'].toString(),
      customerMobile: json['customerMobile'].toString(),
      colourName: json['colourName'].toString(),
      warranty: json['warranty'].toString(),
      box: json['box'].toString(),
      charger: json['charger'].toString(),
      bill: json['bill'].toString(),
      paymentType: json['paymentType'].toString(),
      purchaseExecutive: json['purchaseExecutive'].toString(),
      saleExecutive: json['saleExecutive'].toString(),
    );
  }
}
