import 'package:exam/export.dart';

class GetListSheetsRepo {
  final ApiClient _apiClient;

  GetListSheetsRepo(this._apiClient);

  Future<SpreadsheetEntity> call({required String domain}) async {
    try {
      final response = await _apiClient.get('/$domain?key=${AppConst.apiKey}');
      if (response.statusCode == 200) {
        // Giả sử API trả về một list tên sheet
        AppLogger.logD('Response data GetListSheetsRepo: ${response.data}'); // Debug log
        return SpreadsheetEntity.fromJson(response.data);
      } else {
        throw Exception('Failed to load sheets');
      }
    } catch (e) {
      throw Exception('Error fetching sheets: $e');
    }
  }
}
//create provider for get list sheets repo

final getListSheetsRepoProvider = Provider<GetListSheetsRepo>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return GetListSheetsRepo(apiClient);
});
