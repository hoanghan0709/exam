//use apiclient to get list sheets

import 'package:exam/export.dart';

class GetConfigSheetsRepo {
  final ApiClient _apiClient;

  GetConfigSheetsRepo(this._apiClient);

  Future<SheetConfigEntity> call({String? sheetName}) async {
    try {
      late final response;

      if (sheetName != null) {
        response = await _apiClient.get(
          '/${AppConst.keySheet}/values/$sheetName?key=${AppConst.apiKey}',
        );
      }
      if (response.statusCode == 200) {
        // Giả sử API trả về một list tên sheet
        AppLogger.info('Response data GetListSheetsRepo: ${response.data}'); // Debug log
        return SheetConfigEntity.fromJson(response.data);
      } else {
        throw Exception('Failed to load sheets');
      }
    } catch (e) {
      throw Exception('Error fetching sheets: $e');
    }
  }
}
//create provider for get list sheets repo

final getConfigSheetsRepoProvider = Provider<GetConfigSheetsRepo>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return GetConfigSheetsRepo(apiClient);
});
