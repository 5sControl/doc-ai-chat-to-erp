// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get common_continue => 'Continuar';

  @override
  String get common_select => 'Selecionar';

  @override
  String get common_ok => 'OK';

  @override
  String get common_error => 'Erro';

  @override
  String get onboarding_translateSummarizationTo => 'Traduzir os resumos para';

  @override
  String get onboarding_goodbyeInfoOverload =>
      'Adeus à sobrecarga de informação!';

  @override
  String get onboarding_oneClickShareToGetSummary =>
      'Um clique em \"Compartilhar\" para obter o resumo';

  @override
  String get onboarding_welcomeTitle => 'Bem-vindo ao Summify';

  @override
  String get onboarding_welcomeSubtitle => 'Resumidor de IA pessoal';

  @override
  String get settings_profile => 'Perfil';

  @override
  String get settings_general => 'Geral';

  @override
  String get settings_interfaceLanguage => 'Idioma da interface';

  @override
  String get settings_translationLanguage => 'Idioma de tradução';

  @override
  String get settings_selectLanguageTitle => 'Selecionar idioma';

  @override
  String get settings_group_subscription => 'Assinatura e mais';

  @override
  String get settings_group_about => 'Sobre';

  @override
  String get settings_group_support => 'Suporte';

  @override
  String get settings_group_account => 'Conta';

  @override
  String get settings_group_voice => 'Voz';

  @override
  String get wordTapHint_title => 'Tradução de palavras';

  @override
  String get wordTapHint_message => 'Toque numa palavra para obter a tradução.';

  @override
  String get wordTapHint_dontShowAgain => 'Não mostrar novamente';

  @override
  String get wordTapHint_showLater => 'Mostrar mais tarde';

  @override
  String get paywall_beSmartWithYourTime => 'Use seu tempo com inteligência!';

  @override
  String get paywall_payWeekly => 'Pagar semanalmente';

  @override
  String get paywall_payAnnually => 'Pagar anualmente';

  @override
  String paywall_saveUpTo(Object amount) {
    return 'Economize até $amount\\\$';
  }

  @override
  String get paywall_buy => 'COMPRAR';

  @override
  String get paywall_andGetOn => 'E RECEBA NO';

  @override
  String get paywall_forFree => 'GRÁTIS!';

  @override
  String get paywall_12Months => '12 meses';

  @override
  String get paywall_1Week => '1 semana';

  @override
  String get paywall_1Month => '1 mês';

  @override
  String get paywall_1WeekMultiline => '1 semana';

  @override
  String get paywall_1MonthMultiline => '1 mês';

  @override
  String get paywall_12MonthsMultiline => '12 meses';

  @override
  String get paywall_accessAllPremiumCancelAnytime =>
      'Acesse todos os recursos premium! Cancele quando quiser';

  @override
  String paywall_pricePerYear(Object price) {
    return '$price/ano';
  }

  @override
  String paywall_pricePerWeek(Object price) {
    return '$price/semana';
  }

  @override
  String get paywall_termsOfUse => 'Termos de uso';

  @override
  String get paywall_restorePurchase => 'Restaurar compra';

  @override
  String get paywall_privacyPolicy => 'Política de privacidade';

  @override
  String get paywall_unlimitedSummaries => 'Resumos ilimitados';

  @override
  String get paywall_documentResearch => 'Pesquisa de documentos';

  @override
  String get paywall_briefAndDeepSummary => 'Resumo breve e profundo';

  @override
  String get paywall_translation => 'Tradução';

  @override
  String get paywall_addToChromeForFree => 'Adicionar ao Chrome GRÁTIS';

  @override
  String get offer_needMoreSummaries => 'Você precisa de sucesso?';

  @override
  String get offer_maximizeYourProductivity => 'Maximize sua produtividade!';

  @override
  String get offer_outOfSummaries => 'Sem resumos?';

  @override
  String get offer_maximizeProductivityAndEfficiency =>
      'Maximize sua produtividade e eficiência!';

  @override
  String get offer_getMoreInNoTime => 'Faça mais em pouco tempo!';

  @override
  String get offer_goUnlimited => 'Ativar ilimitado';

  @override
  String get bundle_subscriptionsNotAvailable => 'Assinaturas indisponíveis';

  @override
  String get bundle_getForFree => 'OBTER GRÁTIS';

  @override
  String get bundle_on => 'na';

  @override
  String get bundle_version => 'Versão';

  @override
  String get bundle_offer_unlockLimitless => 'Desbloqueie infinitas';

  @override
  String get bundle_offer_possibilities => 'possibilidades';

  @override
  String get bundle_offer_endlessPossibilities => 'Possibilidades infinitas';

  @override
  String get bundle_offer_with50Off => 'com 50% de desconto';

  @override
  String get bundle_offer_get4UnlimitedApps => 'Obtenha 4 apps ilimitados';

  @override
  String get bundle_tabBundle => 'Pacote';

  @override
  String get bundle_tabUnlimited => 'Ilimitado';

  @override
  String get purchase_youAreTheBest => 'Você é o melhor!';

  @override
  String get purchase_get => 'Obtenha';

  @override
  String get purchase_versionForFree => 'a versão grátis!';

  @override
  String get purchase_copyLink => 'Copiar link';

  @override
  String get purchase_collectYourGift => 'Resgatar seu presente';

  @override
  String get purchase_enterYourEmail => 'Digite seu e-mail';

  @override
  String get summary_couldNotOpenURL => 'Não foi possível abrir o URL';

  @override
  String get summary_couldNotOpenFile => 'Não foi possível abrir o arquivo';

  @override
  String get summary_originalFileNoLongerAvailable =>
      'O arquivo original não está mais disponível';

  @override
  String get summary_filePathNotFound => 'Caminho do arquivo não encontrado';

  @override
  String get summary_originalTextNotAvailable =>
      'Texto original não disponível';

  @override
  String get summary_breakThroughTheLimits => 'Supere os limites';

  @override
  String get summary_sourceNotAvailable =>
      'O texto de origem não está disponível para este tipo de resumo';

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
  String get diagram_share => 'Compartilhar';

  @override
  String get quiz_failedToGenerate => 'Falha ao gerar o quiz';

  @override
  String get quiz_retry => 'Tentar novamente';

  @override
  String get quiz_knowledgeQuiz => 'Quiz de conhecimento';

  @override
  String get quiz_testYourUnderstanding =>
      'Teste sua compreensão deste documento';

  @override
  String get quiz_questions => 'Perguntas';

  @override
  String get quiz_estimatedTime => 'Tempo estimado';

  @override
  String get quiz_minutes => 'min';

  @override
  String get quiz_startQuiz => 'Iniciar quiz';

  @override
  String get quiz_explanation => 'Explicação';

  @override
  String get quiz_previous => 'Anterior';

  @override
  String get quiz_viewResults => 'Ver resultados';

  @override
  String get quiz_nextQuestion => 'Próxima pergunta';

  @override
  String quiz_questionNofTotal(Object current, Object total) {
    return 'Pergunta $current de $total';
  }

  @override
  String get quiz_overview => 'Visão geral';

  @override
  String get quiz_stepByStep => 'Passo a passo';

  @override
  String get quiz_excellent => 'Excelente! 🎉';

  @override
  String get quiz_goodJob => 'Bom trabalho! 👍';

  @override
  String get quiz_notBad => 'Nada mal! Continue aprendendo 📚';

  @override
  String get quiz_keepPracticing => 'Continue praticando! 💪';

  @override
  String get quiz_correct => 'Correto';

  @override
  String get quiz_incorrect => 'Incorreto';

  @override
  String get quiz_total => 'Total';

  @override
  String get quiz_retakeQuiz => 'Refazer quiz';

  @override
  String get quiz_reviewAnswers => 'Revisar respostas';

  @override
  String quiz_question(Object number) {
    return 'Pergunta $number';
  }

  @override
  String get savedCards_title => 'Cartões salvos';

  @override
  String get savedCards_removeBookmarkTitle => 'Remover marcador?';

  @override
  String get savedCards_removeBookmarkMessage =>
      'Este cartão será removido dos seus marcadores.';

  @override
  String get savedCards_cancel => 'Cancelar';

  @override
  String get savedCards_remove => 'Remover';

  @override
  String get savedCards_cardRemoved => 'Cartão removido dos marcadores';

  @override
  String get savedCards_sourceNotFound => 'Documento fonte não encontrado';

  @override
  String get savedCards_clearAll => 'Limpar tudo';

  @override
  String get savedCards_searchHint => 'Buscar cartões salvos...';

  @override
  String savedCards_cardCount(Object count) {
    return '$count cartão';
  }

  @override
  String savedCards_cardsCount(Object count) {
    return '$count cartões';
  }

  @override
  String get savedCards_clearFilters => 'Limpar filtros';

  @override
  String get savedCards_noCardsYet => 'Ainda não há cartões salvos';

  @override
  String get savedCards_saveCardsToAccess =>
      'Salve cartões interessantes para acessá-los mais tarde';

  @override
  String get savedCards_noCardsFound => 'Nenhum cartão encontrado';

  @override
  String get savedCards_tryAdjustingFilters => 'Tente ajustar os filtros';

  @override
  String get savedCards_clearAllTitle => 'Limpar todos os cartões salvos?';

  @override
  String get savedCards_clearAllMessage =>
      'Isso removerá todos os seus cartões salvos. Esta ação não pode ser desfeita.';

  @override
  String get savedCards_allCleared => 'Todos os cartões salvos foram limpos';

  @override
  String get home_search => 'Buscar';

  @override
  String get info_productivityInfo => 'Info de produtividade';

  @override
  String get info_words => 'Palavras';

  @override
  String get info_time => 'Tempo, ';

  @override
  String get info_timeMin => '(min)';

  @override
  String get info_saved => 'Economizado, ';

  @override
  String get info_original => 'Original';

  @override
  String get info_brief => 'Breve';

  @override
  String get info_deep => 'Profundo';

  @override
  String get extension_growYourProductivity => 'AUMENTE SUA PRODUTIVIDADE';

  @override
  String get extension_copyLink => 'Copiar link';

  @override
  String get extension_sendLink => 'Enviar link';

  @override
  String get extension_enterYourEmail => 'Digite seu e-mail';

  @override
  String get auth_skip => 'Pular';

  @override
  String get auth_hello => 'Olá!';

  @override
  String get auth_fillInToGetStarted => 'Preencha para começar';

  @override
  String get auth_emailAddress => 'Endereço de e-mail';

  @override
  String get auth_password => 'Senha';

  @override
  String get auth_forgotPassword => 'Esqueceu a senha?';

  @override
  String get auth_loginIn => 'Entrar';

  @override
  String get auth_orLoginWith => 'Ou entre com';

  @override
  String get auth_dontHaveAccount => 'Não tem uma conta? ';

  @override
  String get auth_registerNow => 'Registre-se agora';

  @override
  String get auth_passwordCannotBeEmpty => 'A senha não pode estar vazia';

  @override
  String get auth_passwordMustBe6Chars =>
      'A senha deve ter pelo menos 6 caracteres';

  @override
  String get registration_skip => 'Pular';

  @override
  String get registration_registerAndGet => 'Registre-se e ganhe';

  @override
  String get registration_2Free => '2 ';

  @override
  String get registration_1FreePerDay => '1 free per day';

  @override
  String get registration_unlimited => 'resumos ilimitados';

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
  String get giftCode_menuTitle => 'Resgatar código presente';

  @override
  String get giftCode_dialogTitle => 'Introduza o código presente';

  @override
  String get giftCode_placeholder => 'Código';

  @override
  String get giftCode_activate => 'Ativar';

  @override
  String giftCode_success(int count) {
    return 'Código presente aceite. Recebeu $count documentos.';
  }

  @override
  String get giftCode_error => 'Código inválido ou já utilizado.';

  @override
  String get registration_summarizations => 'grátis';

  @override
  String get registration_name => 'Nome';

  @override
  String get registration_emailAddress => 'Endereço de e-mail';

  @override
  String get registration_password => 'Senha';

  @override
  String get registration_confirmPassword => 'Confirmar senha';

  @override
  String get registration_register => 'Registrar';

  @override
  String get registration_orLoginWith => 'Ou entre com';

  @override
  String get registration_alreadyHaveAccount => 'Já tem uma conta? ';

  @override
  String get registration_loginNow => 'Entre agora';

  @override
  String get registration_passwordMismatch => 'As senhas não correspondem';

  @override
  String get request_secureSum => 'Resumo seguro';

  @override
  String get request_readMyBook => 'Ler meu livro';

  @override
  String get request_speechToText => 'Recurso de fala para texto';

  @override
  String get request_textToSpeech => 'Recurso de texto para fala';

  @override
  String get request_addLanguage => 'Adicionar idioma';

  @override
  String get request_orWriteMessage => 'Ou escreva-nos uma mensagem';

  @override
  String get request_name => 'Nome';

  @override
  String get request_enterYourName => 'Digite seu nome';

  @override
  String get request_email => 'E-mail';

  @override
  String get request_enterYourEmail => 'Digite seu e-mail';

  @override
  String get request_message => 'Mensagem';

  @override
  String get request_enterYourRequest => 'Digite sua solicitação';

  @override
  String get request_submit => 'Enviar';

  @override
  String get request_selectLanguage => 'Selecionar idioma';

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
      'Regenerar cartões de conhecimento?';

  @override
  String get knowledgeCards_regenerateMessage =>
      'Os cartões atuais serão removidos e novos serão gerados. Continuar?';

  @override
  String get knowledgeCards_cancel => 'Cancelar';

  @override
  String knowledgeCards_voiceAnswerTitle(Object term) {
    return 'Como você entende o termo \"$term\"?';
  }

  @override
  String get knowledgeCards_voiceAnswerTask =>
      'Explique com suas próprias palavras';

  @override
  String get knowledgeCards_voiceAnswerSend => 'Enviar';

  @override
  String get knowledgeCards_voiceAnswerStubMessage =>
      'A verificação da sua resposta estará disponível no aplicativo em breve.';

  @override
  String get knowledgeCards_voiceAnswerError =>
      'Não foi possível verificar a resposta. Verifique sua conexão e tente novamente.';

  @override
  String get knowledgeCards_tapMicToSpeak => 'Toque no microfone para falar';

  @override
  String get knowledgeCards_listening => 'Ouvindo...';
}
