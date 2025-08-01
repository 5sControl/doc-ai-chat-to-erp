import 'package:equatable/equatable.dart';

class OffersState extends Equatable {
  final int screenIndex;
  
  const OffersState(this.screenIndex);
  
  @override
  List<Object> get props => [screenIndex];
}
