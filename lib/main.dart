import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> _board = List.filled(9, '');
  String _currentPlayer = 'X';
  String _winner = '';
  List<Color> _colors = [Colors.blue, Colors.purple];
  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();
    _startGradientTransition();
  }

  void _startGradientTransition() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _colorIndex = (_colorIndex + 1) % 2;
      });
      _startGradientTransition();
    });
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _currentPlayer = 'X';
      _winner = '';
    });
  }

  void _handleTap(int index) {
    if (_board[index].isEmpty && _winner.isEmpty) {
      setState(() {
        _board[index] = _currentPlayer;

        // Trigger vibration on tap
        if (Vibration.hasVibrator() != null) {
          Vibration.vibrate(duration: 50);
        }

        if (_checkWinner(_currentPlayer)) {
          _winner = 'Player $_currentPlayer Wins!';
        } else if (!_board.contains('')) {
          _winner = 'It\'s a Tie!';
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWinner(String player) {
    const winningCombos = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var combo in winningCombos) {
      if (_board[combo[0]] == player &&
          _board[combo[1]] == player &&
          _board[combo[2]] == player) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to adapt layout
    double gridSize = MediaQuery.of(context).size.width - 32;

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_colors[_colorIndex], _colors[(_colorIndex + 1) % 2]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Current Player or Winner Text
                Text(
                  _winner.isNotEmpty
                      ? _winner
                      : 'Current Player: $_currentPlayer',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 20),
                // Tic Tac Toe Grid
                Container(
                  width: gridSize,
                  height: gridSize,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => _handleTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            _board[index],
                            style: TextStyle(
                              fontSize: gridSize / 6,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Restart Button
                ElevatedButton(
                  onPressed: _resetGame,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Restart Game', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
