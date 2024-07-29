import 'package:equatable/equatable.dart';

abstract class OffersEvent extends Equatable {
  const OffersEvent();
  
  @override
  List<Object> get props => [];
}

class NextScreenEvent extends OffersEvent {}