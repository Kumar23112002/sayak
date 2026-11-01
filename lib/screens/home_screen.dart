import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? user;

  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  // Selected delivery address
  String _currentAddress = 'Flat 402, Green Valley Apartments, Hyderabad';
  String _addressType = 'Home';

  // Cart state: itemId -> quantity
  final Map<String, int> _cart = {};

  // Favorite product IDs
  final Set<String> _favorites = {};

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.apps_rounded, 'emoji': '✨'},
    {'name': 'Vegetables', 'icon': Icons.eco_rounded, 'emoji': '🥬', 'tag': 'Organic'},
    {'name': 'Fruits', 'icon': Icons.apple_rounded, 'emoji': '🍎', 'tag': 'Fresh'},
    {'name': 'Dairy & Milk', 'icon': Icons.local_drink_rounded, 'emoji': '🥛', 'tag': 'Pure'},
    {'name': 'Bakery & Snacks', 'icon': Icons.bakery_dining_rounded, 'emoji': '🍞', 'tag': 'Crisp'},
    {'name': 'Atta, Rice & Dal', 'icon': Icons.grain_rounded, 'emoji': '🌾', 'tag': 'Staples'},
    {'name': 'Beverages', 'icon': Icons.local_cafe_rounded, 'emoji': '🧃', 'tag': 'Chilled'},
  ];

  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': 'veg_1',
      'name': 'Farm Fresh Tomatoes',
      'vernacular': 'Tamatar • టమాటాలు',
      'category': 'Vegetables',
      'weight': '1 kg',
      'price': 34,
      'originalPrice': 50,
      'discount': '32% OFF',
      'emoji': '🍅',
      'color': Color(0xFFFFECEB),
      'isVeg': true,
      'rating': 4.8,
      'ratingCount': 340,
      'isFlashDeal': true,
      'badge': 'BESTSELLER',
    },
    {
      'id': 'veg_2',
      'name': 'Fresh Mountain Potato',
      'vernacular': 'Aloo • బంగాళాదుంపలు',
      'category': 'Vegetables',
      'weight': '1 kg',
      'price': 28,
      'originalPrice': 40,
      'discount': '30% OFF',
      'emoji': '🥔',
      'color': Color(0xFFF9F0E6),
      'isVeg': true,
      'rating': 4.7,
      'ratingCount': 280,
      'isFlashDeal': false,
      'badge': 'POPULAR',
    },
    {
      'id': 'veg_3',
      'name': 'Fresh Red Onions',
      'vernacular': 'Pyaaz • ఉల్లిపాయలు',
      'category': 'Vegetables',
      'weight': '1 kg',
      'price': 42,
      'originalPrice': 55,
      'discount': '24% OFF',
      'emoji': '🧅',
      'color': Color(0xFFF7ECF7),
      'isVeg': true,
      'rating': 4.9,
      'ratingCount': 510,
      'isFlashDeal': true,
      'badge': 'DAILY MUST',
    },
    {
      'id': 'veg_4',
      'name': 'Organic Palak (Spinach)',
      'vernacular': 'Palak • పాలకూర',
      'category': 'Vegetables',
      'weight': '250 g bunch',
      'price': 18,
      'originalPrice': 25,
      'discount': '28% OFF',
      'emoji': '🥬',
      'color': Color(0xFFE9F8EE),
      'isVeg': true,
      'rating': 4.8,
      'ratingCount': 195,
      'isFlashDeal': false,
      'badge': 'FARM PICK',
    },
    {
      'id': 'veg_5',
      'name': 'Crisp Red Carrots',
      'vernacular': 'Gajar • క్యారెట్లు',
      'category': 'Vegetables',
      'weight': '500 g',
      'price': 24,
      'originalPrice': 35,
      'discount': '31% OFF',
      'emoji': '🥕',
      'color': Color(0xFFFFF0E6),
      'isVeg': true,
      'rating': 4.7,
      'ratingCount': 160,
      'isFlashDeal': true,
      'badge': 'SWEET & CRISP',
    },
    {
      'id': 'veg_6',
      'name': 'Fresh Green Chilli & Coriander',
      'vernacular': 'Mirchi • పచ్చిమిర్చి',
      'category': 'Vegetables',
      'weight': '150 g pack',
      'price': 15,
      'originalPrice': 22,
      'discount': '32% OFF',
      'emoji': '🌶️',
      'color': Color(0xFFEDF8EE),
      'isVeg': true,
      'rating': 4.9,
      'ratingCount': 310,
      'isFlashDeal': false,
      'badge': 'SPICY FRESH',
    },
    {
      'id': 'fruit_1',
      'name': 'Shimla Royal Apples',
      'vernacular': 'Seb • యాపిల్స్',
      'category': 'Fruits',
      'weight': '500 g (4 pcs)',
      'price': 119,
      'originalPrice': 160,
      'discount': '25% OFF',
      'emoji': '🍎',
      'color': Color(0xFFFFEBEB),
      'isVeg': true,
      'rating': 4.9,
      'ratingCount': 420,
      'isFlashDeal': true,
      'badge': 'PREMIUM',
    },
    {
      'id': 'fruit_2',
      'name': 'Robusta Fresh Bananas',
      'vernacular': 'Kela • అరటిపండ్లు',
      'category': 'Fruits',
      'weight': '6 pcs pack',
      'price': 38,
      'originalPrice': 50,
      'discount': '24% OFF',
      'emoji': '🍌',
      'color': Color(0xFFFFFBEB),
      'isVeg': true,
      'rating': 4.7,
      'ratingCount': 340,
      'isFlashDeal': false,
      'badge': 'ENERGY RICH',
    },
    {
      'id': 'fruit_3',
      'name': 'Alphonso Sweet Mangoes',
      'vernacular': 'Aam • బేనీషా మామిడి',
      'category': 'Fruits',
      'weight': '1 kg pack',
      'price': 149,
      'originalPrice': 220,
      'discount': '32% OFF',
      'emoji': '🥭',
      'color': Color(0xFFFFF7E6),
      'isVeg': true,
      'rating': 4.9,
      'ratingCount': 580,
      'isFlashDeal': true,
      'badge': 'SEASON SPECIAL',
    },
    {
      'id': 'dairy_1',
      'name': 'Full Cream Cow Milk',
      'vernacular': 'Doodh • ఆవు పాలు',
      'category': 'Dairy & Milk',
      'weight': '1 Litre pouch',
      'price': 64,
      'originalPrice': 70,
      'discount': '8% OFF',
      'emoji': '🥛',
      'color': Color(0xFFEBF4FF),
      'isVeg': true,
      'rating': 4.9,
      'ratingCount': 720,
      'isFlashDeal': true,
      'badge': 'DAILY MORNING',
    },
    {
      'id': 'dairy_2',
      'name': 'Fresh Farm Malai Paneer',
      'vernacular': 'Paneer • తాజా పనీర్',
      'category': 'Dairy & Milk',
      'weight': '200 g pack',
      'price': 89,
      'originalPrice': 110,
      'discount': '19% OFF',
      'emoji': '🧀',
      'color': Color(0xFFFFF9E6),
      'isVeg': true,
      'rating': 4.8,
      'ratingCount': 290,
      'isFlashDeal': false,
      'badge': 'SOFT & FRESH',
    },
    {
      'id': 'dairy_3',
      'name': 'Pure Farm Cow Ghee',
      'vernacular': 'Desi Ghee • స్వచ్ఛమైన నెయ్యి',
      'category': 'Dairy & Milk',
      'weight': '500 ml jar',
      'price': 340,
      'originalPrice': 399,
      'discount': '15% OFF',
      'emoji': '🧈',
      'color': Color(0xFFFFF8E7),
      'isVeg': true,
      'rating': 4.9,
      'ratingCount': 410,
      'isFlashDeal': false,
      'badge': 'PURE AROMATIC',
    },
    {
      'id': 'grain_1',
      'name': 'Aashirvaad Sharbati Atta',
      'vernacular': 'Atta • గోధుమ పిండి',
      'category': 'Atta, Rice & Dal',
      'weight': '5 kg bag',
      'price': 265,
      'originalPrice': 295,
      'discount': '10% OFF',
      'emoji': '🌾',
      'color': Color(0xFFFAF2E6),
      'isVeg': true,
      'rating': 4.9,
      'ratingCount': 890,
      'isFlashDeal': false,
      'badge': 'KITCHEN STAPLE',
    },
    {
      'id': 'grain_2',
      'name': 'Daawat Rozana Basmati Rice',
      'vernacular': 'Basmati • బాస్మతి బియ్యం',
      'category': 'Atta, Rice & Dal',
      'weight': '5 kg bag',
      'price': 360,
      'originalPrice': 440,
      'discount': '18% OFF',
      'emoji': '🍚',
      'color': Color(0xFFF7F5EC),
      'isVeg': true,
      'rating': 4.8,
      'ratingCount': 470,
      'isFlashDeal': true,
      'badge': 'LONG GRAIN',
    },
    {
      'id': 'bakery_1',
      'name': 'Whole Wheat Brown Bread',
      'vernacular': 'Bread • బ్రౌన్ బ్రెడ్',
      'category': 'Bakery & Snacks',
      'weight': '400 g',
      'price': 45,
      'originalPrice': 55,
      'discount': '18% OFF',
      'emoji': '🍞',
      'color': Color(0xFFF9F1EB),
      'isVeg': true,
      'rating': 4.6,
      'ratingCount': 220,
      'isFlashDeal': false,
      'badge': 'HEALTHY',
    },
    {
      'id': 'bakery_2',
      'name': 'Royal Cashews & Almonds',
      'vernacular': 'Kaju Badam • జీడిపప్పు బాదం',
      'category': 'Bakery & Snacks',
      'weight': '200 g pack',
      'price': 189,
      'originalPrice': 260,
      'discount': '27% OFF',
      'emoji': '🥜',
      'color': Color(0xFFFDF5E6),
      'isVeg': true,
      'rating': 4.9,
      'ratingCount': 310,
      'isFlashDeal': true,
      'badge': 'ENERGY BOOST',
    },
    {
      'id': 'bev_1',
      'name': 'Fresh Tender Coconut',
      'vernacular': 'Nariyal • కొబ్బరి బొండం',
      'category': 'Beverages',
      'weight': '1 pc (Sweet water)',
      'price': 48,
      'originalPrice': 65,
      'discount': '26% OFF',
      'emoji': '🥥',
      'color': Color(0xFFEDF7ED),
      'isVeg': true,
      'rating': 4.9,
      'ratingCount': 530,
      'isFlashDeal': true,
      'badge': 'NATURAL HYDRATION',
    },
    {
      'id': 'bev_2',
      'name': 'Fresh Cold-Pressed Orange Juice',
      'vernacular': 'Santra • నారింజ రసం',
      'category': 'Beverages',
      'weight': '1 Litre bottle',
      'price': 89,
      'originalPrice': 115,
      'discount': '22% OFF',
      'emoji': '🧃',
      'color': Color(0xFFFFF3E0),
      'isVeg': true,
      'rating': 4.8,
      'ratingCount': 180,
      'isFlashDeal': false,
      'badge': '100% PULP',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  String get _userName {
    final name = widget.user?['fullName'] ?? BackendAuthService.currentUser?['fullName'];
    if (name != null && name.toString().trim().isNotEmpty) {
      return name.toString().trim();
    }
    return 'Sayak Customer';
  }

  String get _userPhone {
    final phone = widget.user?['phoneNumber'] ??
        widget.user?['phone'] ??
        BackendAuthService.currentUser?['phoneNumber'] ??
        BackendAuthService.currentUser?['phone'];
    if (phone != null && phone.toString().trim().isNotEmpty) {
      return phone.toString().trim();
    }
    return '';
  }

  int get _cartItemCount => _cart.values.fold(0, (sum, qty) => sum + qty);

  int get _cartTotalAmount {
    int total = 0;
    _cart.forEach((id, qty) {
      final product = _allProducts.firstWhere((p) => p['id'] == id, orElse: () => {});
      if (product.isNotEmpty) {
        total += ((product['price'] as int) * qty);
      }
    });
    return total;
  }

  List<Map<String, dynamic>> get _flashDeals {
    return _allProducts.where((p) => p['isFlashDeal'] == true).toList();
  }

  List<Map<String, dynamic>> get _filteredProducts {
    return _allProducts.where((p) {
      final matchesCategory = _selectedCategory == 'All' || p['category'] == _selectedCategory;
      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          (p['name'] as String).toLowerCase().contains(query) ||
          ((p['vernacular'] as String?)?.toLowerCase().contains(query) ?? false) ||
          (p['category'] as String).toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _addToCart(String id) {
    setState(() {
      _cart[id] = (_cart[id] ?? 0) + 1;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Added to your basket! • Total: ₹$_cartTotalAmount',
                style: const TextStyle(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.brandDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _removeFromCart(String id) {
    setState(() {
      final current = _cart[id] ?? 0;
      if (current <= 1) {
        _cart.remove(id);
      } else {
        _cart[id] = current - 1;
      }
    });
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
  }

  void _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Log Out from Sayak?',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to log out? You will need to verify your mobile number again to log in.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await BackendAuthService.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showAddressPicker() {
    final textController = TextEditingController(text: _currentAddress);
    String selectedType = _addressType;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.location_on_rounded, color: AppColors.brandPrimary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Orders deliver in 10 minutes to this location',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Address Type Chips
              Row(
                children: ['Home', 'Work', 'Other'].map((type) {
                  final isSelected = selectedType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      selectedColor: AppColors.brandPrimary,
                      backgroundColor: AppColors.primarySurface,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.brandPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onSelected: (val) {
                        setSheetState(() => selectedType = type);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: textController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Flat / House No, Street, Landmark',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.brandPrimary, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Save Delivery Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  onPressed: () {
                    setState(() {
                      _currentAddress = textController.text.trim();
                      _addressType = selectedType;
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Delivery location updated to $selectedType!'),
                        backgroundColor: AppColors.brandPrimary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final items = _cart.entries.map((entry) {
            final product = _allProducts.firstWhere((p) => p['id'] == entry.key);
            return {'product': product, 'qty': entry.value};
          }).toList();

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.shopping_bag_rounded, color: AppColors.brandPrimary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sayak Basket ($_cartItemCount items)',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                                ),
                                const Text(
                                  '⚡ Delivering in 10 Mins',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.accentOrange),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (items.isNotEmpty)
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: () {
                          setState(() => _cart.clear());
                          Navigator.pop(ctx);
                        },
                        icon: const Icon(Icons.delete_outline_rounded, size: 16),
                        label: const Text('Clear', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Free Delivery Progress Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFC8E6C9)),
                  ),
                  child: Row(
                    children: const [
                      Text('🎉', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Yay! Free 10-Minute Express Delivery unlocked!',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF1B5E20)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('🛒', style: TextStyle(fontSize: 44)),
                              SizedBox(height: 10),
                              Text(
                                'Your cart is currently empty',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                              SizedBox(height: 4),
                              Text('Explore farm fresh items and add them here!', style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, _) => const Divider(height: 12),
                          itemBuilder: (ctx, index) {
                            final item = items[index];
                            final product = item['product'] as Map<String, dynamic>;
                            final qty = item['qty'] as int;
                            final pId = product['id'] as String;

                            return Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: product['color'] as Color,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Center(
                                    child: Text(product['emoji'] as String, style: const TextStyle(fontSize: 22)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'] as String,
                                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.textPrimary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${product['weight']} • ₹${product['price']}',
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5, fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySurface,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.brandPrimary.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () {
                                          _removeFromCart(pId);
                                          setSheetState(() {});
                                          setState(() {});
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                          child: Icon(Icons.remove_rounded, color: AppColors.brandPrimary, size: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          '$qty',
                                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.brandPrimary),
                                        ),
                                      ),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () {
                                          _addToCart(pId);
                                          setSheetState(() {});
                                          setState(() {});
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                          child: Icon(Icons.add_rounded, color: AppColors.brandPrimary, size: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
                const Divider(),
                // Bill summary card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Item Total', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w600)),
                          Text('₹$_cartTotalAmount', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('10-Min Fast Delivery', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w600)),
                          Text('FREE', style: TextStyle(color: AppColors.brandPrimary, fontWeight: FontWeight.w800, fontSize: 12.5)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Paper Bag & Handling', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w600)),
                          Text('FREE', style: TextStyle(color: AppColors.brandPrimary, fontWeight: FontWeight.w800, fontSize: 12.5)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Divider(height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Grand Total:', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.textPrimary)),
                          Text('₹$_cartTotalAmount', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.brandPrimary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: items.isEmpty
                        ? null
                        : () {
                            Navigator.pop(ctx);
                            setState(() => _cart.clear());
                            showDialog(
                              context: context,
                              builder: (c) => AlertDialog(
                                backgroundColor: AppColors.surface,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                title: Row(
                                  children: const [
                                    Icon(Icons.check_circle_rounded, color: AppColors.brandLight, size: 26),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Order Placed! 🎉',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  'Thank you $_userName! Your fresh groceries are being packed and will arrive in 10 minutes at:\n\n📍 $_currentAddress',
                                  style: const TextStyle(height: 1.4, color: AppColors.textSecondary),
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.brandPrimary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed: () => Navigator.pop(c),
                                    child: const Text('Awesome!', style: TextStyle(fontWeight: FontWeight.w800)),
                                  ),
                                ],
                              ),
                            );
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bolt_rounded, color: AppColors.accentYellow, size: 20),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Place 10-Min Order • ₹$_cartTotalAmount',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeTab(),
            _buildCategoriesTab(),
            _buildCartTab(),
            _buildProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _currentIndex == 0 && _cartItemCount > 0 ? _buildFloatingCartBar() : null,
    );
  }

  Widget _buildFloatingCartBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF063A20), Color(0xFF0A5830), Color(0xFF147A46)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A5830).withValues(alpha: 0.45),
            blurRadius: 18,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _showCartSheet,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_basket_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_cartItemCount ${_cartItemCount == 1 ? 'item' : 'items'} • ₹$_cartTotalAmount',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.bolt_rounded, color: AppColors.accentYellow, size: 13),
                          Flexible(
                            child: Text(
                              'FREE 10-Min Delivery',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: AppColors.brandBright, fontSize: 10.5, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'View Cart',
                        style: TextStyle(color: AppColors.brandDark, fontWeight: FontWeight.w900, fontSize: 12),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.arrow_forward_rounded, color: AppColors.brandDark, size: 13),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: AppColors.softShadow,
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.brandPrimary,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11.5),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront_rounded),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            activeIcon: Icon(Icons.grid_view_sharp),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: _cartItemCount > 0,
              label: Text('$_cartItemCount'),
              backgroundColor: AppColors.accentOrange,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: _cartItemCount > 0,
              label: Text('$_cartItemCount'),
              backgroundColor: AppColors.accentOrange,
              child: const Icon(Icons.shopping_bag_rounded),
            ),
            label: 'Basket',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      color: AppColors.brandPrimary,
      onRefresh: () async => await Future.delayed(const Duration(milliseconds: 400)),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Top Bar Header
          SliverToBoxAdapter(
            child: _buildTopHeader(),
          ),

          // 2. Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: _buildSearchBar(),
            ),
          ),

          // 3. Trust & Speed Perks Strip
          SliverToBoxAdapter(
            child: _buildTrustPerksStrip(),
          ),

          // 4. Hero Promo Banners Carousel
          SliverToBoxAdapter(
            child: _buildPromoBanners(),
          ),

          // 5. Visual Story Categories Grid (Horizontal Scroll - NO overflow!)
          SliverToBoxAdapter(
            child: _buildVisualCategoryGrid(),
          ),

          // 6. Flash Deal of the Day Rail
          if (_searchQuery.isEmpty)
            SliverToBoxAdapter(
              child: _buildFlashDealsSection(),
            ),

          // 7. Category Filter Pills
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: _buildCategoryList(),
            ),
          ),

          // 8. Main Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            _selectedCategory == 'All' ? '🌱 All Farm Produce' : _selectedCategory,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.brandPrimary.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            '${_filteredProducts.length}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: AppColors.brandPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.bolt_rounded, size: 14, color: AppColors.accentOrange),
                        SizedBox(width: 2),
                        Text(
                          '10 Mins',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 9. Products Grid (Aspect ratio 0.56 gives ample room to avoid any card overflow!)
          _filteredProducts.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: const [
                          Icon(Icons.search_off_rounded, size: 50, color: AppColors.textMuted),
                          SizedBox(height: 12),
                          Text(
                            'No items found matching your search',
                            style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text('Try searching for vegetables, milk, atta or fruits', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.56,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildProductCard(_filteredProducts[index]);
                      },
                      childCount: _filteredProducts.length,
                    ),
                  ),
                ),

          // 10. Brand Assurance Footer Card
          if (_searchQuery.isEmpty)
            SliverToBoxAdapter(
              child: _buildTrustFooterCard(),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      color: AppColors.surface,
      child: Row(
        children: [
          // Sayak Logo with brand pill
          Container(
            height: 40,
            width: 42,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandPrimary.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/logo.jpeg', fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 10),

          // Location Selector
          Expanded(
            child: GestureDetector(
              onTap: _showAddressPicker,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF77F00), Color(0xFFE65100)],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.bolt_rounded, size: 11, color: Colors.white),
                            SizedBox(width: 2),
                            Text(
                              '10 MINS',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _addressType,
                          style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.brandPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _currentAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.brandPrimary),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // User Profile Avatar
          GestureDetector(
            onTap: () => setState(() => _currentIndex = 3),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.brandPrimary, width: 1.8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandPrimary.withValues(alpha: 0.12),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primarySurface,
                child: Text(
                  _userName.isNotEmpty ? _userName[0].toUpperCase() : 'S',
                  style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandPrimary, fontSize: 13.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: AppColors.softShadow,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'Search vegetables, fruits, milk, atta...',
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w500),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.brandPrimary, size: 22),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.mic_none_rounded, color: AppColors.brandPrimary, size: 17),
                    ),
                  ],
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildTrustPerksStrip() {
    final perks = [
      {'icon': '⚡', 'title': '10-Min Fast', 'sub': 'Doorstep Delivery'},
      {'icon': '🚜', 'title': 'Farm Fresh', 'sub': 'Directly Sourced'},
      {'icon': '💰', 'title': 'Lowest Price', 'sub': 'Guaranteed'},
      {'icon': '🧼', 'title': 'Ozone Clean', 'sub': '100% Sanitized'},
    ];

    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: perks.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final p = perks[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(p['icon']!, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      p['title']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    Text(
                      p['sub']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoBanners() {
    final banners = [
      {
        'tag': 'HARVEST FESTIVAL',
        'title': 'Farm Fresh\n40% OFF',
        'subtitle': 'Zero preservatives • 100% Natural',
        'code': 'USE: FARM40',
        'emoji': '🥬',
        'gradient': const LinearGradient(
          colors: [Color(0xFF042D18), Color(0xFF0A5830), Color(0xFF16834B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'tag': 'LIGHTNING SPEED',
        'title': 'Free 10-Min\nDelivery',
        'subtitle': 'On orders above ₹149 today',
        'code': 'USE: SPEED10',
        'emoji': '⚡',
        'gradient': const LinearGradient(
          colors: [Color(0xFFD84315), Color(0xFFF57C00), Color(0xFFFFA000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'tag': 'MORNING ESSENTIALS',
        'title': 'Pure Cow Milk &\nFresh Malai Paneer',
        'subtitle': 'Delivered fresh at your doorstep',
        'code': 'USE: PUREMILK',
        'emoji': '🥛',
        'gradient': const LinearGradient(
          colors: [Color(0xFF075985), Color(0xFF0284C7), Color(0xFF38BDF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 146,
          child: PageView.builder(
            controller: _bannerController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (i) => setState(() => _currentBannerIndex = i),
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final b = banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: b['gradient'] as LinearGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (b['gradient'] as LinearGradient).colors.first.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              b['tag'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            b['title'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w900, color: Colors.white, height: 1.15),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            b['subtitle'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10.5, color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(b['emoji'] as String, style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            b['code'] as String,
                            style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: AppColors.brandDark),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
              width: _currentBannerIndex == index ? 20 : 6,
              height: 5,
              decoration: BoxDecoration(
                color: _currentBannerIndex == index ? AppColors.brandPrimary : AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisualCategoryGrid() {
    final quickCats = [
      {'name': 'Vegetables', 'telugu': 'కూరగాయలు', 'emoji': '🥬', 'color': Color(0xFFE8F5E9)},
      {'name': 'Fruits', 'telugu': 'పండ్లు', 'emoji': '🍎', 'color': Color(0xFFFFEBEE)},
      {'name': 'Dairy & Milk', 'telugu': 'పాలు', 'emoji': '🥛', 'color': Color(0xFFE3F2FD)},
      {'name': 'Bakery & Snacks', 'telugu': 'స్నాక్స్', 'emoji': '🍞', 'color': Color(0xFFFFF3E0)},
      {'name': 'Atta, Rice & Dal', 'telugu': 'బియ్యం పిండి', 'emoji': '🌾', 'color': Color(0xFFEFEBE9)},
      {'name': 'Beverages', 'telugu': 'పానీయాలు', 'emoji': '🧃', 'color': Color(0xFFEDE7F6)},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Explore Categories',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              ),
              GestureDetector(
                onTap: () => setState(() => _currentIndex = 1),
                child: const Text(
                  'See All ➔',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.brandPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Scrollable horizontal list to guarantee NO right overflow
          SizedBox(
            height: 82,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: quickCats.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final cat = quickCats[index];
                final isSelected = _selectedCategory == cat['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat['name'] as String;
                    });
                  },
                  child: SizedBox(
                    width: 64,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: cat['color'] as Color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.brandPrimary : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(cat['emoji'] as String, style: const TextStyle(fontSize: 23)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cat['name'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                            color: isSelected ? AppColors.brandPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashDealsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      color: const Color(0xFFFFF8E7),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Text('🔥', style: TextStyle(fontSize: 17)),
                    SizedBox(width: 6),
                    Text(
                      'Flash Deals of the Day',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFFB45309)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Ends in 02h : 45m',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 202,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _flashDeals.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = _flashDeals[index];
                final pId = product['id'] as String;
                final qty = _cart[pId] ?? 0;

                return Container(
                  width: 148,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Emoji & discount tag
                      Stack(
                        children: [
                          Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: product['color'] as Color,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                            ),
                            child: Center(
                              child: Text(product['emoji'] as String, style: const TextStyle(fontSize: 36)),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDC2626),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                product['discount'] as String,
                                style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.textPrimary),
                            ),
                            Text(
                              product['weight'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '₹${product['price']}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.brandPrimary),
                                      ),
                                      Text(
                                        '₹${product['originalPrice']}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: AppColors.textMuted,
                                          fontSize: 9.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                qty == 0
                                    ? SizedBox(
                                        height: 28,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.brandPrimary,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          onPressed: () => _addToCart(pId),
                                          child: const Text('+ ADD', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                                        ),
                                      )
                                    : Container(
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: AppColors.brandPrimary,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () => _removeFromCart(pId),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                child: Icon(Icons.remove, size: 14, color: Colors.white),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 2),
                                              child: Text('$qty', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11)),
                                            ),
                                            InkWell(
                                              onTap: () => _addToCart(pId),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                child: Icon(Icons.add, size: 14, color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat['name'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cat['emoji'] != null) ...[
                    Text(cat['emoji'] as String, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                  ],
                  Text(cat['name'] as String),
                ],
              ),
              selected: isSelected,
              showCheckmark: false,
              selectedColor: AppColors.brandPrimary,
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected ? AppColors.brandPrimary : AppColors.border,
                  width: 1.2,
                ),
              ),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                fontSize: 11.5,
              ),
              onSelected: (val) {
                setState(() => _selectedCategory = cat['name'] as String);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final pId = product['id'] as String;
    final qty = _cart[pId] ?? 0;
    final isFav = _favorites.contains(pId);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1.1),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji Container + Veg Symbol + Favorite Heart + Discount Tag
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: product['color'] as Color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    product['emoji'] as String,
                    style: const TextStyle(fontSize: 46),
                  ),
                ),
                // Veg Symbol (FSSAI green square)
                Positioned(
                  top: 7,
                  left: 7,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF2E7D32), width: 1.2),
                    ),
                    child: const Icon(Icons.circle, size: 6, color: Color(0xFF2E7D32)),
                  ),
                ),
                // Discount Tag
                Positioned(
                  top: 7,
                  left: 26,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      product['discount'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                // Heart Favorite Icon
                Positioned(
                  top: 3,
                  right: 3,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 19,
                      color: isFav ? AppColors.accentTomato : AppColors.textMuted,
                    ),
                    onPressed: () => _toggleFavorite(pId),
                  ),
                ),
                // Speed pill bottom right
                Positioned(
                  bottom: 5,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.bolt_rounded, size: 11, color: AppColors.accentOrange),
                        Text(
                          '10m',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.brandDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details Body with plenty of headroom
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(9, 6, 9, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Star Rating
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 13, color: AppColors.accentYellow),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              '${product['rating']} (${product['ratingCount']})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product['name'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: AppColors.textPrimary),
                      ),
                      if (product['vernacular'] != null)
                        Text(
                          product['vernacular'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          product['weight'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.brandPrimary, fontSize: 9.5, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹${product['price']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.brandPrimary),
                            ),
                            Text(
                              '₹${product['originalPrice']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Add / Quantity button
                      qty == 0
                          ? SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primarySurface,
                                  foregroundColor: AppColors.brandPrimary,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(color: AppColors.brandPrimary, width: 1.3),
                                  ),
                                ),
                                onPressed: () => _addToCart(pId),
                                child: const Text(
                                  '+ ADD',
                                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5),
                                ),
                              ),
                            )
                          : Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.brandPrimary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () => _removeFromCart(pId),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                      child: Icon(Icons.remove, size: 14, color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: Text(
                                      '$qty',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => _addToCart(pId),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                      child: Icon(Icons.add, size: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
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
    );
  }

  Widget _buildTrustFooterCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('🌿', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Text(
                'The Sayak Quality Guarantee',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTrustPoint('🚜 Direct Farm Sourcing', 'Harvested daily at 4 AM from local Telugu and neighboring farmers.'),
          const SizedBox(height: 8),
          _buildTrustPoint('🧼 3-Stage Ozone Washed', 'Safe, thoroughly sanitized, and pesticide-free fresh produce.'),
          const SizedBox(height: 8),
          _buildTrustPoint('⚡ 10-Minute Express Delivery', 'Chilled dark-store hubs in your neighborhood for rapid doorstep delivery.'),
        ],
      ),
    );
  }

  Widget _buildTrustPoint(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline_rounded, color: AppColors.brandPrimary, size: 17),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Text(desc, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('All Grocery Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Tap any category to explore fresh essentials', style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          const SizedBox(height: 14),
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.15,
              ),
              itemCount: _categories.where((c) => c['name'] != 'All').length,
              itemBuilder: (context, index) {
                final cat = _categories.where((c) => c['name'] != 'All').toList()[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat['name'] as String;
                      _currentIndex = 0;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.softShadow,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(cat['emoji'] as String, style: const TextStyle(fontSize: 34)),
                        const SizedBox(height: 6),
                        Text(
                          cat['name'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (cat['tag'] != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              cat['tag'] as String,
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.brandPrimary),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartTab() {
    if (_cartItemCount == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  color: AppColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_basket_outlined, size: 58, color: AppColors.brandPrimary),
              ),
              const SizedBox(height: 18),
              const Text('Your cart is empty', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              const Text(
                'Explore fresh vegetables, dairy and everyday essentials to start shopping!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, height: 1.4, fontSize: 13),
              ),
              const SizedBox(height: 22),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.storefront_rounded),
                onPressed: () => setState(() => _currentIndex = 0),
                label: const Text('Start Shopping', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Basket ($_cartItemCount)', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                onPressed: () => setState(() => _cart.clear()),
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: const Text('Clear All', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: _cart.entries.map((entry) {
                final product = _allProducts.firstWhere((p) => p['id'] == entry.key);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: product['color'] as Color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(product['emoji'] as String, style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                            ),
                            Text(
                              '₹${product['price']} • ${product['weight']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Qty: ${entry.value}',
                          style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandPrimary, fontSize: 12.5),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _showCartSheet,
              child: Text(
                'Proceed to Checkout • ₹$_cartTotalAmount',
                style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          // Avatar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.brandPrimary, width: 2.5),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primarySurface,
              child: Text(
                _userName.isNotEmpty ? _userName[0].toUpperCase() : 'S',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.brandPrimary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _userName,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
          if (_userPhone.isNotEmpty) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+91 $_userPhone',
                style: const TextStyle(color: AppColors.brandPrimary, fontWeight: FontWeight.w700, fontSize: 12.5),
              ),
            ),
          ],

          const SizedBox(height: 22),

          // Menu Options
          _buildProfileTile(
            icon: Icons.location_on_outlined,
            title: 'Delivery Address',
            subtitle: _currentAddress,
            onTap: _showAddressPicker,
          ),
          _buildProfileTile(
            icon: Icons.receipt_long_rounded,
            title: 'My Orders',
            subtitle: 'View recent orders & invoice',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No previous orders yet.'), behavior: SnackBarBehavior.floating),
              );
            },
          ),
          _buildProfileTile(
            icon: Icons.favorite_border_rounded,
            title: 'My Wishlist',
            subtitle: '${_favorites.length} items saved',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${_favorites.length} items in your wishlist.'), behavior: SnackBarBehavior.floating),
              );
            },
          ),
          _buildProfileTile(
            icon: Icons.headset_mic_rounded,
            title: 'Sayak 24/7 Support',
            subtitle: 'Fast support for your fresh groceries',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact support at support@sayak.in'), behavior: SnackBarBehavior.floating),
              );
            },
          ),

          const SizedBox(height: 26),

          // Log Out Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Log Out', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
              onPressed: _handleLogout,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.brandPrimary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
        subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textMuted),
      ),
    );
  }
}
