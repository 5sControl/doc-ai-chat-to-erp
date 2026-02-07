// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get common_continue => '继续';

  @override
  String get common_select => '选择';

  @override
  String get common_ok => '好';

  @override
  String get common_error => '错误';

  @override
  String get onboarding_translateSummarizationTo => '将摘要翻译为';

  @override
  String get onboarding_goodbyeInfoOverload => '告别信息过载！';

  @override
  String get onboarding_oneClickShareToGetSummary => '一键“分享”获取摘要';

  @override
  String get onboarding_welcomeTitle => '欢迎使用 Summify';

  @override
  String get onboarding_welcomeSubtitle => '个人 AI 摘要工具';

  @override
  String get settings_profile => '个人资料';

  @override
  String get settings_general => '通用';

  @override
  String get settings_interfaceLanguage => '界面语言';

  @override
  String get settings_translationLanguage => '翻译语言';

  @override
  String get settings_selectLanguageTitle => '选择语言';

  @override
  String get paywall_beSmartWithYourTime => '聪明地利用你的时间！';

  @override
  String get paywall_payWeekly => '按周付费';

  @override
  String get paywall_payAnnually => '按年付费';

  @override
  String paywall_saveUpTo(Object amount) {
    return '最多节省 $amount\\\$';
  }

  @override
  String get paywall_buy => '购买';

  @override
  String get paywall_andGetOn => '并在';

  @override
  String get paywall_forFree => '免费获得！';

  @override
  String get paywall_12Months => '12 个月';

  @override
  String get paywall_1Week => '1 周';

  @override
  String get paywall_1Month => '1 个月';

  @override
  String get paywall_1WeekMultiline => '1 周';

  @override
  String get paywall_1MonthMultiline => '1 个月';

  @override
  String get paywall_12MonthsMultiline => '12 个月';

  @override
  String get paywall_accessAllPremiumCancelAnytime => '解锁所有高级功能！随时取消';

  @override
  String paywall_pricePerYear(Object price) {
    return '$price/年';
  }

  @override
  String paywall_pricePerWeek(Object price) {
    return '$price/周';
  }

  @override
  String get paywall_termsOfUse => '使用条款';

  @override
  String get paywall_restorePurchase => '恢复购买';

  @override
  String get paywall_privacyPolicy => '隐私政策';

  @override
  String get paywall_unlimitedSummaries => '无限摘要';

  @override
  String get paywall_documentResearch => '文档研究';

  @override
  String get paywall_briefAndDeepSummary => '简短与深入摘要';

  @override
  String get paywall_translation => '翻译';

  @override
  String get paywall_addToChromeForFree => '免费添加到 Chrome';

  @override
  String get offer_needMoreSummaries => '需要更多摘要？';

  @override
  String get offer_maximizeYourProductivity => '提升你的效率！';

  @override
  String get offer_outOfSummaries => '摘要用完了？';

  @override
  String get offer_maximizeProductivityAndEfficiency => '提升你的效率和生产力！';

  @override
  String get offer_getMoreInNoTime => '立刻获得更多！';

  @override
  String get offer_15DeepSummariesDaily => '每天 15 条深入摘要';

  @override
  String get offer_goUnlimited => '开启无限';

  @override
  String get bundle_subscriptionsNotAvailable => '订阅不可用';

  @override
  String get bundle_getForFree => '免费获取';

  @override
  String get bundle_on => '在';

  @override
  String get bundle_version => '版本';

  @override
  String get bundle_offer_unlockLimitless => '解锁无限';

  @override
  String get bundle_offer_possibilities => '可能';

  @override
  String get bundle_offer_endlessPossibilities => '无限可能';

  @override
  String get bundle_offer_with50Off => '立减 50%';

  @override
  String get bundle_offer_get4UnlimitedApps => '获取 4 个无限应用';

  @override
  String get bundle_tabBundle => '套餐';

  @override
  String get bundle_tabUnlimited => '无限';

  @override
  String get purchase_youAreTheBest => '你太棒了！';

  @override
  String get purchase_get => '免费获取';

  @override
  String get purchase_versionForFree => '版本！';

  @override
  String get purchase_copyLink => '复制链接';

  @override
  String get purchase_collectYourGift => '领取礼物';

  @override
  String get purchase_enterYourEmail => '输入邮箱';

  @override
  String get summary_couldNotOpenURL => '无法打开URL';

  @override
  String get summary_couldNotOpenFile => '无法打开文件';

  @override
  String get summary_originalFileNoLongerAvailable => '原始文件不再可用';

  @override
  String get summary_filePathNotFound => '未找到文件路径';

  @override
  String get summary_originalTextNotAvailable => '原始文本不可用';

  @override
  String get summary_breakThroughTheLimits => '突破限制';

  @override
  String get summary_sourceTab => '来源';

  @override
  String get summary_sourceNotAvailable => '此类摘要无法使用源文本';

  @override
  String get quiz_failedToGenerate => '生成测验失败';

  @override
  String get quiz_retry => '重试';

  @override
  String get quiz_knowledgeQuiz => '知识测验';

  @override
  String get quiz_testYourUnderstanding => '测试您对此文档的理解';

  @override
  String get quiz_questions => '问题';

  @override
  String get quiz_estimatedTime => '预计时间';

  @override
  String get quiz_minutes => '分钟';

  @override
  String get quiz_startQuiz => '开始测验';

  @override
  String get quiz_explanation => '说明';

  @override
  String get quiz_previous => '上一题';

  @override
  String get quiz_viewResults => '查看结果';

  @override
  String get quiz_nextQuestion => '下一题';

  @override
  String quiz_questionNofTotal(Object current, Object total) {
    return '第$current题，共$total题';
  }

  @override
  String get quiz_overview => '概览';

  @override
  String get quiz_stepByStep => '逐步';

  @override
  String get quiz_excellent => '太棒了！🎉';

  @override
  String get quiz_goodJob => '做得好！👍';

  @override
  String get quiz_notBad => '不错！继续学习📚';

  @override
  String get quiz_keepPracticing => '继续练习！💪';

  @override
  String get quiz_correct => '正确';

  @override
  String get quiz_incorrect => '错误';

  @override
  String get quiz_total => '总计';

  @override
  String get quiz_retakeQuiz => '重做测验';

  @override
  String get quiz_reviewAnswers => '查看答案';

  @override
  String quiz_question(Object number) {
    return '第$number题';
  }

  @override
  String get savedCards_title => '已保存的卡片';

  @override
  String get savedCards_removeBookmarkTitle => '删除书签？';

  @override
  String get savedCards_removeBookmarkMessage => '此卡片将从您的书签中删除。';

  @override
  String get savedCards_cancel => '取消';

  @override
  String get savedCards_remove => '删除';

  @override
  String get savedCards_cardRemoved => '卡片已从书签中删除';

  @override
  String get savedCards_sourceNotFound => '未找到源文档';

  @override
  String get savedCards_clearAll => '全部清除';

  @override
  String get savedCards_searchHint => '搜索已保存的卡片...';

  @override
  String savedCards_cardCount(Object count) {
    return '$count张卡片';
  }

  @override
  String savedCards_cardsCount(Object count) {
    return '$count张卡片';
  }

  @override
  String get savedCards_clearFilters => '清除过滤器';

  @override
  String get savedCards_noCardsYet => '还没有保存的卡片';

  @override
  String get savedCards_saveCardsToAccess => '保存有趣的卡片以便稍后访问';

  @override
  String get savedCards_noCardsFound => '未找到卡片';

  @override
  String get savedCards_tryAdjustingFilters => '尝试调整过滤器';

  @override
  String get savedCards_clearAllTitle => '清除所有已保存的卡片？';

  @override
  String get savedCards_clearAllMessage => '这将删除您所有已保存的卡片。此操作无法撤消。';

  @override
  String get savedCards_allCleared => '所有已保存的卡片已清除';

  @override
  String get home_search => '搜索';

  @override
  String get info_productivityInfo => '生产力信息';

  @override
  String get info_words => '字数';

  @override
  String get info_time => '时间，';

  @override
  String get info_timeMin => '（分钟）';

  @override
  String get info_saved => '节省，';

  @override
  String get info_original => '原文';

  @override
  String get info_brief => '简要';

  @override
  String get info_deep => '深入';

  @override
  String get extension_growYourProductivity => '提高您的生产力';

  @override
  String get extension_copyLink => '复制链接';

  @override
  String get extension_sendLink => '发送链接';

  @override
  String get extension_enterYourEmail => '输入邮箱';

  @override
  String get auth_skip => '跳过';

  @override
  String get auth_hello => '你好！';

  @override
  String get auth_fillInToGetStarted => '填写以开始';

  @override
  String get auth_emailAddress => '电子邮件地址';

  @override
  String get auth_password => '密码';

  @override
  String get auth_forgotPassword => '忘记密码？';

  @override
  String get auth_loginIn => '登录';

  @override
  String get auth_orLoginWith => '或使用以下方式登录';

  @override
  String get auth_dontHaveAccount => '还没有账户？';

  @override
  String get auth_registerNow => '立即注册';

  @override
  String get auth_passwordCannotBeEmpty => '密码不能为空';

  @override
  String get auth_passwordMustBe6Chars => '密码必须至少包含6个字符';

  @override
  String get registration_skip => '跳过';

  @override
  String get registration_registerAndGet => '注册并获得';

  @override
  String get registration_2Free => '2次免费';

  @override
  String get registration_unlimited => '无限';

  @override
  String get registration_summarizations => '摘要';

  @override
  String get registration_name => '姓名';

  @override
  String get registration_emailAddress => '电子邮件地址';

  @override
  String get registration_password => '密码';

  @override
  String get registration_confirmPassword => '确认密码';

  @override
  String get registration_register => '注册';

  @override
  String get registration_orLoginWith => '或使用以下方式登录';

  @override
  String get registration_alreadyHaveAccount => '已有账户？';

  @override
  String get registration_loginNow => '立即登录';

  @override
  String get registration_passwordMismatch => '密码不匹配';

  @override
  String get request_secureSum => '安全摘要';

  @override
  String get request_readMyBook => '阅读我的书';

  @override
  String get request_speechToText => '语音转文字功能';

  @override
  String get request_textToSpeech => '文字转语音功能';

  @override
  String get request_addLanguage => '添加语言';

  @override
  String get request_orWriteMessage => '或给我们写信息';

  @override
  String get request_name => '姓名';

  @override
  String get request_enterYourName => '输入您的姓名';

  @override
  String get request_email => '电子邮件';

  @override
  String get request_enterYourEmail => '输入您的邮箱';

  @override
  String get request_message => '信息';

  @override
  String get request_enterYourRequest => '输入您的请求';

  @override
  String get request_submit => '提交';

  @override
  String get request_selectLanguage => '选择语言';

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
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get common_continue => '继续';

  @override
  String get common_select => '选择';

  @override
  String get common_ok => '好';

  @override
  String get common_error => '错误';

  @override
  String get onboarding_translateSummarizationTo => '将摘要翻译为';

  @override
  String get onboarding_goodbyeInfoOverload => '告别信息过载！';

  @override
  String get onboarding_oneClickShareToGetSummary => '一键“分享”获取摘要';

  @override
  String get onboarding_welcomeTitle => '欢迎使用 Summify';

  @override
  String get onboarding_welcomeSubtitle => '个人 AI 摘要工具';

  @override
  String get settings_profile => '个人资料';

  @override
  String get settings_general => '通用';

  @override
  String get settings_interfaceLanguage => '界面语言';

  @override
  String get settings_translationLanguage => '翻译语言';

  @override
  String get settings_selectLanguageTitle => '选择语言';

  @override
  String get paywall_beSmartWithYourTime => '聪明地利用你的时间！';

  @override
  String get paywall_payWeekly => '按周付费';

  @override
  String get paywall_payAnnually => '按年付费';

  @override
  String paywall_saveUpTo(Object amount) {
    return '最多节省 $amount\\\$';
  }

  @override
  String get paywall_buy => '购买';

  @override
  String get paywall_andGetOn => '并在';

  @override
  String get paywall_forFree => '免费获得！';

  @override
  String get paywall_12Months => '12 个月';

  @override
  String get paywall_1Week => '1 周';

  @override
  String get paywall_1Month => '1 个月';

  @override
  String get paywall_1WeekMultiline => '1 周';

  @override
  String get paywall_1MonthMultiline => '1 个月';

  @override
  String get paywall_12MonthsMultiline => '12 个月';

  @override
  String get paywall_accessAllPremiumCancelAnytime => '解锁所有高级功能！随时取消';

  @override
  String paywall_pricePerYear(Object price) {
    return '$price/年';
  }

  @override
  String paywall_pricePerWeek(Object price) {
    return '$price/周';
  }

  @override
  String get paywall_termsOfUse => '使用条款';

  @override
  String get paywall_restorePurchase => '恢复购买';

  @override
  String get paywall_privacyPolicy => '隐私政策';

  @override
  String get paywall_unlimitedSummaries => '无限摘要';

  @override
  String get paywall_documentResearch => '文档研究';

  @override
  String get paywall_briefAndDeepSummary => '简短与深入摘要';

  @override
  String get paywall_translation => '翻译';

  @override
  String get paywall_addToChromeForFree => '免费添加到 Chrome';

  @override
  String get offer_needMoreSummaries => '需要更多摘要？';

  @override
  String get offer_maximizeYourProductivity => '提升你的效率！';

  @override
  String get offer_outOfSummaries => '摘要用完了？';

  @override
  String get offer_maximizeProductivityAndEfficiency => '提升你的效率和生产力！';

  @override
  String get offer_getMoreInNoTime => '立刻获得更多！';

  @override
  String get offer_15DeepSummariesDaily => '每天 15 条深入摘要';

  @override
  String get offer_goUnlimited => '开启无限';

  @override
  String get bundle_subscriptionsNotAvailable => '订阅不可用';

  @override
  String get bundle_getForFree => '免费获取';

  @override
  String get bundle_on => '在';

  @override
  String get bundle_version => '版本';

  @override
  String get bundle_offer_unlockLimitless => '解锁无限';

  @override
  String get bundle_offer_possibilities => '可能';

  @override
  String get bundle_offer_endlessPossibilities => '无限可能';

  @override
  String get bundle_offer_with50Off => '立减 50%';

  @override
  String get bundle_offer_get4UnlimitedApps => '获取 4 个无限应用';

  @override
  String get bundle_tabBundle => '套餐';

  @override
  String get bundle_tabUnlimited => '无限';

  @override
  String get purchase_youAreTheBest => '你太棒了！';

  @override
  String get purchase_get => '免费获取';

  @override
  String get purchase_versionForFree => '版本！';

  @override
  String get purchase_copyLink => '复制链接';

  @override
  String get purchase_collectYourGift => '领取礼物';

  @override
  String get purchase_enterYourEmail => '输入邮箱';

  @override
  String get summary_couldNotOpenURL => '无法打开URL';

  @override
  String get summary_couldNotOpenFile => '无法打开文件';

  @override
  String get summary_originalFileNoLongerAvailable => '原始文件不再可用';

  @override
  String get summary_filePathNotFound => '未找到文件路径';

  @override
  String get summary_originalTextNotAvailable => '原始文本不可用';

  @override
  String get summary_breakThroughTheLimits => '突破限制';

  @override
  String get summary_sourceTab => '来源';

  @override
  String get summary_sourceNotAvailable => '此类摘要无法使用源文本';

  @override
  String get quiz_failedToGenerate => '生成测验失败';

  @override
  String get quiz_retry => '重试';

  @override
  String get quiz_knowledgeQuiz => '知识测验';

  @override
  String get quiz_testYourUnderstanding => '测试您对此文档的理解';

  @override
  String get quiz_questions => '问题';

  @override
  String get quiz_estimatedTime => '预计时间';

  @override
  String get quiz_minutes => '分钟';

  @override
  String get quiz_startQuiz => '开始测验';

  @override
  String get quiz_explanation => '说明';

  @override
  String get quiz_previous => '上一题';

  @override
  String get quiz_viewResults => '查看结果';

  @override
  String get quiz_nextQuestion => '下一题';

  @override
  String quiz_questionNofTotal(Object current, Object total) {
    return '第$current题，共$total题';
  }

  @override
  String get quiz_overview => '概览';

  @override
  String get quiz_stepByStep => '逐步';

  @override
  String get quiz_excellent => '太棒了！🎉';

  @override
  String get quiz_goodJob => '做得好！👍';

  @override
  String get quiz_notBad => '不错！继续学习📚';

  @override
  String get quiz_keepPracticing => '继续练习！💪';

  @override
  String get quiz_correct => '正确';

  @override
  String get quiz_incorrect => '错误';

  @override
  String get quiz_total => '总计';

  @override
  String get quiz_retakeQuiz => '重做测验';

  @override
  String get quiz_reviewAnswers => '查看答案';

  @override
  String quiz_question(Object number) {
    return '第$number题';
  }

  @override
  String get savedCards_title => '已保存的卡片';

  @override
  String get savedCards_removeBookmarkTitle => '删除书签？';

  @override
  String get savedCards_removeBookmarkMessage => '此卡片将从您的书签中删除。';

  @override
  String get savedCards_cancel => '取消';

  @override
  String get savedCards_remove => '删除';

  @override
  String get savedCards_cardRemoved => '卡片已从书签中删除';

  @override
  String get savedCards_sourceNotFound => '未找到源文档';

  @override
  String get savedCards_clearAll => '全部清除';

  @override
  String get savedCards_searchHint => '搜索已保存的卡片...';

  @override
  String savedCards_cardCount(Object count) {
    return '$count张卡片';
  }

  @override
  String savedCards_cardsCount(Object count) {
    return '$count张卡片';
  }

  @override
  String get savedCards_clearFilters => '清除过滤器';

  @override
  String get savedCards_noCardsYet => '还没有保存的卡片';

  @override
  String get savedCards_saveCardsToAccess => '保存有趣的卡片以便稍后访问';

  @override
  String get savedCards_noCardsFound => '未找到卡片';

  @override
  String get savedCards_tryAdjustingFilters => '尝试调整过滤器';

  @override
  String get savedCards_clearAllTitle => '清除所有已保存的卡片？';

  @override
  String get savedCards_clearAllMessage => '这将删除您所有已保存的卡片。此操作无法撤消。';

  @override
  String get savedCards_allCleared => '所有已保存的卡片已清除';

  @override
  String get home_search => '搜索';

  @override
  String get info_productivityInfo => '生产力信息';

  @override
  String get info_words => '字数';

  @override
  String get info_time => '时间，';

  @override
  String get info_timeMin => '（分钟）';

  @override
  String get info_saved => '节省，';

  @override
  String get info_original => '原文';

  @override
  String get info_brief => '简要';

  @override
  String get info_deep => '深入';

  @override
  String get extension_growYourProductivity => '提高您的生产力';

  @override
  String get extension_copyLink => '复制链接';

  @override
  String get extension_sendLink => '发送链接';

  @override
  String get extension_enterYourEmail => '输入邮箱';

  @override
  String get auth_skip => '跳过';

  @override
  String get auth_hello => '你好！';

  @override
  String get auth_fillInToGetStarted => '填写以开始';

  @override
  String get auth_emailAddress => '电子邮件地址';

  @override
  String get auth_password => '密码';

  @override
  String get auth_forgotPassword => '忘记密码？';

  @override
  String get auth_loginIn => '登录';

  @override
  String get auth_orLoginWith => '或使用以下方式登录';

  @override
  String get auth_dontHaveAccount => '还没有账户？';

  @override
  String get auth_registerNow => '立即注册';

  @override
  String get auth_passwordCannotBeEmpty => '密码不能为空';

  @override
  String get auth_passwordMustBe6Chars => '密码必须至少包含6个字符';

  @override
  String get registration_skip => '跳过';

  @override
  String get registration_registerAndGet => '注册并获得';

  @override
  String get registration_2Free => '2次免费';

  @override
  String get registration_unlimited => '无限';

  @override
  String get registration_summarizations => '摘要';

  @override
  String get registration_name => '姓名';

  @override
  String get registration_emailAddress => '电子邮件地址';

  @override
  String get registration_password => '密码';

  @override
  String get registration_confirmPassword => '确认密码';

  @override
  String get registration_register => '注册';

  @override
  String get registration_orLoginWith => '或使用以下方式登录';

  @override
  String get registration_alreadyHaveAccount => '已有账户？';

  @override
  String get registration_loginNow => '立即登录';

  @override
  String get registration_passwordMismatch => '密码不匹配';

  @override
  String get request_secureSum => '安全摘要';

  @override
  String get request_readMyBook => '阅读我的书';

  @override
  String get request_speechToText => '语音转文字功能';

  @override
  String get request_textToSpeech => '文字转语音功能';

  @override
  String get request_addLanguage => '添加语言';

  @override
  String get request_orWriteMessage => '或给我们写信息';

  @override
  String get request_name => '姓名';

  @override
  String get request_enterYourName => '输入您的姓名';

  @override
  String get request_email => '电子邮件';

  @override
  String get request_enterYourEmail => '输入您的邮箱';

  @override
  String get request_message => '信息';

  @override
  String get request_enterYourRequest => '输入您的请求';

  @override
  String get request_submit => '提交';

  @override
  String get request_selectLanguage => '选择语言';

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
}
