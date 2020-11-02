import 'package:flutter/material.dart';
import 'package:steps_indicator/steps_indicator.dart';

class StepIndicator extends StatefulWidget {
  @override
  _StepIndicatorState createState() => _StepIndicatorState();
}

class _StepIndicatorState extends State<StepIndicator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: StepsIndicator(
        selectedStep: 0,
        nbSteps: 3,
        selectedStepColorOut: const Color(0xff11AB17),
        selectedStepColorIn: const Color(0xff11AB17),
        doneStepColor: const Color(0xff11AB17),
        doneLineColor: const Color(0xff11AB17),
        undoneLineColor: const Color(0xffAB0B1F),
        unselectedStepColorIn: const Color(0xffAB0B1F),
        unselectedStepColorOut: const Color(0xffAB0B1F),
        unselectedStepSize: 20,
        selectedStepSize: 20,
        doneStepSize: 20,
      )),
    );
  }
}
