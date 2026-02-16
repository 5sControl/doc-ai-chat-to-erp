// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get common_continue => 'Continuar';

  @override
  String get common_select => 'Seleccionar';

  @override
  String get common_ok => 'OK';

  @override
  String get common_error => 'Error';

  @override
  String get onboarding_translateSummarizationTo => 'Traducir los resúmenes a';

  @override
  String get onboarding_goodbyeInfoOverload =>
      '¡Adiós a la sobrecarga de información!';

  @override
  String get onboarding_oneClickShareToGetSummary =>
      'Un clic en \"Compartir\" para obtener un resumen';

  @override
  String get onboarding_welcomeTitle => 'Bienvenido a Summify';

  @override
  String get onboarding_welcomeSubtitle => 'Resumidor IA personal';

  @override
  String get settings_profile => 'Perfil';

  @override
  String get settings_general => 'General';

  @override
  String get settings_interfaceLanguage => 'Idioma de la interfaz';

  @override
  String get settings_translationLanguage => 'Idioma de traducción';

  @override
  String get settings_selectLanguageTitle => 'Selecciona el idioma';

  @override
  String get wordTapHint_title => 'Traducción de palabras';

  @override
  String get wordTapHint_message =>
      'Pulsa en una palabra para obtener su traducción.';

  @override
  String get wordTapHint_dontShowAgain => 'No volver a mostrar';

  @override
  String get wordTapHint_showLater => 'Mostrar más tarde';

  @override
  String get paywall_beSmartWithYourTime => '¡Aprovecha tu tiempo!';

  @override
  String get paywall_payWeekly => 'Pagar semanalmente';

  @override
  String get paywall_payAnnually => 'Pagar anualmente';

  @override
  String paywall_saveUpTo(Object amount) {
    return 'Ahorra hasta $amount\\\$';
  }

  @override
  String get paywall_buy => 'COMPRAR';

  @override
  String get paywall_andGetOn => 'Y OBTÉN EN';

  @override
  String get paywall_forFree => '¡GRATIS!';

  @override
  String get paywall_12Months => '12 meses';

  @override
  String get paywall_1Week => '1 semana';

  @override
  String get paywall_1Month => '1 mes';

  @override
  String get paywall_1WeekMultiline => '1 semana';

  @override
  String get paywall_1MonthMultiline => '1 mes';

  @override
  String get paywall_12MonthsMultiline => '12 meses';

  @override
  String get paywall_accessAllPremiumCancelAnytime =>
      'Accede a todas las funciones premium. Cancela cuando quieras';

  @override
  String paywall_pricePerYear(Object price) {
    return '$price/año';
  }

  @override
  String paywall_pricePerWeek(Object price) {
    return '$price/semana';
  }

  @override
  String get paywall_termsOfUse => 'Términos de uso';

  @override
  String get paywall_restorePurchase => 'Restaurar compra';

  @override
  String get paywall_privacyPolicy => 'Política de privacidad';

  @override
  String get paywall_unlimitedSummaries => 'Resúmenes ilimitados';

  @override
  String get paywall_documentResearch => 'Investigación de documentos';

  @override
  String get paywall_briefAndDeepSummary => 'Resumen breve y profundo';

  @override
  String get paywall_translation => 'Traducción';

  @override
  String get paywall_addToChromeForFree => 'Añadir a Chrome GRATIS';

  @override
  String get offer_needMoreSummaries => '¿Necesita éxito?';

  @override
  String get offer_maximizeYourProductivity => '¡Maximiza tu productividad!';

  @override
  String get offer_outOfSummaries => '¿Sin resúmenes?';

  @override
  String get offer_maximizeProductivityAndEfficiency =>
      '¡Maximiza tu productividad y eficiencia!';

  @override
  String get offer_getMoreInNoTime => '¡Obtén más en un instante!';

  @override
  String get offer_goUnlimited => 'Activar ilimitado';

  @override
  String get bundle_subscriptionsNotAvailable => 'Suscripciones no disponibles';

  @override
  String get bundle_getForFree => 'OBTÉN GRATIS';

  @override
  String get bundle_on => 'en';

  @override
  String get bundle_version => 'Versión';

  @override
  String get bundle_offer_unlockLimitless => 'Desbloquea infinitas';

  @override
  String get bundle_offer_possibilities => 'posibilidades';

  @override
  String get bundle_offer_endlessPossibilities => 'Posibilidades infinitas';

  @override
  String get bundle_offer_with50Off => 'con 50% de descuento';

  @override
  String get bundle_offer_get4UnlimitedApps => 'Obtén 4 apps ilimitadas';

  @override
  String get bundle_tabBundle => 'Paquete';

  @override
  String get bundle_tabUnlimited => 'Ilimitado';

  @override
  String get purchase_youAreTheBest => '¡Eres el mejor!';

  @override
  String get purchase_get => 'Obtén';

  @override
  String get purchase_versionForFree => '¡la versión gratis!';

  @override
  String get purchase_copyLink => 'Copiar enlace';

  @override
  String get purchase_collectYourGift => 'Recoger tu regalo';

  @override
  String get purchase_enterYourEmail => 'Introduce tu correo';

  @override
  String get summary_couldNotOpenURL => 'No se pudo abrir la URL';

  @override
  String get summary_couldNotOpenFile => 'No se pudo abrir el archivo';

  @override
  String get summary_originalFileNoLongerAvailable =>
      'El archivo original ya no está disponible';

  @override
  String get summary_filePathNotFound => 'No se encontró la ruta del archivo';

  @override
  String get summary_originalTextNotAvailable => 'Texto original no disponible';

  @override
  String get summary_breakThroughTheLimits => 'Supera los límites';

  @override
  String get summary_sourceNotAvailable =>
      'El texto fuente no está disponible para este tipo de resumen';

  @override
  String get research_chipAskQuestion => 'Ask a question';

  @override
  String get research_chipMermaidDiagram => 'Mermaid diagram';

  @override
  String get research_diagramRequest =>
      'Create a Mermaid diagram for this document';

  @override
  String get research_mermaidCopy => 'Copy';

  @override
  String get research_mermaidOpenLive => 'Open in Mermaid Live';

  @override
  String get quiz_failedToGenerate => 'Error al generar el quiz';

  @override
  String get quiz_retry => 'Reintentar';

  @override
  String get quiz_knowledgeQuiz => 'Quiz de conocimientos';

  @override
  String get quiz_testYourUnderstanding =>
      'Pon a prueba tu comprensión de este documento';

  @override
  String get quiz_questions => 'Preguntas';

  @override
  String get quiz_estimatedTime => 'Tiempo estimado';

  @override
  String get quiz_minutes => 'min';

  @override
  String get quiz_startQuiz => 'Iniciar quiz';

  @override
  String get quiz_explanation => 'Explicación';

  @override
  String get quiz_previous => 'Anterior';

  @override
  String get quiz_viewResults => 'Ver resultados';

  @override
  String get quiz_nextQuestion => 'Siguiente pregunta';

  @override
  String quiz_questionNofTotal(Object current, Object total) {
    return 'Pregunta $current de $total';
  }

  @override
  String get quiz_overview => 'Resumen';

  @override
  String get quiz_stepByStep => 'Paso a paso';

  @override
  String get quiz_excellent => '¡Excelente! 🎉';

  @override
  String get quiz_goodJob => '¡Buen trabajo! 👍';

  @override
  String get quiz_notBad => '¡Nada mal! Sigue aprendiendo 📚';

  @override
  String get quiz_keepPracticing => '¡Sigue practicando! 💪';

  @override
  String get quiz_correct => 'Correcto';

  @override
  String get quiz_incorrect => 'Incorrecto';

  @override
  String get quiz_total => 'Total';

  @override
  String get quiz_retakeQuiz => 'Repetir quiz';

  @override
  String get quiz_reviewAnswers => 'Revisar respuestas';

  @override
  String quiz_question(Object number) {
    return 'Pregunta $number';
  }

  @override
  String get savedCards_title => 'Tarjetas guardadas';

  @override
  String get savedCards_removeBookmarkTitle => '¿Eliminar marcador?';

  @override
  String get savedCards_removeBookmarkMessage =>
      'Esta tarjeta se eliminará de tus marcadores.';

  @override
  String get savedCards_cancel => 'Cancelar';

  @override
  String get savedCards_remove => 'Eliminar';

  @override
  String get savedCards_cardRemoved => 'Tarjeta eliminada de marcadores';

  @override
  String get savedCards_sourceNotFound => 'Documento fuente no encontrado';

  @override
  String get savedCards_clearAll => 'Limpiar todo';

  @override
  String get savedCards_searchHint => 'Buscar tarjetas guardadas...';

  @override
  String savedCards_cardCount(Object count) {
    return '$count tarjeta';
  }

  @override
  String savedCards_cardsCount(Object count) {
    return '$count tarjetas';
  }

  @override
  String get savedCards_clearFilters => 'Limpiar filtros';

  @override
  String get savedCards_noCardsYet => 'Aún no hay tarjetas guardadas';

  @override
  String get savedCards_saveCardsToAccess =>
      'Guarda tarjetas interesantes para acceder a ellas más tarde';

  @override
  String get savedCards_noCardsFound => 'No se encontraron tarjetas';

  @override
  String get savedCards_tryAdjustingFilters => 'Intenta ajustar los filtros';

  @override
  String get savedCards_clearAllTitle =>
      '¿Eliminar todas las tarjetas guardadas?';

  @override
  String get savedCards_clearAllMessage =>
      'Esto eliminará todas tus tarjetas guardadas. Esta acción no se puede deshacer.';

  @override
  String get savedCards_allCleared =>
      'Todas las tarjetas guardadas han sido eliminadas';

  @override
  String get home_search => 'Buscar';

  @override
  String get info_productivityInfo => 'Información de productividad';

  @override
  String get info_words => 'Palabras';

  @override
  String get info_time => 'Tiempo, ';

  @override
  String get info_timeMin => '(min)';

  @override
  String get info_saved => 'Ahorrado, ';

  @override
  String get info_original => 'Original';

  @override
  String get info_brief => 'Breve';

  @override
  String get info_deep => 'Profundo';

  @override
  String get extension_growYourProductivity => 'AUMENTA TU PRODUCTIVIDAD';

  @override
  String get extension_copyLink => 'Copiar enlace';

  @override
  String get extension_sendLink => 'Enviar enlace';

  @override
  String get extension_enterYourEmail => 'Introduce tu correo';

  @override
  String get auth_skip => 'Omitir';

  @override
  String get auth_hello => '¡Hola!';

  @override
  String get auth_fillInToGetStarted => 'Completa para comenzar';

  @override
  String get auth_emailAddress => 'Dirección de correo';

  @override
  String get auth_password => 'Contraseña';

  @override
  String get auth_forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get auth_loginIn => 'Iniciar sesión';

  @override
  String get auth_orLoginWith => 'O inicia sesión con';

  @override
  String get auth_dontHaveAccount => '¿No tienes cuenta? ';

  @override
  String get auth_registerNow => 'Regístrate ahora';

  @override
  String get auth_passwordCannotBeEmpty => 'La contraseña no puede estar vacía';

  @override
  String get auth_passwordMustBe6Chars =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get registration_skip => 'Omitir';

  @override
  String get registration_registerAndGet => 'Regístrate y obtén';

  @override
  String get registration_2Free => '2 ';

  @override
  String get registration_1FreePerDay => '1 free per day';

  @override
  String get registration_unlimited => 'resúmenes ilimitados';

  @override
  String get limit_onePerDay => '1 free summary per day';

  @override
  String get limit_resetsTomorrow =>
      'Limit resets at midnight. You get 1 more free summary tomorrow.';

  @override
  String get limit_usedTodayTryTomorrow =>
      'You\'ve used your 1 free summary today. Come back tomorrow for another one, or go unlimited.';

  @override
  String get limit_blockedCardOverlay =>
      'This summary was created over your daily limit. Unlock with Premium. Tomorrow you get 1 new free summary.';

  @override
  String get giftCode_menuTitle => 'Canjear código de regalo';

  @override
  String get giftCode_dialogTitle => 'Introduce el código de regalo';

  @override
  String get giftCode_placeholder => 'Código';

  @override
  String get giftCode_activate => 'Activar';

  @override
  String giftCode_success(int count) {
    return 'Código de regalo aceptado. Has recibido $count documentos.';
  }

  @override
  String get giftCode_error => 'Código inválido o ya utilizado.';

  @override
  String get registration_summarizations => 'gratis';

  @override
  String get registration_name => 'Nombre';

  @override
  String get registration_emailAddress => 'Dirección de correo';

  @override
  String get registration_password => 'Contraseña';

  @override
  String get registration_confirmPassword => 'Confirmar contraseña';

  @override
  String get registration_register => 'Registrarse';

  @override
  String get registration_orLoginWith => 'O inicia sesión con';

  @override
  String get registration_alreadyHaveAccount => '¿Ya tienes cuenta? ';

  @override
  String get registration_loginNow => 'Inicia sesión ahora';

  @override
  String get registration_passwordMismatch => 'Las contraseñas no coinciden';

  @override
  String get request_secureSum => 'Resumen seguro';

  @override
  String get request_readMyBook => 'Leer mi libro';

  @override
  String get request_speechToText => 'Función de voz a texto';

  @override
  String get request_textToSpeech => 'Función de texto a voz';

  @override
  String get request_addLanguage => 'Agregar idioma';

  @override
  String get request_orWriteMessage => 'O escríbenos un mensaje';

  @override
  String get request_name => 'Nombre';

  @override
  String get request_enterYourName => 'Introduce tu nombre';

  @override
  String get request_email => 'Correo';

  @override
  String get request_enterYourEmail => 'Introduce tu correo';

  @override
  String get request_message => 'Mensaje';

  @override
  String get request_enterYourRequest => 'Introduce tu solicitud';

  @override
  String get request_submit => 'Enviar';

  @override
  String get request_selectLanguage => 'Seleccionar idioma';

  @override
  String get ttsDownloadDialogTitle => 'Downloading voice model';

  @override
  String get ttsDownloadDialogBody =>
      'Please keep the app open while we download the voice resources.';

  @override
  String get ttsModelReadyTitle => 'Voice model ready';

  @override
  String get ttsModelReadyMessage =>
      'Voice model downloaded successfully. You can choose a voice in Settings.';

  @override
  String get knowledgeCards_regenerate => 'Regenerar';

  @override
  String get knowledgeCards_regenerateTitle =>
      '¿Regenerar tarjetas de conocimiento?';

  @override
  String get knowledgeCards_regenerateMessage =>
      'Las tarjetas actuales se eliminarán y se generarán nuevas. ¿Continuar?';

  @override
  String get knowledgeCards_cancel => 'Cancelar';

  @override
  String knowledgeCards_voiceAnswerTitle(Object term) {
    return '¿Cómo entiende el término \"$term\"?';
  }

  @override
  String get knowledgeCards_voiceAnswerSend => 'Enviar';

  @override
  String get knowledgeCards_voiceAnswerStubMessage =>
      'La verificación de su respuesta estará disponible en la aplicación pronto.';

  @override
  String get knowledgeCards_voiceAnswerError =>
      'No se pudo verificar la respuesta. Compruebe su conexión e inténtelo de nuevo.';

  @override
  String get knowledgeCards_tapMicToSpeak => 'Toque el micrófono para hablar';

  @override
  String get knowledgeCards_listening => 'Escuchando...';
}
