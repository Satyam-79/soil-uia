// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unused_local_variable, unnecessary_import, use_key_in_widget_constructors, deprecated_member_use, unused_import, no_leading_underscores_for_local_identifiers, unused_element, unused_field, use_build_context_synchronously, avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_icons/weather_icons.dart';

late int result;
late String sugestion;

// late String plot;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soil Moisture Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Soil Moisture Prediction App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class MySecondPage extends StatefulWidget {
  @override
  State<MySecondPage> createState() => _MySecondPageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _currentAddress;
  Position? _currentPosition;
  File? selectedImage;
  String? message = "";

  // getlocation() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //   _locationData = await location.getLocation();
  // }
  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location services are disabled. Please enable the services')));
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Location permissions are denied')));
  //       return false;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.')));
  //     return false;
  //   }
  //   return true;
  // }

  // Future<void> _getCurrentPosition() async {
  //   final hasPermission = await _handleLocationPermission();
  //   if (!hasPermission) return;
  //   await Geolocator.getCurrentPosition().then((Position position) {
  //     setState(() => _currentPosition = position);
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  // Future<void> _getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(28.439422, 77.508743)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //     setState(() {
  //       _currentAddress =
  //           '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
  //     });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  uploadImage() async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("http://172.16.2.248:5000/upload"));

    final headers = {"content-type": "multipart/form-data"};

    request.files.add(http.MultipartFile('image',
        selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
        filename: selectedImage!.path.split("/").last));

    // request.fields["Lat"] = "28.439422";
    // request.fields["Lon"] = "77.508743";

    request.headers.addAll(headers);
    final response = await request.send();
    final res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    result = await resJson['prediction'];
    sugestion = await resJson['sugg'];
    // print(result);

    setState(() {});

    _navigateToNextScreen(context);
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MySecondPage()),
    );
  }

  getImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    // ignore: unnecessary_null_comparison
    selectedImage = File(pickedImage!.path);
    setState(() {});
  }

  void clearImage() async {
    selectedImage = null;
    const MyApp();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: selectedImage == null ? 50 : 500,
                width: 500,
                alignment: Alignment.center,
                child: selectedImage == null
                    ? Text("Select an Image to upload")
                    : Image.file(selectedImage!),
              ),
              TextButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () {
                    selectedImage == null ? getImage() : uploadImage();
                  },
                  icon: Icon(
                    Icons.upload_file,
                    color: Colors.white,
                  ),
                  label: Text(
                    selectedImage == null ? "Select" : "Upload",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: (selectedImage == null) ? false : true,
          child: FloatingActionButton(
            onPressed: clearImage,
            child: Icon(Icons.cancel),
          ),
        ));
  }
}

class _MySecondPageState extends State<MySecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Soil Moisture Prediction App')),
        body: Column(children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            height: 130,
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            child: Stack(alignment: Alignment.topCenter, children: <Widget>[
              Text(
                "Soil Moisture Level",
                style: TextStyle(
                    height: 1.5,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              Container(
                margin: EdgeInsets.only(top: 36.0, left: 50, right: 50),
                child: FAProgressBar(
                  animatedDuration: const Duration(milliseconds: 500),
                  size: 60,
                  // changeColorValue: 50,
                  progressColor: result < 25
                      ? Colors.redAccent
                      : result <= 75
                          ? Colors.yellow
                          : Colors.blue,
                  direction: Axis.horizontal,
                  verticalDirection: VerticalDirection.up,
                  currentValue: result * 1.0,
                  maxValue: 100,
                  displayText: '%',
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 100.0),
                child: Text(
                  result < 40
                      ? "Irrigate more! Low Moisture level"
                      : result <= 75
                          ? "The Moisture level is Moderate"
                          : "The Moisture level is High",
                  style: TextStyle(
                    fontSize: 20,
                    color: result < 25
                        ? Colors.redAccent
                        : result <= 75
                            ? Colors.yellow
                            : Colors.blue,
                  ),
                ),
              ),
            ]),
          ),
          Container(
            // margin: EdgeInsets.only(t),
            height: 300,
            width: 300,
            alignment: Alignment.center,
            child: Image.asset("images/plot.jpg"),
          ),
          Container(
              decoration: const BoxDecoration(
                  // color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              alignment: Alignment.center,
              // height: 300,
              // width: 300,
              // margin: EdgeInsets.only(top: 420, left: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(WeatherIcons.thermometer, size: 15),
                  Text("23",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ],
                // alignment: Alignment.center,
                // Row (children:< Widget>[],)
              )),
          Container(
              width: 150,
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(
                    WeatherIcons.night_alt_cloudy,
                    size: 30,
                  ),
                  Text("Cloudy",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              )),
          Container(
              width: 150,
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(
                    WeatherIcons.wind_beaufort_11,
                    size: 15,
                  ),
                  Text("13 kmph",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              )),
          Container(
              width: 150,
              margin: EdgeInsets.only(top: 15),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(
                    WeatherIcons.humidity,
                    size: 30,
                  ),
                  Text("17%",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              )),
          Container(
            margin: EdgeInsets.only(top: 25),
            width: 400,
            height: 60,
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            alignment: Alignment.center,
            child: Text(
              sugestion,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          )
        ]),
        floatingActionButton: Visibility(
          visible: true,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.cancel),
          ),
        ));
  }
}
