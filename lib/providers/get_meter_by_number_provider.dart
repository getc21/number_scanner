import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:number_scanner/models/electric_meters_model.dart';

class ElectricMeterService {
  final String baseUrl = 'http://10.240.155.29:3000/electricMeters';

  Future<ElectricMeter?> getMeterByNumber(String meterNumber) async {
    final response =
        await http.get(Uri.parse('$baseUrl?meterNumber=$meterNumber'));

    // Imprimir la respuesta del servidor para depuración
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Decodificar la respuesta como lista
      List<dynamic> meters = jsonDecode(response.body);
      
      // Verificar si la lista no está vacía
      if (meters.isNotEmpty) {
        // Convertir el primer objeto de la lista a ElectricMeter
        return ElectricMeter.fromJson(meters[0]);
      } else {
        // Si la lista está vacía, retornar null
        return null;
      }
    } else {
      // Manejo de error en caso de que el estado no sea 200
      return null;
    }
  }
}
