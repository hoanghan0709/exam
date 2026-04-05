import 'package:exam/utils/ext_formatter.dart';

/// Entity cho response từ Google Sheets API (values endpoint)
/// Ví dụ: LINKBAITEST sheet
class SheetLinkExamEntity {
  final String? range;
  final String? majorDimension;
  final List<String> headers;
  final List<SheetLinkExamItem> items;

  const SheetLinkExamEntity({
    this.range,
    this.majorDimension,
    this.headers = const [],
    this.items = const [],
  });

  const SheetLinkExamEntity.empty()
    : range = null,
      majorDimension = null,
      headers = const [],
      items = const [];

  factory SheetLinkExamEntity.fromJson(Map<String, dynamic> json) {
    final values = json['values'] as List<dynamic>?;

    if (values == null || values.isEmpty) {
      return const SheetLinkExamEntity.empty();
    }

    // Row 0 = headers: ["CHỦ ĐỀ", "NỘI DUNG", "SỐ TÍN CHỈ", "LINK BÀI TEST", "DANH SACH LINK KẾT QUẢ"]
    final headerRow = (values[0] as List<dynamic>).map((e) => e.toString()).toList();

    // Row 1+ = data rows
    final items =
        values
            .skip(1)
            .where((row) => (row as List).isNotEmpty)
            .map((row) => SheetLinkExamItem.fromRow(row as List<dynamic>))
            .toList();

    return SheetLinkExamEntity(
      range: json['range'] as String?,
      majorDimension: json['majorDimension'] as String?,
      headers: headerRow,
      items: items,
    );
  }

  /// Lấy danh sách tín chỉ (tên nội dung) — thay thế listTC cũ
  List<String?> get listTC => items.map((e) => e.content).toList();

  /// Tìm item theo số tín chỉ
  SheetLinkExamItem? findByCredit(String credit) {
    try {
      return items.firstWhere((e) => e.creditNumber?.tcNumber == credit.tcNumber);
    } catch (_) {
      return null;
    }
  }

  /// Tìm tất cả items theo chủ đề
  List<SheetLinkExamItem> findByTopic(String topic) {
    return items.where((e) => e.topic?.toUpperCase() == topic.toUpperCase()).toList();
  }

  /// Nhóm items theo chủ đề (fill chủ đề trống từ row trước)
  Map<String, List<SheetLinkExamItem>> get groupedByTopic {
    final Map<String, List<SheetLinkExamItem>> grouped = {};
    String lastTopic = '';

    for (final item in items) {
      final topic = (item.topic?.isNotEmpty == true) ? item.topic! : lastTopic;
      if (topic.isNotEmpty) lastTopic = topic;

      grouped.putIfAbsent(topic, () => []);
      grouped[topic]!.add(item.copyWith(topic: topic));
    }

    return grouped;
  }

  @override
  String toString() => 'SheetConfigEntity(range: $range, items: $items)';
}

/// Mỗi row trong sheet LINKBAITEST
class SheetLinkExamItem {
  final String? topic; // CHỦ ĐỀ
  final String? content; // NỘI DUNG
  final String? creditNumber; // SỐ TÍN CHỈ
  final String? testLink; // LINK BÀI TEST
  final String? resultLink; // DANH SACH LINK KẾT QUẢ

  const SheetLinkExamItem({
    this.topic,
    this.content,
    this.creditNumber,
    this.testLink,
    this.resultLink,
  });

  /// Parse từ một row: [CHỦ ĐỀ, NỘI DUNG, SỐ TÍN CHỈ, LINK BÀI TEST, DANH SACH LINK KẾT QUẢ]
  factory SheetLinkExamItem.fromRow(List<dynamic> row) {
    return SheetLinkExamItem(
      topic: row.isNotEmpty ? row[0]?.toString() : null,
      content: row.length > 1 ? row[1]?.toString() : null,
      creditNumber: row.length > 2 ? "TC${row[2]?.toString()}" : null,
      testLink: row.length > 3 ? row[3]?.toString() : null,
      resultLink: row.length > 4 ? row[4]?.toString() : null,
    );
  }

  SheetLinkExamItem copyWith({
    String? topic,
    String? content,
    String? creditNumber,
    String? testLink,
    String? resultLink,
  }) {
    return SheetLinkExamItem(
      topic: topic ?? this.topic,
      content: content ?? this.content,
      creditNumber: creditNumber ?? this.creditNumber,
      testLink: testLink ?? this.testLink,
      resultLink: resultLink ?? this.resultLink,
    );
  }

  @override
  String toString() =>
      'SheetConfigItem(topic: $topic, content: $content, credit: $creditNumber, '
      'testLink: $testLink, resultLink: $resultLink)';
}
