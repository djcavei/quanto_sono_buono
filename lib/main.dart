import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quanto_sono_buono/formatters/decimal_number_regex_input_formatter.dart';
import 'package:quanto_sono_buono/models/goods_bag.dart';
import 'package:quanto_sono_buono/persistence/db.dart';
import 'package:quanto_sono_buono/persistence/goods_meal_entity.dart';
import 'package:quanto_sono_buono/widgets/goods_meal_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quanto sono buono',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),
        textTheme: GoogleFonts.titilliumWebTextTheme(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Quanto sono buono Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final DatabaseOperations? dbOp = DatabaseOperations.instance;
  final maxNumGoodsMeal = 4;
  final List<GestureDetector> _goodsMealWidgets = [];
  final List<GlobalKey<GoodsMealWidgetState>> _keys = [];
  double _amount = 0;
  final TextEditingController _controller = TextEditingController();
  final DecimalNumberRegexInputFormatter _totalAmountMealValueFormatter =
      DecimalNumberRegexInputFormatter.ofTotalAmount();

  @override
  void initState() {
    super.initState();
    _retrieveGoodsMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Importo spesa",
                          style: TextStyle(fontSize: 18)),
                      ElevatedButton(
                          onPressed: () => _insertAmountDialog(context),
                          child: Text(
                            "$_amount €",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ))
                    ],
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      fixedSize:
                          MaterialStateProperty.all(const Size(100, 50))),
                  onPressed: _calculate,
                  child: const Text(
                    "Calcola!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          )
        ],
        appBar: AppBar(
          leading: IconButton(
            highlightColor:
                _goodsMealWidgets.length < 5 ? null : Colors.transparent,
            style: _setAddButtonStyle(),
            tooltip: "Aggiungi nuovo buono",
            icon: const Icon(Icons.add),
            onPressed: () => setState(() {
              _addNewGoodsMealWidget();
            }),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 5,
          shadowColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: const Text("Quanto sono buono"),
        ),
        body: Column(children: _goodsMealWidgets));
  }

  void _addNewGoodsMealWidget() {
    if (_goodsMealWidgets.length < maxNumGoodsMeal) {
      GlobalKey<GoodsMealWidgetState> globalKey = GlobalKey();
      _keys.add(globalKey);
      _goodsMealWidgets.add(GestureDetector(
          key: UniqueKey(),
          onLongPress: () => _removeGoodsMealDialog(globalKey),
          child: GoodsMealWidget(
              alreadyPresentCallback: _checkIfAlreadyPresent,
              saveCallback: _saveData,
              key: globalKey)));
    } else {
      Fluttertoast.showToast(
          msg: "Non sei così buono...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void _removeGoodsMealDialog(Key uniqueKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Elimina buono?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Torna Indietro'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: () {
                setState(() {
                  _goodsMealWidgets.removeWhere((element) =>
                      uniqueKey == ((element.child!) as GoodsMealWidget).key);
                  _keys.removeWhere((key) => uniqueKey == key);
                  deleteGoodsMealFromDb(
                      (uniqueKey as GlobalKey<GoodsMealWidgetState>)
                          .currentState!
                          .val);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );
  }

  ButtonStyle? _setAddButtonStyle() {
    MaterialStateProperty<Color?>? enabledOrDisabled(bool enabled) {
      return enabled ? null : MaterialStateProperty.all(Colors.black38);
    }

    return ButtonStyle(
        iconSize: MaterialStateProperty.all(35),
        iconColor: enabledOrDisabled(_goodsMealWidgets.length < 5));
  }

  void _insertAmountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Inserisci importo'),
          content: TextField(
            controller: _controller,
            inputFormatters: [_totalAmountMealValueFormatter],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {
                setState(() {
                  _amount = double.parse(_controller.text);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Conferma',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _calculate() {
    double bestDiff = _amount;
    List<GoodsBag> bestCombo = [];
    List<GoodsBag> myGoodsBag = _keys
        .map((e) => GoodsBag(
            value: double.parse(e.currentState!.val),
            quantity: int.parse(e.currentState!.qty)))
        .toList();

    void calculateRec(int idx, double expense, List<GoodsBag> currentBag) {
      if (expense <= _amount && _amount - expense < bestDiff) {
        bestDiff = _amount - expense;
        bestCombo = currentBag.map((e) => e.clone()).toList();
      }
      if (idx < myGoodsBag.length && expense <= _amount) {
        if (myGoodsBag[idx].quantity > currentBag[idx].quantity) {
          ++currentBag[idx].quantity;
          calculateRec(idx, expense + myGoodsBag[idx].value, currentBag);
          --currentBag[idx].quantity;
        }
        calculateRec(idx + 1, expense, currentBag);
      }
    }

    calculateRec(0, 0,
        myGoodsBag.map((e) => GoodsBag(value: e.value, quantity: 0)).toList());

    _showBestComboDialog(context, bestCombo, bestDiff);
  }

  void _showBestComboDialog(
      BuildContext context, List<GoodsBag> bestCombo, double remainingAmount) {
    List<Padding> bestComboToText() {
      var rowList = bestCombo
          .where((element) => element.quantity > 0)
          .map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(children: [
                Text('${e.quantity} buoni da ${e.value}€',
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ])))
          .toList();
      rowList.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(children: [
            Text('Restano da pagare $remainingAmount €',
                style: const TextStyle(fontWeight: FontWeight.bold))
          ])));
      return rowList;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Miglior combinazione'),
          children: bestComboToText(),
        );
      },
    );
  }

  bool _checkIfAlreadyPresent(String value) {
    return _keys
        .where((element) => element.currentState!.val == value)
        .isNotEmpty;
  }

  void _saveData(String qty, String value, String? oldValue) {
    if (value != "0") {
      Future<void> insertGoodsMeal(GoodsMealEntity goodsMealEntity) async {
        await dbOp!.openDb();
        await dbOp!.database!.insert(
          'goods_meal',
          goodsMealEntity.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      if (oldValue != null) {
        deleteGoodsMealFromDb(oldValue);
      }
      insertGoodsMeal(
          GoodsMealEntity(qty: int.parse(qty), val: double.parse(value)));
    }
  }

  void deleteGoodsMealFromDb(String value) async {
    await dbOp!.openDb();
    Future<void> deleteGoodsMeal(String value) async {
      await dbOp!.database!.delete('goods_meal',
          where: 'value = ?', whereArgs: [double.parse(value)]);
    }

    deleteGoodsMeal(value);
  }

  void _retrieveGoodsMeals() async {
    await dbOp!.openDb();
    Future<List<GoodsMealEntity>> goodsMeals() async {
      final List<Map<String, dynamic>> maps =
          await dbOp!.database!.query('goods_meal');

      return List.generate(maps.length, (i) {
        return GoodsMealEntity(
          qty: maps[i]['qty'] as int,
          val: maps[i]['value'] as double,
        );
      });
    }

    var goodsMealList = await goodsMeals();
    setState(() {
      for (int i = 0; i < goodsMealList.length; ++i) {
        _addNewGoodsMealWidget();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        for (int i = 0; i < goodsMealList.length; ++i) {
          _keys[i].currentState!.value("${goodsMealList[i].value}");
          _keys[i]
              .currentState!
              .quantityDropdownButton("${goodsMealList[i].qty}");
        }
      });
    });
  }
}

typedef SaveDataCallback = void Function(
    String qty, String value, String? oldValue);
typedef CheckDataCallback = bool Function(String value);
