import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart' as loc;
import '../models/issues.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController mapController = MapController();
  List<Marker> markers = [];
  loc.Location location = loc.Location();
  loc.LocationData? _locationData;
  bool _serviceEnabled = false;
  loc.PermissionStatus? _permissionGranted;

  @override
  void initState() {
    super.initState();
    initLocation();
    _loadIssues(); // Tải các sự cố khi màn hình bắt đầu
  }

  Future<void> initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {});
  }

  Future<void> _loadIssues() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('issues').get();
    List<Marker> issueMarkers = [];

    for (var doc in snapshot.docs) {
      Issue issue = Issue.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      String address = issue.location;
      String status = issue.status;

      try {
        // Chuyển địa chỉ thành tọa độ
        List<geo.Location> locations = await geo.locationFromAddress(address);
        if (locations.isNotEmpty) {
          Color markerColor;
          if (status == 'Chưa xử lý') {
            markerColor = Colors.red; // Màu đỏ cho sự cố chưa xử lý
          } else if (status == 'Đang xử lý') {
            markerColor = Colors.orange; // Màu cam cho sự cố đang xử lý
          } else {
            continue; // Nếu sự cố đã xử lý, không thêm marker
          }

          issueMarkers.add(
            Marker(
              point: LatLng(locations[0].latitude, locations[0].longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () {
                  // Khi người dùng nhấn vào marker, hiển thị chi tiết sự cố
                  _showIssueDetails(issue);
                },
                child: Icon(
                  Icons.location_on,
                  color: markerColor,
                  size: 40,
                ),
              ),
            ),
          );
        }
      } catch (e) {
        print("Lỗi khi xử lý địa chỉ: $e");
      }
    }

    setState(() {
      markers = issueMarkers; // Cập nhật danh sách markers sau khi tải xong
    });
  }

  void _showIssueDetails(Issue issue) {
    // Hiển thị một hộp thoại với thông tin chi tiết sự cố
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chi tiết sự cố'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mô tả: ${issue.description}'),
                SizedBox(height: 8),
                Text('Vị trí: ${issue.location}'),
                SizedBox(height: 8),
                Text('Trạng thái: ${issue.status}'),
                SizedBox(height: 8),
                if (issue.imageUrl.isNotEmpty) Image.network(issue.imageUrl),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bản Đồ Sự Cố'),
        backgroundColor: Colors.blue,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: LatLng(_locationData?.latitude ?? 16.0736606,
              _locationData?.longitude ?? 108.1472941),
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: markers,
          ),
        ],
      ),
    );
  }
}
