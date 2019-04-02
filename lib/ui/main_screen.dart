import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/model/ai.dart';
import 'package:tic_tac_toe_flutter/model/victory.dart';
import 'package:tic_tac_toe_flutter/util/check_victory.dart';
import 'package:tic_tac_toe_flutter/util/constants.dart';
import 'package:tic_tac_toe_flutter/util/victory_line.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String playerChar = 'X';
  final String aiChar = 'O';

  final Color playerColor = Colors.redAccent;
  final Color aiColor = Colors.greenAccent;

  bool playersTurn = true;
  List<List<String>> field = [
    ['', '', ''],
    ['', '', ''],
    ['', '', '']
  ];

  AI ai;
  Victory victory;

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    ai = AI(field, playerChar, aiChar);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Builder(
          builder: (BuildContext context) {
            _context = context;
            return Center(
              child: Stack(
                children: <Widget>[
                  buildGrid(),
                  buildField(),
                  buildVictoryLine(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Column and Row Grids

  Widget buildGrid() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildHorizontalLine,
              buildHorizontalLine,
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildVerticalLine,
              buildVerticalLine,
            ],
          ),
        ],
      ),
    );
  }

  Container get buildVerticalLine {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      color: Colors.grey,
      width: 5,
    );
  }

  Container get buildHorizontalLine {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      color: Colors.grey,
      height: 5,
    );
  }

  // Fields

  Widget buildField() {
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildCell(0, 0),
                buildCell(0, 1),
                buildCell(0, 2),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildCell(1, 0),
                buildCell(1, 1),
                buildCell(1, 2),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildCell(2, 0),
                buildCell(2, 1),
                buildCell(2, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCell(int row, int column) {
    return AspectRatio(
      aspectRatio: 1,
      child: MaterialButton(
          child: Text(
            field[row][column],
            style: TextStyle(
              fontSize: 82,
              color: field[row][column].isNotEmpty &&
                      field[row][column] == playerChar
                  ? playerColor
                  : aiColor,
            ),
          ),
          onPressed: () {
            if (!_gameIsDone() && playersTurn) {
              setState(() {
                _displayPlayersTurn(row, column);

                if (!_gameIsDone() && !playersTurn) {
                  _displayAiTurn();
                }
              });
            }
          }),
    );
  }

  bool _gameIsDone() {
    return _allCellsAreTaken() || victory != null;
  }

  bool _allCellsAreTaken() {
    return field[0][0].isNotEmpty &&
        field[0][1].isNotEmpty &&
        field[0][2].isNotEmpty &&
        field[1][0].isNotEmpty &&
        field[1][1].isNotEmpty &&
        field[1][2].isNotEmpty &&
        field[2][0].isNotEmpty &&
        field[2][1].isNotEmpty &&
        field[2][2].isNotEmpty;
  }

  void _displayPlayersTurn(int row, int column) {
    print('clicked on row $row column $column');

    if (field[row][column] == "") {
      playersTurn = false;
      field[row][column] = playerChar;
    }

    _checkForVictory();
  }

  void _displayAiTurn() {
    Timer(Duration(milliseconds: 600), () {
      setState(() {
        // AI turn
        var aiDecision = ai.getDecision();
        field[aiDecision.row][aiDecision.column] = aiChar;
        playersTurn = true;

        _checkForVictory();
      });
    });
  }

  void _checkForVictory() {
    victory = CheckVictory.checkForVictory(field, playerChar);

    if (victory != null) {
      String message;

      if (victory.winner == PLAYER) {
        message = 'You Win!';
      } else if (victory.winner == AI_PLAYER) {
        message = 'AI Win!';
      } else if (victory.winner == DRAFT) {
        message = 'Draft';
      }

      print(message);

      Scaffold.of(_context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          duration: Duration(
            minutes: 1,
          ),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              setState(() {
                victory = null;

                field = [
                  ['', '', ''],
                  ['', '', ''],
                  ['', '', '']
                ];

                playersTurn = true;
              });
            },
          ),
        ),
      );
    }
  }

  // Victory line

  Widget buildVictoryLine() {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: VictoryLine(victory),
      ),
    );
  }
}
