String getTransformedText({required String text}) {
  return text
      .replaceAll('\n', '')
      .replaceAll('\n\n', '\n')
      .replaceAll('\n\n\n', '\n')
      .replaceAll('.- ', '.\n- ')
      .replaceFirst('Summary:', '<b>Summary:\n</b>')
      .replaceFirst('Key Points:', '<b>\n\nKey Points:\n</b>')
      .replaceFirst('In-depth Analysis:', '<b>\n\nIn-depth Analysis:\n</b>')
      .replaceFirst('Additional Context:', '<b>\n\nAdditional Context:\n</b>')
      .replaceFirst('Supporting Evidence:', '<b>\n\nSupporting Evidence:\n</b>')
      .replaceFirst('Implications or Conclusions:',
          '<b>\n\nImplications or Conclusions:\n</b>');
}
