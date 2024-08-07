import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LevelMapScreen(),
    );
  }
}

class LevelMapScreen extends StatefulWidget {
  @override
  _LevelMapScreenState createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  final List<LevelNode> nodes = [
    // LevelNode(
    //     offset: const Offset(210, 100), isUnlocked: true, isCompleted: true),
    // LevelNode(
    //     offset: const Offset(260, 180), isUnlocked: true, isCompleted: true),
    // LevelNode(
    //     offset: const Offset(310, 260), isUnlocked: true, isCompleted: false),
    // LevelNode(
    //     offset: const Offset(260, 340), isUnlocked: false, isCompleted: false),
    // LevelNode(
    //     offset: const Offset(210, 420), isUnlocked: false, isCompleted: false),
    // LevelNode(
    //     offset: const Offset(160, 500), isUnlocked: false, isCompleted: false),
    // LevelNode(
    //     offset: const Offset(110, 580), isUnlocked: false, isCompleted: false),
    // LevelNode(
    //     offset: const Offset(160, 660), isUnlocked: false, isCompleted: false),
    // LevelNode(
    //     offset: const Offset(210, 740), isUnlocked: false, isCompleted: false),
    // LevelNode(
    //     offset: const Offset(260, 820), isUnlocked: false, isCompleted: false),
    // LevelNode(
    //     offset: const Offset(310, 900), isUnlocked: false, isCompleted: false),
    // LevelNode(
    //     offset: const Offset(260, 980),
    //     isFinishedUnlocked: false,
    //     isCompleted: false),
  ];

  void cargarLevelNodes(int cantidadNiveles) {
    for (int i = 0; i < cantidadNiveles; i++) {
      int group = (i ~/ 4) % 2;

      if (group == 0) {
        // Izquierda
        nodes.add(
          LevelNode(
            offset: Offset(230 - (i % 4) * 25, 90 + (i * 80)),
            isUnlocked: i < 3,
            isCompleted: i < 2,
          ),
        );
      } else {
        // Derecha
        nodes.add(
          LevelNode(
            offset: Offset(150 + (i % 4) * 25, 90 + (i * 80)),
            isUnlocked: i < 3,
            isCompleted: i < 2,
          ),
        );
      }
    }
  }

  //los offsets deben ser como los de arriba dx de 50 en 50 y dy de 80 en 80, todo dinamicamente
  // void cargarLevelNodes(int cantidadNiveles) {
  //   for (int i = 0; i < cantidadNiveles; i++) {
  //     int group;
  //     if (i < 4) {
  //       group = 0; // O cualquier valor que desees para los primeros tres nodos
  //     } else {
  //       group = ((i - 3) ~/ 4) % 2;
  //     }

  //     if (group == 0) {
  //       // Izquierda
  //       nodes.add(
  //         LevelNode(
  //           offset: Offset(210 - ((i - 3) % 4) * 15, 90 + (i * 80)),
  //           isUnlocked: false,
  //           isCompleted: false,
  //         ),
  //       );
  //     } else {
  //       // Derecha
  //       nodes.add(
  //         LevelNode(
  //           offset: Offset(170 + ((i - 3) % 4) * 15, 90 + (i * 80)),
  //           isUnlocked: false,
  //           isCompleted: false,
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  void initState() {
    cargarLevelNodes(7);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight =
        nodes.map((node) => node.offset!.dy).reduce((a, b) => max(a, b)) + 80;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Niveles del juego'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height:
              maxHeight, // Aumentar el tamaño del height para permitir el scroll
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(
                    double.infinity, 1080), // Ajustar tamaño del CustomPaint
                painter: LevelMapPainter(nodes),
              ),
              ...nodes.map((node) => LevelNodeWidget(node: node)),
            ],
          ),
        ),
      ),
    );
  }
}

class LevelNodeWidget extends StatelessWidget {
  final LevelNode node;

  const LevelNodeWidget({Key? key, required this.node}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: node.offset!.dx - 20,
      top: node.offset!.dy - 20,
      child: GestureDetector(
        onTap: node.isUnlocked ? () => print('Node tapped') : null,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: _getNodeColor(node),
          child: _getNodeIcon(node),
        ),
      ),
    );
  }

  Color _getNodeColor(LevelNode node) {
    if (node.isCompleted) {
      return Colors.green;
    } else if (node.isUnlocked || node.isFinishedUnlocked == true) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  Icon _getNodeIcon(LevelNode node) {
    if (node.isFinishedUnlocked == true) {
      if (node.isCompleted && node.isFinishedUnlocked == true) {
        return const Icon(Icons.emoji_events_rounded, color: Colors.yellow);
      } else {
        return const Icon(Icons.emoji_events_rounded, color: Colors.white);
      }
    } else if (node.isUnlocked) {
      if (node.isCompleted) {
        return const Icon(Icons.check, color: Colors.white);
      } else {
        return const Icon(Icons.play_arrow, color: Colors.white);
      }
    } else if (node.isUnlocked == false && node.isFinishedUnlocked == false) {
      return const Icon(Icons.emoji_events_rounded, color: Colors.white);
    } else {
      return const Icon(Icons.lock, color: Colors.white);
    }
  }
}

class LevelNode {
  final Offset? offset;
  final bool isUnlocked;
  final bool isCompleted;
  final bool? isFinishedUnlocked;

  LevelNode({
    this.offset,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.isFinishedUnlocked,
  });
}

class LevelMapPainter extends CustomPainter {
  final List<LevelNode> nodes;

  LevelMapPainter(this.nodes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;

    for (int i = 0; i < nodes.length - 1; i++) {
      canvas.drawLine(nodes[i].offset ?? Offset(0, 0),
          nodes[i + 1].offset ?? Offset(0, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
