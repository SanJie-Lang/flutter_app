// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Today.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Today _$TodayFromJson(Map<String, dynamic> json) {
  return Today(
      json['city'] as String,
      json['date_y'] as String,
      json['week'] as String,
      json['temperature'] as String,
      json['weather'] as String,
      json['wind'] as String,
      json['dressing_index'] as String,
      json['dressing_advice'] as String,
      json['uv_index'] as String,
      json['comfort_index'] as String,
      json['wash_index'] as String,
      json['travel_index'] as String,
      json['exercise_index'] as String);
}

Map<String, dynamic> _$TodayToJson(Today instance) => <String, dynamic>{
      'city': instance.city,
      'date_y': instance.date_y,
      'week': instance.week,
      'temperature': instance.temperature,
      'weather': instance.weather,
      'wind': instance.wind,
      'dressing_index': instance.dressing_index,
      'dressing_advice': instance.dressing_advice,
      'uv_index': instance.uv_index,
      'comfort_index': instance.comfort_index,
      'wash_index': instance.wash_index,
      'travel_index': instance.travel_index,
      'exercise_index': instance.exercise_index
    };
