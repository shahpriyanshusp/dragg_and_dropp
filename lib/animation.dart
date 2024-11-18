import 'package:flutter/material.dart';

class MoveRightToLeftExample extends StatefulWidget {
  @override
  _MoveRightToLeftExampleState createState() => _MoveRightToLeftExampleState();
}

class _MoveRightToLeftExampleState extends State<MoveRightToLeftExample> {
  bool _isLeft = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Move Right to Left')),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            left: _isLeft ? 0 : MediaQuery.of(context).size.width - 100,
            top: MediaQuery.of(context).size.height / 2 -250,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
          Positioned(
            bottom: 50,
            left: 50,
            child: ElevatedButton(
              onPressed: () => setState(() => _isLeft = !_isLeft),
              child: Text('Animate'),
            ),
          ),
        ],
      ),
    );
  }
}
