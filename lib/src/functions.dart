const froshGroupSymbols = {
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
