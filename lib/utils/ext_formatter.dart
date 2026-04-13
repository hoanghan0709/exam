extension FormatCreditNumberExt on String {
  int get formatCreditNumber => int.tryParse(replaceAll('TC', '')) ?? -1;
}

//use:
// final result = apiList.where((api) {
//   return localList.map((e) => e.tcNumber).contains(api.tcNumber);
// }).toList();

//chỉ lấy string của input dùng regex ( bỏ số và kí tự đặc biệt để )
//cho phép có dấu tiếng việt
extension ExtractStringExt on String {
  //có dấu tiếng việt
  String get extractString => replaceAll(RegExp(r'[^a-zA-ZÀ-ỹ\s]'), '').trim();
}
