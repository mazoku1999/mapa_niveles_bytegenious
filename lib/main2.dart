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
  final double nodeSpacingX = 170; // Espacio horizontal entre nodos
  final double nodeSpacingY = 170; // Espacio vertical entre nodos
  final int nodesPerRow = 3; // Cantidad de nodos por fila

  late final List<LevelNode> nodes;

  @override
  void initState() {
    super.initState();
    nodes = _generateNodes(31); // Generar 31 nodos
  }

  List<LevelNode> _generateNodes(int count) {
    List<LevelNode> generatedNodes = [];
    for (int i = 0; i < count; i++) {
      int row = i ~/ nodesPerRow;
      int col = i % nodesPerRow;
      double x = col * nodeSpacingX + 50;
      double y = row * nodeSpacingY + 30;

      // Cambiar el orden de los nodos en filas impares para crear el patrón zigzag
      if (row % 2 != 0) {
        x = (nodesPerRow - col - 1) * nodeSpacingX + 50;
      }

      generatedNodes.add(LevelNode(
        offset: Offset(x, y),
        isUnlocked: i < 3, // Los primeros 3 nodos están desbloqueados
        isCompleted: i < 2, // Los primeros 2 nodos están completados
      ));
    }
    return generatedNodes;
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight =
        nodes.map((node) => node.offset.dy).reduce((a, b) => a > b ? a : b) +
            nodeSpacingY;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de niveles'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: (nodesPerRow * nodeSpacingX),
          height: maxHeight,
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(double.infinity, double.infinity),
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
                      child: node.isUnlocked
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

  LevelNode({
    required this.offset,
    this.isUnlocked = false,
    this.isCompleted = false,
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
