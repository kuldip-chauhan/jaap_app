import 'package:flutter/material.dart';

class MalaCounterScreen extends StatefulWidget{
  const MalaCounterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MalaCounterScreenState();
}

class _MalaCounterScreenState extends State<MalaCounterScreen> {

  int _totalJaapCount = 0;
  int _currentJaapCount = 0;
  int _malaCount = 0;

  void _updateAllCounts() {
    if (_totalJaapCount == 0) {
      _currentJaapCount = 0;
      _malaCount = 0;
      return;
    }
    _currentJaapCount = _totalJaapCount % 108;

    if (_currentJaapCount == 0) {
      _currentJaapCount = 108;
      _malaCount = _totalJaapCount ~/ 108;
    } else {
      _malaCount = _totalJaapCount ~/ 108;
    }
  }

  void _incrementCounter() {
    setState(() {
      _totalJaapCount++;
      _updateAllCounts();
    });
  }

  void _decrementCounter() {
    if (_totalJaapCount == 0) {
      return;
    }
    setState(() {
      _totalJaapCount--;
      _updateAllCounts();
    });
  }

  void _resetCounter() {
    setState(() {
      _totalJaapCount = 0;
      _updateAllCounts();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
        appBar: AppBar(
          title: Text('Mala Counter'),
          backgroundColor: Colors.amber,
          centerTitle: true,
          //   actions: [
          //     IconButton(onPressed: _resetCounter, icon: const Icon(Icons.refresh),tooltip: 'Mala Count Reset',)
          //   ],
        ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Total Jaap',
                          style: TextStyle(fontSize: 30, color: Colors.black54,fontWeight: FontWeight.bold),
                        ),
                        Text('$_totalJaapCount',
                          style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),

                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Mala 108',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text('$_malaCount',
                          style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Jaap',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '$_currentJaapCount',
                          style: const TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        )
                      ],
                    )
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10,0,6,6),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: _decrementCounter,
                            child: Container(
                              height: 250,
                              decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20)
                              ),

                              child: const Icon(
                                Icons.remove,
                                size: 50,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        )
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10,0,6,0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: _incrementCounter,
                            child: Container(
                              height: 250,
                              decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20)
                              ),

                              child: const Icon(
                                Icons.add,
                                size: 50,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
          ),

          // Layer 2: Reset Button
          Positioned(
            top: 10.0,
            right: 10.0,
            child: IconButton(
              icon: const Icon(Icons.refresh),
              iconSize: 25,
              color: Colors.grey[700],
              onPressed: _resetCounter,
              tooltip: 'Reset Count',
            ),
          )
        ],
      )
    );
  }
}
















