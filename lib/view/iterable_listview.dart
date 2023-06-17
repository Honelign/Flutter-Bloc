// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

extension ToListView<T> on Iterable<T>{
  Widget toListView()=>IterbaleListView(iterable: this);
}

class IterbaleListView<T> extends StatelessWidget {
  final Iterable<T> iterable; 
  const IterbaleListView({
    Key? key,
    required this.iterable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: iterable.length,
      itemBuilder: (context,index){
        return ListTile(
          title: Text(iterable.elementAt(index).toString()),

        );
      },
    );
  }
}
