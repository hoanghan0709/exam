import 'dart:async';

import 'package:exam/export.dart';
import 'package:exam/features/home/controller/get_today_schedule_provider.dart';
import 'package:intl/intl.dart';

class GetSheetsTimelineProvider extends AsyncNotifier<TimelineEntity> {
  GetSheetsTimelineProvider();

  Future<TimelineEntity> fetchSheetsTimeline() async {
    state = const AsyncValue.loading();
    try {
      final sheets = await ref
          .read(getConfigSheetsRepoProvider)
          .call(sheetName: AppConst.timelineKey); //
      final list = sheets['values'];
      //convert sheets to TimelineEntity
      final timelineEntity = TimelineEntity.fromSheet(list);
      AppLogger.info('Fetched sheets timeline: $timelineEntity'); // Debug log
      return timelineEntity;
    } catch (e) {
      // state = AsyncValue.error(e);
      rethrow;
    }
  }

  @override
  FutureOr<TimelineEntity> build() {
    return fetchSheetsTimeline();
  }
}

//create provider
final getSheetsTimelineProvider = AsyncNotifierProvider<GetSheetsTimelineProvider, TimelineEntity>(
  () => GetSheetsTimelineProvider(),
);

class TimelineItem {
  final int day;
  final int totalCredit;

  TimelineItem({required this.day, required this.totalCredit});

  factory TimelineItem.fromList(List<dynamic> row) {
    return TimelineItem(
      day: int.tryParse(row[0].toString()) ?? 0,
      totalCredit: int.tryParse(row[1].toString()) ?? 0,
    );
  }
  //override toString for debug
  @override
  String toString() {
    return 'TimelineItem(day: $day, totalCredit: $totalCredit)';
  }
}

class TimelineEntity {
  final List<TimelineItem> items;
  final int? totalCredit;
  final String? timeline;

  TimelineEntity({required this.items, required this.totalCredit, required this.timeline});

  factory TimelineEntity.fromSheet(List<dynamic> sheet) {
    // Bỏ header, map từng dòng thành TimelineItem
    final items = sheet.skip(1).map((row) => TimelineItem.fromList(row)).toList();
    final totalCredit = items.fold<int>(0, (sum, item) => sum + item.totalCredit);
    return TimelineEntity(items: items, totalCredit: totalCredit, timeline: '');
  }

  copyWith({List<TimelineItem>? items, String? timeline}) {
    return TimelineEntity(
      items: items ?? this.items,
      totalCredit: totalCredit,
      timeline: timeline ?? this.timeline,
    );
  }

  @override
  String toString() {
    return 'TimelineEntity(items: $items, totalCredit: $totalCredit, timeline: $timeline)';
  }
}

final mergedTimelineProvider = FutureProvider.autoDispose<TimelineEntity>((ref) async {
  //define provider
  final schedule = await ref.watch(getTodayScheduleProvider.future);
  final staffInfoState = await ref.watch(getStaffInfoProvider.future);
  final timelineState = await ref.watch(getSheetsTimelineProvider.future);
  //sheet today schedule, get from sheet config
  int totalCredit = schedule.length;
  //find timline with credit of staff in timelineState
  final staffTimeline =
      timelineState.items.where((item) {
        return item.totalCredit == totalCredit;
      }).toList();

  String addDaysToStartDate(String? startDate, int daysToAdd) {
    if (startDate == null) return 'Vui lòng kiểm tra lại kiểu ngày bắt đầu (ngày/tháng/năm)';
    try {
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');

      final parsedDate = dateFormat.parseStrict(startDate);
      final newDate = parsedDate.add(Duration(days: daysToAdd));
      String data = dateFormat.format(newDate);
      return data;
    } catch (e) {
      return 'Không xác định';
    }
  }

  addDaysToStartDate(staffInfoState.staffInfo.startDate, totalCredit);

  return TimelineEntity(
    items: staffTimeline,
    totalCredit: totalCredit,
    timeline: addDaysToStartDate(staffInfoState.staffInfo.startDate, totalCredit),
  );
});
