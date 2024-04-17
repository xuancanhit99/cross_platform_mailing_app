enum SmtpConnectState {
  initial,
  success,
  failure,
  retrying, // new state fix snackBar just show 1 time
  serverSelected,
}