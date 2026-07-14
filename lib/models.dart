class Item {
  String id;
  String jenisBarang;
  String merekModel;
  String kodeBarang;
  String namaPengguna;
  String nipPengguna;
  String teleponPengguna;
  String fotoUrl;
  String barcode;
  String tahunPerolehan;

  Item({
    required this.id,
    required this.jenisBarang,
    required this.merekModel,
    required this.kodeBarang,
    required this.namaPengguna,
    required this.nipPengguna,
    required this.teleponPengguna,
    required this.fotoUrl,
    required this.barcode,
    this.tahunPerolehan = '',
  });

  // Convert an Item to a Map for JSON storage/mock state
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jenisBarang': jenisBarang,
      'merekModel': merekModel,
      'kodeBarang': kodeBarang,
      'namaPengguna': namaPengguna,
      'nipPengguna': nipPengguna,
      'teleponPengguna': teleponPengguna,
      'fotoUrl': fotoUrl,
      'barcode': barcode,
      'tahunPerolehan': tahunPerolehan,
    };
  }

  // Create an Item from a Map
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] ?? '',
      jenisBarang: map['jenisBarang'] ?? '',
      merekModel: map['merekModel'] ?? '',
      kodeBarang: map['kodeBarang'] ?? '',
      namaPengguna: map['namaPengguna'] ?? '',
      nipPengguna: map['nipPengguna'] ?? '',
      teleponPengguna: map['teleponPengguna'] ?? '',
      fotoUrl: map['fotoUrl'] ?? '',
      barcode: map['barcode'] ?? '',
      tahunPerolehan: map['tahunPerolehan'] ?? '',
    );
  }

  Item copyWith({
    String? id,
    String? jenisBarang,
    String? merekModel,
    String? kodeBarang,
    String? namaPengguna,
    String? nipPengguna,
    String? teleponPengguna,
    String? fotoUrl,
    String? barcode,
    String? tahunPerolehan,
  }) {
    return Item(
      id: id ?? this.id,
      jenisBarang: jenisBarang ?? this.jenisBarang,
      merekModel: merekModel ?? this.merekModel,
      kodeBarang: kodeBarang ?? this.kodeBarang,
      namaPengguna: namaPengguna ?? this.namaPengguna,
      nipPengguna: nipPengguna ?? this.nipPengguna,
      teleponPengguna: teleponPengguna ?? this.teleponPengguna,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      barcode: barcode ?? this.barcode,
      tahunPerolehan: tahunPerolehan ?? this.tahunPerolehan,
    );
  }
}

class Room {
  String id;
  String name;
  String year;
  String barcode;
  List<Item> items;

  Room({
    required this.id,
    required this.name,
    required this.year,
    required this.barcode,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'year': year,
      'barcode': barcode,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      year: map['year'] ?? '',
      barcode: map['barcode'] ?? '',
      items: List<Item>.from((map['items'] as List<dynamic>?)?.map((x) => Item.fromMap(x as Map<String, dynamic>)) ?? const []),
    );
  }

  Room copyWith({
    String? id,
    String? name,
    String? year,
    String? barcode,
    List<Item>? items,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      year: year ?? this.year,
      barcode: barcode ?? this.barcode,
      items: items ?? this.items,
    );
  }
}
