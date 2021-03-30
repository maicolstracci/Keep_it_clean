enum BlocStateEnum { INITIAL, LOADING, DONE, ERROR }

class BlocState<T> {
  T data;
  BlocStateEnum state;

  BlocState({this.data, this.state});
}
