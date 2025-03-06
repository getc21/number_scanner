import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Crear un objeto Paint para el fondo degradado
    Paint paint = Paint();

    // Fondo degradado dinámico
    paint.shader = const LinearGradient(
      colors: [
        Color.fromARGB(255, 46, 46, 54), // Color de fondo oscuro
        Color.fromARGB(255, 64, 64, 74), // Color intermedio
        Color.fromARGB(255, 89, 89, 102) // Color más claro
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Círculos con efectos de opacidad
    paint = Paint()..color = Colors.white.withOpacity(0.1);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.3), 200, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 150, paint);

    // Círculos pequeños y brillantes
    paint.color = Colors.white.withOpacity(0.05);
    for (double i = 0; i < size.width; i += 50) {
      for (double j = 0; j < size.height; j += 50) {
        canvas.drawCircle(Offset(i, j), 10, paint);
      }
    }

    // Líneas suaves y abstractas
    paint.color = Colors.white.withOpacity(0.2);
    paint.strokeWidth = 2;

    Path path = Path();
    path.moveTo(size.width * 0, size.height * 0);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.3, size.width * 1, size.height * 0);
    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(size.width * 1, size.height * 1);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.7, size.width * 0, size.height * 1);
    canvas.drawPath(path, paint);

    // Formas adicionales
    paint.color = Colors.white.withOpacity(0.05);
    for (double i = 0; i < 6; i++) {
      canvas.drawRect(
        Rect.fromLTWH(size.width * (0.15 * i), size.height * 0.5, 15, 100),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Utils {
  static const primaryColor = Color(0xff060539);
  static void showSnakbarError(String titulo, String msg, int duracion,
      [SnackPosition? position]) {
    Get.snackbar(titulo, msg,
        titleText: estiloTexto(titulo, 16.0, true, Colors.white),
        colorText: Colors.white.withOpacity(0.8),
        snackPosition: position ?? SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade900.withOpacity(0.9),
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        borderColor: Colors.white.withOpacity(0.8),
        borderWidth: 1,
        icon: const Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 35.0,
          ),
        ),
        duration: Duration(seconds: duracion));
  }

  static Text estiloTexto(String txt, double tamanio, bool fontWeight,
          [Color? col, bool? center]) =>
      Text(
        txt,
        textAlign: center == true ? TextAlign.center : TextAlign.left,
        style: Get.textTheme.bodyMedium!.copyWith(
            fontSize: tamanio * 1.1,
            fontWeight: fontWeight ? FontWeight.bold : null,
            color:
                col ?? (Get.isDarkMode ? Colors.white70 : Utils.primaryColor)),
      );

  static Text styledText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey[800]),
    );
  }

  static Widget textLlaveValor(String llave, String valor, Color colorLetra) {
    return SizedBox(
      width: Get.width,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: llave,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: colorLetra,
              ),
            ),
            TextSpan(
              text: valor,
              style: TextStyle(
                fontSize: 14,
                color: colorLetra,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
