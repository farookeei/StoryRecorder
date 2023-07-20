import 'env_abstract.dart';
import 'env_type.dart';
import 'dart:developer';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal(); //constructor can define init val to variables using {}

  static final Environment _singleton = Environment._internal();

  static const String dev = 'DEV';
  static const String staging = 'STAGING';
  static const String prod = 'PROD';
  static const String test = 'TEST';
  static const String challenge = 'CHALLENGE';

  BaseConfig? config;
  String env = 'DEV';

  initConfig(String environment) {
    config = _getConfig(environment);
    env = environment;
  }

  String get envType {
    return env;
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.prod:
        log("In PRODUCTION mode");
        return ProdConfig();
      case Environment.staging:
        log("In STAGING mode");
        return StagingConfig();
      case Environment.test:
        log("In TEST mode");
        return TestConfig();
      case Environment.challenge:
        log("In CHALLENGE mode");
        return ChallengeConfig();
      default:
        log("In DEVELOPMENT mode");
        return DevConfig();
    }
  }
}
