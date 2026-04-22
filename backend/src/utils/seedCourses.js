require('dotenv').config();
const mongoose = require('mongoose');
const Course = require('../models/Course');

const sampleCourses = [
  {
    title: 'Bridal makeup artist',
    subtitle: 'Full bridal workflow for professional artists',
    description: 'Complete bridal makeup training covering consultation, skin prep, base, eye work, saree-event finishing, and client-ready bridal execution.',
    category: 'bridal',
    previewVideoId: 'dQw4w9WgXcQ',
    price: 14999,
    discountedPrice: 9999,
    language: 'Tamil',
    level: 'intermediate',
    isPublished: true,
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
    requirements: ['Basic makeup kit', 'Beginner-friendly practice model'],
    instructor: "Veera's Beauty & Tattoo Studio",
    modules: [
      {
        title: 'Bridal Base and Skin Prep',
        description: 'Understand bridal consultation, skin prep, and long-wear base techniques',
        order: 1,
        lessons: [
          {
            title: 'Skin Prep for Bridal Clients',
            description: 'Prepare different skin types for bridal makeup and long events.',
            youtubeVideoId: 'dQw4w9WgXcQ',
            duration: 900,
            order: 1,
            isFreePreview: true,
          },
          {
            title: 'Corrector and Foundation Matching',
            description: 'Choose undertones, correct pigmentation, and build a lasting bridal base.',
            youtubeVideoId: 'M7lc1UVf-VE',
            duration: 1200,
            order: 2,
            isFreePreview: false,
          },
        ],
      },
      {
        title: 'Special Occasion Bridal Looks',
        description: 'Create advanced bridal and function-ready makeup looks',
        order: 2,
        lessons: [
          {
            title: 'Muhoortham and Wedding Looks',
            description: 'Create traditional wedding-ready eye and lip combinations.',
            youtubeVideoId: 'ysz5S6PUM-U',
            duration: 1500,
            order: 1,
            isFreePreview: false,
          },
          {
            title: 'Air Brush, Waterproof and HD Finish',
            description: 'Finish the makeup for photography, sweat resistance, and long wear.',
            youtubeVideoId: 'ScMzIvxBSi4',
            duration: 900,
            order: 2,
            isFreePreview: false,
          },
        ],
      },
    ],
  },
  {
    title: 'Beautician',
    subtitle: 'Core beautician skills for studio and freelance work',
    description: 'A complete beautician course for skin care, cleanup, facial basics, threading, waxing, and client handling.',
    category: 'grooming',
    previewVideoId: 'M7lc1UVf-VE',
    price: 8999,
    discountedPrice: 6499,
    language: 'Tamil',
    level: 'beginner',
    isPublished: true,
    isFeatured: false,
    whatYouLearn: [
      'Cleanup and facial basics',
      'Threading and waxing workflow',
      'Client hygiene and consultation',
      'Salon-ready service confidence',
    ],
    requirements: ['Basic beautician tools', 'Practice model or mannequin'],
    instructor: "Veera's Beauty & Tattoo Studio",
    modules: [
      {
        title: 'Beautician Foundations',
        description: 'Daily service workflow and salon basics',
        order: 1,
        lessons: [
          {
            title: 'Skin Analysis and Client Prep',
            description: 'Basic consultation, hygiene, and preparation steps.',
            youtubeVideoId: 'M7lc1UVf-VE',
            duration: 600,
            order: 1,
            isFreePreview: true,
          },
          {
            title: 'Cleanup, Facial and Grooming Routine',
            description: 'Perform standard beauty services with correct order and technique.',
            youtubeVideoId: 'ysz5S6PUM-U',
            duration: 1200,
            order: 2,
            isFreePreview: false,
          },
        ],
      },
    ],
  },
  {
    title: 'Hair cut & colour',
    subtitle: 'Hair cutting, colouring and finishing techniques',
    description: 'Practical salon course for haircutting, sectioning, colouring, highlights, and post-service finishing.',
    category: 'hair',
    previewVideoId: 'ScMzIvxBSi4',
    price: 7999,
    discountedPrice: 5499,
    language: 'Tamil',
    level: 'beginner',
    isPublished: true,
    isFeatured: false,
    whatYouLearn: [
      'Layer, trim and basic haircut patterns',
      'Global colour and highlight workflow',
      'Hair care after colour',
    ],
    requirements: ['Hair cutting kit', 'Practice head or real model'],
    instructor: "Veera's Beauty & Tattoo Studio",
    modules: [
      {
        title: 'Hair Cut and Colour Basics',
        description: 'Start with cutting preparation and colour mixing',
        order: 1,
        lessons: [
          {
            title: 'Sectioning and Haircut Prep',
            description: 'Learn sectioning and core haircut posture.',
            youtubeVideoId: 'ScMzIvxBSi4',
            duration: 700,
            order: 1,
            isFreePreview: true,
          },
          {
            title: 'Global Colour and Highlight Process',
            description: 'Understand safe application and finishing steps.',
            youtubeVideoId: 'dQw4w9WgXcQ',
            duration: 1100,
            order: 2,
            isFreePreview: false,
          },
        ],
      },
    ],
  },
  {
    title: '1 day Seminar',
    subtitle: 'Fast-track seminar for beauty business exposure',
    description: 'A one-day seminar introducing beauty industry basics, client expectations, and high-demand services.',
    category: 'business',
    previewVideoId: 'dQw4w9WgXcQ',
    price: 1999,
    discountedPrice: 999,
    language: 'Tamil',
    level: 'beginner',
    isPublished: true,
    isFeatured: false,
    whatYouLearn: [
      'Beauty industry overview',
      'Service selection guidance',
      'Client handling basics',
    ],
    requirements: ['Notebook and interest to learn'],
    instructor: "Veera's Beauty & Tattoo Studio",
    modules: [
      {
        title: 'Seminar Sessions',
        description: 'A compact introduction to studio skills and opportunities',
        order: 1,
        lessons: [
          {
            title: 'Beauty Career Introduction',
            description: 'Understand different beauty service paths and opportunities.',
            youtubeVideoId: 'dQw4w9WgXcQ',
            duration: 600,
            order: 1,
            isFreePreview: true,
          },
          {
            title: 'Studio Workflow Snapshot',
            description: 'See how services, bookings, and clients are managed.',
            youtubeVideoId: 'M7lc1UVf-VE',
            duration: 900,
            order: 2,
            isFreePreview: false,
          },
        ],
      },
    ],
  },
  {
    title: 'Advance treatment course',
    subtitle: 'Advanced skin and treatment-focused learning',
    description: 'Advanced course covering premium facial workflows, treatment consultation, and skin-result planning.',
    category: 'skin',
    previewVideoId: 'M7lc1UVf-VE',
    price: 11999,
    discountedPrice: 8999,
    language: 'Tamil',
    level: 'advanced',
    isPublished: true,
    isFeatured: false,
    whatYouLearn: [
      'Advanced facial planning',
      'Skin treatment consultation',
      'Result-focused routine building',
    ],
    requirements: ['Beauty treatment kit', 'Basic beautician knowledge'],
    instructor: "Veera's Beauty & Tattoo Studio",
    modules: [
      {
        title: 'Treatment Essentials',
        description: 'Learn consultation and premium skin service flow',
        order: 1,
        lessons: [
          {
            title: 'Advanced Skin Consultation',
            description: 'Understand skin concerns before treatment selection.',
            youtubeVideoId: 'M7lc1UVf-VE',
            duration: 800,
            order: 1,
            isFreePreview: true,
          },
          {
            title: 'Premium Treatment Execution',
            description: 'Step-by-step advanced treatment workflow.',
            youtubeVideoId: 'ysz5S6PUM-U',
            duration: 1300,
            order: 2,
            isFreePreview: false,
          },
        ],
      },
    ],
  },
  {
    title: 'Hair style course',
    subtitle: 'Reception, party and bridal hairstyle training',
    description: 'Detailed hairstyle course for curls, buns, volume, bridal styling, and modern finish techniques.',
    category: 'hair',
    previewVideoId: 'ysz5S6PUM-U',
    price: 6999,
    discountedPrice: 4999,
    language: 'Tamil',
    level: 'beginner',
    isPublished: true,
    isFeatured: false,
    whatYouLearn: [
      'Reception curls and volume',
      'Traditional and modern buns',
      'Bridal hairstyle finishing',
    ],
    requirements: ['Hair styling tools', 'Practice model'],
    instructor: "Veera's Beauty & Tattoo Studio",
    modules: [
      {
        title: 'Hair Styling Basics',
        description: 'Start with sectioning, prep, and structure',
        order: 1,
        lessons: [
          {
            title: 'Tool Setup and Hair Prep',
            description: 'Prepare hair for curls, buns and secure styling.',
            youtubeVideoId: 'ysz5S6PUM-U',
            duration: 700,
            order: 1,
            isFreePreview: true,
          },
          {
            title: 'Party and Bridal Hair Styles',
            description: 'Build salon-ready styles for events and weddings.',
            youtubeVideoId: 'ScMzIvxBSi4',
            duration: 1200,
            order: 2,
            isFreePreview: false,
          },
        ],
      },
    ],
  },
  {
    title: 'Tattoo course',
    subtitle: 'Tattoo design basics and studio workflow',
    description: 'Entry-level tattoo course for hygiene, line practice, stencil placement, and customer handling.',
    category: 'tattoo',
    previewVideoId: 'ScMzIvxBSi4',
    price: 12999,
    discountedPrice: 9999,
    language: 'Tamil',
    level: 'beginner',
    isPublished: true,
    isFeatured: false,
    whatYouLearn: [
      'Stencil and transfer basics',
      'Machine handling and hygiene',
      'Simple tattoo layout',
    ],
    requirements: ['Tattoo starter kit', 'Practice sheets'],
    instructor: "Veera's Beauty & Tattoo Studio",
    modules: [
      {
        title: 'Tattoo Foundations',
        description: 'Start with hygiene, setup, and line confidence',
        order: 1,
        lessons: [
          {
            title: 'Tattoo Hygiene and Setup',
            description: 'Prepare a safe and clean workspace.',
            youtubeVideoId: 'ScMzIvxBSi4',
            duration: 650,
            order: 1,
            isFreePreview: true,
          },
          {
            title: 'Stencil and Basic Outline Practice',
            description: 'Create neat lines and basic tattoo execution.',
            youtubeVideoId: 'M7lc1UVf-VE',
            duration: 1100,
            order: 2,
            isFreePreview: false,
          },
        ],
      },
    ],
  },
  {
    title: 'Sareep pre- pleating',
    subtitle: 'Practical saree pre-pleating and draping class',
    description: 'Learn saree pre-pleating, pinning, quick draping, and event-ready finishing for bridal and function clients.',
    category: 'bridal',
    previewVideoId: 'dQw4w9WgXcQ',
    price: 2999,
    discountedPrice: 1999,
    language: 'Tamil',
    level: 'beginner',
    isPublished: true,
    isFeatured: false,
    whatYouLearn: [
      'Pre-pleating techniques',
      'Quick event draping',
      'Secure bridal saree finishing',
    ],
    requirements: ['Saree and pins', 'Practice model'],
    instructor: "Veera's Beauty & Tattoo Studio",
    modules: [
      {
        title: 'Pre-Pleating Techniques',
        description: 'Learn folding, pinning, and finishing',
        order: 1,
        lessons: [
          {
            title: 'Pre-Pleating Basics',
            description: 'Prepare saree pleats before draping.',
            youtubeVideoId: 'dQw4w9WgXcQ',
            duration: 500,
            order: 1,
            isFreePreview: true,
          },
          {
            title: 'Bridal Draping Finish',
            description: 'Lock saree draping for long events and comfort.',
            youtubeVideoId: 'M7lc1UVf-VE',
            duration: 900,
            order: 2,
            isFreePreview: false,
          },
        ],
      },
    ],
  },
  {
    title: 'Goddess makeup class',
    subtitle: 'Creative goddess and temple-inspired makeup looks',
    description: 'Special makeup class focused on goddess-style transformation with eyes, contour, ornaments, and stage-ready balance.',
    category: 'makeup',
    previewVideoId: 'M7lc1UVf-VE',
    price: 4999,
    discountedPrice: 3499,
    language: 'Tamil',
    level: 'intermediate',
    isPublished: true,
    isFeatured: false,
    whatYouLearn: [
      'Goddess makeup styling',
      'Classical and devotional face balance',
      'Color selection for stage presence',
    ],
    requirements: ['Creative makeup kit', 'Practice model'],
    instructor: "Veera's Beauty & Tattoo Studio",
    modules: [
      {
        title: 'Special Makeup Concepts',
        description: 'Learn standout devotional and cultural looks',
        order: 1,
        lessons: [
          {
            title: 'Goddess Makeup Structure',
            description: 'Plan eyes, brows, lips, and highlight placement.',
            youtubeVideoId: 'M7lc1UVf-VE',
            duration: 850,
            order: 1,
            isFreePreview: true,
          },
          {
            title: 'Classical Dance Makeup Finish',
            description: 'Balance stage makeup for traditional performances.',
            youtubeVideoId: 'ysz5S6PUM-U',
            duration: 1100,
            order: 2,
            isFreePreview: false,
          },
        ],
      },
    ],
  },
  {
    title: 'SFX makeup class',
    subtitle: 'Creative special effects makeup training',
    description: 'Hands-on SFX course for texture effects, wounds, dramatic creative looks, and event special makeup.',
    category: 'makeup',
    previewVideoId: 'ysz5S6PUM-U',
    price: 6999,
    discountedPrice: 4999,
    language: 'Tamil',
    level: 'advanced',
    isPublished: true,
    isFeatured: false,
    whatYouLearn: [
      'SFX texture creation',
      'Creative wound and illusion makeup',
      'Goddess and dramatic special looks',
    ],
    requirements: ['SFX materials', 'Advanced makeup interest'],
    instructor: "Veera's Beauty & Tattoo Studio",
    modules: [
      {
        title: 'SFX Foundations',
        description: 'Start with texture building and safe product usage',
        order: 1,
        lessons: [
          {
            title: 'SFX Product Introduction',
            description: 'Understand basic SFX materials and preparation.',
            youtubeVideoId: 'ysz5S6PUM-U',
            duration: 700,
            order: 1,
            isFreePreview: true,
          },
          {
            title: 'Creative Special Makeup Demo',
            description: 'Build a dramatic special look using layered techniques.',
            youtubeVideoId: 'ScMzIvxBSi4',
            duration: 1300,
            order: 2,
            isFreePreview: false,
          },
        ],
      },
    ],
  },
];

const coursesWithoutVideos = sampleCourses.map((course) => ({
  ...course,
  previewVideoId: null,
  modules: (course.modules || []).map((module) => ({
    ...module,
    lessons: (module.lessons || []).map((lesson) => ({
      ...lesson,
      youtubeVideoId: null,
    })),
  })),
}));

const run = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, { dbName: 'veeras_beauty' });

    const oldSampleTitles = [
      'Professional Bridal Makeup Masterclass',
      'Hair Styling for Parlour Professionals',
      'Mehendi Design Fast Track',
    ];

    await Course.deleteMany({ title: { $in: oldSampleTitles } });

    await Course.bulkWrite(
      coursesWithoutVideos.map((course) => ({
        updateOne: {
          filter: { title: course.title },
          update: { $set: course },
          upsert: true,
        },
      })),
    );

    console.log('Courses refreshed successfully');
    process.exit(0);
  } catch (error) {
    console.error('Course seed failed:', error.message);
    process.exit(1);
  }
};

run();
