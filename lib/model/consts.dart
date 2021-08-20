import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubitApp.dart';

Widget getlist(Map model,context){
  return Dismissible(
    key: Key(model['id'].toString() ),
    onDismissed: (dir){
      AppCubit.getobject(context).deleteDataBase(id: model['id']);

    },
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child:   Row(

        children: [

          CircleAvatar(

            radius: 40.0,

            child: Text('${model['time']}')

            ,

          ),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${model['title']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                Text('${model['data']}',style: TextStyle(color: Colors.grey),),
              ],
            ),
          ),
          SizedBox(width: 20,),
          IconButton(
              onPressed: (){
                AppCubit.getobject(context).uodateDataBase(status: 'Done', id: model['id']);
              },
              icon: Icon(Icons.check_box,color: Colors.orangeAccent,)),
          IconButton(
              onPressed: (){
                AppCubit.getobject(context).uodateDataBase(status: 'Arachive', id: model['id']);

              },
              icon: Icon(Icons.archive,color: Colors.black38,)),


        ],

      ),
    ),
  );
}
Widget check(){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,size: 80,color: Colors.grey,),
        Text('No Tasks Yet Please Add Some Tasks',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
      ],
    ),
  );
}