enum BlocStateEnum { IDLE, LOADING, DONE, ERROR }

class BlocState<T> {
  T data;
  BlocStateEnum state;

  BlocState({this.data, this.state});
}
