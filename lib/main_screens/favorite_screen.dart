import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/car_ad_provider.dart';
import '../providers/favorites_provider.dart';
import 'car_details/car_details.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              color: const Color(0xFFE8C87C),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Top Bar with Logo and Menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A5F),
                          borderRadius: BorderRadius. circular(8),
                        ),
                        child: const Text(
                          'GC',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE8C87C),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Color(0xFF1E3A5F),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD54F),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF1E3A5F),
                                ),
                              ),
                              const Text(
                                "Favorite Cars",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A5F),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E3A5F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                child: const Text(
                                  'Know more',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Favorites List
            Expanded(
              child: favoritesAsync.when(
                data: (favoriteIds) {
                  print('❤️ Favorites Screen: Received ${favoriteIds.length} favorite IDs');
                  print('❤️ Favorite IDs: $favoriteIds');

                  // Check if user is logged in
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    print('⚠️ User not logged in');
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.login,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Please log in to view favorites',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (favoriteIds.isEmpty) {
                    print('📭 No favorites found');
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons. favorite_border,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No favorites yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A5F),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add cars to favorites to see them here',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets. all(16),
                    itemCount: favoriteIds.length,
                    itemBuilder: (context, index) {
                      final adId = favoriteIds[index];
                      print('🔄 Building card for car ID: $adId');
                      return _FavoriteCarCard(adId: adId);
                    },
                  );
                },
                loading: () {
                  print('⏳ Loading favorites...');
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1E3A5F),
                    ),
                  );
                },
                error: (error, stack) {
                  print('❌ Error loading favorites: $error');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading favorites',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors. red[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors. grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteCarCard extends ConsumerWidget {
  final String adId;

  const _FavoriteCarCard({required this.adId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('🎴 _FavoriteCarCard: Building card for ID: $adId');
    final carAsync = ref.watch(carByIdProvider(adId));

    return carAsync.when(
      data: (car) {
        if (car == null) {
          print('❌ Car data is null for ID: $adId');
          return _buildDeletedCarCard(context, ref);
        }

        print('✅ Car data loaded: ${car['Car Name']}');

        final carName = car['Car Name'] ??  '${car['Brand']} ${car['Model']}';
        final location = car['Set Location'] ?? 'Unknown';
        final fuelType = car['Fuel Type'] ?? 'Unknown';
        final price = car['Final Estimated Price'] ?? car['Estimated Price'] ?? 'N/A';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailsScreen(carId: adId),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                // Car Image
                Container(
                  width: 100,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.directions_car,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Car Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Location: $location - Fuel: $fuelType',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors. grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        price. toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Favorite Icon and View Button
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 24,
                      ),
                      onPressed: () async {
                        try {
                          await ref.read(favoritesServiceProvider).removeFavorite(adId);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Removed from favorites'),
                                backgroundColor: Color(0xFF1E3A5F),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarDetailsScreen(carId: adId),
                          ),
                        );
                      },
                      style: ElevatedButton. styleFrom(
                        backgroundColor: const Color(0xFF1E3A5F),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'View car',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors. white,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 12, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () {
        print('⏳ Loading car data for ID: $adId');
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors. white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF1E3A5F),
            ),
          ),
        );
      },
      error: (error, stack) {
        print('❌ Error loading car data for ID: $adId - Error: $error');
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.error, color: Colors.red),
            title: const Text('Error loading car'),
            subtitle: Text(error.toString()),
          ),
        );
      },
    );
  }

  Widget _buildDeletedCarCard(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons. directions_car,
                size: 40,
                color: Colors. grey[600],
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Car no longer available',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'This listing has been removed',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors. grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              try {
                await ref.read(favoritesServiceProvider).removeFavorite(adId);
                if (context. mounted) {
                  ScaffoldMessenger.of(context). showSnackBar(
                    const SnackBar(
                      content: Text('Removed from favorites'),
                      backgroundColor: Color(0xFF1E3A5F),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}