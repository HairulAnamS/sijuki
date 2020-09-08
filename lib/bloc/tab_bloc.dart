import 'package:bloc/bloc.dart';

enum TabEvent {to_home, to_search, to_notif, to_profil}

class TabBloc extends Bloc<TabEvent, int>{
  int _idx = 0;
  TabBloc(int initialState) : super(initialState);

  @override
  Stream<int> mapEventToState(TabEvent event) async* {
    if(event == TabEvent.to_search) _idx = 1;
    else if(event == TabEvent.to_notif) _idx = 2;
    else if(event == TabEvent.to_profil) _idx = 3;
    else _idx = 0;

    print(_idx);
    yield _idx;  
  }

}