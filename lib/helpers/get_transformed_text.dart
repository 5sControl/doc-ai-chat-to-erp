String getTransformedText({required String text}) {
  return text
      .replaceFirst('Summary:', '<b>Summary:</b>')
      .replaceFirst('In-depth Analysis:', '<b>In-depth Analysis:</b>')
      .replaceFirst('Key Points:', '<b>Key Points:</b>')
      .replaceFirst('Additional Context:', '<b>Additional Context:</b>')
      .replaceFirst('Supporting Evidence:', '<b>Supporting Evidence:</b>')
      .replaceFirst('Implications or Conclusions:',
          '<b>Implications or Conclusions:</b>')
      .replaceAll('\n\n', '\n');
}
