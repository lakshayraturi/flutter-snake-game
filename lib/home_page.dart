import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_snake_game/blank_pixel.dart';
import 'package:flutter_snake_game/food_pixel.dart';
import 'package:flutter_snake_game/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //grid dimensions
  int rowSize = 10;
  int totalNumberOfSquares = 100;

  //user score
  int currentScore = 0;

  // snake position
  List<int> snakePos = [
    0,
    1,
    2,
  ];

  // snake direction is initially to the right
  var currentDirection = snake_Direction.RIGHT;

  //food position
  int foodPos = 55;

  //start the game
  void startGame() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        // keep the snake moving!
        moveSnake();

        //check if the game is over
        if (gameOver()) {
          timer.cancel();

          // display a message to the user
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Game Over'),
                  content: Text('Your score is: ' + currentScore.toString()),
                );
              });
        }
      });
    });
  }

  void eatFood() {
    currentScore++;
    //(while statement)-> Making sure the new food is not where the snake is
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          //add a new head
          //if snake is at the right wall, need to tr-afjust
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos..add(snakePos.last + 1);
          }
        }

        break;
      case snake_Direction.LEFT:
        {
          //add a new head
          //if snake is at the right wall, need to tr-afjust
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }

        break;
      case snake_Direction.UP:
        {
          //add a new head
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }

        break;
      case snake_Direction.DOWN:
        {
          //add a new head
          if (snakePos.last + rowSize > totalNumberOfSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }

        break;
      default:
    }

    //snake is eating the food
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      //remove the tail
      snakePos.removeAt(0);
    }
  }

  //game over
  bool gameOver() {
    // the game is over when the snake runs into itself
    // this occurs when there is a duplicate position in the snakePos list

    // this list is the body of the snake (no head)
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);

    if (bodySnake.contains(snakePos.last)) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //user current score
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Current Score'),
                    Text(
                      currentScore.toString(),
                      style: const TextStyle(
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),

                // highscores, top 5 or 10
                const Text('highscores..'),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    currentDirection != snake_Direction.UP) {
                  currentDirection = snake_Direction.DOWN;
                } else if (details.delta.dy < 0 &&
                    currentDirection != snake_Direction.DOWN) {
                  currentDirection = snake_Direction.UP;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 &&
                    currentDirection != snake_Direction.LEFT) {
                  currentDirection = snake_Direction.RIGHT;
                } else if (details.delta.dx < 0 &&
                    currentDirection != snake_Direction.RIGHT) {
                  currentDirection = snake_Direction.LEFT;
                }
              },
              child: GridView.builder(
                  itemCount: totalNumberOfSquares,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize),
                  itemBuilder: (context, index) {
                    if (snakePos.contains(index)) {
                      return SnakePixel();
                    } else if (foodPos == index) {
                      return FoodPixel();
                    } else {
                      return BlankPixel();
                    }
                  }),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  child: const Text('PLAY'),
                  color: Colors.pink,
                  onPressed: startGame,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
