part of '../max.dart';

String _androidStudioRunConfigTemplate(String flavor) {
  return '''<component name="ProjectRunConfigurationManager">
  <configuration default="false" name="$flavor" type="FlutterRunConfigurationType" factoryName="Flutter">
    <option name="additionalArgs" value="--flavor $flavor --dart-define APP_FLAVOR=$flavor" />
    <option name="filePath" value="\$PROJECT_DIR\$/lib/main.dart" />
    <method v="2" />
  </configuration>
</component>
''';
}
