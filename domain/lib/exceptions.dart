abstract class WhoWritesException implements Exception {}

class UnexpectedException implements WhoWritesException {}

class EmptyFormFieldException implements WhoWritesException {}

class InvalidFormFieldException implements WhoWritesException {}

class FirebaseUserNotFoundedException implements WhoWritesException {}

class FirebaseWrongPassWordException implements WhoWritesException {}

class FirebaseInvalidEmailException implements WhoWritesException {}

class FirebaseUserDisabledException implements WhoWritesException {}

class FirebaseWeakPasswordException implements WhoWritesException {}

class FirebaseEmailAlreadyExistsException implements WhoWritesException {}
