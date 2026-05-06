import 'package:exam/export.dart';

//define class GetSheetState include SpreadsheetEntity and String to get grid_range
class GetSheetState {
  final SpreadsheetEntity? spreadsheet;
  final List<String> gridRange;

  GetSheetState({this.spreadsheet, required this.gridRange});
  //copywith
  GetSheetState copyWith({SpreadsheetEntity? spreadsheet, List<String>? gridRange}) {
    return GetSheetState(
      spreadsheet: spreadsheet ?? this.spreadsheet,
      gridRange: gridRange ?? this.gridRange,
    );
  }

  String? get branchName {
    var name = spreadsheet?.sheets?.firstOrNull?.tables?.firstOrNull?.name;
    AppLogger.logD('Branch name: $spreadsheet');
    return name;
  }
}

//with AsynNOtifier
class GetSheetsProvider extends AsyncNotifier<GetSheetState> {
  @override
  Future<GetSheetState> build() async {
    return await fetchSheets();
  }

  Future<GetSheetState> fetchSheets() async {
    state = const AsyncValue.loading();
    List<String> gridRange = [];
    // SpreadsheetEntity sheets = SpreadsheetEntity.empty();
    // call api with List Sheets Repository
    final getRepository = ref.read(getListSheetsRepoProvider);
    try {
      // 1. Tạo một danh sách các Future (chưa await ngay)
      final futures =
          AppConst.apiKeys.map((item) async {
            final result = await getRepository.call(domain: item);
            AppLogger.logD('Fetching sheets for API key: $item');
            AppLogger.logD('Fetching result : ${result.sheets?.toList()}');
            return result;
          }).toList();

      // 2. Chạy tất cả cùng lúc và đợi kết quả cuối cùng
      final results = await Future.wait(futures);

      // 3. Xử lý kết quả sau khi tất cả đã xong
      SpreadsheetEntity? mainSheet;
      for (var result in results) {
        if (result.sheets != null && result.sheets!.isNotEmpty) {
          gridRange.addAll(_convertToA1Notation(result));
          // Lấy spreadsheet đầu tiên có tables để hiển thị branchName
          mainSheet ??= result;
        }
      }
      AppLogger.logD('Fetched sheets: $gridRange'); // Debug log
      return GetSheetState(spreadsheet: mainSheet, gridRange: gridRange);
    } catch (e) {
      return GetSheetState(spreadsheet: SpreadsheetEntity.empty(), gridRange: []);
    }
  }

  List<String> _convertToA1Notation(SpreadsheetEntity sheets) {
    List<String> gridRanges = [];
    if (sheets.sheets != null && sheets.sheets!.isNotEmpty) {
      final firstSheet = sheets.sheets!.toList();
      //use for loop to get all tables in first sheet and convert to A1 notation
      for (final sheet in firstSheet) {
        if (sheet.tables != null && sheet.tables!.isNotEmpty) {
          final listTable = sheet.tables!.toList();
          for (final table in listTable) {
            final gridRange = GridRange.fromTableEntity(table, sheetName: sheet.properties?.title);
            gridRanges.add(gridRange.toA1Notation());
          }
        }
      }
    }
    return gridRanges;
  }
}

//create provider for GetSheetsProvider
final getSheetsProvider = AsyncNotifierProvider<GetSheetsProvider, GetSheetState>(() {
  return GetSheetsProvider();
});

class Sheet {
  final String name;
  final String id;

  Sheet({required this.name, required this.id});
}
