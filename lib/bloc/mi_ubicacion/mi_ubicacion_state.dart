part of 'mi_ubicacion_bloc.dart';

@immutable
class MiUbicacionState {

  final bool siguiendo;
  final bool existeUbicacion;
  final LatLng ubicacion;

  MiUbicacionState({
    this.siguiendo = true, 
    this.existeUbicacion = false,
     this.ubicacion
  });

  MiUbicacionState copyWith({ bool siguiendo, bool existeUbicacion, LatLng ubicacion}){
    return MiUbicacionState(
      siguiendo: siguiendo ?? this.siguiendo,
      ubicacion: ubicacion ?? this.ubicacion,
      existeUbicacion: existeUbicacion ?? this.existeUbicacion
    );
  }

  

}
