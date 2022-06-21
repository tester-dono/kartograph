import 'package:kartograph/config/app_config.dart';
import 'package:kartograph/config/coordinates.dart';
import 'package:kartograph/config/debug_options.dart';
import 'package:kartograph/config/environment/build_types.dart';
import 'package:kartograph/config/environment/environment.dart';
import 'package:kartograph/config/urls.dart';
import 'package:kartograph/runner.dart';

/// Main entry point of app.
void main() {
  Environment.init(
    buildType: BuildType.debug,
    config: AppConfig(
      url: Url.testUrl,
      lat: ProjectCoordinates.staringLat,
      lng: ProjectCoordinates.staringLng,
      proxyUrl: Url.devProxyUrl,
      debugOptions: DebugOptions(
        debugShowCheckedModeBanner: true,
      ),
    ),
  );

  run();
}
