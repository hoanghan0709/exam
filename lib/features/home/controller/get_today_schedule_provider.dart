import 'dart:async';

import 'package:exam/export.dart';

class GetTodayScheduleProvider extends AsyncNotifier<List<ListTC>> {
  GetTodayScheduleProvider();

  Future<List<ListTC>> fetchTodaySchedule() async {
    state = const AsyncValue.loading();
    try {
      final staffInfo = await ref.watch(getStaffInfoProvider.future);
      final configSheets = await ref.watch(getConfigSheetsProvider.future);

      final currentPosition = staffInfo.staffInfo.position?.displayName ?? '';

      if (currentPosition.isEmpty) return [];

      final tcList = configSheets.spreadsheet.getListTCByPosition(currentPosition);

      print('Position: $currentPosition');
      print('TC list: $tcList');

      final List<ListTC> schedule = tcList.map((tc) => ListTC(content: tc)).toList();

      return schedule;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ListTC>> build() async {
    return fetchTodaySchedule();
  }
}

//create provider
final getTodayScheduleProvider = AsyncNotifierProvider<GetTodayScheduleProvider, List<ListTC>>(
  () => GetTodayScheduleProvider(),
);
