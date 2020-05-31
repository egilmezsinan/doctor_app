import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_app/models/active_appo_model.dart';
import 'package:doctor_appointment_app/models/doktor_model.dart';
import 'package:doctor_appointment_app/models/fav_list_model.dart';
import 'package:doctor_appointment_app/models/hospital_model.dart';
import 'package:doctor_appointment_app/models/section_model.dart';

class DelService {
  ActiveAppointment activeAppointment = ActiveAppointment();

  // This method delete a doctor also her/his active appoit
  deleteDoctorbyTCKN(Doktor doktor) {
    Firestore.instance
        .collection("tblDoktor")
        .document(doktor.reference.documentID)
        .delete();
    Firestore.instance
        .collection("tblAktifRandevu")
        .where('doktorTCKN', isEqualTo: doktor.kimlikNo)
        .getDocuments()
        .then(
      (QuerySnapshot docs) {
        if (docs.documents.isNotEmpty) {
          for (var i = 0; i < docs.documents.length; i++) {
            Firestore.instance
                .collection("tblAktifRandevu")
                .document(docs.documents[i].reference.documentID)
                .delete();
          }
        }
      },
    );
  }

  deleteActiveAppointment(ActiveAppointment randevu) {
    Firestore.instance
        .collection('tblAktifRandevu')
        .document(randevu.reference.documentID)
        .delete();
  }

  deleteDocFromUserFavList(FavoriteList fav) {
    Firestore.instance
        .collection('tblFavoriler')
        .document(fav.reference.documentID)
        .delete();
  }

  deleteSectionBySectionId(Section bolum, var referans) {
    Firestore.instance
        .collection("tblBolum")
        .document(referans.documentID)
        .delete();
    Firestore.instance
        .collection("tblDoktor")
        .where('bolumId', isEqualTo: bolum.bolumId)
        .getDocuments()
        .then(
      (QuerySnapshot docs) {
        if (docs.documents.isNotEmpty) {
          for (var i = 0; i < docs.documents.length; i++) {
            Firestore.instance
                .collection("tblAktifRandevu")
                .where('doktorTCKN', isEqualTo: docs.documents[i]['kimlikNo'])
                .getDocuments()
                .then(
              (QuerySnapshot docs) {
                if (docs.documents.isNotEmpty) {
                  for (var i = 0; i < docs.documents.length; i++) {
                    Firestore.instance
                        .collection("tblAktifRandevu")
                        .document(docs.documents[i].reference.documentID)
                        .delete();
                  }
                }
              },
            );
            Firestore.instance
                .collection("tblDoktor")
                .document(docs.documents[i].reference.documentID)
                .delete();
          }
        }
      },
    );
  }

  deleteHospitalById(Hospital hastane) {
    Section section = Section();
    Firestore.instance
        .collection("tblBolum")
        .where('hastaneId', isEqualTo: hastane.hastaneId)
        .getDocuments()
        .then(
      (QuerySnapshot docs) {
        for (var i = 0; i < docs.documents.length; i++) {
          section = Section.fromMap(docs.documents[i].data);
          deleteSectionBySectionId(section, docs.documents[i].reference);
        }
      },
    );
    Firestore.instance
        .collection("tblHastane")
        .document(hastane.reference.documentID)
        .delete();
  }
}
