import 'dart:convert';

ElectricMetersModel electricMetersModelFromJson(String str) => ElectricMetersModel.fromJson(json.decode(str));

String electricMetersModelToJson(ElectricMetersModel data) => json.encode(data.toJson());

class ElectricMetersModel {
    List<ElectricMeter> electricMeters;

    ElectricMetersModel({
        required this.electricMeters,
    });

    factory ElectricMetersModel.fromJson(Map<String, dynamic> json) => ElectricMetersModel(
        electricMeters: List<ElectricMeter>.from(json["electricMeters"].map((x) => ElectricMeter.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "electricMeters": List<dynamic>.from(electricMeters.map((x) => x.toJson())),
    };
}

class ElectricMeter {
    int id;
    String ownerName;
    String meterNumber;
    Bills electricConsumption;
    Bills bills;
    String zone;
    String address;

    ElectricMeter({
        required this.id,
        required this.ownerName,
        required this.meterNumber,
        required this.electricConsumption,
        required this.bills,
        required this.zone,
        required this.address,
    });

    factory ElectricMeter.fromJson(Map<String, dynamic> json) => ElectricMeter(
        id: json["id"],
        ownerName: json["ownerName"],
        meterNumber: json["meterNumber"],
        electricConsumption: Bills.fromJson(json["electricConsumption"]),
        bills: Bills.fromJson(json["bills"]),
        zone: json["zone"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ownerName": ownerName,
        "meterNumber": meterNumber,
        "electricConsumption": electricConsumption.toJson(),
        "bills": bills.toJson(),
        "zone": zone,
        "address": address,
    };
}

class Bills {
    int april;
    int may;
    int june;
    int july;
    int august;
    int september;

    Bills({
        required this.april,
        required this.may,
        required this.june,
        required this.july,
        required this.august,
        required this.september,
    });

    factory Bills.fromJson(Map<String, dynamic> json) => Bills(
        april: json["April"],
        may: json["May"],
        june: json["June"],
        july: json["July"],
        august: json["August"],
        september: json["September"],
    );

    Map<String, dynamic> toJson() => {
        "April": april,
        "May": may,
        "June": june,
        "July": july,
        "August": august,
        "September": september,
    };
}
