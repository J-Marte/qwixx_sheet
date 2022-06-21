
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quixx/UI/number_tick.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Color> colors = [
    Colors.red,
    Colors.yellow[700]!,
    Colors.green,
    Colors.blue,
  ];
  
  final List<Color?> backgroundColors = [
    Colors.red[100],
    Colors.yellow[100],
    Colors.green[100],
    Colors.blue[100],
  ];

  final Map<int, int> crossToPoint = {
    1: 1,
    2: 3,
    3: 6,
    4: 10,
    5: 15,
    6: 21,
    7: 28,
    8: 36,
    9: 45,
    10: 55,
    11: 66,
    12: 78,
  };

  final List<List<bool>> values = List<List<bool>>.generate(4, (index) => List<bool>.generate(12, (index) => false));
  final List<bool> wrongRolls = List<bool>.generate(4, (index) => false);

  int countCrosses(int row){
    int erg = 0;

    for (int i = 0; i < values[row].length; i++){
      if(values[row][i]) erg++;
    }

    return erg;
  }

  bool isEnabled(int row, int column){
    for (int i = column + 1; i < values[row].length; i++){
      if(values[row][i]) {
        return false;
      }
    }
    return true;
  }

  int getPoints(){
    int erg = 0;
    for (int i = 0; i < 4; i++) {
      int? temp = crossToPoint[countCrosses(i)];
      if (temp != null) erg += temp;
    }

    for (int i = 0; i < wrongRolls.length; i++){
      if(wrongRolls[i]) erg -= 5;
    }

    return erg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Text(widget.title),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 15),
            alignment: Alignment.center,
            child: Text("Punkte: ${getPoints()}", style: const TextStyle(
              fontSize: 24,
            ),)
          )
        ],
      ),
      body: Column(
        children: [
          for (int i = 0; i < colors.length; i++)
            Container(
              decoration: BoxDecoration(
                color: colors[i],
                borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
              margin: const EdgeInsets.only(right: 6, top: 3, bottom: 3, left: 15),
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  for (int j = 1; j < 12; j++)
                    Expanded(child: NumberTick(color: colors[i], backgroundColor: backgroundColors[i]!, number: i < 2 ? (j + 1) : (13 - j), enabled: isEnabled(i, j - 1), value: values[i][j-1], onClick: (b) {
                      setState(() {
                        values[i][j-1] = b;
                      });
                    },)),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        if (countCrosses(i) > 4) {
                          setState(() {
                            values[i][11]= !values[i][11];
                          });
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text("Es müssen mindestens 4 Kreuzte in einer Reihe sein um diese Abzuschließen"),
                          ));
                        }
                      },
                      child: FractionallySizedBox(
                        widthFactor: 0.7,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipOval(
                            child: Container(
                              color: backgroundColors[i],
                              child: Transform.rotate(
                                angle: values[i][11] ? 0 : pi/4,
                                child: Icon(values[i][11] ? Icons.lock_outline_rounded : Icons.lock_open_outlined, color: colors[i],)
                              ),
                            )
                          )
                        )
                      )
                    )
                  ),
                ],
              )
            ),
          Expanded(child: 
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6, right: 3, top: 3, bottom: 6), 
                child: IntrinsicWidth(child: Column(
                  children: [
                    Expanded(child: Container(alignment: Alignment.center, child: const Text("Kreuze", style: TextStyle(fontSize: 20)))),
                    const Divider(color: Colors.black, thickness: 1),
                    Expanded(child: Container(alignment: Alignment.center, child: const Text("Punkte", style: TextStyle(fontSize: 20)))),
                  ],
                )),
              ),
              for (MapEntry e in crossToPoint.entries)
                Expanded(child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  margin: const EdgeInsets.only(left: 6, right: 1, top: 1, bottom: 6), 
                  child: IntrinsicWidth(child: Column(
                    children: [
                      Expanded(child: Container(alignment: Alignment.center, child: Text("${e.key}x", style: const TextStyle(fontSize: 18)))),
                      const Divider(color: Colors.black, thickness: 1),
                      Expanded(child: Container(alignment: Alignment.center, child: Text(e.value.toString(), style: const TextStyle(fontSize: 18)))),
                    ],
                  )),
                )),
              Padding(
                padding: const EdgeInsets.only(right: 6, left: 3, top: 3, bottom: 6), 
                child: IntrinsicWidth(child: Column(
                  children: [
                    Expanded(child: Container(alignment: Alignment.center, child: const Text("Fehlwürfe je -5", style: TextStyle(fontSize: 18)))),
                    Row(
                      children: [
                        for(int i = 0; i < wrongRolls.length; i++)
                          Checkbox(
                            value: wrongRolls[i],
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            onChanged: (b) { 
                              setState(() {
                                  wrongRolls[i] = b == true;
                              });
                           },
                          ),
                      ],
                    )
                  ],
                )),
              ),
            ],
          ))
        ],
      )
    );
  }
}
