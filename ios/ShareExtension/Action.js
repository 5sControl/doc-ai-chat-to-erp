var ExtensionPreprocessingJS = {
  run: function(arguments) {
    arguments.completionFunction({
      "title": document.title,
      "url": document.URL
    });
  }
};
