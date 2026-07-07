// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:barcode/barcode.dart';
import 'package:qr/qr.dart';
import 'models.dart';

void printItemLabelImpl(Item item, Room room) {
  // Generate barcode SVG
  final barcodeSvg = _generateBarcodeSvg(item.kodeBarang);
  
  // Generate QR Code SVG (berisi link rujukan ke GitHub Pages)
  final qrUrl = 'https://ariniarini2207-arch.github.io/webdp3a/?item=${item.id}';
  final qrSvg = _generateQrSvg(qrUrl);
  
  final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Cetak Label Aset - ${item.jenisBarang}</title>
  <style>
    @media print {
      body {
        margin: 0;
        padding: 0;
      }
      .label-container {
        border: none !important;
        box-shadow: none !important;
      }
    }
    
    body {
      font-family: 'Arial', sans-serif;
      margin: 20px;
      background-color: #ffffff;
      color: #000000;
    }
    
    .label-container {
      width: 480px;
      border: 2px solid #000000;
      border-radius: 8px;
      padding: 16px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      background-color: #ffffff;
      box-sizing: border-box;
    }
    
    .header {
      display: flex;
      align-items: center;
      border-bottom: 2px double #000000;
      padding-bottom: 8px;
      margin-bottom: 12px;
    }
    
    .logo-placeholder {
      width: 45px;
      height: 45px;
      margin-right: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .header-text {
      flex: 1;
      font-size: 10px;
      font-weight: bold;
      text-transform: uppercase;
      text-align: center;
      line-height: 1.3;
    }
    
    .content-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 12px;
      font-size: 13px;
    }
    
    .content-table td {
      padding: 4px 0;
      vertical-align: top;
    }
    
    .content-table td.label {
      width: 100px;
      font-weight: bold;
    }
    
    .content-table td.colon {
      width: 12px;
    }
    
    .codes-section {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-top: 1px dashed #000000;
      padding-top: 10px;
    }
    
    .barcode-area {
      flex: 1;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding-right: 10px;
    }
    
    .barcode-svg-container {
      width: 100%;
      max-width: 240px;
      height: 60px;
    }
    
    .barcode-text {
      font-family: monospace;
      font-size: 11px;
      font-weight: bold;
      margin-top: 4px;
      letter-spacing: 1px;
    }
    
    .qr-area {
      width: 90px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      border-left: 1px dashed #000000;
      padding-left: 10px;
    }
    
    .qr-svg-container {
      width: 75px;
      height: 75px;
    }
    
    .qr-text {
      font-size: 9px;
      font-weight: bold;
      margin-top: 4px;
      color: #333333;
    }
  </style>
</head>
<body>

  <div class="label-container">
    <div class="header">
      <div class="logo-placeholder">
        <svg width="40" height="45" viewBox="0 0 100 115" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M50 0 L95 25 L95 85 L50 115 L5 85 L5 25 Z" stroke="black" stroke-width="6" fill="#F4F4F4"/>
          <path d="M50 15 L85 34 L85 80 L50 100 L15 80 L15 34 Z" fill="black" opacity="0.1"/>
          <circle cx="50" cy="55" r="22" stroke="black" stroke-width="5" fill="none"/>
          <path d="M35 55 L65 55 M50 40 L50 70" stroke="black" stroke-width="5" stroke-linecap="round"/>
        </svg>
      </div>
      <div class="header-text">
        Pemerintah Provinsi Sulawesi Selatan<br>
        Dinas Pemberdayaan Perempuan, Perlindungan Anak,<br>
        Pengendalian Penduduk dan KB
      </div>
    </div>
    
    <table class="content-table">
      <tr>
        <td class="label">Nama Aset</td>
        <td class="colon">:</td>
        <td style="font-weight: bold;">${item.jenisBarang}</td>
      </tr>
      <tr>
        <td class="label">Merek/Model</td>
        <td class="colon">:</td>
        <td>${item.merekModel}</td>
      </tr>
      <tr>
        <td class="label">Ruangan</td>
        <td class="colon">:</td>
        <td>${room.name} (${room.year})</td>
      </tr>
    </table>
    
    <div class="codes-section">
      <div class="barcode-area">
        <div class="barcode-svg-container">
          $barcodeSvg
        </div>
        <div class="barcode-text">${item.kodeBarang}</div>
      </div>
      
      <div class="qr-area">
        <div class="qr-svg-container">
          $qrSvg
        </div>
        <div class="qr-text">GOOGLE LENS</div>
      </div>
    </div>
  </div>

  <script>
    window.onload = function() {
      setTimeout(function() {
        window.print();
        setTimeout(function() {
          window.close();
        }, 500);
      }, 500);
    }
  </script>
</body>
</html>
''';

  final popup = html.window.open('', 'label-${item.id}', 'width=620,height=520');
  if (popup != null) {
    popup.document.open();
    popup.document.write(htmlContent);
    popup.document.close();
  }
}

void printRoomLabelImpl(Room room) {
  // Generate barcode SVG
  final barcodeSvg = _generateBarcodeSvg(room.barcode);
  
  // Generate QR Code SVG (berisi link rujukan ke GitHub Pages ruangan)
  final qrUrl = 'https://ariniarini2207-arch.github.io/webdp3a/?room=${room.id}';
  final qrSvg = _generateQrSvg(qrUrl);
  
  final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Cetak Label Ruangan - ${room.name}</title>
  <style>
    @media print {
      body {
        margin: 0;
        padding: 0;
      }
      .label-container {
        border: none !important;
        box-shadow: none !important;
      }
    }
    
    body {
      font-family: 'Arial', sans-serif;
      margin: 20px;
      background-color: #ffffff;
      color: #000000;
    }
    
    .label-container {
      width: 480px;
      border: 2px solid #000000;
      border-radius: 8px;
      padding: 16px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      background-color: #ffffff;
      box-sizing: border-box;
    }
    
    .header {
      display: flex;
      align-items: center;
      border-bottom: 2px double #000000;
      padding-bottom: 8px;
      margin-bottom: 12px;
    }
    
    .logo-placeholder {
      width: 45px;
      height: 45px;
      margin-right: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .header-text {
      flex: 1;
      font-size: 10px;
      font-weight: bold;
      text-transform: uppercase;
      text-align: center;
      line-height: 1.3;
    }
    
    .content-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 12px;
      font-size: 13px;
    }
    
    .content-table td {
      padding: 4px 0;
      vertical-align: top;
    }
    
    .content-table td.label {
      width: 100px;
      font-weight: bold;
    }
    
    .content-table td.colon {
      width: 12px;
    }
    
    .codes-section {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-top: 1px dashed #000000;
      padding-top: 10px;
    }
    
    .barcode-area {
      flex: 1;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding-right: 10px;
    }
    
    .barcode-svg-container {
      width: 100%;
      max-width: 240px;
      height: 60px;
    }
    
    .barcode-text {
      font-family: monospace;
      font-size: 11px;
      font-weight: bold;
      margin-top: 4px;
      letter-spacing: 1px;
    }
    
    .qr-area {
      width: 90px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      border-left: 1px dashed #000000;
      padding-left: 10px;
    }
    
    .qr-svg-container {
      width: 75px;
      height: 75px;
    }
    
    .qr-text {
      font-size: 9px;
      font-weight: bold;
      margin-top: 4px;
      color: #333333;
    }
  </style>
</head>
<body>

  <div class="label-container">
    <div class="header">
      <div class="logo-placeholder">
        <svg width="40" height="45" viewBox="0 0 100 115" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M50 0 L95 25 L95 85 L50 115 L5 85 L5 25 Z" stroke="black" stroke-width="6" fill="#F4F4F4"/>
          <path d="M50 15 L85 34 L85 80 L50 100 L15 80 L15 34 Z" fill="black" opacity="0.1"/>
          <circle cx="50" cy="55" r="22" stroke="black" stroke-width="5" fill="none"/>
          <path d="M35 55 L65 55 M50 40 L50 70" stroke="black" stroke-width="5" stroke-linecap="round"/>
        </svg>
      </div>
      <div class="header-text">
        Pemerintah Provinsi Sulawesi Selatan<br>
        Dinas Pemberdayaan Perempuan, Perlindungan Anak,<br>
        Pengendalian Penduduk dan KB
      </div>
    </div>
    
    <table class="content-table">
      <tr>
        <td class="label">Label Ruang</td>
        <td class="colon">:</td>
        <td style="font-weight: bold; font-size: 16px;">${room.name}</td>
      </tr>
      <tr>
        <td class="label">Tahun Reg.</td>
        <td class="colon">:</td>
        <td>${room.year}</td>
      </tr>
    </table>
    
    <div class="codes-section">
      <div class="barcode-area">
        <div class="barcode-svg-container">
          $barcodeSvg
        </div>
        <div class="barcode-text">${room.barcode}</div>
      </div>
      
      <div class="qr-area">
        <div class="qr-svg-container">
          $qrSvg
        </div>
        <div class="qr-text">GOOGLE LENS</div>
      </div>
    </div>
  </div>

  <script>
    window.onload = function() {
      setTimeout(function() {
        window.print();
        setTimeout(function() {
          window.close();
        }, 500);
      }, 500);
    }
  </script>
</body>
</html>
''';

  final popup = html.window.open('', 'label-ruang-${room.id}', 'width=620,height=520');
  if (popup != null) {
    popup.document.open();
    popup.document.write(htmlContent);
    popup.document.close();
  }
}

String _generateBarcodeSvg(String data) {
  try {
    final bc = Barcode.code128();
    return bc.toSvg(data, width: 220, height: 50, drawText: false);
  } catch (e) {
    return '<svg width="220" height="50"><text x="10" y="25">Error Barcode</text></svg>';
  }
}

String _generateQrSvg(String data) {
  try {
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );
    final qrImage = QrImage(qrCode);
    
    final moduleCount = qrImage.moduleCount;
    final size = 150.0;
    final dotSize = size / moduleCount;
    
    final sb = StringBuffer();
    sb.write('<svg width="100%" height="100%" viewBox="0 0 $size $size" fill="none" xmlns="http://www.w3.org/2000/svg">');
    sb.write('<rect width="$size" height="$size" fill="white"/>');
    
    for (int x = 0; x < moduleCount; x++) {
      for (int y = 0; y < moduleCount; y++) {
        if (qrImage.isDark(y, x)) {
          final px = x * dotSize;
          final py = y * dotSize;
          sb.write('<rect x="$px" y="$py" width="$dotSize" height="$dotSize" fill="black"/>');
        }
      }
    }
    sb.write('</svg>');
    return sb.toString();
  } catch (e) {
    return '<svg width="75" height="75"><text x="5" y="40">Error QR</text></svg>';
  }
}
