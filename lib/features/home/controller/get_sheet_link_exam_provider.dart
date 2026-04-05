import 'package:exam/export.dart';

// sheets: LINK TEST
class SheetLinkExamState {
  final SheetLinkExamEntity spreadsheet;

  SheetLinkExamState({required this.spreadsheet});

  SheetLinkExamState copyWith({SheetLinkExamEntity? spreadsheet}) {
    return SheetLinkExamState(spreadsheet: spreadsheet ?? this.spreadsheet);
  }

  SheetLinkExamState.empty() : spreadsheet = const SheetLinkExamEntity();
}

/// Provider chỉ chịu trách nhiệm fetch dữ liệu link exam
/// KHÔNG modify state của provider khác
class GetSheetsLinkExamProvider extends AsyncNotifier<SheetLinkExamState> {
  @override
  Future<SheetLinkExamState> build() async {
    final getRepository = ref.read(getLinkExamSheetsRepoProvider);
    try {
      final sheets = await getRepository.call(sheetName: AppConst.linkExam);
      AppLogger.info('Fetched link exam sheets: ${sheets.items.length} items');
      return SheetLinkExamState(spreadsheet: sheets);
    } catch (e, st) {
      AppLogger.error('Error fetching link exam sheets', e, st);
      return SheetLinkExamState(spreadsheet: SheetLinkExamEntity.empty());
    }
  }
}

final getLinkExamSheetsProvider =
    AsyncNotifierProvider<GetSheetsLinkExamProvider, SheetLinkExamState>(
      GetSheetsLinkExamProvider.new,
    );
