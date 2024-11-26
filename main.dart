import 'package:flutter/material.dart';

void main() {
  runApp(const DockApp());
}

class DockApp extends StatelessWidget {
  const DockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: const Align(
          alignment: Alignment.bottomCenter,
          child: Dock(),
        ),
      ),
    );
  }
}

class Dock extends StatefulWidget {
  const Dock({super.key});

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  List<IconData> dockIcons = [
    Icons.home,
    Icons.search,
    Icons.notifications,
    Icons.settings,
    Icons.camera_alt,
  ];

  int hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 50),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: dockIcons.map((icon) {
          int index = dockIcons.indexOf(icon);
          return MouseRegion(
            onEnter: (_) => setState(() => hoveredIndex = index),
            onExit: (_) => setState(() => hoveredIndex = -1),
            child: Draggable<int>(
              data: index,
              feedback: _buildDockIcon(icon, isDragging: true),
              childWhenDragging: const SizedBox.shrink(),
              onDragCompleted: () {},
              child: DragTarget<int>(
                onAcceptWithDetails: (details) {
                  final fromIndex =
                      details.data; 
                  setState(() {
                    final draggedIcon = dockIcons[fromIndex];
                    dockIcons.removeAt(fromIndex);
                    dockIcons.insert(index, draggedIcon);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return GestureDetector(
                    child: _buildDockIcon(
                      icon,
                      isHovered: index == hoveredIndex,
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDockIcon(IconData icon,
      {bool isHovered = false, bool isDragging = false}) {
    double size = isHovered ? 80 : 50;
    size = isDragging ? 55 : size;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 50, end: size),
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            icon,
            color: Colors.white,
            size: value,
          ),
        );
      },
    );
  }
}
