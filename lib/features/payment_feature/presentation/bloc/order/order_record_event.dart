part of 'order_record_bloc.dart';

abstract class OrderRecordEvent extends Equatable {
  const OrderRecordEvent();

  @override
  List<Object> get props => [];
}

class OrderRecordsRequest extends OrderRecordEvent {}
