import 'package:dio/dio.dart';
import 'package:exam/export.dart';

class GetLinkExamSheetsRepo {
  final ApiClient _apiClient;

  GetLinkExamSheetsRepo(this._apiClient);

  Future<SheetLinkExamEntity> call({String? sheetName}) async {
    try {
      late final Response response;

      if (sheetName != null) {
        response = await _apiClient.get(
          '/${AppConst.keySheet}/values/$sheetName?key=${AppConst.apiKey}',
        );
      }
      if (response.statusCode == 200) {
        // Giả sử API trả về một list tên sheet
        AppLogger.info('Response data GetLinkExamSheetsRepo: ${response.data}'); // Debug log
        return SheetLinkExamEntity.fromJson(response.data);
      } else {
        throw Exception('Failed to load sheets');
      }
    } catch (e) {
      throw Exception('Error fetching sheets: $e');
    }
  }
}
//create provider for get list sheets repo

final getLinkExamSheetsRepoProvider = Provider<GetLinkExamSheetsRepo>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return GetLinkExamSheetsRepo(apiClient);
});
