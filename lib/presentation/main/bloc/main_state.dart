part of 'main_bloc.dart';

class MainState extends Equatable {
  const MainState({this.currentTabIndex = 0});

  final int currentTabIndex;

  @override
  List<Object> get props => [currentTabIndex];

  MainState copyWith({int? currentTabIndex, bool? isInternetValid}) {
    return MainState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }
}
