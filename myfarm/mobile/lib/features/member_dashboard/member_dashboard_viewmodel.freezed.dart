// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_dashboard_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemberDashboardState {

 bool get isLoading; bool get isLoadingHistory; MemberDashboardDto? get dashboard; PageResponse<PaymentDto>? get paymentsPage; PageResponse<FeedAllocationDto>? get feedHistoryPage; String? get error; int get currentPaymentPage; int get currentFeedPage; YearMonth get selectedPeriod;
/// Create a copy of MemberDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberDashboardStateCopyWith<MemberDashboardState> get copyWith => _$MemberDashboardStateCopyWithImpl<MemberDashboardState>(this as MemberDashboardState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MemberDashboardState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberDashboardState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isLoadingHistory, _this.isLoadingHistory) || other.isLoadingHistory == _this.isLoadingHistory)&&(identical(other.dashboard, _this.dashboard) || other.dashboard == _this.dashboard)&&(identical(other.paymentsPage, _this.paymentsPage) || other.paymentsPage == _this.paymentsPage)&&(identical(other.feedHistoryPage, _this.feedHistoryPage) || other.feedHistoryPage == _this.feedHistoryPage)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.currentPaymentPage, _this.currentPaymentPage) || other.currentPaymentPage == _this.currentPaymentPage)&&(identical(other.currentFeedPage, _this.currentFeedPage) || other.currentFeedPage == _this.currentFeedPage)&&(identical(other.selectedPeriod, _this.selectedPeriod) || other.selectedPeriod == _this.selectedPeriod));
}


@override
int get hashCode {
  final _this = this as MemberDashboardState;
  return Object.hash(runtimeType,_this.isLoading,_this.isLoadingHistory,_this.dashboard,_this.paymentsPage,_this.feedHistoryPage,_this.error,_this.currentPaymentPage,_this.currentFeedPage,_this.selectedPeriod);
}

@override
String toString() {
  final _this = this as MemberDashboardState;
  return 'MemberDashboardState(isLoading: ${_this.isLoading}, isLoadingHistory: ${_this.isLoadingHistory}, dashboard: ${_this.dashboard}, paymentsPage: ${_this.paymentsPage}, feedHistoryPage: ${_this.feedHistoryPage}, error: ${_this.error}, currentPaymentPage: ${_this.currentPaymentPage}, currentFeedPage: ${_this.currentFeedPage}, selectedPeriod: ${_this.selectedPeriod})';
}


}

/// @nodoc
abstract mixin class $MemberDashboardStateCopyWith<$Res>  {
  factory $MemberDashboardStateCopyWith(MemberDashboardState value, $Res Function(MemberDashboardState) _then) = _$MemberDashboardStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isLoadingHistory, MemberDashboardDto? dashboard, PageResponse<PaymentDto>? paymentsPage, PageResponse<FeedAllocationDto>? feedHistoryPage, String? error, int currentPaymentPage, int currentFeedPage, YearMonth selectedPeriod
});


$YearMonthCopyWith<$Res> get selectedPeriod;

}
/// @nodoc
class _$MemberDashboardStateCopyWithImpl<$Res>
    implements $MemberDashboardStateCopyWith<$Res> {
  _$MemberDashboardStateCopyWithImpl(this._self, this._then);

  final MemberDashboardState _self;
  final $Res Function(MemberDashboardState) _then;

/// Create a copy of MemberDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isLoadingHistory = null,Object? dashboard = freezed,Object? paymentsPage = freezed,Object? feedHistoryPage = freezed,Object? error = freezed,Object? currentPaymentPage = null,Object? currentFeedPage = null,Object? selectedPeriod = null,}) {
  return _then(MemberDashboardState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingHistory: null == isLoadingHistory ? _self.isLoadingHistory : isLoadingHistory // ignore: cast_nullable_to_non_nullable
as bool,dashboard: freezed == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as MemberDashboardDto?,paymentsPage: freezed == paymentsPage ? _self.paymentsPage : paymentsPage // ignore: cast_nullable_to_non_nullable
as PageResponse<PaymentDto>?,feedHistoryPage: freezed == feedHistoryPage ? _self.feedHistoryPage : feedHistoryPage // ignore: cast_nullable_to_non_nullable
as PageResponse<FeedAllocationDto>?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,currentPaymentPage: null == currentPaymentPage ? _self.currentPaymentPage : currentPaymentPage // ignore: cast_nullable_to_non_nullable
as int,currentFeedPage: null == currentFeedPage ? _self.currentFeedPage : currentFeedPage // ignore: cast_nullable_to_non_nullable
as int,selectedPeriod: null == selectedPeriod ? _self.selectedPeriod : selectedPeriod // ignore: cast_nullable_to_non_nullable
as YearMonth,
  ));
}
/// Create a copy of MemberDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YearMonthCopyWith<$Res> get selectedPeriod {
  
  return $YearMonthCopyWith<$Res>(_self.selectedPeriod, (value) {
    return _then(_self.copyWith(selectedPeriod: value));
  });
}
}


/// Adds pattern-matching-related methods to [MemberDashboardState].
extension MemberDashboardStatePatterns on MemberDashboardState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberDashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberDashboardState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberDashboardState value)  $default,){
final _that = this;
switch (_that) {
case _MemberDashboardState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberDashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _MemberDashboardState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isLoadingHistory,  MemberDashboardDto? dashboard,  PageResponse<PaymentDto>? paymentsPage,  PageResponse<FeedAllocationDto>? feedHistoryPage,  String? error,  int currentPaymentPage,  int currentFeedPage,  YearMonth selectedPeriod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberDashboardState() when $default != null:
return $default(_that.isLoading,_that.isLoadingHistory,_that.dashboard,_that.paymentsPage,_that.feedHistoryPage,_that.error,_that.currentPaymentPage,_that.currentFeedPage,_that.selectedPeriod);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isLoadingHistory,  MemberDashboardDto? dashboard,  PageResponse<PaymentDto>? paymentsPage,  PageResponse<FeedAllocationDto>? feedHistoryPage,  String? error,  int currentPaymentPage,  int currentFeedPage,  YearMonth selectedPeriod)  $default,) {final _that = this;
switch (_that) {
case _MemberDashboardState():
return $default(_that.isLoading,_that.isLoadingHistory,_that.dashboard,_that.paymentsPage,_that.feedHistoryPage,_that.error,_that.currentPaymentPage,_that.currentFeedPage,_that.selectedPeriod);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isLoadingHistory,  MemberDashboardDto? dashboard,  PageResponse<PaymentDto>? paymentsPage,  PageResponse<FeedAllocationDto>? feedHistoryPage,  String? error,  int currentPaymentPage,  int currentFeedPage,  YearMonth selectedPeriod)?  $default,) {final _that = this;
switch (_that) {
case _MemberDashboardState() when $default != null:
return $default(_that.isLoading,_that.isLoadingHistory,_that.dashboard,_that.paymentsPage,_that.feedHistoryPage,_that.error,_that.currentPaymentPage,_that.currentFeedPage,_that.selectedPeriod);case _:
  return null;

}
}

}

/// @nodoc


class _MemberDashboardState implements MemberDashboardState {
  const _MemberDashboardState({this.isLoading = false, this.isLoadingHistory = false, this.dashboard, this.paymentsPage, this.feedHistoryPage, this.error, this.currentPaymentPage = 0, this.currentFeedPage = 0, required this.selectedPeriod});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoadingHistory;
@override final  MemberDashboardDto? dashboard;
@override final  PageResponse<PaymentDto>? paymentsPage;
@override final  PageResponse<FeedAllocationDto>? feedHistoryPage;
@override final  String? error;
@override@JsonKey() final  int currentPaymentPage;
@override@JsonKey() final  int currentFeedPage;
@override final  YearMonth selectedPeriod;

/// Create a copy of MemberDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberDashboardStateCopyWith<_MemberDashboardState> get copyWith => __$MemberDashboardStateCopyWithImpl<_MemberDashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberDashboardState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingHistory, isLoadingHistory) || other.isLoadingHistory == isLoadingHistory)&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard)&&(identical(other.paymentsPage, paymentsPage) || other.paymentsPage == paymentsPage)&&(identical(other.feedHistoryPage, feedHistoryPage) || other.feedHistoryPage == feedHistoryPage)&&(identical(other.error, error) || other.error == error)&&(identical(other.currentPaymentPage, currentPaymentPage) || other.currentPaymentPage == currentPaymentPage)&&(identical(other.currentFeedPage, currentFeedPage) || other.currentFeedPage == currentFeedPage)&&(identical(other.selectedPeriod, selectedPeriod) || other.selectedPeriod == selectedPeriod));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isLoadingHistory,dashboard,paymentsPage,feedHistoryPage,error,currentPaymentPage,currentFeedPage,selectedPeriod);
}

@override
String toString() {
    return 'MemberDashboardState(isLoading: $isLoading, isLoadingHistory: $isLoadingHistory, dashboard: $dashboard, paymentsPage: $paymentsPage, feedHistoryPage: $feedHistoryPage, error: $error, currentPaymentPage: $currentPaymentPage, currentFeedPage: $currentFeedPage, selectedPeriod: $selectedPeriod)';
}


}

/// @nodoc
abstract mixin class _$MemberDashboardStateCopyWith<$Res> implements $MemberDashboardStateCopyWith<$Res> {
  factory _$MemberDashboardStateCopyWith(_MemberDashboardState value, $Res Function(_MemberDashboardState) _then) = __$MemberDashboardStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isLoadingHistory, MemberDashboardDto? dashboard, PageResponse<PaymentDto>? paymentsPage, PageResponse<FeedAllocationDto>? feedHistoryPage, String? error, int currentPaymentPage, int currentFeedPage, YearMonth selectedPeriod
});


@override $YearMonthCopyWith<$Res> get selectedPeriod;

}
/// @nodoc
class __$MemberDashboardStateCopyWithImpl<$Res>
    implements _$MemberDashboardStateCopyWith<$Res> {
  __$MemberDashboardStateCopyWithImpl(this._self, this._then);

  final _MemberDashboardState _self;
  final $Res Function(_MemberDashboardState) _then;

/// Create a copy of MemberDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isLoadingHistory = null,Object? dashboard = freezed,Object? paymentsPage = freezed,Object? feedHistoryPage = freezed,Object? error = freezed,Object? currentPaymentPage = null,Object? currentFeedPage = null,Object? selectedPeriod = null,}) {
  return _then(_MemberDashboardState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingHistory: null == isLoadingHistory ? _self.isLoadingHistory : isLoadingHistory // ignore: cast_nullable_to_non_nullable
as bool,dashboard: freezed == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as MemberDashboardDto?,paymentsPage: freezed == paymentsPage ? _self.paymentsPage : paymentsPage // ignore: cast_nullable_to_non_nullable
as PageResponse<PaymentDto>?,feedHistoryPage: freezed == feedHistoryPage ? _self.feedHistoryPage : feedHistoryPage // ignore: cast_nullable_to_non_nullable
as PageResponse<FeedAllocationDto>?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,currentPaymentPage: null == currentPaymentPage ? _self.currentPaymentPage : currentPaymentPage // ignore: cast_nullable_to_non_nullable
as int,currentFeedPage: null == currentFeedPage ? _self.currentFeedPage : currentFeedPage // ignore: cast_nullable_to_non_nullable
as int,selectedPeriod: null == selectedPeriod ? _self.selectedPeriod : selectedPeriod // ignore: cast_nullable_to_non_nullable
as YearMonth,
  ));
}

/// Create a copy of MemberDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YearMonthCopyWith<$Res> get selectedPeriod {
  
  return $YearMonthCopyWith<$Res>(_self.selectedPeriod, (value) {
    return _then(_self.copyWith(selectedPeriod: value));
  });
}
}

// dart format on
