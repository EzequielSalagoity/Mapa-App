import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa_app/widgets/widgets.dart';


class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  @override
  void initState() {

    context.read<MiUbicacionBloc>().iniciarSeguimiento();
    
    super.initState();
  }

  @override
  void dispose() {
    context.read<MiUbicacionBloc>().cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
              builder: (context, state) {
                return crearMapa(state);                    
              },
            ),
            Positioned(
              top: 10,
              child: SearchBar()
            ),
            MarcadorManual(),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BtnUbicacion(),
            BtnSeguirUbicacion(),
            BtnMiRuta(),
          ],
        ),
   ),
    );
  }

  Widget crearMapa(MiUbicacionState state){
    if(!state.existeUbicacion) return Center(child: Text('Ubicando...'));

    //return Text('${state.ubicacion.latitude},${state.ubicacion.longitude}');

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.add(OnNuevaUbicacion(state.ubicacion));

    final cameraPosition = new CameraPosition(
      target: state.ubicacion,
      zoom: 15,
    );

    return BlocBuilder<MapaBloc, MapaState>(
      builder: (context, _) {
        return GoogleMap(
          initialCameraPosition: cameraPosition,
          mapType: MapType.normal,
          compassEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,      
          onMapCreated: (GoogleMapController controller){
            return mapaBloc.initMapa(controller);
          },
          polylines: mapaBloc.state.polylines.values.toSet(),
          markers: mapaBloc.state.markers.values.toSet(),
          onCameraMove: (cameraPosition){
            mapaBloc.add(OnMovioMapa(cameraPosition.target));
          },
        );
      },
    );    
  }

}