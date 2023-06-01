import 'package:flutter/foundation.dart';
import 'package:testingbloc_course/models.dart';

@immutable
abstract class NotesApiProtocol{
  const NotesApiProtocol();
  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  });

}
@immutable 
 class NoteApi implements NotesApiProtocol {  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) =>Future.delayed(const Duration(seconds: 2), ()=> loginHandle==const LoginHandle.fooBar()?mockNotes:null);
}
