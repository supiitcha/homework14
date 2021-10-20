import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homework14/service/api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _month = 0;
  int _year = 0;
  var _isLoading = false;
  bool _guessAge = false;

  void guessClickButton() async {
    print("${_year} ${_month} ");
    var data = await _guess();

    if (data == null) return;

    bool value = data["value"];
    String text = data["text"];

    if (value) {
      setState(() {
        _guessAge = true;
      });
    } else {
      _showMaterialDialog('ผลการทาย', text);
    }
  }

  Future<Map<String, dynamic>?> _guess() async {
    try {
      setState(() {
        _isLoading = true;
      });
      var data = (await Api().submit('guess_teacher_age', {'year': _year, 'month': _month})) as Map<String, dynamic>;
      return data;
    } catch (e) {
      print(e);
      _showMaterialDialog('ERROR', e.toString());
      return null;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme.of(context).textTheme.bodyText2),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GUESS TEACHER'S AGE"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.amberAccent.shade200,
        child: Stack(
          children: [
            if(!_guessAge)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'อายุอาจารย์',
                        style: GoogleFonts.lato(fontSize: 30.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 20.0),
                              child: SpinBox(
                                textStyle: GoogleFonts.lato(fontSize: 30.0),
                                min: 0,
                                max: 100,
                                value: 0,
                                onChanged: (value) => setState(() {
                                  _year = value as int;
                                }),
                                decoration: InputDecoration(
                                    labelText: 'ปี',
                                    labelStyle: GoogleFonts.lato(fontSize: 30.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: SpinBox(
                                textStyle: GoogleFonts.lato(fontSize: 30.0),
                                min: 0,
                                max: 11,
                                value: 0,
                                onChanged: (value) => setState(() {
                                  _month = value as int;
                                }),
                                decoration: InputDecoration(
                                  labelText: 'เดือน',
                                  labelStyle: GoogleFonts.lato(fontSize: 30.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: OutlinedButton(
                                onPressed: guessClickButton,
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.amberAccent,
                                ),
                                child: Text("ทาย"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if(_guessAge)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'อายุอาจารย์',
                        style: GoogleFonts.lato(fontSize: 30.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        '${_year} ปี ${_month} เดือน',
                        style: GoogleFonts.lato(fontSize: 24.0),
                      ),
                    ),
                    Icon(
                      Icons.done,
                      color: Colors.green,
                      size: 80.0,
                    ),
                  ],
                ),
              ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: SizedBox(
                    width: 200.0,
                    height: 200.0,
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
