import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
//   PuzzleOptions puzzleOptions = new PuzzleOptions(patternName: "winter");
//
//   Puzzle puzzle = new Puzzle(puzzleOptions);
//
//   puzzle.generate().then((_) {
//     print("=====================================");
//     print("Your puzzle, fresh off the press:");
//     print("-------------------------------------");
//     printGrid(puzzle.board());
//     print("=====================================");
//     print("Give up? Here's your puzzle solution:");
//     print("-------------------------------------");
//     printGrid(puzzle.solvedBoard());
//     print("=====================================");
//   });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TextEditingController> _controller =
  List.generate(81, (i) => TextEditingController());
  String resultText = '';
  final player = AudioPlayer();

  List<List<int>> sudokuBoard = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9],
  ];

  int getNumberAt(int index) {
    int resultIndex = index % 9;
    return resultIndex;
  }
  int getRowNumberAt(int index) {
    double divide = index / 9;
    int resultIndex = divide.toInt();

    return resultIndex;
  }
  String getCellText(int index) {
    int number = getNumberAt(index);
    int row = getRowNumberAt(index);

    return '${number.toString()}, ${row.toString()}';
  }
  int getSudokuElementAt(int index) {
    int i = getNumberAt(index);
    int j = getRowNumberAt(index);

    List<int> row = sudokuBoard.elementAt(i);
    int value = row.elementAt(j);

    return value;
  }
  bool solve() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (sudokuBoard[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (isSafe(row, col, num)) {
              sudokuBoard[row][col] = num;
              if (solve()) {
                return true;
              }
              sudokuBoard[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    update();
    return true;
  }
  bool isSafe(int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (sudokuBoard[row][i] == num || sudokuBoard[i][col] == num) {
        return false;
      }
    }

    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (sudokuBoard[startRow + i][startCol + j] == num) {
          return false;
        }
      }
    }

    return true;
  }
  void update() {
    setState(() {
      for (int i = 0; i < 81; i++) {
        _controller.elementAt(i).text = getSudokuElementAt(i).toString();
      }
    });
  }
  void change() {
    setState(() {
      if (solve()) {
        player.play(AssetSource("Unlock.wav"));
        resultText = "Solved!";
      } else {
        player.play(AssetSource("boom.wav"));
        resultText = "Cannot Solve!";
      }
    });
  }
  void reset() {
    player.play(AssetSource("click.wav"));
    setState(() {
      // sudokuBoard = [
      //   [5, 3, 0, 0, 7, 0, 0, 0, 0],
      //   [6, 0, 0, 1, 9, 5, 0, 0, 0],


      //   [0, 9, 8, 0, 0, 0, 0, 6, 0],
      //   [8, 0, 0, 0, 6, 0, 0, 0, 3],
      //   [4, 0, 0, 8, 0, 3, 0, 0, 1],
      //   [7, 0, 0, 0, 2, 0, 0, 0, 6],
      //   [0, 6, 0, 0, 0, 0, 2, 8, 0],
      //   [0, 0, 0, 4, 1, 9, 0, 0, 5],
      //   [0, 0, 0, 0, 8, 0, 0, 7, 9],
      // ];
      sudokuBoard = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
      ];
      resultText = '';
      for (int i = 0; i < 81; i++) {
        _controller.elementAt(i).text = '';
      }
    });
  }
  void printBoard() {
    player.play(AssetSource("debug.wav"));
    print(sudokuBoard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sudoku Solver',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the Sudoku board
            SizedBox(
              width: 400,
              height: 400,
              child: GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9),
                itemCount: 81,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.all(2.0),
                      padding: const EdgeInsets.all(3.0),
                      color: ((getRowNumberAt(index) == 0) ||
                          (getRowNumberAt(index) == 1) ||
                          (getRowNumberAt(index) == 2) ||
                          (getRowNumberAt(index) == 6) ||
                          (getRowNumberAt(index) == 7) ||
                          (getRowNumberAt(index) == 8)) &&
                          ((getNumberAt(index) == 0) ||
                              (getNumberAt(index) == 1) ||
                              (getNumberAt(index) == 2) ||
                              (getNumberAt(index) == 6) ||
                              (getNumberAt(index) == 7) ||
                              (getNumberAt(index) == 8)) ||
                          ((getNumberAt(index) == 3) && (getRowNumberAt(index) == 3) ||
                              (getNumberAt(index) == 3) && (getRowNumberAt(index) == 4) ||
                              (getNumberAt(index) == 3) && (getRowNumberAt(index) == 5) ||
                              (getNumberAt(index) == 4) && (getRowNumberAt(index) == 3) ||
                              (getNumberAt(index) == 4) && (getRowNumberAt(index) == 4) ||
                              (getNumberAt(index) == 4) && (getRowNumberAt(index) == 5) ||
                              (getNumberAt(index) == 5) && (getRowNumberAt(index) == 3) ||
                              (getNumberAt(index) == 5) && (getRowNumberAt(index) == 4) ||
                              (getNumberAt(index) == 5) && (getRowNumberAt(index) == 5)


                          ) ? Colors.red : Colors.blue,

                      child: Center(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          controller: _controller.elementAt(index),
                          onChanged: (text) {
                            try {
                              _controller.elementAt(index).text = text;
                              int parsedValue = int.parse(text);

                              // Sprawdzenie, czy wartość jest pojedynczą cyfrą
                              if (parsedValue < 1 || parsedValue > 9) {
                                throw FormatException('Wprowadź liczbę od 1 do 9');
                              }

                              // Aktualizacja planszy tylko dla prawidłowych wartości
                              sudokuBoard[getNumberAt(index)][getRowNumberAt(index)] = parsedValue;
                            } catch (e) {
                              final snackBar = SnackBar(
                                content: Text('Błąd: Wprowadź liczbę od 1 do 9'),
                                duration: Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              Future.delayed(Duration(seconds: 2), () {
                                _controller.elementAt(index).text = '';
                              });
                            }
                          },
                        ),
                      ));
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(resultText),
            ElevatedButton(
              onPressed: change,
              child: const Text('Solve'),
            ),
            ElevatedButton(onPressed: reset, child: const Text('Reset')),
            ElevatedButton(
                onPressed: printBoard, child: const Text("DEBUG: PrintBoard()"))
          ],
        ),
      ),
    );
  }
}
