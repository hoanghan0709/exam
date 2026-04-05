import 'package:exam/features/home/entity/spreadsheet_entity.dart';
import 'package:exam/utils/logger.dart';

class GridRange {
  final int startRowIndex;
  final int endRowIndex;
  final int startColumnIndex;
  final int endColumnIndex;
  final String? sheetName;

  GridRange({
    required this.startRowIndex,
    required this.endRowIndex,
    required this.startColumnIndex,
    required this.endColumnIndex,
    this.sheetName,
  });

  /// Convert từ RangeEntity (API response) sang GridRange
  factory GridRange.fromRangeEntity(RangeEntity range, {String? sheetName}) {
    return GridRange(
      startRowIndex: range.startRowIndex ?? 0,
      endRowIndex: range.endRowIndex ?? 0,
      startColumnIndex: range.startColumnIndex ?? 0,
      endColumnIndex: range.endColumnIndex ?? 0,
      sheetName: sheetName,
    );
  }

  /// Convert từ TableEntity — tự lấy sheetName từ tên table
  factory GridRange.fromTableEntity(TableEntity table, {String? sheetName}) {
    return GridRange.fromRangeEntity(
      table.range ?? const RangeEntity(),
      sheetName: sheetName ?? table.name,
    );
  }

  /// Convert từ BandedRange
  factory GridRange.fromBandedRange(BandedRange banded, {String? sheetName}) {
    return GridRange.fromRangeEntity(banded.range ?? const RangeEntity(), sheetName: sheetName);
  }

  /// Lấy địa chỉ A1 notation (ví dụ: Sheet1!A1:G25)
  String toA1Notation() => GridRangeExtension.gridRangeToA1(this);

  @override
  String toString() => 'GridRange($sheetName: ${toA1Notation()})';
}

class GridRangeExtension {
  static String columnToLetter(int col) {
    String result = '';
    col += 1;

    while (col > 0) {
      int rem = (col - 1) % 26;
      result = String.fromCharCode(65 + rem) + result;
      col = (col - 1) ~/ 26;
    }

    return result;
  }

  static String gridRangeToA1(GridRange range) {
    final startCol = columnToLetter(range.startColumnIndex);
    final endCol = columnToLetter(range.endColumnIndex - 1);

    final startRow = range.startRowIndex + 1;
    final endRow = range.endRowIndex;

    final a1 = '$startCol$startRow:$endCol$endRow';

    var data = range.sheetName != null ? '${range.sheetName}!$a1' : a1;
    AppLogger.info('Converted GridRange to A1 notation: $data');
    return data;
  }
  //final range = GridRange(
  //   startRowIndex: 0,
  //   endRowIndex: 25,
  //   startColumnIndex: 3,
  //   endColumnIndex: 5,
  //   sheetName: 'Sheet1',
  // );

  // print(gridRangeToA1(range));
  // 👉 Sheet1!D1:E25
}
