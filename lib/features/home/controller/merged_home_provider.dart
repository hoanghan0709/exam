import 'package:exam/export.dart';

/// Derived provider — tự động combine config + linkExam
/// Không cần gọi thủ công, tự rebuild khi 1 trong 2 source thay đổi
final mergedTCProvider = FutureProvider.autoDispose<List<ListTC>>((ref) async {
  // Watch cả 2 provider — tự rebuild khi bất kỳ cái nào thay đổi
  final staffInfo = await ref.watch(getStaffInfoProvider.future);
  final configState = await ref.watch(getConfigSheetsProvider.future);
  final linkExamState = await ref.watch(getLinkExamSheetsProvider.future);

  // 1. Lọc missingCredits
  final missingCredits =
      staffInfo.staffInfo.missingCredits?.split(',').map((e) => e.trim()).toList() ?? [];

  final filteredTC =
      configState.listCreditNumber.where((tc) => !missingCredits.contains(tc.content)).toList();
  //2.Merge linkExam vào listTC đã lọc missingCredits để map link tương ứng
  final linkExamSheet = linkExamState.spreadsheet;
  final List<ListTC> result = [];

  for (final configItem in filteredTC) {
    final matched = linkExamSheet.findByCredit(configItem.content ?? '');
    result.add(
      ListTC(
        topic: matched?.content ?? '',
        content: configItem.content,
        creditNumber: configItem.creditNumber,
        link: matched?.testLink ?? configItem.link,
      ),
    );
  }

  return result;
});

//from 1->24
List<String> listCreditNumberDefault = [
  'TC1',
  'TC2',
  'TC3',
  'TC4',
  'TC5',
  'TC6',
  'TC7',
  'TC8',
  'TC9',
  'TC10',
  'TC11',
  'TC12',
  'TC13',
  'TC14',
  'TC15',
  'TC16',
  'TC17',
  'TC18',
  'TC19',
  'TC20',
  'TC21',
  'TC22',
  'TC23',
  'TC24',
];
