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
      // Gọi API lấy dữ liệu sheet — dùng gridRange đầu tiên (sheet "Thông tin")
      final staffInfo = await getRepository.callByEmail(
        gridRange: gridRange.first,
        email: userEmail,
      );

      print('Fetched staff info: $staffInfo');

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
