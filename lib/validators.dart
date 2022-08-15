/// Ensure that [value] is not empty.
String? validateNonEmptyValue({
  required final String? value,
  final String emptyValueMessage = 'You must provide a value',
}) {
  if (value == null || value.isEmpty) {
    return emptyValueMessage;
  }
  return null;
}
