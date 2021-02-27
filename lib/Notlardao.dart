import 'package:notlar_uygulamasi/Notlar.dart';
import 'package:notlar_uygulamasi/VeritabaniYardimcisi.dart';

class Notlardao {
  Future<List<Notlar>> tumNotlar() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM notlar");

    return List.generate(maps.length, (i) {
      var satir = maps[i];

      return Notlar(
        satir["not_id"],
        satir["ders_adi"],
        satir["not1"],
        satir["not2"],
      );
    });
  }

  Future<List<Notlar>> notEkle(String ders_adi, int not1, int not2) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    var bilgiler = Map<String, dynamic>();
    bilgiler["ders_adi"] = ders_adi;
    bilgiler["not1"] = not1;
    bilgiler["not2"] = not2;

    await db.insert("notlar", bilgiler);
  }

  Future<List<Notlar>> notGuncelle(int not_id, String ders_adi, int not1, int not2) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    var bilgiler = Map<String, dynamic>();
    bilgiler["ders_adi"] = ders_adi;
    bilgiler["not1"] = not1;
    bilgiler["not2"] = not2;

    await db.update("notlar", bilgiler, where: "not_id=?", whereArgs: [not_id]);
  }

  Future<List<Notlar>> notSil(int not_id) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    await db.delete("notlar", where: "not_id=?", whereArgs: [not_id]);
  }
}
