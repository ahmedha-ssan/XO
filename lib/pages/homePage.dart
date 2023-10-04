import 'package:flutter/material.dart';
import 'package:xogame/BLS/gameLogic.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  bool isSwitched = false;
  Game game = Game();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: Column(
        children: [
          SwitchListTile.adaptive(
            title: const Text(
              'Turn on/off two player',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
            value: isSwitched,
            onChanged: (val) {
              setState(() {
                isSwitched = val;
              });
            },
          ),
          Text(
            'IT\'S $activePlayer TURN ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 11,
              crossAxisSpacing: 7,
              childAspectRatio: 1,
              crossAxisCount: 3,
              children: List.generate(
                  9,
                  (index) => GestureDetector(
                        onTap: gameOver
                            ? null
                            : () async {
                                if ((player.playerX.isEmpty ||
                                        !player.playerX.contains(index)) &&
                                    (player.playerO.isEmpty ||
                                        !player.playerO.contains(index))) {
                                  game.playGame(index, activePlayer);
                                  upDateState();
                                  if (!isSwitched && !gameOver && turn != 9) {
                                    await game.autoPlay(activePlayer);
                                    upDateState();
                                  }
                                }
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              player.playerX.contains(index)
                                  ? 'X'
                                  : player.playerO.contains(index)
                                      ? 'O'
                                      : '',
                              style: TextStyle(
                                color: player.playerX.contains(index)
                                    ? Colors.red
                                    : Colors.blue,
                                fontSize: 43,
                              ),
                            ),
                          ),
                        ),
                      )),
            ),
          ),
          Text(
            result,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
            ),
            textAlign: TextAlign.center,
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                activePlayer = 'X';
                gameOver = false;
                turn = 0;
                result = '';
                player.playerX = [];

                player.playerO = [];
              });
            },
            icon: Icon(Icons.replay),
            label: Text('Repat the game...'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).splashColor,
              ),
            ),
          )
        ],
      )),
    );
  }

  void upDateState() {
    setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;
        result = '$winnerPlayer is the winner...';
      } else if (!gameOver && turn == 9) {
        result = 'Draw...';
      }
    });
  }
}
