// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

@immutable
class LoginHandle{
  final String token;
  const LoginHandle({
    required this.token
  });
  const LoginHandle.fooBar(): token='foobar';
  @override bool operator ==(covariant LoginHandle other)=>token == other.token;
   
  @override
  // TODO: implement hashCode
  int get hashCode => token.hashCode;
  @override
  String toString()=>'LoginHandle (token =$token)';
}
enum LoginErrors{
  invalidHandle
}
@immutable
class Note {
  final String title;
  const Note({
    required this.title,
  });
  @override
  String toString() =>'Note {title=$title}';
}
final mocjNotes=Iterable.generate(3,(i)=>Note(title:'Note ${i+1}'));
