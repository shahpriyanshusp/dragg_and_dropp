import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: MacDock(),
        ),
      ),
    );
  }
}

class MacDock extends StatefulWidget {
  const MacDock({super.key});

  @override
  _MacDockState createState() => _MacDockState();
}

class _MacDockState extends State<MacDock> {
  List<String> icons = ['home', 'search', 'settings', 'alarm', 'person'];
  int hoverIndex = -1;
  int draggingIndex = -1;
  bool needToBuildNewWidget = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(icons.length, (index) {
          return DragTarget<String>(
            onWillAcceptWithDetails: (data) => false,
            onLeave: (_) => setState(() => hoverIndex = -1),
            onAcceptWithDetails: (data) {
              setState(() {
                int draggedIndex = icons.indexOf(data.data);
                String temp = icons[index];
                icons[index] = icons[draggedIndex];
                icons[draggedIndex] = temp;
                hoverIndex = -1;
                draggingIndex = -1;
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Draggable<String>(
                data: icons[index],
                feedback: Transform.scale(
                  scale: 1.0,
                  child: Icon(
                    _getIconData(icons[index]),
                    size: 60,
                    color: Colors.green,
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.0,
                  child: needToBuildNewWidget ? const SizedBox.shrink() : _buildDockItem(index),
                ),
                affinity: Axis.vertical,
                onDragStarted: () {
                  setState(() {
                    needToBuildNewWidget = false;
                    draggingIndex = index;
                  });
                },

                onDragUpdate: (data){
                  if (data.localPosition.dy < 385) {
                    setState(() {
                      needToBuildNewWidget = true;
                    });
                  } else if (data.localPosition.dy > 500) {
                    setState(() {
                      needToBuildNewWidget = true;
                    });
                  } else if (data.localPosition.dy >= 385 && data.localPosition.dy <= 500) {
                    // Specific logic for the range between 390 and 420
                    setState(() {
                      needToBuildNewWidget = false;
                    });
                  }

                },
                onDragEnd: (_) {
                  setState(() {
                    draggingIndex = -1;
                    hoverIndex = -1;
                  });
                },
                child: _buildDockItem(index),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildDockItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: const Duration(seconds: 30),
        curve: Curves.easeIn,
        child: Icon(
          _getIconData(icons[index]),
          size: hoverIndex == index ? 60 : 50,
          color: Colors.white,
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'home':
        return Icons.home;
      case 'search':
        return Icons.search;
      case 'settings':
        return Icons.settings;
      case 'alarm':
        return Icons.alarm;
      case 'person':
        return Icons.person;
      default:
        return Icons.help_outline;
    }
  }
}
