enum SigninStatus {
  inProgress,

  // show error under form fields
  editError,

  // sign in
  signinSuccess,

  // reset password
  invalidMailForResetPassword,
  resetPasswordSuccess,

  // snack bar notified errors
  userNotFound,
  wrongPassword,
  unexpectedError,
}
