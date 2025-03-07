import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_ui/form_ui.dart';
// ignore: implementation_imports
import 'package:form_ui/src/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FormTheme.lightTheme,
      darkTheme: FormTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Scaffold(body: MainBody()),
    );
  }
}

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final TextEditingController _controller = TextEditingController();
  List<Offset> positions = [];

  void show() {
    String text = _controller.text;
    // print(text);
    text.replaceAll(' ', '');
    while (text.contains('\n\n')) {
      text.replaceAll('\n\n', '\n');
    }
    positions.clear();
    final rows = text.split('\n');
    for (final row in rows) {
      if (!row.contains(',')) {
        continue;
      }
      final rowData = row.split(',');
      String x = rowData[0], y = rowData[1];
      if (double.tryParse(x) != null && double.tryParse(y) != null) {
        positions.add(Offset(double.parse(x), double.parse(y)));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FormTextInput(controller: _controller, maxLine: 5, minLine: 5),
                  FormSecondaryButton(
                    onPressed: () {
                      show();
                    },
                    child: Text('Show'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FittedBox(
                child: SizedBox(
                  height: 818,
                  width: 1496,
                  child: FutureBuilder(
                    future: rootBundle.load('assets/img/field1.png'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return FormPositionView(
                          bytes: snapshot.data!.buffer.asUint8List(),
                          positions: positions,
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator.adaptive());
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
