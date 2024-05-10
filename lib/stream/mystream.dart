import 'dart:async';

class MyStream {
  StreamController counterController = StreamController<bool>.broadcast();
  Stream get counterStream => counterController.stream;


  void signOut(){
    counterController.sink.add(true);
  }
}
