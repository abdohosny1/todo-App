import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/cubitApp.dart';
import 'package:todo_app/cubit/stateCubit.dart';

import 'cubit/bloc_observe.dart';
import 'model/archived_tasks.dart';
import 'model/consts.dart';
import 'model/done_tasks.dart';
import 'model/new_tasks.dart';


void main(){
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        primaryColor: Colors.orangeAccent
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatelessWidget {


  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();

  var titleContoler=TextEditingController();
  var timeContoler=TextEditingController();
  var dayContoler=TextEditingController();




  @override
  Widget build(BuildContext context) {



    return BlocProvider(
     create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppState>(
        listener:(context,state){
          if(state is AppInsertDataBase){
            Navigator.of(context).pop();
          }
        } ,
        builder: (context,state){
          var cubit=AppCubit.getobject(context);

          return  Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.txet[cubit.currentIndex]),
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.orangeAccent,
              splashColor: Colors.black87,
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if(cubit.isbootomsheet){
                  if(formKey.currentState!.validate()){
                    cubit.insertToDatabase(
                        titlr: titleContoler.text, time: timeContoler.text, day: dayContoler.text);

                  }

                }else{
                  scaffoldKey.currentState!.showBottomSheet((context) => Form(
                    key: formKey,
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      color: Colors.white,
                      child: Column(
                        mainAxisSize:MainAxisSize.min,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            validator: ( value){
                              if(value!.isEmpty){
                                return 'Title must not empty';
                              }
                              return null;
                            },
                            controller: titleContoler,
                            decoration: InputDecoration(
                                prefix: Icon(Icons.title),
                                labelText: 'Task Tittle',
                                hintText: 'Enter Title',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.black38)
                                )
                            ),
                          ),
                          SizedBox(height: 10,),
                          TextFormField(

                            keyboardType: TextInputType.datetime,
                            validator: ( value){
                              if(value!.isEmpty){
                                return 'Time must not empty';
                              }
                              return null;
                            },
                            onTap: (){
                              showTimePicker(context: context,
                                  initialTime: TimeOfDay.now()
                              ).then((value) {
                                timeContoler.text=value!.format(context);
                              });
                            },
                            controller: timeContoler,
                            decoration: InputDecoration(
                                prefix: Icon(Icons.watch_later_outlined),
                                labelText: ' Task Time',
                                hintText: 'Enter Time',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.black38)
                                )
                            ),
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            keyboardType: TextInputType.datetime,
                            validator: ( value){
                              if(value!.isEmpty){
                                return 'Day must not empty';
                              }
                              return null;
                            },
                            onTap: (){
                              showDatePicker(context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2022)
                              ).then((value)  {
                                dayContoler.text=DateFormat.yMMMd().format(value!);
                              });
                            },
                            //  enabled: false,
                            controller: dayContoler,
                            decoration: InputDecoration(
                                prefix: Icon(Icons.calendar_today),
                                labelText: ' Task Day',
                                hintText: 'Enter Dat',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.black38)
                                )
                            ),
                          ),

                        ],
                      ),
                    ),

                  ),
                    elevation: 15,
                  ).closed.then((value) {
                    cubit.changeBottomSheet(isShow: false, icon: Icons.edit);

                  });
                  cubit.changeBottomSheet(isShow: true, icon: Icons.add);

                }


                // try{
                //   var name=await getname();
                //   print(name);
                //   print('osama');
                //   throw('some errors!!!!!!!');
                // }catch (error){
                //   print('error is ${error.toString()}');
                // }
                // getname().then((value) {
                //   print(value);
                //   print('osama');
                //   throw('some error');
                // }).catchError((error){
                //   print('error is ${error.toString()}');
                // });

              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap:(index){
                     cubit.changeIndex(index);
              },
              selectedItemColor: Colors.amber[800],

              items: [
                BottomNavigationBarItem(
                  icon:Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon:Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon:Icon(Icons.archive_outlined),
                  label: 'Achived',
                ),
              ],
            ),
            body:state is! AppGetDataBaseLoading? AppCubit.getobject(context).screen[cubit.currentIndex]:Center(child: CircularProgressIndicator()),
            // ConditionalBuilder(
            //   condition: tasks.length >0,
            //   builder: (context)=>screen[_currentIndex],
            //   fallback: (context)=>Center(child: CircularProgressIndicator()),
            // ) ,
          );
        },

      ),
    );
  }

  // Future <String> getname() async{
  //    return 'Abdo hosny';
  //  }


}


