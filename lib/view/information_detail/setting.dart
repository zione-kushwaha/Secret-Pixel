import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import '/constants/constant.dart';
import '/core/pincode_field.dart';
import '/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:pincode_input_fields/pincode_input_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/showsnackbar.dart';
import '../../providers/future_provider.dart';
import '../../providers/theme_provider.dart';

class Setting extends ConsumerStatefulWidget {
  const Setting({super.key});

  @override
  ConsumerState<Setting> createState() => _SettingState();
}

class _SettingState extends ConsumerState<Setting> {
  // function to show the alert dialog to enter the 4 digit pin
  Future<void> showAlertDialog(BuildContext context, WidgetRef refs) async {
    final PincodeInputFieldsController _controller =
        PincodeInputFieldsController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: GetColor.backgroundColor(context),
          title: Text('Enter 4 digit pin'),
          content: buildPincode(800, 500, context, _controller),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text('Submit'),
              onPressed: () async {
                if (_controller.text.length == 4) {
                  SharedPreferences.getInstance().then((prefs) async {
                    prefs.setString('password', _controller.text);
                    await refs
                        .read(isEnableProvider.notifier)
                        .updateIsEnable(true);
                  });
                  Navigator.pop(context, _controller.text);
                  show_snackbar(context, 'Default Password Enabled');
                } else {
                  show_snackbar(context, 'Please enter 4 digit pin');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SettingsList(
          darkTheme: SettingsThemeData(
            settingsListBackground: blackColor,
          ),
          lightTheme: SettingsThemeData(
              settingsListBackground: GetColor.backgroundColor(context)),
          sections: [
            SettingsSection(
              title: Text('General'),
              tiles: [
                SettingsTile(
                  title: Text('Theme'),
                  description: Text('Light/Dark'),
                  leading: Icon(Icons.dark_mode),
                  trailing: ThemeSwitcher.withTheme(
                    clipper: ThemeSwitcherCircleClipper(),
                    builder: (_, switcher, theme) {
                      return Consumer(builder: (context, refs, child) {
                        return Switch(
                            activeColor: GetColor.textColor(context),
                            value: refs.read(themeProvider)!.brightness ==
                                Brightness.dark,
                            onChanged: (val) {
                              refs.read(themeProvider.notifier).toggleTheme();
                              switcher.changeTheme(
                                theme: refs.read(themeProvider)!,
                              );
                            });
                      });
                    },
                  ),
                  onPressed: (BuildContext context) {
                    // Handle theme change
                  },
                ),
                SettingsTile(
                  title: Text('Default password'),
                  description: Text('Set default password for encryption'),
                  leading: Icon(Icons.lock),
                  trailing: Consumer(builder: (context, refs, child) {
                    final isEnable = refs.watch(isEnableProvider);
                    return Switch(
                      activeColor: GetColor.textColor(context),
                      value: isEnable,
                      onChanged: (val) async {
                        if (val) {
                          await showAlertDialog(context, refs);
                        } else {
                          SharedPreferences.getInstance().then((prefs) async {
                            prefs.setString('password', '0000');
                            await refs
                                .read(isEnableProvider.notifier)
                                .updateIsEnable(false);
                          });
                          show_snackbar(context, 'Default Password disabled');
                        }
                      },
                    );
                  }),
                  onPressed: (BuildContext context) {
                    // Handle default password
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text('Legal'),
              tiles: [
                SettingsTile(
                  title: Text('Terms & Conditions'),
                  leading: Icon(Icons.description),
                  onPressed: (BuildContext context) async {
                    // Handle terms & conditions
                    launchUrl(Uri.parse(
                        'https://sites.google.com/view/secretpixelconditions/home'));
                  },
                ),
                SettingsTile(
                  title: Text('Privacy Policy'),
                  leading: Icon(Icons.privacy_tip),
                  onPressed: (BuildContext context) async {
                    // Handle privacy policy
                    launchUrl(Uri.parse(
                        'https://sites.google.com/view/secretpixel/home'));
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text('Info'),
              tiles: [
                SettingsTile(
                  title: Text('Report some issue?'),
                  leading: Icon(Icons.report),
                  onPressed: (BuildContext context) {
                    launch('mailto:helpsecretpixel@gmail.com');
                  },
                ),
                SettingsTile(
                  title: Text('Version'),
                  description: Text('1.0.0+1'),
                  leading: Icon(Icons.info),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
