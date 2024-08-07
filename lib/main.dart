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
    LevelNode(
        offset: const Offset(210, 100), isUnlocked: true, isCompleted: true),
    LevelNode(
        offset: const Offset(260, 180), isUnlocked: true, isCompleted: true),
    LevelNode(
        offset: const Offset(310, 260), isUnlocked: true, isCompleted: false),
    LevelNode(
        offset: const Offset(260, 340), isUnlocked: false, isCompleted: false),
    LevelNode(
        offset: const Offset(210, 420), isUnlocked: false, isCompleted: false),
    LevelNode(
        offset: const Offset(160, 500), isUnlocked: false, isCompleted: false),
    LevelNode(
        offset: const Offset(110, 580), isUnlocked: false, isCompleted: false),
    LevelNode(
        offset: const Offset(160, 660), isUnlocked: false, isCompleted: false),
    LevelNode(
        offset: const Offset(210, 740), isUnlocked: false, isCompleted: false),
    LevelNode(
        offset: const Offset(260, 820), isUnlocked: false, isCompleted: false),
    LevelNode(
        offset: const Offset(310, 900), isUnlocked: false, isCompleted: false),
    LevelNode(
        offset: const Offset(260, 980),
        isUnlocked: false,
        isCompleted: false,
        isFinished: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Niveles del juego'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: 1080, // Aumentar el tamaño del height para permitir el scroll
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(
                    double.infinity, 1080), // Ajustar tamaño del CustomPaint
                painter: LevelMapPainter(nodes),
              ),
              ...nodes.map(
                (node) => Positioned(
                  left: node.offset.dx - 20,
                  top: node.offset.dy - 20,
                  child: GestureDetector(
                    onTap: node.isUnlocked
                        ? () {
                            print('Node tapped');
                          }
                        : null,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: node.isCompleted
                          ? Colors.green
                          : node.isUnlocked
                              ? Colors.orange
                              : Colors.grey,
                      child: node.isFinished == true
                          ? const Icon(Icons.emoji_events, color: Colors.white)
                          : node.isUnlocked
                              ? node.isCompleted
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : const Icon(Icons.play_arrow,
                                      color: Colors.white)
                              : const Icon(Icons.lock, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LevelNode {
  final Offset offset;
  final bool isUnlocked;
  final bool isCompleted;
  //No obligatoria
  bool? isFinished = false;

  LevelNode({
    required this.offset,
    this.isUnlocked = false,
    this.isCompleted = false,
    //No obligatoria pero se puede usar
    this.isFinished,
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
      canvas.drawLine(nodes[i].offset, nodes[i + 1].offset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
