import 'package:exam/export.dart';

class GetInforStaff {
  final ApiClient _apiClient;

  GetInforStaff(this._apiClient);

  /// Lấy thông tin staff đầu tiên từ sheet
  // Future<InforStaffEntity> call({required String gridRange}) async {
  //   try {
  //     final response = await _apiClient.get(
  //       '/${AppConst.keySheet}/values/$gridRange?key=${AppConst.apiKey}',
  //     );
  //     if (response.statusCode == 200) {
  //       print('Response data GetInforStaff: ${response.data}');
  //       return InforStaffEntity.fromJson(response.data);
  //     } else {
  //       throw Exception('Failed to load staff info');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching staff info: $e');
  //   }
  // }

  /// Lấy thông tin staff theo email
  Future<InforStaffEntity?> callByEmail({required String gridRange, required String email}) async {
    try {
      final response = await _apiClient.get(
        '/${AppConst.keySheet}/values/$gridRange?key=${AppConst.apiKey}',
      );
      if (response.statusCode == 200) {
        return InforStaffEntity.findByEmail(response.data, email);
      } else {
        throw Exception('Failed to load staff info');
      }
    } catch (e) {
      throw Exception('Error fetching staff info: $e');
    }
  }
}

final getInforStaffProvider = Provider<GetInforStaff>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return GetInforStaff(apiClient);
});
