import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../../auth/presentation/providers/user_provider.dart';

// Nigerian states with major cities and zip codes
const Map<String, Map<String, String>> nigerianLocations = {
  'Abia': {'Aba': '450211', 'Umuahia': '440221'},
  'Abuja FCT': {'Garki': '900101', 'Gwagwalada': '900104', 'Wuse': '900281', 'Maitama': '900271', 'Asokoro': '900231', 'Kubwa': '900108'},
  'Adamawa': {'Yola': '640211', 'Mubi': '650241'},
  'Akwa Ibom': {'Uyo': '520001', 'Eket': '520111'},
  'Anambra': {'Awka': '420001', 'Onitsha': '434001'},
  'Bauchi': {'Bauchi': '740001', 'Azare': '751001'},
  'Bayelsa': {'Yenagoa': '560001'},
  'Benue': {'Makurdi': '970001', 'Otukpo': '972001'},
  'Borno': {'Maiduguri': '600001', 'Biu': '601001'},
  'Cross River': {'Calabar': '540001', 'Ogoja': '543001'},
  'Delta': {'Asaba': '320001', 'Warri': '332001', 'Sapele': '331001'},
  'Ebonyi': {'Abakaliki': '480001'},
  'Edo': {'Benin City': '300001', 'Ekpoma': '310001'},
  'Ekiti': {'Ado-Ekiti': '360001'},
  'Enugu': {'Enugu': '400001', 'Nsukka': '410001'},
  'Gombe': {'Gombe': '760001'},
  'Imo': {'Owerri': '460001', 'Orlu': '473001'},
  'Jigawa': {'Dutse': '720001'},
  'Kaduna': {'Kaduna': '800001', 'Zaria': '810001'},
  'Kano': {'Kano': '700001'},
  'Katsina': {'Katsina': '820001'},
  'Kebbi': {'Birnin Kebbi': '860001'},
  'Kogi': {'Lokoja': '260001', 'Idah': '271001'},
  'Kwara': {'Ilorin': '240001', 'Offa': '250001'},
  'Lagos': {'Ikeja': '100001', 'Lagos Island': '101001', 'Victoria Island': '101241', 'Lekki': '105102', 'Surulere': '101283'},
  'Nasarawa': {'Lafia': '950001', 'Keffi': '961001'},
  'Niger': {'Minna': '920001', 'Bida': '912001'},
  'Ogun': {'Abeokuta': '110001', 'Sagamu': '121001'},
  'Ondo': {'Akure': '340001', 'Ondo': '351001'},
  'Osun': {'Osogbo': '230001', 'Ife': '220001'},
  'Oyo': {'Ibadan': '200001', 'Ogbomoso': '210001'},
  'Plateau': {'Jos': '930001', 'Bukuru': '930105'},
  'Rivers': {'Port Harcourt': '500001', 'Bonny': '504001'},
  'Sokoto': {'Sokoto': '840001'},
  'Taraba': {'Jalingo': '660001'},
  'Yobe': {'Damaturu': '620001', 'Potiskum': '621001'},
  'Zamfara': {'Gusau': '860001'},
};

class ProfileDetailScreen extends ConsumerStatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  ConsumerState<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  bool _restaurantStatusOnline = true;
  bool _restaurantStatusBusy = false;

  String? _selectedState = 'Abuja FCT';
  String? _selectedCity = 'Gwagwalada';
  String _zip = '900104';

  final MapController _mapController = MapController();
  final TextEditingController _addressController = TextEditingController(
    text: 'Shop B4, 1234 Shopping Complex, Along Lorem Way',
  );

  LatLng _markerPosition = const LatLng(9.0563, 7.4985); // Default: Abuja
  bool _isSearching = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _geocodeAddress() async {
    final query = _addressController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent('$query, Nigeria')}&format=json&limit=1',
      );
      final response = await http.get(uri, headers: {
        'User-Agent': 'PickEatPickIt/1.0',
      });

      if (response.statusCode == 200) {
        final results = json.decode(response.body) as List;
        if (results.isNotEmpty) {
          final lat = double.parse(results[0]['lat']);
          final lon = double.parse(results[0]['lon']);
          setState(() {
            _markerPosition = LatLng(lat, lon);
          });
          _mapController.move(_markerPosition, 14.0);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Address not found. Try a different search.')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to search address. Check your connection.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  List<String> get _states => nigerianLocations.keys.toList()..sort();

  List<String> get _cities {
    if (_selectedState == null) return [];
    return nigerianLocations[_selectedState]?.keys.toList() ?? [];
  }

  void _onStateChanged(String? state) {
    setState(() {
      _selectedState = state;
      final cities = nigerianLocations[state]?.keys.toList() ?? [];
      _selectedCity = cities.isNotEmpty ? cities.first : null;
      _zip = _selectedCity != null ? (nigerianLocations[state]?[_selectedCity] ?? '') : '';
    });
  }

  void _onCityChanged(String? city) {
    setState(() {
      _selectedCity = city;
      _zip = city != null ? (nigerianLocations[_selectedState]?[city] ?? '') : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userStreamProvider);
    final user = userAsync.value;

    final storeName = user?.firstName ?? 'Store name';
    final email = user?.email ?? 'email@example.com';
    final phone = user?.phoneNumber ?? '+234 000 000 0000';
    final fullName = '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();
    final profileImageUrl = user?.profileImageUrl;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF228B22),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            // Green status bar
            Container(
              color: const Color(0xFF228B22),
              height: MediaQuery.of(context).padding.top,
            ),
            // App bar
            Container(
              height: kToolbarHeight,
              decoration: const BoxDecoration(
                color: Color(0xFFE5F2FF),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    offset: Offset(0, 4),
                    blurRadius: 200,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    // Restaurant Status
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Restaurant Status',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF228B22),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Switch(
                              value: _restaurantStatusBusy,
                              onChanged: (val) {
                                setState(() => _restaurantStatusBusy = val);
                              },
                              activeTrackColor: const Color(0xFF228B22),
                              inactiveTrackColor: Colors.grey[300],
                            ),
                            Switch(
                              value: _restaurantStatusOnline,
                              onChanged: (val) {
                                setState(() => _restaurantStatusOnline = val);
                              },
                              activeTrackColor: const Color(0xFF228B22),
                              inactiveTrackColor: Colors.grey[300],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Profile card — 340×142, white, shadow, border-radius 10
                    Center(
                      child: Container(
                        width: 340,
                        height: 142,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x40000000),
                              offset: Offset(0, 4),
                              blurRadius: 200,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            // Profile photo in #E5F2FF circle
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 75,
                                  height: 75,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE5F2FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: profileImageUrl != null && profileImageUrl.isNotEmpty
                                          ? NetworkImage(profileImageUrl)
                                          : const AssetImage('assets/images/man.png') as ImageProvider,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Update\nProfile Photo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            // Store info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    storeName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Text(
                                    'Restaurant',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF228B22),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    email,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    phone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF228B22),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Personal information header
                    const Text(
                      'Personal information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF228B22),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Full Name
                    _buildInfoCard(
                      label: 'Full Name',
                      value: fullName.isNotEmpty ? fullName : 'N/A',
                    ),
                    const SizedBox(height: 12),

                    // Email Address
                    _buildInfoCard(
                      label: 'Email Address',
                      value: email,
                    ),
                    const SizedBox(height: 12),

                    // Phone Number
                    _buildInfoCard(
                      label: 'Phone Number',
                      value: phone,
                    ),

                    const SizedBox(height: 24),

                    // Address section
                    const Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF228B22),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Enter your address...',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: _isSearching
                            ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF228B22)),
                                ),
                              )
                            : IconButton(
                                icon: const Icon(Icons.search, color: Color(0xFF228B22)),
                                onPressed: _geocodeAddress,
                              ),
                      ),
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      onSubmitted: (_) => _geocodeAddress(),
                    ),

                    // State, City, Zip dropdowns
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Zip
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Zip',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF228B22),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _zip,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(height: 1, color: Colors.grey[300]),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // City dropdown
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'City',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF228B22),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCity,
                                  isExpanded: true,
                                  isDense: true,
                                  icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                  items: _cities.map((city) {
                                    return DropdownMenuItem(
                                      value: city,
                                      child: Text(city),
                                    );
                                  }).toList(),
                                  onChanged: _onCityChanged,
                                ),
                              ),
                              Container(height: 1, color: Colors.grey[300]),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // State dropdown
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'State',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF228B22),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedState,
                                  isExpanded: true,
                                  isDense: true,
                                  icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                  items: _states.map((state) {
                                    return DropdownMenuItem(
                                      value: state,
                                      child: Text(state),
                                    );
                                  }).toList(),
                                  onChanged: _onStateChanged,
                                ),
                              ),
                              Container(height: 1, color: Colors.grey[300]),
                            ],
                          ),
                        ),
                      ],
                    ),

                        ],
                      ),
                    ),

                    // White background section from Delivery Range — full width
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 200),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFFFF),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Delivery Range
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFF228B22), size: 22),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Delivery Range',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _selectedState ?? 'Abuja',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF228B22),
                                        ),
                                      ),
                                      Text(
                                        '  •  ${_selectedCity ?? 'Gwagwalada'}  •  Garki Town',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Real Map
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: FlutterMap(
                                mapController: _mapController,
                                options: MapOptions(
                                  initialCenter: _markerPosition,
                                  initialZoom: 12.0,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.pickeat.pickit',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: _markerPosition,
                                        width: 30,
                                        height: 30,
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Color(0xFF228B22),
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Save button
                          Center(
                            child: SizedBox(
                              width: 299,
                              height: 49,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Save logic
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF228B22),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F2FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF228B22),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
