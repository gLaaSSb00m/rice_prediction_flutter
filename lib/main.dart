import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rice Prediction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  String _prediction = 'No prediction yet';
  double _confidence = 0.0;
  String _riceInfo = '';
  Interpreter? _interpreter;
  bool _isLoading = false;
  String _errorMessage = '';
  String _modelPath = '';
  List<String> _riceClasses = [];
  List<Map<String, dynamic>> _riceInfos = [];

  final List<String> _defaultRiceClasses = [
    "10_Lal_Aush","11_Jirashail","12_Gutisharna","13_Red_Cargo","14_Najirshail",
    "15_Katari_Polao","16_Lal_Biroi","17_Chinigura_Polao","18_Amondhan","19_Shorna5",
    "1_Subol_Lota","20_Lal_Binni","21_Arborio","22_Turkish_Basmati","23_Ipsala",
    "24_Jasmine","25_Karacadag","26_BD30","27_BD33","28_BD39","29_BD49",
    "2_Bashmoti","30_BD51","31_BD52","32_BD56","33_BD57","34_BD70","35_BD72",
    "36_BD75","37_BD76","38_BD79","39_BD85","3_Ganjiya","40_BD87","41_BD91",
    "42_BD93","43_BD95","44_Binadhan7","45_Binadhan8","46_Binadhan10","47_Binadhan11",
    "48_Binadhan12","49_Binadhan14","4_Shampakatari","50_Binadhan16","51_Binadhan17",
    "52_Binadhan19","53_Binadhan21","54_Binadhan23","55_Binadhan24","56_Binadhan25",
    "57_Binadhan26","58_BR22","59_BR23","5_Katarivog","60_BRRI67","61_BRRI74",
    "62_BRRI102","6_BR28","7_BR29","8_Paijam","9_Bashful"
  ];

  @override
  void initState() {
    super.initState();
    _syncData();
  }

  Future<void> _syncData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await _downloadModel();
      await _downloadRiceInfo();
    }
    await _loadLocalData();
  }

  Future<void> _downloadModel() async {
    const baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_model/'));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/rice_model.tflite');
        await file.writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _downloadRiceInfo() async {
    const baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_rice_info/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final riceInfos = data['rice_infos'] as List;
        final classes = riceInfos.map((info) => info['variety_name'] as String).toList();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('rice_classes', classes);
        await prefs.setString('rice_infos', jsonEncode(riceInfos));
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    _riceClasses = prefs.getStringList('rice_classes') ?? _defaultRiceClasses;

    final riceInfosJson = prefs.getString('rice_infos');
    if (riceInfosJson != null) {
      final decoded = jsonDecode(riceInfosJson) as List;
      _riceInfos = decoded.map((item) => item as Map<String, dynamic>).toList();
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/rice_model.tflite');
    if (await file.exists()) {
      _modelPath = file.path;
    } else {
      _modelPath = 'assets/rice_model.tflite';
    }
    await _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      if (_modelPath.startsWith('assets/')) {
        _interpreter = await Interpreter.fromAsset(_modelPath);
      } else {
        _interpreter = await Interpreter.fromFile(File(_modelPath));
      }
      _interpreter!.resizeInputTensor(0, [1, 224, 224, 3]);
      _interpreter!.allocateTensors();
      // Model loaded successfully
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load model: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      setState(() {
        _errorMessage = '';
      });

      var status = await Permission.photos.status;
      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
          await _predict();
        } else {
          setState(() {
            _errorMessage = 'No image selected.';
          });
        }
      } else {
        status = await Permission.photos.request();
        if (status.isGranted) {
          final picker = ImagePicker();
          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            setState(() {
              _image = File(pickedFile.path);
            });
            await _predict();
          } else {
            setState(() {
              _errorMessage = 'No image selected.';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Permission denied. Please grant photo access.';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking image: $e';
      });
    }
  }

  Future<void> _predict() async {
    if (_interpreter == null || _image == null) return;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Preprocess image
      final imageBytes = await _image!.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      final resizedImage = img.copyResize(image, width: 224, height: 224);
      final input = _imageToByteList(resizedImage);

      // Run inference
      var inputTensor = _interpreter!.getInputTensor(0);
      inputTensor.data = input.buffer.asUint8List();
      _interpreter!.invoke();
      var outputTensor = _interpreter!.getOutputTensor(0);
      final predictions = outputTensor.data.buffer.asFloat32List();
      final maxIndex = predictions.indexWhere((element) => element == predictions.reduce((a, b) => a > b ? a : b));
      final predictedClass = _riceClasses[maxIndex];
      final confidence = predictions[maxIndex] * 100;

      // Get rice info
      final riceInfoItem = _riceInfos.firstWhere(
        (info) => info['variety_name'] == predictedClass,
        orElse: () => {'info': 'Information not available.'},
      );
      final riceInfo = riceInfoItem['info'] as String;

      setState(() {
        _prediction = predictedClass;
        _confidence = confidence;
        _riceInfo = riceInfo;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Prediction failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Float32List _imageToByteList(img.Image image) {
    final Float32List result = Float32List(1 * 224 * 224 * 3);
    int bufferIndex = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toDouble() / 255.0;
        final g = pixel.g.toDouble() / 255.0;
        final b = pixel.b.toDouble() / 255.0;

        result[bufferIndex++] = r;
        result[bufferIndex++] = g;
        result[bufferIndex++] = b;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rice Variety Prediction'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Select a rice image to predict its variety',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _image == null
                          ? Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.image,
                                size: 64,
                                color: Colors.grey,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(_image!, height: 200, fit: BoxFit.cover),
                            ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _pickImage,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Select Image'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_errorMessage.isNotEmpty)
                Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else if (_prediction != 'No prediction yet')
                Card(
                  elevation: 4,
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Prediction Result',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Variety: $_prediction',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Info: $_riceInfo',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}
