import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(CameraTextScannerApp(camera: firstCamera));
}

class CameraTextScannerApp extends StatelessWidget {
  final CameraDescription camera;

  const CameraTextScannerApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: CameraScreen(camera: camera),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({required this.camera});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final TextEditingController _scannedTextController = TextEditingController();
  File? _capturedImage;
  File? _croppedFile;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scannedTextController.dispose();
    super.dispose();
  }

  Future<void> _scanText() async {
    setState(() {
      _capturedImage = null;
      _croppedFile = null;
    });

    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final imageBytes = File(image.path).readAsBytesSync();
      final uiImage = await decodeImageFromList(imageBytes);

      // Calculate the coordinates of the rectangle
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      //
      final topLeft = renderBox.localToGlobal(
        Offset(
          renderBox.size.width / 2 - 150,
          80,
        ),
      );
      final bottomRight = renderBox.localToGlobal(
        Offset(
          renderBox.size.width / 2 + 150,
          80 + 48,
        ),
      );

      // Convert coordinates to image scale
      final scaleX = uiImage.width / renderBox.size.width;
      final scaleY = uiImage.height / renderBox.size.height;
      final cropRect = Rect.fromLTRB(
        topLeft.dx * scaleX,
        topLeft.dy * scaleY,
        bottomRight.dx * scaleX,
        bottomRight.dy * scaleY,
      );

      // Crop the image
      final decodedImage = img.decodeImage(imageBytes)!;
      final croppedImage = img.copyCrop(
        decodedImage,
        x: cropRect.left.toInt(),
        y: cropRect.top.toInt(),
        width: cropRect.width.toInt(),
        height: cropRect.height.toInt(),
      );

      // Save the cropped image temporarily
      _croppedFile = File(
          '${(await getTemporaryDirectory()).path}/${DateTime.now().microsecondsSinceEpoch}}.png');
      await _croppedFile!.writeAsBytes(img.encodePng(croppedImage));

      // Update the captured image to show it below the camera preview
      setState(() {
        _capturedImage = _croppedFile;
      });

      // Perform text recognition on the cropped image
      final inputImage = InputImage.fromFilePath(_croppedFile!.path);
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);

      String scannedText = '';
      bool hasNonNumericText = false;

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final text = line.text;
          // if (RegExp(r'^[0-9]+$').hasMatch(text)) {
          scannedText += '$text ';
          // } else {
          //   hasNonNumericText = true;
          // }
        }
      }

      if (hasNonNumericText) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Warning: Text detected!')),
        );
      }

      setState(() {
        _scannedTextController.text = scannedText.trim();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Scanner'),
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Define the rectangle area
            final rect = Rect.fromCenter(
              center: Offset(
                MediaQuery.of(context).size.width / 2,
                80,
              ),
              width: 300,
              height: 64,
            );

            return Stack(
              children: [
                CameraPreview(_controller),

                //01704340860

                //
                CustomPaint(
                  size: Size.infinite,
                  painter: OverlayPainter(rect),
                ),

                //
                if (_capturedImage != null)
                  Positioned(
                    bottom: 200,
                    left: 16,
                    right: 16,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _capturedImage!,
                          height: 64,
                          width: 300,
                        )),
                  ),

                //
                Positioned(
                  bottom: 112,
                  left: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        //
                        Expanded(
                          child: TextFormField(
                            controller: _scannedTextController,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8)),
                          ),
                        ),

                        const SizedBox(width: 10),

                        //
                        MaterialButton(
                            color: Colors.deepPurpleAccent,
                            height: 50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onPressed: () {
                              String text = _scannedTextController.text.trim();
                              Clipboard.setData(ClipboardData(text: text))
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(text)));
                              });
                            },
                            child: const Text('Copy')),
                      ],
                    ),
                  ),
                ),

                //
                Positioned(
                  bottom: 24,
                  right: 16,
                  left: 16,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      minimumSize: Size(MediaQuery.sizeOf(context).width, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _scanText,
                    child: Text(
                      'Scan Number'.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

//
class OverlayPainter extends CustomPainter {
  final Rect rect;

  OverlayPainter(this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.7);

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(rect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
