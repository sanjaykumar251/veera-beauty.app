class FallbackCatalog {
  static final List<Map<String, dynamic>> services = [
    {
      '_id': 'svc_haircut_style_ladies',
      'name': 'Haircut & Style (Ladies)',
      'category': 'hair',
      'description': 'Professional haircut with styling and blow dry',
      'duration': 45,
      'price': 299,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_hair_color_global',
      'name': 'Hair Colour (Global)',
      'category': 'hair',
      'description': 'Full head global colour with premium dye',
      'duration': 120,
      'price': 999,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_hair_style',
      'name': 'Hair Style',
      'category': 'hair',
      'description': 'Soft curls, buns and event-ready styling',
      'duration': 60,
      'price': 799,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_basic_facial',
      'name': 'Basic Facial',
      'category': 'skin',
      'description': 'Deep cleansing facial for glowing skin',
      'duration': 60,
      'price': 499,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_gold_facial',
      'name': 'Gold Facial',
      'category': 'skin',
      'description': 'Luxury gold facial for radiant skin',
      'duration': 75,
      'price': 999,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_advance_treatment_facial',
      'name': 'Advance Treatment Facial',
      'category': 'skin',
      'description': 'Premium skin treatment facial for special care',
      'duration': 90,
      'price': 1999,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_normal_makeup',
      'name': 'Normal Makeup',
      'category': 'makeup',
      'description': 'Simple and elegant makeup for everyday functions',
      'duration': 75,
      'price': 1499,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_baby_shower_makeup',
      'name': 'Baby Shower Makeup',
      'category': 'makeup',
      'description': 'Fresh and radiant look for baby shower celebrations',
      'duration': 120,
      'price': 2999,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_hd_makeup',
      'name': 'HD Makeup',
      'category': 'makeup',
      'description': 'Camera-friendly HD makeup finish',
      'duration': 140,
      'price': 4999,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_air_brush_makeup',
      'name': 'Air Brush Makeup',
      'category': 'makeup',
      'description': 'Air brush finish with premium flawless coverage',
      'duration': 150,
      'price': 7999,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_bridal_makeup',
      'name': 'Bridal Makeup',
      'category': 'bridal',
      'description': 'Complete bridal makeup and hairstyle',
      'duration': 180,
      'price': 8999,
      'isBridalService': true,
      'isAvailable': true,
    },
    {
      '_id': 'svc_hd_bridal_makeup',
      'name': 'HD Bridal Makeup',
      'category': 'bridal',
      'description': 'Premium HD bridal makeup with airbrush finish',
      'duration': 210,
      'price': 14999,
      'isBridalService': true,
      'isAvailable': true,
    },
    {
      '_id': 'svc_bridal_mehendi',
      'name': 'Bridal Mehendi (Full)',
      'category': 'mehendi',
      'description': 'Intricate bridal mehendi on both hands and feet',
      'duration': 300,
      'price': 2999,
      'isBridalService': true,
      'isAvailable': true,
    },
    {
      '_id': 'svc_mehendi_service',
      'name': 'Mehendi Service',
      'category': 'mehendi',
      'description': 'Regular mehendi service for events and festive bookings',
      'duration': 45,
      'price': 399,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_mehendi_cone',
      'name': 'Organic Mehendi Cone (For Sale)',
      'category': 'mehendi',
      'description': 'Organic mehendi cone available for direct sale',
      'duration': 10,
      'price': 60,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_small_tattoo',
      'name': 'Small Tattoo (2-4 cm)',
      'category': 'tattoo',
      'description': 'Custom small tattoo design',
      'duration': 60,
      'price': 999,
      'isBridalService': false,
      'isAvailable': true,
    },
    {
      '_id': 'svc_saree_draping_bridal',
      'name': 'Saree Draping (Bridal)',
      'category': 'saree_draping',
      'description': 'Elaborate bridal saree draping style',
      'duration': 60,
      'price': 799,
      'isBridalService': true,
      'isAvailable': true,
    },
    {
      '_id': 'svc_grooming_package',
      'name': 'Full Body Grooming Package',
      'category': 'grooming',
      'description': 'Waxing, facial, cleanup and threading combo',
      'duration': 180,
      'price': 1999,
      'isBridalService': false,
      'isAvailable': true,
    },
  ];

  static final List<Map<String, dynamic>> courses = [
    _course(
      id: 'course_bridal_makeup_artist',
      title: 'Bridal makeup artist',
      subtitle: 'Full bridal workflow for professional artists',
      description:
          'Complete bridal makeup training covering consultation, skin prep, base, eye work, and client-ready bridal execution.',
      category: 'bridal',
      price: 14999,
      discountedPrice: 9999,
      level: 'intermediate',
      isFeatured: true,
      whatYouLearn: [
        'Normal makeup',
        'Puberty makeup',
        'Baby shower makeup',
        'Party makeup',
        'Outdoor shoot makeup',
        'Muhoortham makeup',
        'Christian wedding makeup',
        'Semi HD makeup',
        'HD makeup',
        'Ultra HD makeup',
        'Waterproof makeup',
        'Sweat proof makeup',
        'Air brush makeup',
      ],
      modules: [
        _module(
          id: 'module_bridal_base',
          title: 'Bridal Base and Skin Prep',
          lessons: [
            _lesson(
              id: 'lesson_skin_prep',
              title: 'Skin Prep for Bridal Clients',
              videoId: 'dQw4w9WgXcQ',
              isFreePreview: true,
            ),
            _lesson(
              id: 'lesson_foundation',
              title: 'Corrector and Foundation Matching',
              videoId: 'M7lc1UVf-VE',
            ),
          ],
        ),
      ],
    ),
    _course(
      id: 'course_beautician',
      title: 'Beautician',
      subtitle: 'Core beautician skills for studio work',
      description:
          'Beautician course for cleanup, facial basics, threading, waxing, and client handling.',
      category: 'grooming',
      price: 8999,
      discountedPrice: 6499,
      whatYouLearn: [
        'Cleanup and facial basics',
        'Threading and waxing workflow',
        'Client hygiene and consultation',
      ],
      modules: [
        _module(
          id: 'module_beautician_foundation',
          title: 'Beautician Foundations',
          lessons: [
            _lesson(
              id: 'lesson_skin_analysis',
              title: 'Skin Analysis and Client Prep',
              videoId: 'M7lc1UVf-VE',
              isFreePreview: true,
            ),
            _lesson(
              id: 'lesson_cleanup',
              title: 'Cleanup, Facial and Grooming Routine',
              videoId: 'ysz5S6PUM-U',
            ),
          ],
        ),
      ],
    ),
    _course(
      id: 'course_hair_cut_colour',
      title: 'Hair cut & colour',
      subtitle: 'Hair cutting and colouring techniques',
      description:
          'Salon course for haircutting, sectioning, colouring, and highlights.',
      category: 'hair',
      price: 7999,
      discountedPrice: 5499,
      modules: [
        _module(
          id: 'module_hair_basic',
          title: 'Hair Cut and Colour Basics',
          lessons: [
            _lesson(
              id: 'lesson_sectioning',
              title: 'Sectioning and Haircut Prep',
              videoId: 'ScMzIvxBSi4',
              isFreePreview: true,
            ),
            _lesson(
              id: 'lesson_colour_process',
              title: 'Global Colour and Highlight Process',
              videoId: 'dQw4w9WgXcQ',
            ),
          ],
        ),
      ],
    ),
    _course(
      id: 'course_1_day_seminar',
      title: '1 day Seminar',
      subtitle: 'Fast-track seminar for beauty business exposure',
      description:
          'One-day seminar introducing beauty industry basics and high-demand services.',
      category: 'business',
      price: 1999,
      discountedPrice: 999,
      modules: [
        _module(
          id: 'module_seminar',
          title: 'Seminar Sessions',
          lessons: [
            _lesson(
              id: 'lesson_career_intro',
              title: 'Beauty Career Introduction',
              videoId: 'dQw4w9WgXcQ',
              isFreePreview: true,
            ),
          ],
        ),
      ],
    ),
    _course(
      id: 'course_advance_treatment',
      title: 'Advance treatment course',
      subtitle: 'Advanced skin and treatment-focused learning',
      description:
          'Advanced course covering facial workflows, treatment consultation, and skin-result planning.',
      category: 'skin',
      price: 11999,
      discountedPrice: 8999,
      modules: [
        _module(
          id: 'module_treatment',
          title: 'Treatment Essentials',
          lessons: [
            _lesson(
              id: 'lesson_skin_consultation',
              title: 'Advanced Skin Consultation',
              videoId: 'M7lc1UVf-VE',
              isFreePreview: true,
            ),
          ],
        ),
      ],
    ),
    _course(
      id: 'course_hair_style',
      title: 'Hair style course',
      subtitle: 'Reception, party and bridal hairstyle training',
      description:
          'Detailed hairstyle course for curls, buns, volume, and bridal styling.',
      category: 'hair',
      price: 6999,
      discountedPrice: 4999,
      modules: [
        _module(
          id: 'module_hair_style',
          title: 'Hair Styling Basics',
          lessons: [
            _lesson(
              id: 'lesson_hair_prep',
              title: 'Tool Setup and Hair Prep',
              videoId: 'ysz5S6PUM-U',
              isFreePreview: true,
            ),
          ],
        ),
      ],
    ),
    _course(
      id: 'course_tattoo',
      title: 'Tattoo course',
      subtitle: 'Tattoo design basics and studio workflow',
      description:
          'Entry-level tattoo course for hygiene, line practice, and stencil placement.',
      category: 'tattoo',
      price: 12999,
      discountedPrice: 9999,
      modules: [
        _module(
          id: 'module_tattoo',
          title: 'Tattoo Foundations',
          lessons: [
            _lesson(
              id: 'lesson_tattoo_setup',
              title: 'Tattoo Hygiene and Setup',
              videoId: 'ScMzIvxBSi4',
              isFreePreview: true,
            ),
          ],
        ),
      ],
    ),
    _course(
      id: 'course_saree_prepleating',
      title: 'Sareep pre- pleating',
      subtitle: 'Practical saree pre-pleating and draping class',
      description:
          'Learn saree pre-pleating, pinning, and event-ready draping for clients.',
      category: 'bridal',
      price: 2999,
      discountedPrice: 1999,
      modules: [
        _module(
          id: 'module_saree',
          title: 'Pre-Pleating Techniques',
          lessons: [
            _lesson(
              id: 'lesson_prepleating',
              title: 'Pre-Pleating Basics',
              videoId: 'dQw4w9WgXcQ',
              isFreePreview: true,
            ),
          ],
        ),
      ],
    ),
    _course(
      id: 'course_goddess_makeup',
      title: 'Goddess makeup class',
      subtitle: 'Creative goddess and temple-inspired makeup looks',
      description:
          'Special makeup class focused on goddess-style transformation and stage-ready balance.',
      category: 'makeup',
      price: 4999,
      discountedPrice: 3499,
      modules: [
        _module(
          id: 'module_goddess',
          title: 'Special Makeup Concepts',
          lessons: [
            _lesson(
              id: 'lesson_goddess_structure',
              title: 'Goddess Makeup Structure',
              videoId: 'M7lc1UVf-VE',
              isFreePreview: true,
            ),
          ],
        ),
      ],
    ),
    _course(
      id: 'course_sfx_makeup',
      title: 'SFX makeup class',
      subtitle: 'Creative special effects makeup training',
      description:
          'Hands-on SFX course for texture effects, wounds, and dramatic creative looks.',
      category: 'makeup',
      price: 6999,
      discountedPrice: 4999,
      level: 'advanced',
      modules: [
        _module(
          id: 'module_sfx',
          title: 'SFX Foundations',
          lessons: [
            _lesson(
              id: 'lesson_sfx_intro',
              title: 'SFX Product Introduction',
              videoId: 'ysz5S6PUM-U',
              isFreePreview: true,
            ),
          ],
        ),
      ],
    ),
  ];

  static final Map<String, dynamic> vipPlan = {
    'success': true,
    'offlineMode': true,
    'plan': {
      'name': 'VIP Loyalty Membership',
      'price': 999,
      'currency': 'INR',
      'duration': '1 Year',
      'benefits': [
        'Yearly package for regular clients',
        'Priority booking support',
        '11th service FREE after 10 visits',
        '5% extra off on bridal bookings',
        'Selected Buy 1 Get 1 offers',
      ],
      'upiId': 'veeras@paytm',
      'upiName': "Veera's Beauty & Tattoo Studio",
    },
  };

  static Map<String, dynamic> getServices({String? category}) {
    final filtered = category == null
        ? services
        : services.where((service) => service['category'] == category).toList();
    return {
      'success': true,
      'offlineMode': true,
      'services': filtered,
    };
  }

  static Map<String, dynamic> getService(String id) {
    final service = services.firstWhere(
      (item) => item['_id'] == id,
      orElse: () => services.first,
    );
    return {
      'success': true,
      'offlineMode': true,
      'service': service,
    };
  }

  static Map<String, dynamic> getCourses({String? category}) {
    final filtered = category == null
        ? courses
        : courses.where((course) => course['category'] == category).toList();
    return {
      'success': true,
      'offlineMode': true,
      'courses': filtered,
    };
  }

  static Map<String, dynamic> getCourse(String id) {
    final course = courses.firstWhere(
      (item) => item['_id'] == id,
      orElse: () => courses.first,
    );
    return {
      'success': true,
      'offlineMode': true,
      'course': course,
      'isEnrolled': false,
      'progress': null,
    };
  }

  static Map<String, dynamic> getMyCourses() {
    return {
      'success': true,
      'offlineMode': true,
      'courses': <Map<String, dynamic>>[],
    };
  }

  static Map<String, dynamic> _course({
    required String id,
    required String title,
    required String subtitle,
    required String description,
    required String category,
    required int price,
    required int discountedPrice,
    String level = 'beginner',
    bool isFeatured = false,
    List<String> whatYouLearn = const [],
    List<Map<String, dynamic>> modules = const [],
  }) {
    final totalLessons = modules.fold<int>(
      0,
      (sum, module) => sum + ((module['lessons'] as List?)?.length ?? 0),
    );

    return {
      '_id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'category': category,
      'price': price,
      'discountedPrice': discountedPrice,
      'effectivePrice': discountedPrice,
      'language': 'Tamil',
      'level': level,
      'isPublished': true,
      'isFeatured': isFeatured,
      'whatYouLearn': whatYouLearn,
      'requirements': ['Contact studio for full enrollment details'],
      'instructor': "Veera's Beauty & Tattoo Studio",
      'modules': modules,
      'totalLessons': totalLessons,
    };
  }

  static Map<String, dynamic> _module({
    required String id,
    required String title,
    required List<Map<String, dynamic>> lessons,
  }) {
    return {
      '_id': id,
      'title': title,
      'description': title,
      'order': 1,
      'lessons': lessons,
    };
  }

  static Map<String, dynamic> _lesson({
    required String id,
    required String title,
    required String videoId,
    bool isFreePreview = false,
  }) {
    return {
      '_id': id,
      'title': title,
      'description': title,
      'youtubeVideoId': videoId,
      'duration': 600,
      'order': 1,
      'isFreePreview': isFreePreview,
    };
  }
}
