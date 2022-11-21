part of 'pages.dart';

class Ongkirpage extends StatefulWidget {
  const Ongkirpage({Key? key}) : super(key: key);

  @override
  _OngkirpageState createState() => _OngkirpageState();
}

class _OngkirpageState extends State<Ongkirpage> {
  bool isLoading = false;
  String dropdownvalue = 'jne';
  var kurir = ['jne', 'pos', 'tiki'];

  final ctrlBerat = TextEditingController();

  dynamic provId;
  dynamic provIdTujuan;
  dynamic provinceData;
  dynamic provinceDataTujuan;
  dynamic selectedProvince;
  dynamic selectedProvinceTujuan;
  bool isSelectedProvinceTujuan = false;
  bool isSelectedProvince = false;

  String selectedKurir = "jne";

  Future<List<Province>> getProvinces() async {
    dynamic listProvince;
    await MasterDataServices.getProvince().then((value) {
      setState(() {
        listProvince = value;
      });
    });

    return listProvince;
  }

  dynamic cityId;
  dynamic cityIdTujuan;
  dynamic city;
  dynamic cityData;
  dynamic cityDataTujuan;
  dynamic selectedCity;
  dynamic selectedCityTujuan;
  bool isSelectedCity = false;
  bool isSelectedCityTujuan = false;

  Future<List<City>> getCities(dynamic provId) async {
    dynamic listCity;
    await MasterDataServices().getCity(provId).then((value) {
      setState(() {
        listCity = value;
      });
    });

    return listCity;
  }

  String ori = '';
  String des = '';

  List<Costs> listCosts = [];
  Future<dynamic> getCostsData() async {
    await RajaOngkirService.getMyOngKir(
            cityId, cityIdTujuan, int.parse(ctrlBerat.text), selectedKurir)
        .then((value) {
      setState(() {
        listCosts = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    provinceData = getProvinces();
    provinceDataTujuan = getProvinces();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hitung Ongkir"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  //Flexible untuk form
                  Flexible(
                    flex: 10,
                    child: Column(
                      children: [
                        Lottie.asset('assets/lottie_json/delivery-map.json',
                            width: 250),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton(
                                  value: dropdownvalue,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  items: kurir.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                  }),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: ctrlBerat,
                                  decoration: InputDecoration(
                                    labelText: 'Berat (gr)',
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value == null || value == 0
                                        ? 'Berat harus diisi atau tidak boleh 0!'
                                        : null;
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Origin",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 125,
                                child: FutureBuilder<List<Province>>(
                                  future: provinceData,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          value: selectedProvince,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black),
                                          hint: selectedProvince == null
                                              ? Text("Pilih Provinsi Kamu")
                                              : Text(selectedProvince.province),
                                          items: snapshot.data!
                                              .map<DropdownMenuItem<Province>>(
                                                  (Province value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.province.toString()));
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedProvince = newValue;
                                              provId =
                                                  selectedProvince.provinceId;
                                              isSelectedProvince = true;
                                            });
                                            selectedCity = null;
                                            cityData = getCities(provId);
                                          });
                                    } else if (snapshot.hasError) {
                                      return Text("Tidak ada data");
                                    }

                                    return UiLoading.loadingDD();
                                  },
                                ),
                              ),
                              Container(
                                width: 125,
                                child: FutureBuilder<List<City>>(
                                  future: cityData,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          value: selectedCity,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          hint: selectedCity == null
                                              ? Text('Pilih kota')
                                              : Text(selectedCity.cityName),
                                          items: snapshot.data!
                                              .map<DropdownMenuItem<City>>(
                                                  (City value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()));
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedCity = newValue;
                                              cityId = selectedCity.cityId;
                                              isSelectedCity = true;
                                            });
                                          });
                                    } else if (snapshot.hasError) {
                                      return const Text("Tidak ada data.");
                                    }
                                    return UiLoading.loadingDD();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // DESTINATION
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Destinasi Tujuan",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 125,
                                child: FutureBuilder<List<Province>>(
                                  future: provinceData,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          value: selectedProvinceTujuan,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black),
                                          hint: selectedProvinceTujuan == null
                                              ? Text("Pilih Provinsi Tujuan")
                                              : Text(selectedProvinceTujuan
                                                  .province),
                                          items: snapshot.data!
                                              .map<DropdownMenuItem<Province>>(
                                                  (Province value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.province.toString()));
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedProvinceTujuan = newValue;
                                              provId = selectedProvinceTujuan
                                                  .provinceId;
                                              isSelectedProvinceTujuan = true;
                                            });
                                            selectedCityTujuan = null;
                                            cityDataTujuan = getCities(provId);
                                          });
                                    } else if (snapshot.hasError) {
                                      return Text("Tidak ada data");
                                    }
                                    return UiLoading.loadingDD();
                                  },
                                ),
                              ),
                              Container(
                                width: 125,
                                child: FutureBuilder<List<City>>(
                                  future: cityDataTujuan,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          value: selectedCityTujuan,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          hint: selectedCityTujuan == null
                                              ? Text('Pilih Kota Tujuan')
                                              : Text(
                                                  selectedCityTujuan.cityName),
                                          items: snapshot.data!
                                              .map<DropdownMenuItem<City>>(
                                                  (City value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()));
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedCityTujuan = newValue;
                                              cityIdTujuan =
                                                  selectedCityTujuan.cityId;
                                              isSelectedCityTujuan = true;
                                            });
                                          });
                                    } else if (snapshot.hasError) {
                                      return const Text("Tidak ada data.");
                                    }
                                    return UiLoading.loadingDD();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (cityId.toString().isEmpty ||
                                cityIdTujuan.toString().isEmpty ||
                                selectedKurir.isEmpty ||
                                ctrlBerat.text.isEmpty) {
                              UiToast.toastErr("Semua field harus diisi");
                            } else {
                              setState(
                                () {
                                  isLoading = true;
                                },
                              );
                              getCostsData();
                              print("benerr bro");
                            }
                          },
                          child: Text("Cek Estimasi Ongkir"),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),

                  //Flexible untuk nampilin data
                  Flexible(
                    flex: 2,
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: listCosts.isEmpty
                            ? const Align(
                                alignment: Alignment.center,
                                child: Text("Tidak ada data"))
                            : ListView.builder(
                                itemCount: listCosts.length,
                                itemBuilder: (context, index) {
                                  return LazyLoadingList(
                                      initialSizeOfItems: 10,
                                      loadMore: () {},
                                      child: CardOngkir(listCosts[index]),
                                      index: index,
                                      hasMore: true);
                                })),
                  )
                ],
              )),
          isLoading == true ? UiLoading.loading() : Container(),
        ],
      ),
    );
  }
}
