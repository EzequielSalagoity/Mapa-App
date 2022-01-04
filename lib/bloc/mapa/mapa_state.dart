part of 'mapa_bloc.dart';

@immutable
class MapaState {

  final bool mapaListo;
  final bool dibujarRecorrido;
  final bool seguirUbicacion;
  final LatLng ubicacionCentral;

  // Polylines
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  MapaState({
    this.mapaListo = false, 
    this.dibujarRecorrido = false,
    Map<String, Polyline> polylines,
    Map<String, Marker> markers,
    this.seguirUbicacion = false,
    this.ubicacionCentral,
  }): this.polylines = polylines ?? new Map(),
  this.markers = markers ?? new Map();

  MapaState copyWith({ Map<String, Marker> markers,bool mapaListo, bool dibujarRecorrido, LatLng ubicacionCentral, bool seguirUbicacion, Map<String, Polyline> polylines }){
    return MapaState(
      mapaListo: mapaListo ?? this.mapaListo,
      seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
      polylines: polylines ?? this.polylines,
      markers: markers ?? this.markers,
      ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
      dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido
    );
  }
}
