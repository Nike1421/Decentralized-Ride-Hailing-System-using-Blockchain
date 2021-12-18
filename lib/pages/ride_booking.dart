import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:latlong/latlong.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:blockchain_ridesharing/directions_repo.dart';
import 'package:blockchain_ridesharing/directions_model.dart';
import 'package:blockchain_ridesharing/autocomplete_model.dart';
import 'package:blockchain_ridesharing/autocomplete_repo.dart';
import 'package:blockchain_ridesharing/search_delegate_options.dart';

class BookRide extends StatefulWidget {
  const BookRide({Key? key}) : super(key: key);

  @override
  _BookRideState createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  static final _initialCameraPosition = MapOptions(
    center: LatLng(19.0760, 72.8777),
    zoom: 11.5,
  );
  late Marker _origin;
  late Marker _destination;

  late LatLng destinationCrd;
  late LatLng originCrd;

  late Prediction res;
  TextEditingController _originController = new TextEditingController();
  TextEditingController _destinationController = new TextEditingController();
  List<Marker> markerlist = [];
  List<LatLng> coordlist = [];
  bool visibleCont = true;
  bool visibleText = false;
  bool visibleTopMenu = true;
  String buttonText = "_addmarker";
  @override
  void toggleState() {
    setState(() {
      visibleText = !visibleText;
      buttonText = "Check Availability";
    });
  }

  void removeTopMenu() {
    setState(() {
      visibleTopMenu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Book Ride'),
          centerTitle: true,
        ),
        body: Container(
            child: Stack(children: [
          FlutterMap(
            options: _initialCameraPosition,
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/nike1421/ckwxapwvdgnaq14p4s3q7fbxp/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibmlrZTE0MjEiLCJhIjoiY2t3eGE2cjkzMGJ3YjJ2bGF2YnB1bDlrNyJ9.9-2Wtpza6YIuPDyhpCpzSA",
                additionalOptions: {
                  'accessToken':
                      "pk.eyJ1IjoibmlrZTE0MjEiLCJhIjoiY2t3eGE2cjkzMGJ3YjJ2bGF2YnB1bDlrNyJ9.9-2Wtpza6YIuPDyhpCpzSA",
                  'id': "mapbox.mapbox-streets-v8"
                },
              ),
              MarkerLayerOptions(
                markers: markerlist,
              ),
              PolylineLayerOptions(polylines: [
                Polyline(points: coordlist, strokeWidth: 5.0, color: Colors.red)
              ])
            ],
          ),
          Column(
            children: [
              Visibility(
                  visible: visibleTopMenu,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0))),
                    height: 200.0,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(
                                15.0, 15.0, 15.0, 7.5),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: TextFormField(
                                        controller: _originController,
                                        onTap: () async {
                                          final res = await showSearch(
                                              context: context, delegate: AutoSearch());
                                          _originController.text = res!.predictionLocationsDescription[0];

                                          originCrd = res.predictionPoints[0];
                                        }, // // Show the search delegate here
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Source',
                                        ))))),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(
                                15.0, 15.0, 15.0, 7.5),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: TextFormField(
                                      controller: _destinationController,
                                        onTap: () async {
                                          final res = await showSearch(
                                              context: context, delegate: AutoSearch());
                                          _destinationController.text = res!.predictionLocationsDescription[0];

                                          destinationCrd = res.predictionPoints[0];
                                        }, // the search delegate here
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Destination',
                                        ))))),
                        Visibility(
                            visible: visibleText,
                            child: const Text("Estd Time")),
                        Visibility(
                            visible: visibleText,
                            child: const Text("Estd Cost")),
                      ],
                    ),
                  )),
              Container(
                color: Colors.grey,
              )
            ],
          ),
          Visibility(
              visible: !visibleTopMenu,
              child: Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .60,
                    right: 20.0,
                    left: 20.0),
                child: Container(
                  height: 250.0,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 15.0),
                            child: Card(
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    height: 75.0,
                                    width: 75.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Column(
                                      children: const [
                                        Text("Line1"),
                                        Text("Line2"),
                                        Text("Line3")
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 25.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .30,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('Cancel'),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)))),
                                )),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 25.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .30,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('Call'),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)))),
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .40,
                              child: const TextField(
                                  decoration: InputDecoration(
                                labelText: 'Source',
                              )),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .40,
                              child: const TextField(
                                  decoration: InputDecoration(
                                labelText: 'Source',
                              )),
                            )
                          ],
                        )
                      ],
                    ),
                    color: Colors.white,
                    elevation: 4.0,
                  ),
                ),
              ))
        ])),
        floatingActionButton: !visibleText
            ? Visibility(
                child: FloatingActionButton.extended(
                    onPressed: () {
                      _addMarker(originCrd, destinationCrd);
                    },
                    label: Text("buttonText"),
                    icon: const Icon(Icons.car_rental)))
            : Visibility(
                visible: visibleTopMenu,
                child: FloatingActionButton.extended(
                    onPressed: () {
                      _addMarker;
                      //showModalBottomSheet(
                      //context: context,
                      //barrierColor: Colors.transparent,
                      //builder: (context) {
                      //  return ConfTrial();
                      //});
                    },
                    label: Text(buttonText),
                    icon: const Icon(Icons.car_rental)),
              ));
    // floatingActionButton: FloatingActionButton(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     foregroundColor: Colors.black,
    //     onPressed: () => _googleMapController.animateCamera(
    //         CameraUpdate.newCameraPosition(_initialCameraPosition))));
  }

  void _addMarker(LatLng originCrd, LatLng destinationCrd) async {
    _origin = Marker(
      width: 80.0,
      height: 80.0,
      point: originCrd,
      builder: (ctx) => const FlutterLogo(),
    );

    _destination = Marker(
      width: 80.0,
      height: 80.0,
      point: destinationCrd,
      builder: (ctx) => const FlutterLogo(),
    );

    markerlist.add(_origin);
    markerlist.add(_destination);

    Directions _info;
    // Get directions
    final directions = await DirectionsRepository()
        .getDirections(origin: _origin.point, destination: _destination.point);
    setState(() => _info = directions!);
    coordlist = directions!.polylinePoints;
  }
}
