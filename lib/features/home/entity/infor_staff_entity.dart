//EnumPosition
enum EnumPosition {
  bill('BILL'),
  support('SUPPORT'),
  cashier('THU NGÂN'),
  waiter('ĐI THỰC'),
  cleaner('TẠP VỤ'),
  bar('BAR'),
  cskh('CHĂM SÓC KHÁCH HÀNG'),
  manager('QUẢN LÝ');

  final String displayName;

  const EnumPosition(this.displayName);
  //fromjson to mapping data from json to enum
  factory EnumPosition.fromJson(String json) {
    return EnumPosition.values.firstWhere(
      (e) => e.displayName == json,
      orElse: () => EnumPosition.bill,
    );
  }
  //get value
  String get value => displayName;
  //tojson to mapping data from enum to json
  String toJson() {
    return displayName;
  }
}

//enum roadmap
enum EnumRoadmap {
  newStaff('NV mới'),
  oldStaff('Theo tháng');

  final String displayRoadmap;

  const EnumRoadmap(this.displayRoadmap);
  //fromMap
  factory EnumRoadmap.fromJson(String json) {
    return EnumRoadmap.values.firstWhere(
      (e) => e.displayRoadmap.toLowerCase() == json.toLowerCase(),
      orElse: () => EnumRoadmap.newStaff,
    );
  }
  //get value
  String get value => displayRoadmap;
  //tojson to mapping data from enum to json
  String toJson() {
    return displayRoadmap;
  }
}

class InforStaffEntity {
  final EnumPosition? position; // 0: VỊ TRÍ
  final String? name; // 1: TÊN
  final String? email; // 2: GMAIL
  final String? startDate; // 3: TÁCH NGÀY VÔ LÀM
  final String? totalDays; // 4: SỐ NGÀY
  final EnumRoadmap? roadmap; // 5: LỘ TRÌNH
  final String? requiredCredits; // 6: TC PHẢI ĐẠT
  final String? completedCredits; // 7: TC ĐÃ HOÀN THÀNH
  final String? missingCredits; // 8: TC THIẾU

  const InforStaffEntity({
    this.position,
    this.name,
    this.email,
    this.startDate,
    this.totalDays,
    this.roadmap,
    this.requiredCredits,
    this.completedCredits,
    this.missingCredits,
  });

  const InforStaffEntity.empty()
    : position = null,
      name = null,
      email = null,
      startDate = null,
      totalDays = null,
      roadmap = null,
      requiredCredits = null,
      completedCredits = null,
      missingCredits = null;

  /// Parse từ Google Sheets API response (values endpoint)
  /// Response format: { "range": "...", "majorDimension": "ROWS", "values": [[...], [...]] }
  /// Row 0 = header, Row 1+ = data
  factory InforStaffEntity.fromJson(Map<String, dynamic> json) {
    final values = json['values'] as List<dynamic>?;
    if (values == null || values.length < 2) {
      return const InforStaffEntity.empty();
    }
    // values[0] = header row, skip it
    // values[1] = first data row (hoặc tìm theo email)
    // Trả về tất cả rows dưới dạng list
    final row = values[1] as List<dynamic>;
    return InforStaffEntity._fromRow(row);
  }

  /// Parse tất cả staff từ response
  static List<InforStaffEntity> fromJsonList(Map<String, dynamic> json) {
    final values = json['values'] as List<dynamic>?;
    if (values == null || values.length < 2) return [];

    // Skip header row (index 0)
    return values
        .skip(1)
        .where((row) => (row as List).isNotEmpty && row[0].toString().isNotEmpty)
        .map((row) => InforStaffEntity._fromRow(row as List<dynamic>))
        .toList();
  }

  static bool parseBool(dynamic value) {
    if (value == null) return false;
    final str = value.toString().toLowerCase();
    return str == 'true' || str == 'yes' || str == '1';
  }

  /// Parse từ một row dữ liệu
  /// Thứ tự: [VỊ TRÍ, TÊN, GMAIL, TÁCH NGÀY VÔ LÀM, SỐ NGÀY, LỘ TRÌNH, TC PHẢI ĐẠT, TC ĐÃ HOÀN THÀNH, TC THIẾU]
  factory InforStaffEntity._fromRow(List<dynamic> row) {
    return InforStaffEntity(
      position: row.isNotEmpty ? EnumPosition.fromJson(row[0]?.toString() ?? '') : null,
      name: row.length > 1 ? row[1]?.toString() : null,
      email: row.length > 2 ? row[2]?.toString() : null,
      startDate: row.length > 3 ? row[3]?.toString() : null,
      totalDays: row.length > 4 ? row[4]?.toString() : null,
      roadmap: row.length > 5 ? EnumRoadmap.fromJson(row[5]?.toString() ?? '') : null,
      requiredCredits: row.length > 6 ? row[6]?.toString() : null,
      completedCredits: row.length > 7 ? row[7]?.toString() : null,
      missingCredits: row.length > 8 ? row[8]?.toString() : null,
    );
  }

  /// Tìm staff theo email (GMAIL ở index 2)
  static InforStaffEntity? findByEmail(Map<String, dynamic> json, String email) {
    final allStaff = fromJsonList(json);
    try {
      return allStaff.firstWhere((staff) => staff.email?.toLowerCase() == email.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  @override
  String toString() =>
      'InforStaffEntity(position: $position, name: $name, email: $email, '
      'startDate: $startDate, totalDays: $totalDays, roadmap: $roadmap, '
      'requiredCredits: $requiredCredits, completedCredits: $completedCredits, '
      'missingCredits: $missingCredits)';
}
