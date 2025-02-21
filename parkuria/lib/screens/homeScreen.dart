import 'dart:async';

import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Size size; // Oyun ekranının boyutları

  late Timer gameTimer; // Oyunun ana zamanlayıcısı
  late Timer scoreTimer; // Skor zamanlayıcısı

  double characterLeft = 100;
  double characterBottom = 55;
  double trapLeft1 = 800;
  double trapLeft2 = 1200; // İkinci engelin başlangıç pozisyonu
  double trapBottom = 55;

  double jumpSpeed = 0;
  bool isJumping = false; // Zıplama kontrolü
  bool isGameRunning = false;
  bool showTryAgain = false;

  int score = 0; // Skor değişkeni
  int secondsElapsed = 0; // Geçen süre

  void resetGame() {
    setState(() {
      characterLeft = 100;
      characterBottom = 55;
      trapLeft1 = 800;
      trapLeft2 = 1200;
      jumpSpeed = 0;
      isJumping = false;
      isGameRunning = false;
      showTryAgain = false;
      score = 0;
      secondsElapsed = 0;
      if (gameTimer.isActive) gameTimer.cancel();
      if (scoreTimer.isActive) scoreTimer.cancel();
    });
  }

  void startGame() {
    isGameRunning = true; // Oyun başlatıldığında true yap
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        // Trap hareketi
        trapLeft1 -= 5;
        trapLeft2 -= 5;

        if (trapLeft1 < -10) {
          trapLeft1 = size.width + 100; // Engelin başlangıç pozisyonu
          updateScore(); // Skoru artır
        }
        if (trapLeft2 < -10) {
          trapLeft2 = size.width + 100; // Engelin başlangıç pozisyonu
          updateScore(); // Skoru artır
        }

        // Karakterin zıplama hareketi
        if (isJumping) {
          characterBottom += jumpSpeed;
          jumpSpeed -= 0.5; // Zıplama hızını azalt

          if (characterBottom <= 55) {
            characterBottom = 55;
            isJumping = false;
          }
        }

        // Trap ve karakter çarpışma kontrolü
        if ((trapLeft1 <= characterLeft + 70 && trapLeft1 >= characterLeft) ||
            (trapLeft2 <= characterLeft + 70 && trapLeft2 >= characterLeft)) {
          if (characterBottom < 130) {
            gameTimer.cancel();
            scoreTimer.cancel(); // Skor zamanlayıcısını durdur
            setState(() {
              showTryAgain = true;
            });
          }
        }
      });
    });

    scoreTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isGameRunning) {
        setState(() {
          secondsElapsed++;
          score++; // Skoru her saniye artır
        });
      }
    });
  }

  void jump() {
    if (isJumping) return;

    setState(() {
      jumpSpeed = 8; // Zıplama hızı
      isJumping = true;
    });
  }

  void updateScore() {
    setState(() {
      score += 10; // Skoru artır
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bgimage.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            // Skor ve Kronometre
            left: 20,
            top: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Score: $score',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
                Text(
                  'Time: ${secondsElapsed ~/ 60}:${(secondsElapsed % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            // Trap 1
            bottom: trapBottom,
            left: trapLeft1,
            child: const NewTrapWidgets(),
          ),
          Positioned(
            // Trap 2
            bottom: trapBottom,
            left: trapLeft2,
            child: const NewTrapWidgets(),
          ),
          Positioned(
            // Karakter
            left: characterLeft,
            bottom: characterBottom,
            child: Container(
              width: 50, // Farklı bir boyut
              height: 74,
              color: Colors.blue, // Farklı bir renk
              child: const Center(
                child: Text(
                  "<Halit>",
                  style: TextStyle(fontSize: 23, color: Colors.white),
                ),
              ),
            ),
          ),
          if (showTryAgain)
            Center(
              child: ElevatedButton(
                onPressed: resetGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: Text(
                  "Try Again! (Time: ${secondsElapsed ~/ 60}:${(secondsElapsed % 60).toString().padLeft(2, '0')})",
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          Positioned(
            // START Butonu
            top: 60,
            right: 60,
            child: OutlinedButton(
              onPressed: isGameRunning
                  ? null
                  : () {
                      startGame();
                    },
              child: const Text("Start"),
            ),
          ),
          Positioned(
            // ZIPLAMA Butonu
            top: 110,
            right: 60,
            child: ElevatedButton(
              onPressed: jump,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent,
              ),
              child: const Text("JUMP!"),
            ),
          ),
        ],
      ),
    );
  }
}

class NewTrapWidgets extends StatelessWidget {
  const NewTrapWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 74,
      color: Colors.red, // Engellerin rengi
    );
  }
}
