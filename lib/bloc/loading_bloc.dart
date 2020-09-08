import 'package:bloc/bloc.dart';

enum LoadingEvent {to_show, to_hide}

class LoadingBloc extends Bloc<LoadingEvent, bool>{
  bool _isShow = false;
  LoadingBloc(bool initialState) : super(initialState);

  @override
  Stream<bool> mapEventToState(LoadingEvent event) async* {
    _isShow = (event == LoadingEvent.to_show) ? true : false;
    print(_isShow);
    yield _isShow;  
  }

}