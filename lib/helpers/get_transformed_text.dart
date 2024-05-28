// String getTransformedText({required String text}) {
//   return text
//       .replaceAll('\n', '')
//       .replaceAll('\n\n', '\n')
//       .replaceAll('\n\n\n', '\n')
//       .replaceAll('.- ', '.\n- ')
//       .replaceFirst('Summary:', '<b>Summary:\n</b>')
//       .replaceFirst('Key Points:', '<b>\n\nKey Points:\n</b>')
//       .replaceFirst('In-depth Analysis:', '<b>\n\nIn-depth Analysis:\n</b>')
//       .replaceFirst('Additional Context:', '<b>\n\nAdditional Context:\n</b>')
//       .replaceFirst('Supporting Evidence:', '<b>\n\nSupporting Evidence:\n</b>')
//       .replaceFirst('Implications or Conclusions:',
//           '<b>\n\nImplications or Conclusions:\n</b>');
// }

String getTransformedText({required String text}) {
  return text
      .replaceAll('\n', '')
      .replaceAll('   ', '')
      .replaceAll('\n\n', '\n')
      .replaceAll('\n\n\n', '\n')
      .replaceAll('.- ', '.\n- ')
      .replaceFirst('Summary:', 'Summary:\n')
      .replaceFirst('Key Points:', '\n\nKey Points:\n')
      .replaceFirst('In-depth Analysis:', '\n\nIn-depth Analysis:\n')
      .replaceFirst('Additional Context:', '\n\nAdditional Context:\n')
      .replaceFirst('Supporting Evidence:', '\n\nSupporting Evidence:\n')
      .replaceFirst(
          'Implications or Conclusions:', '\n\nImplications or Conclusions:\n');
}
