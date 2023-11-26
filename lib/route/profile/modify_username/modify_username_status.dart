enum ModifyUsernameStatus {
  inProgress,

  // show progress indicator
  waiting,

  // show error under form fields
  editError,

  // show error in snack bar
  unexpectedError,

  // name modified
  success,
}
