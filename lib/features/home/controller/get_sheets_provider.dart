import 'package:exam/export.dart';

//define class GetSheetState include SpreadsheetEntity and String to get grid_range
class GetSheetState {
  final SpreadsheetEntity spreadsheet;
  final List<String> gridRange;

  GetSheetState({required this.spreadsheet, required this.gridRange});
  //copywith
  GetSheetState copyWith({SpreadsheetEntity? spreadsheet, List<String>? gridRange}) {
    return GetSheetState(
      spreadsheet: spreadsheet ?? this.spreadsheet,
      gridRange: gridRange ?? this.gridRange,
    );
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

    final getRepository = ref.read(getListSheetsRepoProvider);
    try {
      final sheets = await getRepository.call();
      //convert gridRange to A1 notation
      final gridRange = _convertToA1Notation(sheets);

      AppLogger.debug('Fetched sheets: $gridRange'); // Debug log
      return GetSheetState(spreadsheet: sheets, gridRange: gridRange);
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
