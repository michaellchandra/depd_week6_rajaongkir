part of 'services.dart';

class MasterDataServices {
  static Future<http.Response> getMahasiswa() async{
    var response = await http.get(
      Uri.https("localhost:9090", "/mahasiswa"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var job = json.decode(response.body);
    print(job.toString());
  
    return response;
  }

  static Future<List<Province>> getProvince() async {
    var response = await http.get(
      Uri.https(Const.baseUrl, '/starter/province'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      },
    );

    var job = json.decode(response.body);

    List<Province> result = [];
    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => Province.fromJson(e))
          .toList();
    }
    // Map<String, dynamic> result = {};
    // result['status'] = job['rajaongkir']['']['code'];
    // result['message'] = job['rajaongkir']['status']['description'];

    // if (result['status'] == 200) {
    //   result['data'] = job['rajaongkir']['result'];
    // }
    return result;
  }

  Future<List<City>> getCity(var provId) async {
    var response = await http.get(
      Uri.https(Const.baseUrl, "/starter/city"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "key": Const.apiKey
      },
    );

    var job = json.decode(response.body);
    List<City> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => City.fromJson(e))
          .toList();
    }

    List<City> selectedCities = [];
    for (var c in result) {
      if (c.provinceId == provId) {
        selectedCities.add(c);
      }
    }

    return selectedCities;
  }
}
