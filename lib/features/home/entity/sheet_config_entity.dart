// // create object for this json
import 'package:exam/features/home/controller/get_sheet_config_provider.dart';

class SheetConfigEntity {
  final String? range;
  final String? majorDimension;
  final List<List<String?>>? values;

  const SheetConfigEntity({this.range, this.majorDimension, this.values});

  factory SheetConfigEntity.fromJson(Map<String, dynamic> json) {
    return SheetConfigEntity(
      range: json['range'] as String?,
      majorDimension: json['majorDimension'] as String?,
      values:
          (json['values'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>).map((v) => v?.toString()).toList())
              .toList(),
    );
  }
  List<String> getListTCByPosition(String position) {
    if (values == null || values!.length < 2) return [];
    final header = values![0];
    return values!
        .skip(1) // skip header
        .where((row) => row.isNotEmpty && row[0]?.toLowerCase() == position.toLowerCase())
        .expand((e) {
          return [
            for (int i = 1; i < e.length; i++)
              if (e[i] == '1' && i < header.length && header[i] != null) header[i]!,
          ];
        })
        .toList();
  }

  Map<String, dynamic> toJson() => {
    'range': range,
    'majorDimension': majorDimension,
    'values': values?.map((e) => e.map((v) => v).toList()).toList(),
  };
  //empty
  const SheetConfigEntity.empty() : range = null, majorDimension = null, values = null;
  @override
  String toString() =>
      'SheetConfigEntity(range: $range, majorDimension: $majorDimension, values: $values)';
}
