import 'package:DevQuiz/challenge/challenge_page.dart';
import 'package:DevQuiz/core/app_colors.dart';
import 'package:DevQuiz/home/home_controller.dart';
import 'package:DevQuiz/home/home_state.dart';
import 'package:DevQuiz/home/widgets/appbar/app_bar_widget.dart';
import 'package:DevQuiz/home/widgets/level_button/level_button_widget.dart';
import 'package:DevQuiz/home/widgets/quiz_card/quiz_card_widget.dart';
import 'package:DevQuiz/shared/models/quiz_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();
  List listQuizCards = [];

  @override
  void initState() {    
    super.initState();
    controller.getUser();
    controller.getQuizzes();
    controller.stateNotifier.addListener(() {
      setState(() {});
    });
  }

  void handleChangeDificulty(List<QuizModel> lista) {
    setState(() {
      listQuizCards = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.state == HomeState.sucess) {            
      return Scaffold(
        appBar: AppBarWidget(user: controller.user!,),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LevelButtonWidget(
                    label: "Fácil",
                    onTap: () {                      
                      handleChangeDificulty(controller.quizzes!.where((e) => e.level.toString() == "Level.facil").toList());                       
                    },
                  ),
                  LevelButtonWidget(
                    label: "Médio",
                    onTap: () {
                      handleChangeDificulty(controller.quizzes!.where((e) => e.level.toString() == "Level.medio").toList());                      
                    },
                  ),
                  LevelButtonWidget(
                    label: "Difícil",
                    onTap: () {
                      handleChangeDificulty(controller.quizzes!.where((e) => e.level.toString() == "Level.dificil").toList());                      
                    },
                  ),
                  LevelButtonWidget(
                    label: "Perito",
                    onTap: () {
                      handleChangeDificulty(controller.quizzes!.where((e) => e.level.toString() == "Level.perito").toList());                      
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Expanded(
                  child: GridView.count(
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  crossAxisCount: 2,
                  children: 
                    listQuizCards.map((e) => 
                    QuizCardWidget(
                      title: e.title, 
                      percent: e.questionAnswered/e.questions.length,
                      completed: "${e.questionAnswered}/${e.questions.length}",
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => ChallengePage(questions: e.questions, title: e.title,)
                          ));
                      },
                    )).toList(),
                ),
              )
            ],
          ),
        )
      );
    } else {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkGreen),
        ),)
      );
    }
  }
}