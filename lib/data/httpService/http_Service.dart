import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:progiom_cms/homeSettings.dart';

import '../../constants.dart';
import '../../injections.dart';

class HttpSerivce {
  uploadFile(
    String path,
  ) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('${BaseUrl}api/upload'));
    request.files.add(await http.MultipartFile.fromPath('media[]', path));

    request.headers.addAll(
        {"Authorization": "Bearer ${sl<HomesettingsBloc>().token ?? ""}"});

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final String res = await response.stream.bytesToString();
      return (jsonDecode(res)['url']);
    } else {
      print(response.reasonPhrase);
    }
  }
}
