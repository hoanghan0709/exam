import 'package:exam/export.dart';
import 'package:exam/utils/ext_formatter.dart';

class MergedTCResult {
  final List<ListTC> missingTC; // TC còn thiếu
  final List<ListTC> passedTC; // TC đã đạt

  const MergedTCResult({this.missingTC = const [], this.passedTC = const []});
}

/// Derived provider — tự động combine config + linkExam
/// Không cần gọi thủ công, tự rebuild khi 1 trong 2 source thay đổi
final mergedTCProvider = FutureProvider.autoDispose<MergedTCResult>((ref) async {
  // Watch cả 2 provider — tự rebuild khi bất kỳ cái nào thay đổi
  final staffInfo = await ref.watch(getStaffInfoProvider.future);
  final configState = await ref.watch(getConfigSheetsProvider.future);
  final linkExamState = await ref.watch(getLinkExamSheetsProvider.future);

  // 1. Lọc missingCredits
  List<String> missingCredits =
      staffInfo.staffInfo.missingCredits?.split(',').map((e) => e.trim()).toList() ?? [];

  // TC còn thiếu
  final filteredMissing =
      configState.listCreditNumber.where((tc) {
        return missingCredits.any((e) => e.tcNumber == tc.content?.tcNumber);
      }).toList();

  // TC đã đạt
  final filteredPassed =
      configState.listCreditNumber.where((tc) {
        return !missingCredits.any((e) => e.tcNumber == tc.content?.tcNumber);
      }).toList();

  //2.Merge linkExam vào listTC đã lọc missingCredits để map link tương ứng
  final linkExamSheet = linkExamState.spreadsheet;

  List<ListTC> _mergeWithLink(List<ListTC> list) {
    return list.map((configItem) {
      final matched = linkExamSheet.findByCredit(configItem.content ?? '');
      return ListTC(
        topic: matched?.content ?? '',
        content: configItem.content,
        creditNumber: configItem.creditNumber,
        link: matched?.testLink ?? configItem.link,
      );
    }).toList();
  }

  return MergedTCResult(
    missingTC: _mergeWithLink(filteredMissing),
    passedTC: _mergeWithLink(filteredPassed),
  );
});

// // ...existing code...
// /// Derived provider — tự động combine config + linkExam
// /// Không cần gọi thủ công, tự rebuild khi 1 trong 2 source thay đổi
// final mergedTCProvider = FutureProvider.autoDispose<List<ListTC>>((ref) async {
//   // Watch cả 2 provider — tự rebuild khi bất kỳ cái nào thay đổi
//   final staffInfo = await ref.watch(getStaffInfoProvider.future);
//   final configState = await ref.watch(getConfigSheetsProvider.future);
//   final linkExamState = await ref.watch(getLinkExamSheetsProvider.future);

//   // 1. Lọc missingCredits
//   List<String> missingCredits =
//       staffInfo.staffInfo.missingCredits?.split(',').map((e) => e.trim()).toList() ?? [];

//   final filteredTC =
//       configState.listCreditNumber.where((tc) {
//         return missingCredits.any((e) => e.tcNumber == tc.content?.tcNumber);
//       }).toList();
//   //2.Merge linkExam vào listTC đã lọc missingCredits để map link tương ứng
//   final linkExamSheet = linkExamState.spreadsheet;
//   final List<ListTC> result = [];

//   for (final configItem in filteredTC) {
//     final matched = linkExamSheet.findByCredit(configItem.content ?? '');
//     result.add(
//       ListTC(
//         topic: matched?.content ?? '',
//         content: configItem.content,
//         creditNumber: configItem.creditNumber,
//         link: matched?.testLink ?? configItem.link,
//       ),
//     );
//   }

//   return result;
// });

//from 1->24
List<String> listCreditNumberDefault = [
  'TC01',
  'TC02',
  'TC03',
  'TC04',
  'TC05',
  'TC06',
  'TC07',
  'TC08',
  'TC09',
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
