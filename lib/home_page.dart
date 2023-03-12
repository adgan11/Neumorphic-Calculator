import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

var result = 0.0;
var solution = "";

class _HomePageState extends State<HomePage> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    refresh() {
      darkMode = !darkMode;
      setState(() {});
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: darkMode ? Colors.black : Colors.white,
      ),
      home: CalculatorPage(
        darkMode: darkMode,
        refreshParent: refresh,
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  CalculatorPage({
    super.key,
    required this.darkMode,
    required this.refreshParent,
  });

  bool darkMode;
  Function refreshParent;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.darkMode ? Colors.black : Colors.white,
        foregroundColor: widget.darkMode ? Colors.white : Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            widget.refreshParent();
          },
          icon: Icon(
            widget.darkMode ? Icons.light_mode : Icons.dark_mode,
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(24.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  solution,
                  style: TextStyle(
                    color: widget.darkMode ? Colors.white : Colors.black,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(color: Colors.grey, thickness: 2),
              SizedBox(
                height: MediaQuery.of(context).size.height / 45,
              ),
              Row(
                children: [
                  ...getTextCustomRow("AC"),
                  ...getTextCustomRow("x"),
                  ...getTextCustomRow("+/-"),
                  ...getTextCustomRow("/"),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 45,
              ),
              Row(
                children: [
                  ...getTextNumberRow(1, Colors.grey),
                  ...getTextCustomRow("X"),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 45,
              ),
              Row(
                children: [
                  ...getTextNumberRow(4, Colors.grey),
                  ...getTextCustomRow("-"),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 45,
              ),
              Row(
                children: [
                  ...getTextNumberRow(7, Colors.grey),
                  ...getTextCustomRow("+")
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 45,
              ),
              Row(
                children: [
                  ...getTextCustomRow("%"),
                  ...getTextCustomRow("0"),
                  ...getTextCustomRow("."),
                  ...getTextCustomRow("=")
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getTextNumberRow(iVal, buttonColor) {
    List<Widget> childs = [];
    refresh() {
      setState(() {});
    }

    for (var i = iVal; i < iVal + 3; i++) {
      if (!i.isNegative) {
        childs.add(
          Center(
            child: Row(
              children: [
                NeuButton(
                  notifyParent: refresh,
                  solveEquations: solveEquations,
                  darkMode: widget.darkMode,
                  buttonBGcolor: widget.darkMode ? Colors.black : Colors.white,
                  buttonFGcolor: Colors.blue,
                  buttonVal: i.toString(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 17,
                ),
              ],
            ),
          ),
        );
      }
    }

    return childs;
  }

  List<Widget> getTextCustomRow(buttonVal) {
    List<Widget> childs = [];

    refresh() {
      setState(() {});
    }

    for (var i = 0; i < 1; i++) {
      childs.add(
        Row(
          children: [
            NeuButton(
              buttonBGcolor: widget.darkMode ? Colors.black : Colors.white,
              buttonFGcolor: Colors.orange,
              buttonVal: buttonVal,
              notifyParent: refresh,
              darkMode: widget.darkMode,
              solveEquations: solveEquations,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 17,
            ),
          ],
        ),
      );
    }

    return childs;
  }

  solveEquations() async {
    ContextModel cm = ContextModel();
    Expression exp = Parser().parse(solution);
    result = exp.evaluate(EvaluationType.REAL, cm);
    return result;
  }
}

class NeuButton extends StatefulWidget {
  const NeuButton({
    super.key,
    this.buttonBGcolor,
    this.buttonFGcolor,
    this.buttonVal,
    this.darkMode,
    required this.notifyParent,
    required this.solveEquations,
  });

  final buttonBGcolor;
  final buttonFGcolor;
  final buttonVal;
  final Function notifyParent;
  final Function solveEquations;
  final darkMode;

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() {
          isPressed = true;
        });
        if (widget.buttonVal == "AC") {
          solution = "";
          widget.notifyParent();
        } else if (widget.buttonVal == "=") {
          if (result - result.round() != 0) {
            solution = result.toString();
          } else {
            solution = result.round().toString();
          }
          widget.notifyParent();
        } else if (widget.buttonVal == "X") {
          solution = '$solution*';
          widget.notifyParent();
        } else if (widget.buttonVal == "x") {
          solution = solution.substring(0, solution.length - 1);
          widget.notifyParent();
        } else if (widget.buttonVal == "+/-") {
          if (solution != "") {
            solution = "-($solution)";
          } else {
            solution = "-";
          }
          widget.notifyParent();
        } else {
          solution = solution + widget.buttonVal;
          widget.notifyParent();
          widget.solveEquations();
        }
      },
      onPointerUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        width: MediaQuery.of(context).size.width / 6.15,
        height: MediaQuery.of(context).size.height / (6.15 * 2),
        decoration: BoxDecoration(
          color: widget.buttonBGcolor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: widget.buttonFGcolor,
              offset: isPressed ? const Offset(-2, -2) : const Offset(-4, -4),
              blurRadius: isPressed ? 2 : 30,
              inset: isPressed,
            ),
            BoxShadow(
              color: widget.buttonBGcolor,
              offset: isPressed ? const Offset(2, 2) : const Offset(4, 4),
              blurRadius: isPressed ? 5 : 30,
              inset: isPressed,
            )
          ],
        ),
        child: Center(
          child: Text(
            "${widget.buttonVal}",
            style: TextStyle(
              color: widget.buttonFGcolor,
              fontSize: 28,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
