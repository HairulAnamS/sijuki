import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

enum ModeEvent { to_dark, to_light }

class ModeBloc extends HydratedBloc<ModeEvent, int> {
  
  ModeBloc(int initialState): super(0);

  @override
  Stream<int> mapEventToState(ModeEvent event) async* {
    yield (event == ModeEvent.to_dark) ? 1 : 0;
  }

  @override
  int fromJson(Map<String, dynamic> json) {
    try {
      print(json['mode']);
      return (json['mode'] as int);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, int> toJson(int state) {
    try {
      print('mode bloc: $state');
      return {'mode': state};
    } catch (_) {
      return null;
    }
  }
}
