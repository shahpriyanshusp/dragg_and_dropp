import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock<IconData>(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (icon) => DockItem(icon: icon),
          ),
        ),
      ),
    );
  }
}

/// Dock widget that supports draggable items.
class Dock<T extends Object> extends StatefulWidget {
  const Dock({
    super.key,
    required this.items,
    required this.builder,
  });

  /// Initial list of items.
  final List<T> items;

  /// Builder function for creating widgets from items.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T extends Object> extends State<Dock<T>> {
  /// Internal list of items.
  late final List<T> _items = widget.items.toList();
  int hoverIndex = -1;
  int draggingIndex = -1;
  bool needToBuildNewWidget = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return DragTarget<T>(
            onWillAcceptWithDetails: (data) => false,

            builder: (context, candidateData, rejectedData) {
              return Draggable<T>(
                data: item,
                feedback: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOutQuint,
                    child: widget.builder(item)),
                childWhenDragging: Opacity(
                  opacity: 0.0,
                  child: needToBuildNewWidget ? const SizedBox.shrink() : widget.builder(item),
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
                child: AnimatedContainer(
                    curve: Curves.bounceInOut,
                    duration: const Duration(seconds: 50),
                    child: widget.builder(item)),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

/// A single dock item widget.
class DockItem extends StatelessWidget {
  const DockItem({super.key, required this.icon});

  /// Icon to display in the dock item.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 48),
      height: 48,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.primaries[icon.hashCode % Colors.primaries.length],
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
