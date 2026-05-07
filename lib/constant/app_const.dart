//const string
import 'dart:io';

class AppConst {
  static const String keySheet = '1twM4yNr-_HlQy7lU7TnwR7EDhxFUrArilT1DCHQ4zBc';
  static const String defaultAvatar =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBctWK5OWKCLcJEGDAbhpXWCi8zZ8gUr_yKo4rg5DX_i2esI9jbot8I6MXz-CCgvnCV1GTQnsu8qXc-NNjrT8l_Hluftgo8uPKzeS8vnKWic4RYEJhUpAoXCV7ryN7wXwvWgVe12OX-6JLgSLoiQMdCcy0UBRAfGULEo5l8gRmuUcU6qdVSIxPvvjtn0kw7cNtm1Ug_b5DifrZunn52SPSmO-CCgetvC_wo70EWpFzycU7VPXW4i4DvdXGOTMDzzCXsWtvPx82OEcM';

  static const String imgDashBoard =
      'https://img.freepik.com/free-photo/blue-toned-collection-aligned-paper-sheets_23-2148320449.jpg?semt=ais_incoming&w=740&q=80';

  // static const String userPosition = 'Vị trí • Phòng Vận hành Hệ thống';
  static const String apiKey = 'AIzaSyCBNfLFGaOrdNBBGVEQtpTuCx-J1pGlrRw';
  static const String timelineKey = 'TIMELINE_14NGAY';
  static const String configKey = 'CAUHINH';
  static const String linkExam = 'LINKBAITEST';

  //List api key
  static final List<String> apiKeys = [
    keySheet,
    '1Bqs89WbsGr35B1l-cKGlu1JMahMWv8X7I8NA_lQD4B8', //ĐỒNG NAI
  ]; //'1Bqs89WbsGr35B1l-cKGlu1JMahMWv8X7I8NA_lQD4B8'
  static String? clientId() {
    //check platform
    if (Platform.isIOS) {
      return "613237324796-4kjqlph2tsimoms268t2kiq5nonra2gu.apps.googleusercontent.com";
    } else {
      return null;
    }
  }

  static String serverClientId() {
    if (Platform.isIOS) {
      return "613237324796-4kjqlph2tsimoms268t2kiq5nonra2gu.apps.googleusercontent.com";
    } else {
      return "613237324796-kcrg1u3rrbn0viej37jdoj831ing8i6d.apps.googleusercontent.com";
    }
  }
}
