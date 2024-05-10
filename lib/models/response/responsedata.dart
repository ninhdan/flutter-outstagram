class ResponseData<T>{
  int? status;
  T? data;
  String? message;
  ResponseData({this.status, this.data, this.message});
}