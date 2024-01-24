import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quanto_sono_buono/formatters/decimal_number_regex_input_formatter.dart';
import 'package:quanto_sono_buono/models/goods_bag.dart';
import 'package:quanto_sono_buono/widgets/goods_meal_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
  final List<GestureDetector> _goodsMealWidgets = [];

  GoodsBag seven = GoodsBag(value: 7, quantity: 0);
  GoodsBag fourFive = GoodsBag(value: 4.5, quantity: 0);
  double amount = 0;
  final DecimalNumberRegexInputFormatter _decimalNumberRegexInputFormatter =
      DecimalNumberRegexInputFormatter();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _increment7Goods() {
    setState(() {
      if (seven.quantity < 20) {
        ++seven.quantity;
      }
    });
    _saveData();
  }

  void _decrement7Goods() {
    setState(() {
      if (seven.quantity > 0) {
        --seven.quantity;
      }
    });
    _saveData();
  }

  void _increment4_5Goods() {
    setState(() {
      if (fourFive.quantity < 20) {
        ++fourFive.quantity;
      }
    });
    _saveData();
  }

  void _decrement4_5Goods() {
    setState(() {
      if (fourFive.quantity > 0) {
        --fourFive.quantity;
      }
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            throw UnimplementedError();
          }),
          tooltip: "Calcola",
          child: const Icon(Icons.calculate),
        ),
        appBar: AppBar(
          leading: IconButton(
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

  void _loadData() async {
    var sp = await SharedPreferences.getInstance();
    setState(() {
      seven.quantity = sp.getInt('qty_seven') ?? 0;
      fourFive.quantity = sp.getInt('qty_fourFive') ?? 0;
    });
  }

  void _saveData() async {
    var sp = await SharedPreferences.getInstance();
    sp.setInt('qty_seven', seven.quantity);
    sp.setInt('qty_fourFive', fourFive.quantity);
    _loadData();
  }

  void _addNewGoodsMealWidget() {
    _goodsMealWidgets.add(GestureDetector(
        onLongPress: _removeGoodsMealDialog, child: GoodsMealWidget(index: _goodsMealWidgets.length)));
  }

  void _removeGoodsMealDialog() {
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
                  _goodsMealWidgets.removeWhere((gestureDetector) =>  (gestureDetector.child! as GoodsMealWidget).index == )
                  _goodsMealWidgets.remo
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

}
