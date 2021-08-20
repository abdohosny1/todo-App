import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import 'model/archived_tasks.dart';
import 'model/consts.dart';
import 'model/done_tasks.dart';
import 'model/new_tasks.dart';


void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatelessWidget {

  List <Widget> screen=[
    NewTasks(),
    DoneTasks(),
    ArchivedTasks()
  ];
  List<String> txet=['New Tasks','Done Tasks', 'Arachived Tasks'];
  int _currentIndex=0;
  late Database database;
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
  bool isbootomsheet=false;
  IconData fabIcon=Icons.edit ;
  var titleContoler=TextEditingController();
  var timeContoler=TextEditingController();
  var dayContoler=TextEditingController();



  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(txet[_currentIndex]),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        splashColor: Colors.black87,
        child: Icon(fabIcon),
        onPressed: () {
          if(isbootomsheet){
            if(formKey.currentState!.validate()){
              insertToDatabase(titlr: titleContoler.text, time: timeContoler.text, day: dayContoler.text)
                  .then((value) {

                getDataFromDataBase(database).then((value){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Done')));
                  Navigator.of(context).pop();
                  // setState(() {
                  //   isbootomsheet=false;
                  //   fabIcon=Icons.edit;
                  //   tasks=value;
                  // });



                });

              });

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
              isbootomsheet=false;
              // setState(() {
              //   fabIcon=Icons.edit;
              // });
            });
            // setState(() {
            //   fabIcon=Icons.add;
            // });
            isbootomsheet=true;
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
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap:(index){
          // setState(() {
          //   _currentIndex=index;
          // });
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
      //body:tasks.length >0 ? screen[_currentIndex]:Center(child: CircularProgressIndicator()),
      // ConditionalBuilder(
      //   condition: tasks.length >0,
      //   builder: (context)=>screen[_currentIndex],
      //   fallback: (context)=>Center(child: CircularProgressIndicator()),
      // ) ,
    );
  }

  // Future <String> getname() async{
  //    return 'Abdo hosny';
  //  }

  createDatabase() async{

    //var databasesPath = await getDatabasesPath();
    ///String path = join(databasesPath, 'todo.db');

    database=await openDatabase(
        'todo.db',version: 1,
        onCreate: (database,version)async{
          print('create data base');
          // await database.execute(sql);
          database.execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT, data TEXT,time TEXT,status TEXT)'
          ).then((value) {
            print('Table is created');
          }).catchError((e){print('error when create table is ${e.toString()}');});
        },
        onOpen: (database){
          print('database is open');
          getDataFromDataBase(database).then((value){
            // setState(() {
            //   tasks=value;
            //
            // });

          });
        }
    );

  }

  Future insertToDatabase({
    required String titlr,required String time,required String day
  })async {
    return  await database.transaction((txn) {
      txn.rawInsert('INSERT INTO tasks(title,data,time,status) VALUES("$titlr","$day","$time","new") ')
          .then((value) {
        print('$value insert done');

      }).catchError((e){print('error when insert is :${e.toString()}');});
      return  Future<Null>(() {});
    });
  }


  Future <List<Map>> getDataFromDataBase(database)async{

    return await database.rawQuery('SELECT * FROM tasks');

  }
}


