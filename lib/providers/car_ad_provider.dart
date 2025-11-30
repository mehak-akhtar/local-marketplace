import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ========== FIRESTORE PROVIDER ==========
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// ========== CARS COLLECTION REFERENCE ==========
final carsCollectionProvider = Provider<CollectionReference>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('global');
});

// ========== ALL ACTIVE CARS STREAM ==========
final allCarsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final carsCollection = ref.watch(carsCollectionProvider);

  return carsCollection
      .where('status', isEqualTo: 'active')
      .orderBy('listed_at', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
      });
});

// ========== CARS BY BRAND (Client-side filtering) ==========
final carsByBrandProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, brand) {
      final carsCollection = ref.watch(carsCollectionProvider);

      if (brand == 'All') {
        // ✅ Return all cars stream directly
        return carsCollection
            .where('status', isEqualTo: 'active')
            .orderBy('listed_at', descending: true)
            .snapshots()
            .map((snapshot) {
              return snapshot.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                return data;
              }).toList();
            });
      }

      // ✅ Get all cars and filter client-side to avoid composite index
      return carsCollection
          .where('status', isEqualTo: 'active')
          .orderBy('listed_at', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  return data;
                })
                .where(
                  (car) =>
                      (car['Brand'] as String? ?? '').toLowerCase() ==
                      brand.toLowerCase(),
                )
                .toList();
          });
    });

// ========== CARS BY FUEL TYPE (Client-side filtering) ==========
final carsByFuelTypeProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, fuelType) {
      final carsCollection = ref.watch(carsCollectionProvider);

      if (fuelType == 'All') {
        return carsCollection
            .where('status', isEqualTo: 'active')
            .orderBy('listed_at', descending: true)
            .snapshots()
            .map((snapshot) {
              return snapshot.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                return data;
              }).toList();
            });
      }

      return carsCollection
          .where('status', isEqualTo: 'active')
          .orderBy('listed_at', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  return data;
                })
                .where(
                  (car) =>
                      (car['Fuel Type'] as String? ?? '').toLowerCase() ==
                      fuelType.toLowerCase(),
                )
                .toList();
          });
    });

// ========== CARS BY TRANSMISSION TYPE (Client-side filtering) ==========
final carsByTransmissionProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      transmission,
    ) {
      final carsCollection = ref.watch(carsCollectionProvider);

      if (transmission == 'All') {
        return carsCollection
            .where('status', isEqualTo: 'active')
            .orderBy('listed_at', descending: true)
            .snapshots()
            .map((snapshot) {
              return snapshot.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                return data;
              }).toList();
            });
      }

      return carsCollection
          .where('status', isEqualTo: 'active')
          .orderBy('listed_at', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  return data;
                })
                .where(
                  (car) =>
                      (car['Transmission Type'] as String? ?? '')
                          .toLowerCase() ==
                      transmission.toLowerCase(),
                )
                .toList();
          });
    });

// ========== CARS BY LOCATION (Client-side filtering) ==========
final carsByLocationProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, location) {
      final carsCollection = ref.watch(carsCollectionProvider);

      if (location == 'All') {
        return carsCollection
            .where('status', isEqualTo: 'active')
            .orderBy('listed_at', descending: true)
            .snapshots()
            .map((snapshot) {
              return snapshot.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                return data;
              }).toList();
            });
      }

      return carsCollection
          .where('status', isEqualTo: 'active')
          .orderBy('listed_at', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  return data;
                })
                .where((car) {
                  final carLocation = (car['Set Location'] as String? ?? '')
                      .toLowerCase();
                  return carLocation.contains(location.toLowerCase());
                })
                .toList();
          });
    });

// ========== SINGLE CAR BY ID ==========
final carByIdProvider = StreamProvider.family<Map<String, dynamic>?, String>((
  ref,
  carId,
) {
  final carsCollection = ref.watch(carsCollectionProvider);

  return carsCollection.doc(carId).snapshots().map((snapshot) {
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      data['id'] = snapshot.id;
      return data;
    }
    return null;
  });
});

// ========== CARS BY SELLER ==========
final carsBySellerProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, sellerUid) {
      final carsCollection = ref.watch(carsCollectionProvider);

      return carsCollection
          .where('seller_uid', isEqualTo: sellerUid)
          .where('status', isEqualTo: 'active')
          .orderBy('listed_at', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList();
          });
    });

// ========== SEARCH CARS BY QUERY (using Provider instead of StreamProvider) ==========
final searchCarsProvider = Provider.family<List<Map<String, dynamic>>, String>((
  ref,
  searchQuery,
) {
  final allCarsAsync = ref.watch(allCarsStreamProvider);

  return allCarsAsync.when(
    data: (cars) {
      if (searchQuery.isEmpty) {
        return [];
      }

      final query = searchQuery.toLowerCase();
      return cars.where((car) {
        final brand = (car['Brand'] as String? ?? '').toLowerCase();
        final model = (car['Model'] as String? ?? '').toLowerCase();
        final carName = (car['Car Name'] as String? ?? '').toLowerCase();
        final location = (car['Set Location'] as String? ?? '').toLowerCase();

        return brand.contains(query) ||
            model.contains(query) ||
            carName.contains(query) ||
            location.contains(query);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// ========== GET UNIQUE BRANDS ==========
final uniqueBrandsProvider = Provider<List<String>>((ref) {
  final allCarsAsync = ref.watch(allCarsStreamProvider);

  return allCarsAsync.when(
    data: (cars) {
      final brands = cars
          .map((car) => car['Brand'] as String? ?? '')
          .where((brand) => brand.isNotEmpty)
          .toSet()
          .toList();
      brands.sort();
      return ['All', ...brands];
    },
    loading: () => ['All'],
    error: (_, __) => ['All'],
  );
});

// ========== GET UNIQUE FUEL TYPES ==========
final uniqueFuelTypesProvider = Provider<List<String>>((ref) {
  final allCarsAsync = ref.watch(allCarsStreamProvider);

  return allCarsAsync.when(
    data: (cars) {
      final fuelTypes = cars
          .map((car) => car['Fuel Type'] as String? ?? '')
          .where((fuel) => fuel.isNotEmpty)
          .toSet()
          .toList();
      fuelTypes.sort();
      return ['All', ...fuelTypes];
    },
    loading: () => ['All'],
    error: (_, __) => ['All'],
  );
});

// ========== GET UNIQUE LOCATIONS ==========
final uniqueLocationsProvider = Provider<List<String>>((ref) {
  final allCarsAsync = ref.watch(allCarsStreamProvider);

  return allCarsAsync.when(
    data: (cars) {
      final locations = cars
          .map((car) => car['Set Location'] as String? ?? '')
          .where((loc) => loc.isNotEmpty)
          .toSet()
          .toList();
      locations.sort();
      return ['All', ...locations];
    },
    loading: () => ['All'],
    error: (_, __) => ['All'],
  );
});

// ========== SELECTED FILTER NOTIFIERS ==========

// Selected Brand Notifier
class SelectedBrandNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void setBrand(String brand) {
    state = brand;
  }

  void reset() {
    state = 'All';
  }
}

final selectedBrandProvider = NotifierProvider<SelectedBrandNotifier, String>(
  SelectedBrandNotifier.new,
);

// Selected Fuel Type Notifier
class SelectedFuelTypeNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void setFuelType(String fuelType) {
    state = fuelType;
  }

  void reset() {
    state = 'All';
  }
}

final selectedFuelTypeProvider =
    NotifierProvider<SelectedFuelTypeNotifier, String>(
      SelectedFuelTypeNotifier.new,
    );

// Selected Transmission Notifier
class SelectedTransmissionNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void setTransmission(String transmission) {
    state = transmission;
  }

  void reset() {
    state = 'All';
  }
}

final selectedTransmissionProvider =
    NotifierProvider<SelectedTransmissionNotifier, String>(
      SelectedTransmissionNotifier.new,
    );

// Search Query Notifier
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);
