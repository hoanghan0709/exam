import 'package:exam/export.dart';

/// ListTC chứa thông tin tín chỉ kèm link test
class ListTC {
  final String? topic;
  final String? content;
  final String? link;
  final String? creditNumber;

  const ListTC({this.topic, this.content, this.link, this.creditNumber});

  @override
  String toString() => 'ListTC(content: $content, link: $link, credit: $creditNumber)';
}

//sheet: CAU HINH
class SheetConfigState {
  final SheetConfigEntity spreadsheet;
  final List<ListTC> listCreditNumber;

  SheetConfigState({required this.spreadsheet, required this.listCreditNumber});
  //copywith
  SheetConfigState copyWith({SheetConfigEntity? spreadsheet, List<ListTC>? listTC}) {
    return SheetConfigState(
      spreadsheet: spreadsheet ?? this.spreadsheet,
      listCreditNumber: listTC ?? this.listCreditNumber,
    );
  }

  @override
  String toString() {
    return 'SheetConfigState(spreadsheet: $spreadsheet)';
  }

  //empty constructor for testing
  SheetConfigState.empty() : spreadsheet = const SheetConfigEntity(), listCreditNumber = [];
}

//with AsyncNotifier
class GetSheetConfigProvider extends AsyncNotifier<SheetConfigState> {
  @override
  Future<SheetConfigState> build() async {
    return await fetchSheets();
  }

  Future<SheetConfigState> fetchSheets() async {
    state = const AsyncValue.loading();

    final getRepository = ref.read(getConfigSheetsRepoProvider);
    try {
      final sheets = await getRepository.call(sheetName: AppConst.configKey); // Debug log

      return SheetConfigState(
        listCreditNumber: listCreditNumberDefault.map((tc) => ListTC(content: tc)).toList(),
        spreadsheet: sheets,
      );
    } catch (e) {
      return SheetConfigState(spreadsheet: SheetConfigEntity.empty(), listCreditNumber: []);
    }
  }

  //emit listTC to UI
  void onChangeTC(List<ListTC> listTC) {
    state = AsyncValue.data(state.value!.copyWith(listTC: listTC));
  }
}

//create provider for GetSheetsProvider
final getConfigSheetsProvider = AsyncNotifierProvider<GetSheetConfigProvider, SheetConfigState>(() {
  return GetSheetConfigProvider();
});
