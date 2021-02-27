import 'package:flutter/material.dart';
import 'package:notlar_uygulamasi/Notlar.dart';
import 'package:notlar_uygulamasi/Notlardao.dart';
import 'package:notlar_uygulamasi/main.dart';

class NotDetaySayfa extends StatefulWidget {
  Notlar not;
  NotDetaySayfa({this.not});
  @override
  _NotDetaySayfaState createState() => _NotDetaySayfaState();
}

class _NotDetaySayfaState extends State<NotDetaySayfa> {
  var tfDersAdi = TextEditingController();
  var tfNot1 = TextEditingController();
  var tfNot2 = TextEditingController();

  Future<void> sil(int notId) async {
    await Notlardao().notSil(notId);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));
  }

  Future<void> guncelle(int notId, String ders_adi, int not1, int not2) async {
    await Notlardao().notGuncelle(notId, ders_adi, not1, not2);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));
  }

  @override
  void initState() {
    super.initState();
    tfDersAdi.text = widget.not.ders_adi;
    tfNot1.text = widget.not.not_1.toString();
    tfNot2.text = widget.not.not_2.toString();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Not Detay"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_rounded,
              color: Colors.red,
              size: 28,
            ),
            onPressed: () {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text(widget.not.ders_adi),
                  content: Text("Bu dersi silmek istediğinizden emin misiniz ?"),
                  actions: [
                    FlatButton(
                      child: Text(
                        "HAYIR",
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "EVET",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        sil(widget.not.not_id);
                      },
                    )
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.deepPurpleAccent,
              size: 28,
            ),
            onPressed: () {
              if (formKey.currentState.validate()) {
                guncelle(
                  widget.not.not_id,
                  tfDersAdi.text,
                  int.parse(tfNot1.text),
                  int.parse(tfNot2.text),
                );
              }
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  controller: tfDersAdi,
                  decoration: InputDecoration(hintText: "Ders Adı"),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Ders adı boş olamaz";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: tfNot1,
                  decoration: InputDecoration(hintText: "Not 1"),
                  keyboardType: TextInputType.number,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Not 1 boş olamaz";
                    } else if (int.tryParse(text) == null) {
                      return "Lütfen not 1 için sayı giriniz";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: tfNot2,
                  decoration: InputDecoration(hintText: "Not 2"),
                  keyboardType: TextInputType.number,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Not 2 boş olamaz";
                    } else if (int.tryParse(text) == null) {
                      return "Lütfen not 2 için sayı giriniz";
                    } else {
                      return null;
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
