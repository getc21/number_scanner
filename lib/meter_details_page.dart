import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_scanner/models/electric_meters_model.dart';
import 'package:number_scanner/utils/utils.dart';

class MeterDetailsPage extends StatefulWidget {
  final ElectricMeter meter;

  const MeterDetailsPage({Key? key, required this.meter}) : super(key: key);

  @override
  State<MeterDetailsPage> createState() => _MeterDetailsPageState();
}

class _MeterDetailsPageState extends State<MeterDetailsPage> {
  bool isExpandedConsumption =
      false; // Control para el ExpansionTile de consumo
  bool isExpandedBilling =
      false; // Control para el ExpansionTile de facturación

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Detalles del Medidor'), 
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 55, 55, 65),
      ),
      body: CustomPaint(
        painter: CustomBackgroundPainter(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Nro: ${widget.meter.meterNumber}',
                style: TextStyle(fontSize: 24),
              ), // Este texto permanece
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.grey), // Borde plomo
                  borderRadius:
                      BorderRadius.circular(8), // Bordes redondeados opcional
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Utils.textLlaveValor(
                          "Nombre cliente: ",
                          widget.meter.ownerName,
                          const Color.fromARGB(
                              255, 34, 38, 53)), // Reemplazo aquí
                      const SizedBox(height: 6),
                      Utils.textLlaveValor(
                          "Zona: ",
                          widget.meter.zone,
                          const Color.fromARGB(
                              255, 34, 38, 53)), // Reemplazo aquí
                      const SizedBox(height: 6),
                      Utils.textLlaveValor(
                          "Dirección: ",
                          widget.meter.address,
                          const Color.fromARGB(
                              255, 34, 38, 53)), // Reemplazo aquí
                      SizedBox(height: 10),
                      // ExpansionTile para el consumo
                      Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          iconColor: const Color.fromARGB(255, 34, 38, 53),
                          collapsedIconColor:
                              const Color.fromARGB(255, 34, 38, 53),
                          title: Utils.textLlaveValor(
                              "Consumo de los últimos 6 meses: ",
                              '',
                              const Color.fromARGB(
                                  255, 34, 38, 53)), // Reemplazo aquí
                          initiallyExpanded: isExpandedConsumption,
                          tilePadding: EdgeInsets.zero,
                          onExpansionChanged: (expanded) {
                            setState(() {
                              isExpandedConsumption =
                                  expanded; // Cambia el estado de expansión
                            });
                          },
                          children: [
                            Container(
                              width: Get.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.grey), // Borde plomo
                                borderRadius: BorderRadius.circular(
                                    8), // Bordes redondeados opcional
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Utils.textLlaveValor(
                                        "Abril: ",
                                        "${widget.meter.electricConsumption.april} kW",
                                        const Color.fromARGB(
                                            255, 34, 38, 53)), // Reemplazo aquí
                                    Utils.textLlaveValor(
                                        "Mayo: ",
                                        "${widget.meter.electricConsumption.may} kW",
                                        const Color.fromARGB(
                                            255, 34, 38, 53)), // Reemplazo aquí
                                    Utils.textLlaveValor(
                                        "Junio: ",
                                        "${widget.meter.electricConsumption.june} kW",
                                        const Color.fromARGB(
                                            255, 34, 38, 53)), // Reemplazo aquí
                                    Utils.textLlaveValor(
                                        "Julio: ",
                                        "${widget.meter.electricConsumption.july} kW",
                                        const Color.fromARGB(
                                            255, 34, 38, 53)), // Reemplazo aquí
                                    Utils.textLlaveValor(
                                        "Agosto: ",
                                        "${widget.meter.electricConsumption.august} kW",
                                        const Color.fromARGB(
                                            255, 34, 38, 53)), // Reemplazo aquí
                                    Utils.textLlaveValor(
                                        "Septiembre: ",
                                        "${widget.meter.electricConsumption.september} kW",
                                        const Color.fromARGB(
                                            255, 34, 38, 53)), // Reemplazo aquí
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ExpansionTile para la facturación
                      Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          iconColor: const Color.fromARGB(255, 34, 38, 53),
                          collapsedIconColor:
                              const Color.fromARGB(255, 34, 38, 53),
                          title: Utils.textLlaveValor(
                              "Facturación de los últimos 6 meses: ",
                              '',
                              const Color.fromARGB(
                                  255, 34, 38, 53)), // Reemplazo aquí
                          initiallyExpanded: isExpandedBilling,
                          tilePadding: EdgeInsets.zero,
                          onExpansionChanged: (expanded) {
                            setState(() {
                              isExpandedBilling =
                                  expanded; // Cambia el estado de expansión
                            });
                          },
                          children: [
                            Container(
                              width: Get.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.grey), // Borde plomo
                                borderRadius: BorderRadius.circular(
                                    8), // Bordes redondeados opcional
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Utils.textLlaveValor(
                                        "Abril: ",
                                        "${widget.meter.bills.april} Bs",
                                        const Color.fromARGB(
                                            255, 34, 38, 53)), // Reemplazo aquí
                                    Utils.textLlaveValor(
                                        "Mayo: ",
                                        "${widget.meter.bills.may} Bs",
                                        const Color.fromARGB(
                                            255, 34, 38, 53)), // Reemplazo aquí
                                    Utils.textLlaveValor(
                                        "Junio: ",
                                        "${widget.meter.bills.june} Bs",
                                        const Color.fromARGB(
                                            255, 34, 38, 53)), // Reemplazo aquí
                                    Utils.textLlaveValor(
                                        "Julio: ",
                                        "${widget.meter.bills.july} Bs",
                                        const Color.fromARGB(
                                            255, 34, 38, 53)), // Reemplazo aquí
                                    Utils.textLlaveValor(
                                        "Agosto: ",
                                        "${widget.meter.bills.august} Bs",
                                        const Color.fromARGB(
                                            255, 34, 38, 53)), // Reemplazo aquí
                                    Utils.textLlaveValor(
                                        "Septiembre: ",
                                        "${widget.meter.bills.september} Bs",
                                        const Color.fromARGB(
                                            255, 34, 38, 53)), // Reemplazo aquí
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
