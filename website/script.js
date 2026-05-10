const serviceCategories = [
  { key: "all", label: "All Services" },
  { key: "bridal", label: "Bridal" },
  { key: "makeup", label: "Makeup" },
  { key: "hair", label: "Hair" },
  { key: "skin", label: "Skin" },
  { key: "mehendi", label: "Mehendi" },
  { key: "tattoo", label: "Tattoo" },
  { key: "grooming", label: "Grooming" }
];

const services = [
  { name: "Bridal Makeup", category: "bridal", price: 8999, duration: "180 mins", description: "Complete bridal makeup and hairstyle for wedding moments that last through the day." },
  { name: "HD Bridal Makeup", category: "bridal", price: 14999, duration: "210 mins", description: "Premium HD bridal finish with advanced detailing, long wear, and photo-ready texture." },
  { name: "Saree Draping (Bridal)", category: "bridal", price: 799, duration: "60 mins", description: "Elegant bridal saree draping support to complete the final look beautifully." },
  { name: "Normal Makeup", category: "makeup", price: 1499, duration: "75 mins", description: "Simple, elegant makeup for family functions, casual events, and daytime looks." },
  { name: "Baby Shower Makeup", category: "makeup", price: 2999, duration: "120 mins", description: "Fresh, camera-friendly makeup style tailored for baby shower celebrations." },
  { name: "HD Makeup", category: "makeup", price: 4999, duration: "140 mins", description: "A more polished finish that photographs beautifully and wears well." },
  { name: "Air Brush Makeup", category: "makeup", price: 7999, duration: "150 mins", description: "Premium flawless finish with a light, long-stay air brush feel." },
  { name: "Haircut & Style (Ladies)", category: "hair", price: 299, duration: "45 mins", description: "Professional haircut with finishing style and blow dry support." },
  { name: "Hair Colour (Global)", category: "hair", price: 999, duration: "120 mins", description: "Full-head colour service with premium dye application and clean finish." },
  { name: "Hair Style", category: "hair", price: 799, duration: "60 mins", description: "Soft curls, buns, and event-ready hairstyling for functions and shoots." },
  { name: "Basic Facial", category: "skin", price: 499, duration: "60 mins", description: "Deep cleansing facial for regular skin maintenance and glow." },
  { name: "Gold Facial", category: "skin", price: 999, duration: "75 mins", description: "Luxury facial choice for a brighter, radiant skin finish." },
  { name: "Advance Treatment Facial", category: "skin", price: 1999, duration: "90 mins", description: "Premium facial care for clients who want stronger skin-focused support." },
  { name: "Bridal Mehendi (Full)", category: "mehendi", price: 2999, duration: "300 mins", description: "Intricate bridal mehendi for hands and feet with rich festive detail." },
  { name: "Mehendi Service", category: "mehendi", price: 399, duration: "45 mins", description: "Regular mehendi service for events, festive bookings, and family functions." },
  { name: "Organic Mehendi Cone", category: "mehendi", price: 60, duration: "Takeaway", description: "Organic mehendi cone available for direct sale from the studio." },
  { name: "Small Tattoo (2-4 cm)", category: "tattoo", price: 999, duration: "60 mins", description: "Clean, custom small tattoo design for first-timers and minimal looks." },
  { name: "Full Body Grooming Package", category: "grooming", price: 1999, duration: "180 mins", description: "Waxing, cleanup, threading, and grooming essentials in one package." }
];

const courses = [
  { title: "Bridal makeup artist", category: "Bridal", price: 9999, description: "Full bridal workflow for professional artists.", highlights: ["Muhoortham and wedding looks", "HD and Ultra HD topics", "Waterproof and air brush finishing"] },
  { title: "Beautician", category: "Grooming", price: 6499, description: "Core beautician skills for studio work.", highlights: ["Skin analysis", "Cleanup and facial basics", "Threading and waxing workflow"] },
  { title: "Hair cut & colour", category: "Hair", price: 5499, description: "Hair cutting and colouring techniques.", highlights: ["Sectioning basics", "Global colour process", "Highlight planning"] },
  { title: "1 day Seminar", category: "Business", price: 999, description: "Fast-track seminar for beauty business exposure.", highlights: ["Beauty career intro", "High-demand services", "Studio awareness"] },
  { title: "Advance treatment course", category: "Skin", price: 8999, description: "Advanced skin and treatment-focused learning.", highlights: ["Consultation methods", "Treatment planning", "Premium facial flow"] },
  { title: "Hair style course", category: "Hair", price: 4999, description: "Reception, party, and bridal hairstyle training.", highlights: ["Tool setup", "Hair prep", "Volume and bun styling"] },
  { title: "Tattoo course", category: "Tattoo", price: 9999, description: "Tattoo design basics and studio workflow.", highlights: ["Hygiene setup", "Stencil placement", "Basic line practice"] },
  { title: "Sareep pre- pleating", category: "Bridal", price: 1999, description: "Practical saree pre-pleating and draping class.", highlights: ["Pre-pleating basics", "Pinning confidence", "Client-ready finish"] },
  { title: "Goddess makeup class", category: "Makeup", price: 3499, description: "Creative goddess and temple-inspired makeup looks.", highlights: ["Special makeup concepts", "Face balancing", "Stage-ready styling"] },
  { title: "SFX makeup class", category: "Makeup", price: 4999, description: "Creative special effects makeup training.", highlights: ["Texture effects", "Special look creation", "Dramatic transformation basics"] }
];

const serviceFilters = document.getElementById("serviceFilters");
const servicesGrid = document.getElementById("servicesGrid");
const courseList = document.getElementById("courseList");
const courseSpotlight = document.getElementById("courseSpotlight");

let activeCategory = "all";

function renderServiceFilters() {
  serviceFilters.innerHTML = serviceCategories
    .map(
      (item) => `
        <button class="chip ${item.key === activeCategory ? "is-active" : ""}" type="button" data-filter="${item.key}">
          ${item.label}
        </button>
      `
    )
    .join("");

  serviceFilters.querySelectorAll("[data-filter]").forEach((button) => {
    button.addEventListener("click", () => {
      activeCategory = button.dataset.filter;
      renderServiceFilters();
      renderServices();
    });
  });
}

function renderServices() {
  const filtered = activeCategory === "all"
    ? services
    : services.filter((service) => service.category === activeCategory);

  servicesGrid.innerHTML = filtered
    .map(
      (service) => `
        <article class="service-card" data-reveal>
          <div class="service-card__meta">
            <span class="tag">${service.category}</span>
            <span class="tag">${service.duration}</span>
          </div>
          <h3>${service.name}</h3>
          <p>${service.description}</p>
          <div class="service-card__footer">
            <span class="price">Rs ${service.price}</span>
            <a href="https://wa.me/918344549199?text=${encodeURIComponent(`Hi, I want to book ${service.name}`)}" target="_blank" rel="noreferrer">
              Book via WhatsApp
            </a>
          </div>
        </article>
      `
    )
    .join("");

  revealOnScroll();
}

function renderCourses() {
  courseList.innerHTML = courses
    .map(
      (course, index) => `
        <article class="course-item" data-index="${index}" data-reveal>
          <div class="course-item__meta">
            <span class="tag">${course.category}</span>
            <span class="tag">Rs ${course.price}</span>
          </div>
          <h3>${course.title}</h3>
          <p>${course.description}</p>
          <div class="course-item__footer">
            <span>${course.highlights[0]}</span>
            <strong>View Syllabus</strong>
          </div>
        </article>
      `
    )
    .join("");

  courseList.querySelectorAll(".course-item").forEach((item) => {
    item.addEventListener("mouseenter", () => updateSpotlight(Number(item.dataset.index)));
    item.addEventListener("click", () => updateSpotlight(Number(item.dataset.index)));
  });

  updateSpotlight(0);
  revealOnScroll();
}

function updateSpotlight(index) {
  const course = courses[index];
  if (!course) return;

  courseSpotlight.innerHTML = `
    <p class="eyebrow">Spotlight Course</p>
    <h3>${course.title}</h3>
    <p>${course.description}</p>
    <ul>
      ${course.highlights.map((item) => `<li>${item}</li>`).join("")}
    </ul>
  `;
}

function revealOnScroll() {
  const nodes = document.querySelectorAll("[data-reveal]");
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.18 }
  );

  nodes.forEach((node) => observer.observe(node));
}

renderServiceFilters();
renderServices();
renderCourses();
revealOnScroll();
