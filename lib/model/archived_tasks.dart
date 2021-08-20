import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubitApp.dart';
import 'package:todo_app/cubit/stateCubit.dart';

import 'consts.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        builder: (context,state){
          var tasks=AppCubit.getobject(context).arachivTasks;
          return tasks.length>0? ListView.separated(
              itemBuilder: (context,index)=>getlist(tasks[index],context),
              separatorBuilder: (context,index)=>Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
              itemCount: tasks.length): check() ;
        },
        listener: (context,state){}
    );
  }

}
