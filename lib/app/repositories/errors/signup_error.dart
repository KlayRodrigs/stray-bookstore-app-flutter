enum SignupError {
  emailAlreadyInUse('Este e-mail já está em uso. Por favor, faça login.'),
  invalidEmail('Formato de e-mail inválido. Por favor, verifique seu endereço de e-mail.'),
  weakPassword('Senha muito fraca. Por favor, use uma senha mais forte.'),
  unknown('Ocorreu um erro inesperado. Por favor, tente novamente.');

  final String message;
  const SignupError(this.message);
}
