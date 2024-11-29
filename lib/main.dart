import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  String _output = '0';
  bool _shouldClearInput = false;

  void _calculateResult() {
    if (_input.isEmpty) return;

    try {
      // Create parser and expression
      Parser p = Parser();
      Expression exp = p.parse(_input);

      // Evaluate expression
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        // Format result to remove trailing zeros
        if (eval == eval.roundToDouble()) {
          _output = eval.toInt().toString();
        } else {
          _output = eval.toString();
        }
        _shouldClearInput = true;
      });
    } catch (e) {
      setState(() {
        _output = 'Error';
        _shouldClearInput = true;
      });
    }
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (_shouldClearInput) {
        _input = '';
        _shouldClearInput = false;
      }

      switch (value) {
        case 'C':
          _input = '';
          _output = '0';
          break;
        case '=':
          _calculateResult();
          break;
        case '⌫':
          if (_input.isNotEmpty) {
            _input = _input.substring(0, _input.length - 1);
          }
          break;
        default:
          _input += value;
      }
    });
  }

  Widget _buildButton(String text, {Color? color, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.white,
            foregroundColor: color != null ? Colors.white : Colors.black87,
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () => _onButtonPressed(text),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: GoogleFonts.rubik(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _input,
                        style: GoogleFonts.rubik(
                          fontSize: 32,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _output,
                        style: GoogleFonts.rubik(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      _buildButton('C', color: Colors.redAccent),
                      _buildButton('⌫', color: Colors.orange),
                      _buildButton('('),
                      _buildButton(')'),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('/', color: Colors.deepPurple),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('*', color: Colors.deepPurple),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('-', color: Colors.deepPurple),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('0'),
                      _buildButton('.'),
                      _buildButton('=', color: Colors.deepPurple),
                      _buildButton('+', color: Colors.deepPurple),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
