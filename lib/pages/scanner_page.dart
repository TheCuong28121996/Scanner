import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key, required this.onScanner}) : super(key: key);

  final Function(String?) onScanner;

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Barcode? result;
  QRViewController? _controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF28022),
        elevation: 1,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
          Navigator.pop(context);
        }),
      ),
      body: Stack(
        children: [
          _buildQrView(),
          const Positioned(
            bottom: 130,
            left: 70,
            right: 70,
            child: Text(
              'Di chuyển camera đến vùng chứa mã code cần quét',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView() {
    var scanArea = _checkScreen() ? 150.0 : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 2,
          borderLength: 30,
          borderWidth: 2,
          overlayColor: const Color(0xFF808080),
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;

    _controller?.scannedDataStream.listen((scanData) {
      //_controller?.pauseCamera();
      _controller?.dispose();
      widget.onScanner(scanData.code);
      Navigator.pop(context);
    });
  }

  void _onPermissionSet(
      BuildContext context, QRViewController ctrl, bool permission) {
    if (!permission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chưa cấp quyền!')),
      );
    }
  }

  bool _checkScreen() {
    Size size = MediaQuery.of(context).size;
    return (size.width < 400 || size.height < 400);
  }
}
