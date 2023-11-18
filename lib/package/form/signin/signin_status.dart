enum SigninStatus {
  inProgress,

  // show progress indicator
  waiting,

  // show error under form fields
  editError,

  // sign in
  signinSuccess,

  // reset password
  invalidMailForResetPassword,
  userNotFound,
  resetPasswordSuccess,

  // snack bar notified errors
  invalidCredentials, // TODO : l10n
  unexpectedError,
}
