import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notlar_uygulamasi/NotDetaySayfa.dart';
import 'package:notlar_uygulamasi/NotKayitSayfa.dart';
import 'package:notlar_uygulamasi/Notlar.dart';
import 'package:notlar_uygulamasi/Notlardao.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Not Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  Future<List<Notlar>> tumNotlarGoster() async {
    List notlarListesi = await Notlardao().tumNotlar();
    return notlarListesi;
  }

  Future<bool> uygulamayiKapat() async {
    await exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.cancel,
            size: 35,
            color: Colors.white,
          ),
          onPressed: () => uygulamayiKapat(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Notlar Uygulamasi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            FutureBuilder(
              future: tumNotlarGoster(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var notlarListesi = snapshot.data;
                  double ortalama = 0;
                  if (!notlarListesi.isEmpty) {
                    double toplam = 0.0;
                    for (var not in notlarListesi) {
                      toplam += (not.not_1 + not.not_2) / 2;
                    }
                    ortalama = toplam / notlarListesi.length;
                  }
                  return Text(
                    "Ortalama : ${ortalama.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  );
                } else {
                  return Text(
                    "Ortalama : 0",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: uygulamayiKapat,
        child: FutureBuilder<List<Notlar>>(
          future: tumNotlarGoster(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var notlarListesi = snapshot.data;
              return ListView.builder(
                itemCount: notlarListesi.length,
                itemBuilder: (context, i) {
                  var not = notlarListesi[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotDetaySayfa(
                            not: not,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              not.ders_adi,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(not.not_1.toString()),
                            Text(not.not_2.toString())
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NotKayitSayfa()));
        },
        tooltip: 'Not Ekle',
        child: Icon(Icons.add),
      ),
    );
  }
}
