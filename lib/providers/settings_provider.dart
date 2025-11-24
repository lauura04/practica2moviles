import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier{
  static const String keySonidoActivado = 'sonido_activado';
  static const String keyMusicActivada = 'musica_activada';
  static const String keyVolumenGeneral = 'volumen_general';
  static const String keyVolumenEfectos = 'volumen_efectos';
  static const String keyModoOscuro = 'modo_oscuro';
  static const String keyEfectoAnimaciones = 'efecto_animaciones';



  // valores de los ajustes (por defecto)
  bool _sonidoActivado = true;
  bool _musicActivada = true;
  double _volumenGeneral = 0.7;
  double _volumenEfectos = 0.8;
  bool _modoOscuro = false;
  bool _efectosAnimaciones = true;


  bool _isLoading = true;

  // getters públicos para los valores
  bool get sonidoActivado => _sonidoActivado;
  bool get musicActivada => _musicActivada;
  double get volumenGeneral => _volumenGeneral;
  double get volumenEfectos => _volumenEfectos;
  bool get modoOscuro => _modoOscuro;
  bool get efectosAnimaciones => _efectosAnimaciones;

  bool get isLoading => _isLoading;

  //getter para el tema actual de la app
  ThemeData get currentTheme => _modoOscuro ? ThemeData.dark() : ThemeData.light();

  SettingsProvider(){

  }
  Future<void> inicializar() async{
    await _cargarAjustes();
}

  Future<void> setSonidoActivado(bool valor) async{
    _sonidoActivado = valor;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keySonidoActivado, valor);
  }

  Future<void> setMusicaActivada(bool valor) async{
    _musicActivada = valor;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyMusicActivada, valor);
  }

  Future<void> setVolumenGeneral(double valor) async{
    _volumenGeneral = valor;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyVolumenGeneral, valor);
  }

  Future<void> setVolumenEfectos(double valor) async{
    _volumenEfectos = valor;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyVolumenEfectos, valor);
  }

  Future<void> setModoOscuro(bool valor) async{
    _modoOscuro = valor;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyModoOscuro, valor);
  }

  Future<void> setEfectoAnimaciones(bool valor) async{
    _efectosAnimaciones = valor;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyEfectoAnimaciones, valor);
  }


  //logica de carga
  Future<void> _cargarAjustes() async{
    final prefs = await SharedPreferences.getInstance();

    _sonidoActivado = prefs.getBool(keySonidoActivado) ?? _sonidoActivado;
    _musicActivada = prefs.getBool(keyMusicActivada) ?? _musicActivada;
    _volumenGeneral = prefs.getDouble(keyVolumenGeneral) ?? _volumenGeneral;
    _volumenEfectos = prefs.getDouble(keyVolumenEfectos) ?? _volumenEfectos;
    _modoOscuro = prefs.getBool(keyModoOscuro) ?? _modoOscuro;
    _efectosAnimaciones = prefs.getBool(keyEfectoAnimaciones) ?? _efectosAnimaciones;


    _isLoading = false;

    notifyListeners();
  }
}