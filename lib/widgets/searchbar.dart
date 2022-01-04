
part of 'widgets.dart';

class SearchBar extends StatelessWidget {

   @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        
        if(state.seleccionManual){
          return Container();
        }else{
          return FadeInDown(
            duration: Duration(milliseconds: 300),
            child: buildSearchBar(context)
          );
        }

      },
    );
  }

  
  Widget buildSearchBar(BuildContext context) {
    
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),        
        width: width,
        child: GestureDetector(
          onTap: () async {
            final proximidad = context.read<MiUbicacionBloc>().state.ubicacion;
            final historial = context.read<BusquedaBloc>().state.historial;

            final SearchResult resultado = await showSearch(
              context: context, 
              delegate: SearchDestination(proximidad, historial)
            );
            this.retornoBusqueda(context, resultado);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
            width: double.infinity,
            child: Text('¿Donde quieres ir?', style: TextStyle(color: Colors.black87)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0,5)
                )
              ]
            ),
          ),
        ),
      ),
    );
  }

  void retornoBusqueda(BuildContext context, SearchResult result) async {

    try {
      print(result.cancelo);
      print(result.manual);
      if(result.cancelo) return;

      if(result.manual){
        context.read<BusquedaBloc>().add(OnActivarMarcadorManual());
        return;
      }     

      calculandoAlerta(context); 
    } catch (e) {
    }

    // Calcular la ruta en base al valor: Result
    final trafficService = new TrafficService();
    final mapaBloc = context.read<MapaBloc>();

    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = result.position;

    final drivingResponse = await trafficService.getCoordsInicioyFin(inicio, destino);
    

    final geometry = drivingResponse.routes[0].geometry;
    final duracion = drivingResponse.routes[0].duration;
    final distancia = drivingResponse.routes[0].distance;
    final nombreDestino = result.nombreDestino;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);
    final List<LatLng> rutaCoordenadas = points.decodedCoords.map((point) => LatLng(point[0],point[1])).toList();

    mapaBloc.add(OnCrearRutaInicioDestino(nombreDestino, rutaCoordenadas,distancia,duracion));

    Navigator.of(context).pop();

    final busquedaBloc = context.read<BusquedaBloc>();
    busquedaBloc.add(OnAgregarHistorial(result));

    
  }

 
}