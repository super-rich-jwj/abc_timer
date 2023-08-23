import 'dart:async';
import 'package:action_slider/action_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({super.key});

  @override
  State<StopWatch> createState() => StopWatchState();
}

class StopWatchState extends State<StopWatch> {
  int _milliseconds = 0, _seconds = 0, _minutes = 0, _hours = 0;
  String _dHour = "00", _dMin = "00", _dSec = "00", _dMsec = "00";
  Timer? _timer;
  bool started = false;
  List laps = [];
  int? fontSize;
  ScrollController scrollController = ScrollController();

  void copyLaps() {
    String lapsText = laps.join("\n");
    Clipboard.setData(ClipboardData(text: lapsText));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Copy Complete, Paste in your notepad")));
  }

  void timerStop() {
    _timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void timerReset() {
    _timer?.cancel();
    setState(() {
      _milliseconds = 0;
      _seconds = 0;
      _minutes = 0;
      _hours = 0;

      _dMsec = "00";
      _dSec = "00";
      _dMin = "00";
      _dHour = "00";

      laps = [];

      started = false;
    });
  }

  void addlaps() {
    String lap = "$_dHour:$_dMin:$_dSec.$_dMsec";
    setState(() {
      laps.add(lap);
    });
    _scrollToTop();
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  void timerStart() {
    started = true;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      int localMsec = _milliseconds + 1;
      int localSec = _seconds;
      int localMin = _minutes;
      int localHour = _hours;

      if (localMsec > 99) {
        if (localSec > 58) {
          if (localMin > 58) {
            localHour++;
            localMin = 0;
            localSec = 0;
            localMsec = 0;
          } else {
            localMin++;
            localSec = 0;
            localMsec = 0;
          }
        } else {
          localSec++;
          localMsec = 0;
        }
      }

      setState(() {
        _milliseconds = localMsec;
        _seconds = localSec;
        _minutes = localMin;
        _hours = localHour;

        _dMsec = (_milliseconds >= 10) ? "$_milliseconds" : "0$_milliseconds";
        _dSec = (_seconds >= 10) ? "$_seconds" : "0$_seconds";
        _dMin = (_minutes >= 10) ? "$_minutes" : "0$_minutes";
        _dHour = (_hours >= 10) ? "$_hours" : "0$_hours";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 2 / 5,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText("$_dHour:$_dMin:$_dSec.$_dMsec",
                            maxFontSize: 100,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 7)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ActionSlider.standard(
                      width: 300,
                      height: 50,
                      sliderBehavior: SliderBehavior.stretch,
                      toggleColor: Colors.grey.shade600,
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: const Icon(
                        Icons.double_arrow,
                      ),
                      reverseSlideAnimationCurve: Curves.easeInExpo,
                      onTap: (controller, pos) {},
                      action: (controller) {
                        timerReset();
                      },
                      child: const Text(
                        "Reset",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 30),
                          ElevatedButton(
                              onPressed: copyLaps,
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(70, 70),
                                  foregroundColor: Colors.grey.shade900,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10)),
                              child: const Icon(
                                Icons.copy,
                                size: 30,
                                color: Colors.black,
                              )),
                          const SizedBox(width: 50),
                          ElevatedButton(
                            onPressed: () {
                              (!started) ? timerStart() : timerStop();
                            },
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(70, 70),
                                foregroundColor: Colors.grey.shade900,
                                backgroundColor: (!started)
                                    ? const Color.fromARGB(255, 104, 174, 227)
                                    : const Color.fromARGB(255, 218, 163, 62),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10)),
                            child: (!started)
                                ? const Icon(
                                    Icons.play_arrow,
                                    size: 30,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.pause,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                          ),
                          const SizedBox(width: 50),
                          ElevatedButton(
                            onPressed: () {
                              addlaps();
                            },
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(70, 70),
                                foregroundColor: Colors.grey.shade900,
                                backgroundColor: Theme.of(context).primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10)),
                            child: const Icon(
                              Icons.flag,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 3 / 5,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: laps.length,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lap ${index + 1}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            Text(
                              "${laps[index]}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
