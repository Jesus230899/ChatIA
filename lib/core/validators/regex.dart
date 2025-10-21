class Regex {
  static bool fullName(String value) {
    const regex = r"^[a-zñA-ZÑ ]{2,80}$";
    if (RegExp(regex).hasMatch(value)) return true;
    return false;
  }

  static bool email(String value) {
    const regex =
        r"""^[\w\.-]{1,150}@[a-zA-Z0-9-]{1,100}(\.[a-zA-Z]{2,10}){1,2}$""";
    if (RegExp(regex).hasMatch(value)) return true;
    return false;
  }


  static bool password(String value) {
    const regex = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
    if (RegExp(regex).hasMatch(value)) return true;
    return false;
  }
}
