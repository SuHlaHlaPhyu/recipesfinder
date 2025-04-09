part of 'main_bloc.dart';

sealed class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class NavIndexChanged extends MainEvent {
  const NavIndexChanged({required this.index});

  final int index;

  @override
  List<Object> get props => [index];
}
