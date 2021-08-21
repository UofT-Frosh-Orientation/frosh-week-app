import 'package:connectivity_plus/connectivity_plus.dart';

const welcomeMessages = [
  "Hello",
  "Hi",
  "How are you?",
  "Hi there",
  "Hello there",
  "Hi!",
  "Hello!",
  "Hello there!",
  "Hi there!",
  "What's up?",
  "Welcome",
  "Welcome!",
  "Good day,",
];

const froshGroupSymbols = {
  'all': "α",
  'alpha': "α",
  'beta': "β",
  'gamma': "γ",
  'delta': "δ",
  'zeta': "ζ",
  'theta': "θ",
  'kappa': "κ",
  'iota': "ι",
  'lambda': "λ",
  'ni': "ν",
  'omicron': "ο",
  'pi': "π",
  'rho': "ρ",
  'sigma': "σ",
  'tau': "τ",
  'upsilon': "ε",
  'phi': "φ",
  'chi': "χ",
  'psi': "ψ",
  'omega': "ω",
};

extension CapExtension on String {
  String get capitalizeFirst =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.capitalizeFirst)
      .join(" ");
}

Future<bool> hasNetwork() async {
  ConnectivityResult connectivityResult =
      await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}
