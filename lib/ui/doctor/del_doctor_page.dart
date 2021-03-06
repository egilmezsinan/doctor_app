import 'package:doctor_appointment_app/dbHelper/del_data.dart';
import 'package:doctor_appointment_app/models/doktor_model.dart';
import 'package:doctor_appointment_app/models/hospital_model.dart';
import 'package:doctor_appointment_app/models/section_model.dart';
import 'package:doctor_appointment_app/ui/doctor/show_doctors.dart';
import 'package:doctor_appointment_app/ui/hospital/show_hospitals.dart';
import 'package:doctor_appointment_app/ui/section/show_sections.dart';
import 'package:flutter/material.dart';

class DeleteDoctor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DeleteDoctorState();
  }
}

class DeleteDoctorState extends State {
  Hospital hastane = Hospital();
  Section section = Section();
  Doktor doktor = Doktor();
  double goruntu = 0.0;
  double drGoruntu = 0.0;
  bool hastaneSecildiMi = false;
  bool bolumSecildiMi = false;
  bool doktorSecildiMi = false;
  String textMessage = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Doktor Silme Ekranı",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Hastane Seçmek İçin Tıkla"),
                      onPressed: () {
                        bolumSecildiMi = false;
                        doktorSecildiMi = false;
                        hospitalNavigator(BuildHospitalList());
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    showSelectedHospital(hastaneSecildiMi),
                    SizedBox(
                      height: 16.0,
                    ),
                    RaisedButton(
                      child: Text("Bölüm Seçmek İçin Tıkla"),
                      onPressed: () {
                        if (hastaneSecildiMi) {
                          doktorSecildiMi = false;
                          sectionNavigator(BuildSectionList(hastane));
                        } else {
                          alrtHospital(
                              context, "Hastane seçmeden bölüm seçemezsiniz");
                        }
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    _showSelectedSection(bolumSecildiMi),
                    SizedBox(
                      height: 16.0,
                    ),
                    RaisedButton(
                      child: Text("Doktor Seçmek İçin Tıkla"),
                      onPressed: () {
                        if (hastaneSecildiMi && bolumSecildiMi) {
                          doctorNavigator(BuildDoctorList(section, hastane));
                        } else {
                          alrtHospital(context,
                              "Hastane ve bölüm seçmeden doktor seçemezsiniz");
                        }
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    showSelectedDoctor(doktorSecildiMi),
                    SizedBox(
                      height: 25.0,
                    ),
                    _silButonu()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void alrtHospital(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text("Uyarı!"),
      content: Text(message),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDoctor;
      },
    );
  }

  void hospitalNavigator(dynamic page) async {
    hastane = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (hastane == null) {
      hastaneSecildiMi = false;
    } else {
      hastaneSecildiMi = true;
      setState(() {});
    }
  }

  void sectionNavigator(dynamic page) async {
    section = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (section == null) {
      bolumSecildiMi = false;
    } else {
      bolumSecildiMi = true;
      setState(() {});
    }
  }

  showSelectedHospital(bool secildiMi) {
    String textMessage = " ";
    if (secildiMi) {
      setState(
        () {
          textMessage = this.hastane.hastaneAdi.toString();
        },
      );
      goruntu = 1.0;
    } else {
      goruntu = 0.0;
    }

    return Container(
      decoration: BoxDecoration(),
      child: Row(
        children: <Widget>[
          Text(
            "Seçilen Hastane : ",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Opacity(
              opacity: goruntu,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  textMessage,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ))
        ],
      ),
    );
  }

  _showSelectedSection(bool secildiMi) {
    double goruntu = 0.0;

    if (secildiMi) {
      setState(
        () {
          textMessage = this.section.bolumAdi.toString();
        },
      );
      goruntu = 1.0;
    } else {
      goruntu = 0.0;
    }

    return Container(
      decoration: BoxDecoration(),
      child: Row(
        children: <Widget>[
          Text(
            "Seçilen Bölüm : ",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Opacity(
              opacity: goruntu,
              child: Container(
                  alignment: Alignment.center,
                  child: _buildTextMessage(textMessage)))
        ],
      ),
    );
  }

  _buildTextMessage(String gelenText) {
    return Text(
      textMessage,
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }

  void doctorNavigator(dynamic page) async {
    doktor = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (doktor == null) {
      doktorSecildiMi = false;
    } else {
      doktorSecildiMi = true;
      setState(() {});
    }
  }

  showSelectedDoctor(bool secildiMih) {
    String textMessage = " ";
    if (secildiMih) {
      setState(
        () {
          textMessage = this.doktor.adi.toString() + " " + this.doktor.soyadi;
        },
      );
      drGoruntu = 1.0;
    } else {
      drGoruntu = 0.0;
    }

    return Container(
      decoration: BoxDecoration(),
      child: Row(
        children: <Widget>[
          Text(
            "Seçilen Doktor : ",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Opacity(
            opacity: goruntu,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                textMessage,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  _silButonu() {
    return Container(
      child: RaisedButton(
        child: Text(
          "Seçili Doktoru Sil",
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          if (hastaneSecildiMi && bolumSecildiMi && doktorSecildiMi) {
            DelService().deleteDoctorbyTCKN(doktor);
            Navigator.pop(context, true);
          } else {
            alrtHospital(context, "Eksik bilgi var");
          }
        },
      ),
    );
  }
}
