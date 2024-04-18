import 'dart:async';
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Backend/base_client.dart';
import '../../directionWidget.dart';
import '../Chat/chat_screen.dart';
import '../Globals/constants.dart';
import '../Login/login_screen.dart';
import '../UploadLawnImages/uploadCompletedJobImg_screen.dart';
import '../UploadLawnImages/uploadLawnImages_screen.dart';

class TrackService extends StatefulWidget {
  final String fromWhere;
  final String lt;
  final String ln;
  final int id;
  final String address;
  final String date;
  final String? service_for;
  final String? period;
  final String grand_total;

  const TrackService({
    required this.id,
    required this.address,
    required this.date,
    required this.service_for,
    required this.period,
    required this.grand_total,
    required this.fromWhere,
    required this.lt,
    required this.ln,
  });

  @override
  State<TrackService> createState() => _TrackServiceState();
}

class _TrackServiceState extends State<TrackService> {
  bool accepted = true;
  bool onWay = true;
  bool startedJob = false;
  bool finishedJob = false;

  Map<String, dynamic>? userMap;

  Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController controller;

  Set<Marker> _markers = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();

  List<LatLng> polylineCoordinates = [];

  PolylinePoints? polylinePoints;

  String googleAPIKey = googleApiKey;

  // BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;

  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;

  LocationData? currentLocation;

  LocationData destinationLocation =
      LocationData.fromMap({"latitude": 0.00, "longitude": 0.00});

  Location? location;
  Timer? timer;
  bool showMap = true;
  String? img = "images/upload.jpg";

  StreamSubscription<LocationData>? locationSubscription;

  Future<void> startListeningLocation() async {
    locationSubscription =
        location!.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;

      if (mounted) {
        setState(() {});
      }

      updatePinOnMap();
    });
  }

  void stopListeningLocation() {
    locationSubscription?.cancel();
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    // create an instance of Location
    location = Location();
    polylinePoints = PolylinePoints();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    startListeningLocation();
    timer = Timer.periodic(const Duration(minutes: 2), (Timer t) async {
      //
      var response = await BaseClient().updateProviderLoc(
        "/update-provider-location",
        widget.id.toString(),
        currentLocation!.latitude.toString(),
        currentLocation!.longitude.toString(),
      );
      if (response["message"] == "Unauthenticated.") {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              // 3
              child: const LogIn(),
            ),
            (route) => false,
          );
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Alert!',
              message: 'To continue, kindly log in again',
              contentType: ContentType.help,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      } else {
        if (!response["success"]) {
          //
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    });
    // set the initial location
    setInitialLocation();
    // set custom marker pins
    setSourceAndDestinationIcons();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    stopListeningLocation();
    controller.dispose();
  }

  void setSourceAndDestinationIcons() async {
    // sourceIcon = await BitmapDescriptor.fromAssetImage(
    //   const ImageConfiguration(devicePixelRatio: 2.5),
    //   'assets/driving_pin.png',
    // );
    // sourceIcon = await MarkerIcon.pictureAsset(
    //   assetPath: 'images/upload.jpg',
    //   height: 80,
    //   width: 80,
    // );
    // destinationIcon = await BitmapDescriptor.fromAssetImage(
    //   const ImageConfiguration(devicePixelRatio: 2.5),
    //   'assets/destination_map_marker.png',
    // );
    // destinationIcon = await MarkerIcon.pictureAsset(
    // assetPath: 'images/image1.png',
    // height: 100,
    // width: 100,
    // );
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? user = localStorage.getString('user');
    userMap = jsonDecode(user!) as Map<String, dynamic>;
    if (userMap!["image"] != null) {
      img = userMap!["image"];
    }
    if (mounted) {
      setState(() {});
    }
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location!.getLocation();
    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": double.parse(widget.lt),
      "longitude": double.parse(widget.ln)
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: 17,
      // tilt: CAMERA_TILT,
      bearing: 30,
      target: LatLng(double.parse(widget.lt), double.parse(widget.ln)),
    );
    EasyLoading.dismiss();
    if (currentLocation != null) {
      EasyLoading.dismiss();
      initialCameraPosition = CameraPosition(
        zoom: 17,
        // tilt: CAMERA_TILT,
        bearing: 30,
        target: LatLng(
          currentLocation!.latitude!,
          currentLocation!.longitude!,
        ),
      );
    } else {
      setInitialLocation();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          // widget.fromWhere == 'Request' ? "Job Location" : "Track your service",
          "Track service",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          DirectionsWidget(
            latitude: double.parse(widget.lt),
            longitude: double.parse(widget.ln),
            address: widget.address,
          ),
        ],
      ),
      body: currentLocation == null
          ? null
          : Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                if (showMap)
                  GoogleMap(
                    // myLocationEnabled: true,
                    tiltGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    markers: _markers,
                    // polylines: widget.fromWhere == 'Request' ? {} : _polylines,
                    // polylines: _polylines,
                    mapType: MapType.satellite,
                    initialCameraPosition: initialCameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      // my map has completed being created;
                      // i'm ready to show the pins on the map
                      showPinsOnMap();
                    },
                  ),
                SizedBox(
                  child:
                      //  widget.fromWhere == 'OnMyWay'
                      //     ?
                      Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2.5,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Scrollbar(
                              // thumbVisibility: true,
                              // trackVisibility: true,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      widget.fromWhere == 'OnMyWay'
                                          ? "On my way"
                                          : widget.fromWhere == 'jobStarted'
                                              ? "Job Started"
                                              : "null",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        20,
                                        10,
                                        20,
                                        10,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: HexColor("#58D109"),
                                            size: 16,
                                          ),
                                          Flexible(
                                            child: Divider(
                                              color: HexColor("#58D109"),
                                            ),
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: HexColor("#58D109"),
                                            size: 16,
                                          ),
                                          Flexible(
                                            child: Divider(
                                              color: HexColor("#58D109"),
                                            ),
                                          ),
                                          Icon(
                                            widget.fromWhere == 'jobStarted'
                                                ? Icons.circle
                                                : Icons.circle_outlined,
                                            color: HexColor("#58D109"),
                                            size: 16,
                                          ),
                                          Flexible(
                                            child: Divider(
                                              color: HexColor("#58D109"),
                                            ),
                                          ),
                                          Icon(
                                            widget.fromWhere == 'jobCompleted'
                                                ? Icons.circle
                                                : Icons.circle_outlined,
                                            color: HexColor("#58D109"),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        20,
                                        0,
                                        20,
                                        20,
                                      ),
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Column(
                                              children: [
                                                Material(
                                                  elevation: 5,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.grey[300],
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                            0,
                                                            5,
                                                            10,
                                                            0,
                                                          ),
                                                          child:
                                                              IntrinsicHeight(
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  'images/logo3.png',
                                                                  height: 80,
                                                                ),
                                                                Flexible(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              widget.service_for == null ? "Lawn Mowing" : "Snow Plowing ${widget.service_for}",
                                                                              style: const TextStyle(fontSize: 12),
                                                                            ),
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  5,
                                                                                ),
                                                                                border: Border.all(
                                                                                  color: HexColor("#24B550"),
                                                                                ),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(
                                                                                  5,
                                                                                ),
                                                                                child: Text(
                                                                                  "\$${widget.grand_total}",
                                                                                  style: TextStyle(
                                                                                    fontSize: 12,
                                                                                    color: HexColor("#24B550"),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Expanded(
                                                                              child: Text(
                                                                                widget.address,
                                                                                style: const TextStyle(
                                                                                  fontSize: 12,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Divider(
                                                          color:
                                                              Colors.grey[400],
                                                          height: 1,
                                                          thickness: 1,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                            20,
                                                            20,
                                                            20,
                                                            20,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Due date: ${widget.date}",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            10),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    0,
                                                    20,
                                                    0,
                                                    20,
                                                  ),
                                                  child: widget.fromWhere ==
                                                          "OnMyWay"
                                                      ? ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                HexColor(
                                                                    "#24B550"),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            minimumSize: const Size
                                                                .fromHeight(50),
                                                          ),
                                                          onPressed: () {
                                                            stopListeningLocation();
                                                            controller
                                                                .dispose();
                                                            setState(() {
                                                              showMap = false;
                                                            });
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        UploadLawnImages(
                                                                  address: widget
                                                                      .address,
                                                                  date: widget
                                                                      .date,
                                                                  grand_total:
                                                                      widget
                                                                          .grand_total,
                                                                  id: widget.id,
                                                                  period: widget
                                                                      .period,
                                                                  service_for:
                                                                      widget
                                                                          .service_for,
                                                                  fromWhere:
                                                                      'OnMyWay',
                                                                  ln: widget.ln,
                                                                  lt: widget.lt,
                                                                ),
                                                              ),
                                                            ).then((value) =>
                                                                setState(() {
                                                                  // showMap =
                                                                  //     true;
                                                                  _controller =
                                                                      Completer();
                                                                  startListeningLocation();
                                                                }));
                                                          },
                                                          child: const Text(
                                                            'Reached',
                                                          ),
                                                        )
                                                      :
                                                      // Start Job
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                HexColor(
                                                                    "#24B550"),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            minimumSize: const Size
                                                                .fromHeight(50),
                                                          ),
                                                          onPressed: () {
                                                            stopListeningLocation();
                                                            controller
                                                                .dispose();
                                                            setState(() {
                                                              showMap = false;
                                                            });
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        UploadCompletedJobImages(
                                                                  id: widget.id,
                                                                ),
                                                              ),
                                                            ).then((value) =>
                                                                setState(() {
                                                                  // showMap =
                                                                  //     true;
                                                                  _controller =
                                                                      Completer();
                                                                  startListeningLocation();
                                                                }));
                                                          },
                                                          child: const Text(
                                                            'Job Completed',
                                                          ),
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: widget.period == null
                                                ? false
                                                : true,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    'Recurring',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                // 3
                                child: Chat(
                                  orderId: widget.id.toString(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: HexColor("#DCFFE7"),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ImageIcon(
                                const AssetImage(
                                  "images/chat.png",
                                ),
                                color: HexColor("#24B550"),
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ), // : null,
                ),
              ],
            ),
    );
  }

  // void setPolylines() async {
  //   polylineCoordinates.clear();
  //   if (mounted) {
  //     PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
  //       googleAPIKey,
  //       PointLatLng(
  //         currentLocation!.latitude!,
  //         currentLocation!.longitude!,
  //       ),
  //       PointLatLng(
  //         destinationLocation.latitude!,
  //         destinationLocation.longitude!,
  //       ),
  //     );
  //     if (result.points.isNotEmpty) {
  //       // ignore: avoid_single_cascade_in_expression_statements
  //       result.points.forEach((PointLatLng point) {
  //         polylineCoordinates.add(
  //           LatLng(point.latitude, point.longitude),
  //         );
  //       });
  //       _polylines.add(
  //         Polyline(
  //           width: 4, // set the width of the polylines
  //           polylineId: const PolylineId("poly"),
  //           color: HexColor("#0275D8"),
  //           points: polylineCoordinates,
  //         ),
  //       );
  //       if (mounted) {
  //         setState(() {});
  //       }
  //     }
  //   }
  // }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: 17,
      // tilt: CAMERA_TILT,
      bearing: 30,
      target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
    );
    controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    if (mounted) {
      setState(() {});
    }
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    // updated position
    var pinPosition = LatLng(
      currentLocation!.latitude!,
      currentLocation!.longitude!,
    );

    // the trick is to remove the marker (by id)
    // and add it again at the updated location
    _markers.removeWhere((m) => m.markerId.value == "sourcePin");
    _markers.add(
      Marker(
        markerId: const MarkerId("sourcePin"),
        position: pinPosition, // updated position
        infoWindow: const InfoWindow(title: "Your current location"),
        icon: img == "images/upload.jpg"
            ? await MarkerIcon.pictureAsset(
                assetPath: "images/upload.jpg",
                width: 80,
                height: 80,
              )
            : await MarkerIcon.downloadResizePictureCircle(
                "$imageUrl/$img",
                size: 80,
              ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
    // setPolylines();
  }

  void showPinsOnMap() async {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition = LatLng(
      currentLocation!.latitude!,
      currentLocation!.longitude!,
    );
    // get a LatLng out of the LocationData object
    var destPosition = LatLng(
      destinationLocation.latitude!,
      destinationLocation.longitude!,
    );
    // add the initial source location pin
    _markers.add(
      Marker(
        markerId: const MarkerId('sourcePin'),
        position: pinPosition,
        icon: img == "images/upload.jpg"
            ? await MarkerIcon.pictureAsset(
                assetPath: "images/upload.jpg",
                width: 80,
                height: 80,
              )
            : await MarkerIcon.downloadResizePictureCircle(
                "$imageUrl/$img",
              ),
      ),
    );
    // destination pin
    _markers.add(
      Marker(
        markerId: const MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon,
      ),
    );
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    // setPolylines();
  }
}
