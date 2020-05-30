import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_app/dbHelper/add_data.dart';
import 'package:doctor_appointment_app/dbHelper/search_data.dart';
import 'package:doctor_appointment_app/models/active_appo_model.dart';
import 'package:doctor_appointment_app/models/doktor_model.dart';
import 'package:doctor_appointment_app/models/hospital_model.dart';
import 'package:doctor_appointment_app/models/section_model.dart';
import 'package:doctor_appointment_app/models/user_model.dart';
import 'package:doctor_appointment_app/ui/doctor/show_doctors.dart';
import 'package:doctor_appointment_app/ui/hospital/show_hospitals.dart';
import 'package:doctor_appointment_app/ui/section/show_sections.dart';
import 'package:doctor_appointment_app/ui/show_appointment_times.dart';
import 'package:flutter/material.dart';

class MakeAppointment extends StatefulWidget {
  final User kullanici;
  MakeAppointment(this.kullanici);
  @override
  MakeAppointmentState createState() => MakeAppointmentState(kullanici);
}

class MakeAppointmentState extends State<MakeAppointment> {
  bool control1 = false;

  MakeAppointmentState(this.kullanici);

  bool hastaneSecildiMi = false;
  bool bolumSecildiMi = false;
  bool doktorSecildiMi = false;
  bool tarihSecildiMi = false;
  bool appointmentControl1;
  bool appointmentControl2;

  double drGoruntu = 0.0;
  double goruntu = 0.0;

  Hospital hastane = Hospital();
  Section section = Section();
  Doktor doktor = Doktor();
  User kullanici = User();

  String textMessage = " ";

  var randevuTarihi;
  var raisedButtonText = "Tıkla ve Seç";

  var saatTarihBirlesim;

  double goruntuSaat = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Randevu Al",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 9.0, right: 9.0),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Hastane Seçmek İçin Tıkla"),
                        onPressed: () {
                          bolumSecildiMi = false;
                          doktorSecildiMi = false;
                          tarihSecildiMi = false;
                          hospitalNavigator(BuildHospitalList());
                        },
                      ),
                      SizedBox(height: 13.0),
                      showSelectedHospital(hastaneSecildiMi),
                      SizedBox(
                        height: 30.0,
                      ),
                      RaisedButton(
                        child: Text("Bölüm Seçmek İçin Tıkla"),
                        onPressed: () {
                          if (hastaneSecildiMi) {
                            doktorSecildiMi = false;
                            drGoruntu = 0.0;
                            tarihSecildiMi = false;
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
                        height: 30.0,
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
                      dateOfAppointment(),
                      SizedBox(
                        height: 16.0,
                      ),
                      RaisedButton(
                        child: Text("Randevu Saati Seçmek İçin Tıkla"),
                        onPressed: () {
                          if (randevuTarihi != null &&
                              hastaneSecildiMi &&
                              bolumSecildiMi &&
                              doktorSecildiMi) {
                            basicNavigator(
                              AppointmentTimes(
                                randevuTarihi.toString(),
                                doktor,
                              ),
                            );
                            tarihSecildiMi = true;
                          } else {
                            alrtHospital(context,
                                "Yukarıdaki seçimler tamamlanmadan saat seçimine geçilemez");
                          }
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      showSelectedDate(tarihSecildiMi),
                      SizedBox(
                        height: 16.0,
                      ),
                      _buildDoneButton()
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void hospitalNavigator(dynamic page) async {
    hastane = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (hastane == null) {
      hastaneSecildiMi = false;
    } else {
      hastaneSecildiMi = true;
      alrtAppointmentForFav(context, hastane);
    }
  }

  showSelectedHospital(bool secildiMi) {
    String textMessage = " ";
    if (secildiMi) {
      setState(() {
        textMessage = this.hastane.hastaneAdi.toString();
      });
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
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  void alrtHospital(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text(
        "Uyarı!",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDoctor;
        });
  }

  void sectionNavigator(dynamic page) async {
    section = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (section == null) {
      bolumSecildiMi = false;
    } else {
      bolumSecildiMi = true;
    }
  }

  _showSelectedSection(bool secildiMi) {
    double goruntu = 0.0;

    if (secildiMi) {
      setState(() {
        textMessage = this.section.bolumAdi.toString();
      });
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
        ));
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
    }
  }

  showSelectedDoctor(bool secildiMih) {
    String textMessage = " ";
    if (secildiMih) {
      setState(() {
        textMessage = this.doktor.adi.toString() + " " + this.doktor.soyadi;
      });
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
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2021),
    );
    randevuTarihi = picked;
    saatTarihBirlesim = null;
    tarihSecildiMi = false;
  }

  Widget dateOfAppointment() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          Text(
            "Randevu Tarihi: ",
            style: TextStyle(fontSize: 19.0),
          ),
          RaisedButton(
            child: Text(raisedButtonText),
            onPressed: () {
              _selectDate(context).then((result) => setState(() {
                    if (randevuTarihi == null) {
                      raisedButtonText = "Tıkla ve Seç";
                      tarihSecildiMi = false;
                    } else {
                      raisedButtonText =
                          randevuTarihi.toString().substring(0, 10);
                    }
                  }));
            },
          )
        ],
      ),
    );
  }

  showSelectedDate(bool tarihSecildiMi) {
    String textMessage = " ";
    if (tarihSecildiMi) {
      setState(() {
        textMessage = saatTarihBirlesim.toString();
      });
      goruntuSaat = 1.0;
    } else {
      goruntuSaat = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Randevu Tarih ve Saati : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: goruntuSaat,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    textMessage,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  void basicNavigator(dynamic page) async {
    saatTarihBirlesim = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  void alrtAppointment(BuildContext context) {
    var alertAppointment = AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(5.0, 50.0, 5.0, 50.0),
        title: Text(
          "İşlem Özeti",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Container(
          padding: EdgeInsets.only(bottom: 50.0),
          child: Column(
            children: <Widget>[
              showSelectedHospital(hastaneSecildiMi),
              _showSelectedSection(bolumSecildiMi),
              showSelectedDoctor(doktorSecildiMi),
              showSelectedDate(tarihSecildiMi),
              SizedBox(
                height: 13.0,
              ),
              Container(
                child: FlatButton(
                  child: Text(
                    "Tamam",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                    AddService().addDoctorAppointment(doktor);
                    AddService().addActiveAppointment(
                        doktor, kullanici, saatTarihBirlesim);
                  },
                ),
              ),
            ],
          ),
        ));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertAppointment;
        });
  }

  //fav kısmı
  void alrtAppointmentForFav(BuildContext context, Hospital hastane) {
    if (hastaneSecildiMi) {
      var alertAppointment = AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(5.0, 50.0, 5.0, 50.0),
        title: Text(
          "Hastanenin Popüler Doktorları",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Scaffold(body: _buildStremBuilderForFav(context, hastane)),
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertAppointment;
          });
    }
  }

  _buildStremBuilderForFav(BuildContext context, Hospital hastane) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("tblDoktor")
          .where('hastaneId', isEqualTo: hastane.hastaneId)
          .orderBy('favoriSayaci', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildBodyForFav(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildBodyForFav(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 15.0),
      children: snapshot
          .map<Widget>((data) => _buildListItemForFav(context, data))
          .toList(),
    );
  }

  _buildListItemForFav(BuildContext context, DocumentSnapshot data) {
    final doktor = Doktor.fromSnapshot(data);
    String gonder = (doktor.adi + " " + doktor.soyadi);
    return Padding(
      key: ValueKey(doktor.kimlikNo),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          title: Text(gonder),
          onTap: () {},
        ),
      ),
    );
  }

  _buildDoneButton() {
    return Container(
      child: RaisedButton(
        child: Text("Tamamla"),
        onPressed: () {
          if (hastaneSecildiMi &&
              bolumSecildiMi &&
              doktorSecildiMi &&
              tarihSecildiMi &&
              saatTarihBirlesim != null) {
            SearchService()
                .searchDoctorAppointment(doktor, saatTarihBirlesim)
                .then((QuerySnapshot docs) {
              if (docs.documents.isEmpty) {
                SearchService()
                    .searchActiveAppointmentsByHastaTCKN(kullanici.kimlikNo)
                    .then((QuerySnapshot docs) {
                  if (docs.documents.isNotEmpty) {
                    for (var i = 0; i < docs.documents.length; i++) {
                      ActiveAppointment rand =
                          ActiveAppointment.fromMap(docs.documents[i].data);
                      if (rand.randevuTarihi.contains(saatTarihBirlesim)) {
                        alrtHospital(context,
                            "Aynı gün ve saatte 2 farklı doktordan randevunuz olamaz");
                        break;
                      } else {
                        control1 = true;
                      }
                    }
                  } else {
                    control1 = true;
                  }
                  if (control1) {
                    SearchService()
                        .searchActiveAppointmentsWithHastaTCKNAndDoctorTCKN(
                            kullanici.kimlikNo, doktor.kimlikNo)
                        .then((QuerySnapshot docs) {
                      if (docs.documents.isNotEmpty) {
                        for (var i = 0; i <= docs.documents.length; i++) {
                          ActiveAppointment rand =
                              ActiveAppointment.fromMap(docs.documents[i].data);
                          if (rand.randevuTarihi.contains(
                              randevuTarihi.toString().substring(0, 10))) {
                            alrtHospital(context,
                                "Gün içerisinde aynı doktordan 2 randevunuz olamaz");
                            break;
                          } else {
                            alrtAppointment(context);
                            doktor.randevular.add(saatTarihBirlesim);
                          }
                        }
                      } else {
                        alrtAppointment(context);
                        doktor.randevular.add(saatTarihBirlesim);
                      }
                    });
                  }
                });
              } else {
                alrtHospital(context, "Bu seans dolu");
              }
            });
          } else {
            alrtHospital(context, "Eksik bilgi var");
          }
        },
      ),
    );
  }

  //kullanıcının aynı gün ve saatte başka doktora randevusu olup olmadığını kontrol eder.
  buildAppointmentControl1() {}

  // kullanıcının gün içerisinde aynı doktordan randevusu olup olmadığını kontrol eder.
  buildAppointmentControl2() {}
}
