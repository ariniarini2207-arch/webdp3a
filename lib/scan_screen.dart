import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late final MobileScannerController _controller;
  bool _hasDetected = false;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasDetected) return;
    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final code = barcodes.first.rawValue!;
      setState(() => _hasDetected = true);
      Navigator.pop(context, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Pindai QR / Barcode',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF111111),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Torch toggle
          IconButton(
            icon: Icon(
              _torchOn ? Icons.flash_on : Icons.flash_off,
              color: _torchOn ? const Color(0xFFC9E12C) : Colors.grey,
            ),
            onPressed: () async {
              await _controller.toggleTorch();
              setState(() => _torchOn = !_torchOn);
            },
          ),
          // Switch camera
          IconButton(
            icon: const Icon(Icons.cameraswitch_rounded, color: Colors.white),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera view
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Overlay with scanning frame
          Positioned.fill(
            child: CustomPaint(
              painter: _ScanOverlayPainter(
                borderColor: const Color(0xFFC9E12C),
                cutOutSize: MediaQuery.of(context).size.width < 600 ? 260 : 360,
              ),
            ),
          ),

          // Instruction + cancel button
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Arahkan kamera ke QR Code atau Barcode aset',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white70),
                  label: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom overlay painter for the scan window
class _ScanOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double cutOutSize;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final Color overlayColor;

  const _ScanOverlayPainter({
    this.borderColor = const Color(0xFFC9E12C),
    this.cutOutSize = 260,
    this.borderRadius = 12,
    this.borderLength = 30,
    this.borderWidth = 5,
    this.overlayColor = const Color(0x99000000),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final cutOut = Rect.fromCenter(
      center: center,
      width: cutOutSize,
      height: cutOutSize,
    );

    // Semi-transparent overlay with hole
    final overlay = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(cutOut, Radius.circular(borderRadius)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlay);

    // Corner borders
    final border = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    final bp = Path();
    final r = borderRadius;
    final bl = borderLength;

    // Top-left
    bp.moveTo(cutOut.left, cutOut.top + bl);
    bp.lineTo(cutOut.left, cutOut.top + r);
    bp.quadraticBezierTo(cutOut.left, cutOut.top, cutOut.left + r, cutOut.top);
    bp.lineTo(cutOut.left + bl, cutOut.top);

    // Top-right
    bp.moveTo(cutOut.right - bl, cutOut.top);
    bp.lineTo(cutOut.right - r, cutOut.top);
    bp.quadraticBezierTo(
        cutOut.right, cutOut.top, cutOut.right, cutOut.top + r);
    bp.lineTo(cutOut.right, cutOut.top + bl);

    // Bottom-left
    bp.moveTo(cutOut.left, cutOut.bottom - bl);
    bp.lineTo(cutOut.left, cutOut.bottom - r);
    bp.quadraticBezierTo(
        cutOut.left, cutOut.bottom, cutOut.left + r, cutOut.bottom);
    bp.lineTo(cutOut.left + bl, cutOut.bottom);

    // Bottom-right
    bp.moveTo(cutOut.right - bl, cutOut.bottom);
    bp.lineTo(cutOut.right - r, cutOut.bottom);
    bp.quadraticBezierTo(
        cutOut.right, cutOut.bottom, cutOut.right, cutOut.bottom - r);
    bp.lineTo(cutOut.right, cutOut.bottom - bl);

    canvas.drawPath(bp, border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
