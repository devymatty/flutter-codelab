import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yalesson_cvcard/app_theme.dart';
import 'package:yalesson_cvcard/components/card_container.dart';
import 'package:yalesson_cvcard/components/link_icon.dart';
import 'package:yalesson_cvcard/components/text.dart';
import 'package:yalesson_cvcard/cv_icons.dart';
import 'package:yalesson_cvcard/error_handler.dart';
import 'package:yalesson_cvcard/logger.dart';
import 'package:yalesson_cvcard/s.dart';

const _tgAvatar = 'assets/images/avatar.jpeg';

class Links {
  static const github = 'https://github.com/devymatty';
  static const telegram = 'https://t.me/devymatty';
  static const email = 'devymatty@gmail.com';

  const Links._();
}

void main() {
  runZonedGuarded(() {
    initLogger();
    logger.info('Start main');
    runApp(const App());
  }, ErrorHandler.recordError);
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var _isDark = false;
  var _locale = S.en;

  @override
  Widget build(BuildContext context) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.supportedLocales,
        locale: _locale,
        builder: (context, child) => SafeArea(
          child: Material(
            child: Stack(
              children: [
                child ?? const SizedBox.shrink(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: IconButton(
                          onPressed: () {
                            final newMode = !_isDark;
                            logger.info(
                              'Switch theme mode: '
                              '${_isDark.asThemeName} -> ${newMode.asThemeName}',
                            );
                            setState(() => _isDark = !_isDark);
                          },
                          icon: Icon(
                              _isDark ? Icons.sunny : Icons.nightlight_round),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: InkResponse(
                          child: AppText(_locale.languageCode.toUpperCase()),
                          onTap: () {
                            final newLocale = S.isEn(_locale) ? S.ru : S.en;
                            logger.info(
                              'Switch language: '
                              '${_locale.languageCode} -> ${newLocale.languageCode}',
                            );
                            setState(() => _locale = newLocale);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        theme: AppTheme.theme(_isDark),
        home: const HomePage(),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(14.0),
          child: CVCard(),
        ),
      ),
    );
  }
}

class CVCard extends StatelessWidget {
  const CVCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CVCardContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Flexible(
            flex: 3,
            child: InfoWidget(),
          ),
          Flexible(
            flex: 2,
            child: AvatarWidget(),
          ),
        ],
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: IdentityWidget(),
        ),
        LinksWidget(),
      ],
    );
  }
}

class LinksWidget extends StatelessWidget {
  const LinksWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Spacer(flex: 1),
        Flexible(
          flex: 2,
          child: LinkIcon(
            icon: CVIcons.telegram,
            onPressed: () {
              launchUrl(Uri.parse(Links.telegram));
            },
          ),
        ),
        Flexible(
          flex: 2,
          child: LinkIcon(
            icon: CVIcons.github,
            onPressed: () => launchUrl(Uri.parse(Links.github)),
          ),
        ),
        Flexible(
          flex: 2,
          child: LinkIcon(
            icon: CVIcons.email,
            onPressed: () {
              Clipboard.setData(
                const ClipboardData(text: Links.email),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).copied),
                ),
              );
            },
          ),
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}

class IdentityWidget extends StatelessWidget {
  const IdentityWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTitle(S.of(context).name),
        AppSubtitle(S.of(context).company),
      ],
    );
  }
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _tgAvatar,
      fit: BoxFit.fitHeight,
      frameBuilder: (_, child, frame, ___) => AnimatedOpacity(
        opacity: frame != null ? 1.0 : 0,
        duration: const Duration(milliseconds: 1500),
        child: frame != null ? child : Container(),
      ),
    );
  }
}

extension _BoolToThemeName on bool {
  String get asThemeName => this ? 'dark' : 'light';
}
