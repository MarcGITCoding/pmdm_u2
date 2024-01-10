import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Utilidades {
  //Uso del paquete uuid para generar un id único criptográficamente
  static String generarUUID() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  //Formateo de la fecha
  static String formatFecha(DateTime fecha) {
    return DateFormat('HH:mm - dd/MM/yyyy').format(fecha);
  }
}
