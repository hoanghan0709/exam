// // create object for this json
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
