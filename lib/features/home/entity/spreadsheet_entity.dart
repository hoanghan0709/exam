import 'dart:convert';

import 'package:exam/features/home/entity/grid_range.dart';

/// Root entity
class SpreadsheetEntity {
  final String? spreadsheetId;
  final SpreadsheetProperties? properties;
  final List<SheetEntity>? sheets;
  final String? spreadsheetUrl;

  const SpreadsheetEntity({this.spreadsheetId, this.properties, this.sheets, this.spreadsheetUrl});

  factory SpreadsheetEntity.fromJson(Map<String, dynamic> json) {
    return SpreadsheetEntity(
      spreadsheetId: json['spreadsheetId'] as String?,
      properties:
          json['properties'] != null
              ? SpreadsheetProperties.fromJson(json['properties'] as Map<String, dynamic>)
              : null,
      sheets:
          (json['sheets'] as List<dynamic>?)
              ?.map((e) => SheetEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
      spreadsheetUrl: json['spreadsheetUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'spreadsheetId': spreadsheetId,
    'properties': properties?.toJson(),
    'sheets': sheets?.map((e) => e.toJson()).toList(),
    'spreadsheetUrl': spreadsheetUrl,
  };
  //empty constructor for testing
  SpreadsheetEntity.empty()
    : spreadsheetId = null,
      properties = null,
      sheets = null,
      spreadsheetUrl = null;

  String toRawJson() => jsonEncode(toJson());
  factory SpreadsheetEntity.fromRawJson(String str) =>
      SpreadsheetEntity.fromJson(jsonDecode(str) as Map<String, dynamic>);

  @override
  String toString() =>
      'SpreadsheetEntity(id: $spreadsheetId, title: ${properties?.title}, sheets: ${sheets?.length})';
}

/// Spreadsheet properties
class SpreadsheetProperties {
  final String? title;
  final String? locale;
  final String? autoRecalc;
  final String? timeZone;

  const SpreadsheetProperties({this.title, this.locale, this.autoRecalc, this.timeZone});

  factory SpreadsheetProperties.fromJson(Map<String, dynamic> json) {
    return SpreadsheetProperties(
      title: json['title'] as String?,
      locale: json['locale'] as String?,
      autoRecalc: json['autoRecalc'] as String?,
      timeZone: json['timeZone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'locale': locale,
    'autoRecalc': autoRecalc,
    'timeZone': timeZone,
  };
}

/// Sheet entity
class SheetEntity {
  final SheetProperties? properties;
  final List<BandedRange>? bandedRanges;
  final List<TableEntity>? tables;

  const SheetEntity({this.properties, this.bandedRanges, this.tables});

  factory SheetEntity.fromJson(Map<String, dynamic> json) {
    return SheetEntity(
      properties:
          json['properties'] != null
              ? SheetProperties.fromJson(json['properties'] as Map<String, dynamic>)
              : null,
      bandedRanges:
          (json['bandedRanges'] as List<dynamic>?)
              ?.map((e) => BandedRange.fromJson(e as Map<String, dynamic>))
              .toList(),
      tables:
          (json['tables'] as List<dynamic>?)
              ?.map((e) => TableEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'properties': properties?.toJson(),
    'bandedRanges': bandedRanges?.map((e) => e.toJson()).toList(),
    'tables': tables?.map((e) => e.toJson()).toList(),
  };

  @override
  String toString() => 'SheetEntity(title: ${properties?.title}, sheetId: ${properties?.sheetId})';

  /// Lấy danh sách GridRange từ tất cả tables trong sheet
  List<GridRange> getTableGridRanges() {
    return tables?.map((table) {
          return GridRange.fromTableEntity(table, sheetName: properties?.title);
        }).toList() ??
        [];
  }

  /// Lấy danh sách GridRange từ tất cả bandedRanges trong sheet
  List<GridRange> getBandedGridRanges() {
    return bandedRanges?.map((banded) {
          return GridRange.fromBandedRange(banded, sheetName: properties?.title);
        }).toList() ??
        [];
  }
}

/// Sheet properties
class SheetProperties {
  final int? sheetId;
  final String? title;
  final int? index;
  final String? sheetType;
  final GridProperties? gridProperties;

  const SheetProperties({
    this.sheetId,
    this.title,
    this.index,
    this.sheetType,
    this.gridProperties,
  });

  factory SheetProperties.fromJson(Map<String, dynamic> json) {
    return SheetProperties(
      sheetId: json['sheetId'] as int?,
      title: json['title'] as String?,
      index: json['index'] as int?,
      sheetType: json['sheetType'] as String?,
      gridProperties:
          json['gridProperties'] != null
              ? GridProperties.fromJson(json['gridProperties'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'sheetId': sheetId,
    'title': title,
    'index': index,
    'sheetType': sheetType,
    'gridProperties': gridProperties?.toJson(),
  };
}

/// Grid properties
class GridProperties {
  final int? rowCount;
  final int? columnCount;
  final int? frozenRowCount;

  const GridProperties({this.rowCount, this.columnCount, this.frozenRowCount});

  factory GridProperties.fromJson(Map<String, dynamic> json) {
    return GridProperties(
      rowCount: json['rowCount'] as int?,
      columnCount: json['columnCount'] as int?,
      frozenRowCount: json['frozenRowCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'rowCount': rowCount,
    'columnCount': columnCount,
    'frozenRowCount': frozenRowCount,
  };
}

/// Banded range
class BandedRange {
  final int? bandedRangeId;
  final RangeEntity? range;
  final String? bandedRangeReference;

  const BandedRange({this.bandedRangeId, this.range, this.bandedRangeReference});

  factory BandedRange.fromJson(Map<String, dynamic> json) {
    return BandedRange(
      bandedRangeId: json['bandedRangeId'] as int?,
      range:
          json['range'] != null
              ? RangeEntity.fromJson(json['range'] as Map<String, dynamic>)
              : null,
      bandedRangeReference: json['bandedRangeReference'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'bandedRangeId': bandedRangeId,
    'range': range?.toJson(),
    'bandedRangeReference': bandedRangeReference,
  };
}

/// Range entity (used in bandedRanges and tables)
class RangeEntity {
  final int? sheetId;
  final int? startRowIndex;
  final int? endRowIndex;
  final int? startColumnIndex;
  final int? endColumnIndex;

  const RangeEntity({
    this.sheetId,
    this.startRowIndex,
    this.endRowIndex,
    this.startColumnIndex,
    this.endColumnIndex,
  });

  factory RangeEntity.fromJson(Map<String, dynamic> json) {
    return RangeEntity(
      sheetId: json['sheetId'] as int?,
      startRowIndex: json['startRowIndex'] as int?,
      endRowIndex: json['endRowIndex'] as int?,
      startColumnIndex: json['startColumnIndex'] as int?,
      endColumnIndex: json['endColumnIndex'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'sheetId': sheetId,
    'startRowIndex': startRowIndex,
    'endRowIndex': endRowIndex,
    'startColumnIndex': startColumnIndex,
    'endColumnIndex': endColumnIndex,
  };
}

/// Table entity
class TableEntity {
  final String? tableId;
  final String? name;
  final RangeEntity? range;
  final List<ColumnProperty>? columnProperties;

  const TableEntity({this.tableId, this.name, this.range, this.columnProperties});

  factory TableEntity.fromJson(Map<String, dynamic> json) {
    return TableEntity(
      tableId: json['tableId'] as String?,
      name: json['name'] as String?,
      range:
          json['range'] != null
              ? RangeEntity.fromJson(json['range'] as Map<String, dynamic>)
              : null,
      columnProperties:
          (json['columnProperties'] as List<dynamic>?)
              ?.map((e) => ColumnProperty.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'tableId': tableId,
    'name': name,
    'range': range?.toJson(),
    'columnProperties': columnProperties?.map((e) => e.toJson()).toList(),
  };

  @override
  String toString() =>
      'TableEntity(name: $name, columns: ${columnProperties?.map((c) => c.columnName).toList()})';
}

/// Column property
class ColumnProperty {
  final int? columnIndex;
  final String? columnName;

  const ColumnProperty({this.columnIndex, this.columnName});

  factory ColumnProperty.fromJson(Map<String, dynamic> json) {
    return ColumnProperty(
      columnIndex: json['columnIndex'] as int?,
      columnName: json['columnName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'columnIndex': columnIndex, 'columnName': columnName};

  @override
  String toString() => 'ColumnProperty(index: $columnIndex, name: $columnName)';
}
