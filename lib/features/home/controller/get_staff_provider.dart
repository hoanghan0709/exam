import 'package:exam/export.dart';

class GetStaffInfoState {
  final InforStaffEntity staffInfo;

  GetStaffInfoState({required this.staffInfo});

  GetStaffInfoState copyWith({InforStaffEntity? staffInfo}) {
    return GetStaffInfoState(staffInfo: staffInfo ?? this.staffInfo);
  }
}

// get staff info provider, depend on getSheetsProvider and userModelProvider to get gridRange and user email, then call api to get staff info
class GetStaffInfoProvider extends AsyncNotifier<GetStaffInfoState> {
  @override
  Future<GetStaffInfoState> build() async {
    // Chờ getSheetsProvider có data trước (watch sẽ tự rebuild khi sheets ready)
    final sheetsState = await ref.watch(getSheetsProvider.future);
    final gridRange = sheetsState.gridRange;

    AppLogger.info('gridRange in GetStaffInfoProvider: $gridRange'); // Debug log

    if (gridRange.isEmpty) {
      return GetStaffInfoState(staffInfo: const InforStaffEntity.empty());
    }

    // Lấy email user đang login (watch để tự rebuild khi user thay đổi)
    final user = await ref.watch(userModelProvider.future);
    final userEmail = user.email ?? '';

    if (userEmail.isEmpty) {
      return GetStaffInfoState(staffInfo: const InforStaffEntity.empty());
    }

    final getRepository = ref.read(getInforStaffProvider);

    try {
      InforStaffEntity? staffInfo;

      // Dừng ngay khi tìm thấy kết quả hợp lệ — không gọi thừa API
      outer:
      for (final range in gridRange) {
        for (final apiKey in AppConst.apiKeys) {
          AppLogger.debug('Trying range: $range | apiKey: $apiKey');
          final result = await getRepository.callByEmail(
            gridRange: range,
            email: userEmail,
            domain: apiKey,
          );
          if (result?.name?.isNotEmpty == true) {
            AppLogger.debug('Found staff: ${result?.name}');
            staffInfo = result;
            break outer; // ← Thoát cả 2 vòng lặp ngay lập tức
          }
        }
      }

      return GetStaffInfoState(staffInfo: staffInfo ?? const InforStaffEntity.empty());
    } catch (e) {
      print('Error fetching staff info: $e');
      return GetStaffInfoState(staffInfo: const InforStaffEntity.empty());
    }
  }
}

final getStaffInfoProvider = AsyncNotifierProvider<GetStaffInfoProvider, GetStaffInfoState>(
  () => GetStaffInfoProvider(),
);
