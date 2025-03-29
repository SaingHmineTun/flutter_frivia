import 'package:flutter/material.dart';
import 'package:frivia/pages/game_page.dart';
import 'package:frivia/services/WebService.dart';
import 'package:frivia/utility/utils.dart';
import 'package:frivia/widgets/app_bar.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double level = 0;
  double numberOfQuestions = 5;
  String categoryId = "No Category";
  List<String> levelTexts = ["Easy", "Medium", "Hard"];
  late double _deviceWidth;
  late double _deviceHeight;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(appBar: appBarWidget(context), body: _homeUi());
  }

  Widget _homeUi() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _difficultyLevel(),
          _numberOfQuestions(),
          _category(),
          _startButton(),
        ],
      ),
    );
  }

  Widget _numberOfQuestions() {
    return Card(
      color: ColorScheme.of(context).primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Column(
          children: [
            Text(
              "Number of questions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Slider(
              value: numberOfQuestions,
              label: "Number of questions",
              min: 5,
              max: 20,
              divisions: 15,
              onChanged: (newValue) {
                setState(() {
                  numberOfQuestions = newValue;
                });
              },
            ),
            Text(
              numberOfQuestions.toInt().toString(),
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _difficultyLevel() {
    return Card(
      color: ColorScheme.of(context).primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Column(
          children: [
            Text(
              "Difficulty Level",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Slider(
              value: level,
              label: "Difficulty Level",
              min: 0,
              max: 2,
              divisions: 2,
              onChanged: (newValue) {
                setState(() {
                  level = newValue;
                });
              },
            ),
            Text(levelTexts[level.toInt()]),
          ],
        ),
      ),
    );
  }

  Widget _startButton() {
    return MaterialButton(
      color: ColorScheme.of(context).primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return GamePage(
                difficulty: levelTexts[level.toInt()].toLowerCase(),
                numberOfQuestions: numberOfQuestions.toInt(),
                categoryItem:
                    categoryId == "No Category" ? null : category[categoryId],
              );
            },
          ),
        );
      },
      minWidth: _deviceWidth,
      height: _deviceHeight * 0.07,
      child: Text(
        "START",
        style: TextStyle(
          color: ColorScheme.of(context).onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _category() {
    List<String> categories = category.keys.toList(growable: false);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorScheme.of(context).primary,
      ),
      child: DropdownButton(
        underline: SizedBox(),
        iconEnabledColor: ColorScheme.of(context).onPrimary,
        borderRadius: BorderRadius.circular(10),
        dropdownColor: ColorScheme.of(context).tertiary,
        padding: EdgeInsets.all(10),
        isExpanded: true,
        value: categoryId,
        items: ["No Category", ...categories]
            .map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: ColorScheme.of(context).onPrimary),
                ),
              );
            })
            .toList(growable: false),
        onChanged: (val) {
          setState(() {
            categoryId = val!;
          });
        },
      ),
    );
  }
}
