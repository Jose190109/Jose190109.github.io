/**
 * Portofolio Jose Amando Tarigan
 * JavaScript Interactivity & Visual Effects
 */

document.addEventListener('DOMContentLoaded', () => {
  // 1. Inisialisasi Efek Canvas Bintang Malam (Starfield)
  initStarfield();

  // 2. Inisialisasi Efek Ketik (Typing Text Effect)
  initTypingEffect();

  // 3. Navbar Sticky & Scroll Spy
  initNavbar();

  // 4. Filter Kategori Keahlian (Skills Filter)
  initSkillsFilter();

  // 5. Salin Teks ke Clipboard (Copy Buttons)
  initCopyButtons();

  // 6. Formulir Pengiriman Pesan Cepat (WA & Email)
  initContactForm();

  // 7. Tombol Scroll ke Atas
  initScrollTop();
});

/* ==========================================================
   1. STARFIELD ANIMATION
   ========================================================== */
function initStarfield() {
  const canvas = document.getElementById('starfield');
  if (!canvas) return;

  const ctx = canvas.getContext('2d');
  let stars = [];
  const numStars = window.innerWidth < 768 ? 60 : 120;

  function resizeCanvas() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    createStars();
  }

  function createStars() {
    stars = [];
    for (let i = 0; i < numStars; i++) {
      stars.push({
        x: Math.random() * canvas.width,
        y: Math.random() * canvas.height,
        size: Math.random() * 1.8 + 0.4,
        alpha: Math.random(),
        speed: Math.random() * 0.02 + 0.005,
        increasing: Math.random() > 0.5
      });
    }
  }

  function render() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    stars.forEach(star => {
      // Kelap-kelip lembut
      if (star.increasing) {
        star.alpha += star.speed;
        if (star.alpha >= 1) star.increasing = false;
      } else {
        star.alpha -= star.speed;
        if (star.alpha <= 0.1) star.increasing = true;
      }

      ctx.beginPath();
      ctx.arc(star.x, star.y, star.size, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(180, 235, 255, ${star.alpha * 0.8})`;
      ctx.shadowBlur = star.size * 3;
      ctx.shadowColor = '#72efdd';
      ctx.fill();
    });

    requestAnimationFrame(render);
  }

  window.addEventListener('resize', resizeCanvas);
  resizeCanvas();
  render();
}

/* ==========================================================
   2. TYPING EFFECT (Animasi Teks Berputar)
   ========================================================== */
function initTypingEffect() {
  const typingElement = document.getElementById('typing-text');
  if (!typingElement) return;

  const words = [
    'Media Kreatif',
    'Mahasiswa D3 Teknik Informatika USU',
    'Tech & Programming Enthusiast',
    'Organisatoris & Pemimpin Remaja'
  ];

  let wordIndex = 0;
  let charIndex = 0;
  let isDeleting = false;
  let typingDelay = 120;

  function type() {
    const currentWord = words[wordIndex];

    if (isDeleting) {
      typingElement.textContent = currentWord.substring(0, charIndex - 1);
      charIndex--;
      typingDelay = 60;
    } else {
      typingElement.textContent = currentWord.substring(0, charIndex + 1);
      charIndex++;
      typingDelay = 120;
    }

    if (!isDeleting && charIndex === currentWord.length) {
      isDeleting = true;
      typingDelay = 1800; // Diam sejenak saat teks selesai
    } else if (isDeleting && charIndex === 0) {
      isDeleting = false;
      wordIndex = (wordIndex + 1) % words.length;
      typingDelay = 400;
    }

    setTimeout(type, typingDelay);
  }

  type();
}

/* ==========================================================
   3. NAVBAR BEHAVIOR & SCROLL SPY
   ========================================================== */
function initNavbar() {
  const navbarWrapper = document.querySelector('.navbar-wrapper');
  const menuToggle = document.getElementById('menuToggle');
  const navMenu = document.getElementById('navMenu');
  const navLinks = document.querySelectorAll('.nav-link');
  const sections = document.querySelectorAll('section');

  // Sticky navbar dengan background blur saat scroll
  window.addEventListener('scroll', () => {
    if (window.scrollY > 40) {
      navbarWrapper.classList.add('scrolled');
    } else {
      navbarWrapper.classList.remove('scrolled');
    }

    // Scroll spy
    let current = '';
    const scrollPosition = window.pageYOffset + 180;

    sections.forEach(section => {
      const sectionTop = section.offsetTop;
      const sectionHeight = section.offsetHeight;
      if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
        current = section.getAttribute('id');
      }
    });

    navLinks.forEach(link => {
      link.classList.remove('active');
      if (link.getAttribute('href') === `#${current}`) {
        link.classList.add('active');
      }
    });
  });

  // Mobile menu toggle
  if (menuToggle && navMenu) {
    menuToggle.addEventListener('click', () => {
      navMenu.classList.toggle('open');
      const icon = menuToggle.querySelector('i');
      if (navMenu.classList.contains('open')) {
        icon.classList.remove('fa-bars');
        icon.classList.add('fa-xmark');
      } else {
        icon.classList.remove('fa-xmark');
        icon.classList.add('fa-bars');
      }
    });

    // Tutup menu saat salah satu link diklik
    navLinks.forEach(link => {
      link.addEventListener('click', () => {
        navMenu.classList.remove('open');
        const icon = menuToggle.querySelector('i');
        if (icon) {
          icon.classList.remove('fa-xmark');
          icon.classList.add('fa-bars');
        }
      });
    });
  }
}

/* ==========================================================
   4. SKILLS FILTERING
   ========================================================== */
function initSkillsFilter() {
  const filterBtns = document.querySelectorAll('.filter-btn');
  const skillCards = document.querySelectorAll('.skill-card');

  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      // Hapus active dari semua tombol
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      const filterValue = btn.getAttribute('data-filter');

      skillCards.forEach(card => {
        const category = card.getAttribute('data-category');
        if (filterValue === 'all' || category === filterValue) {
          card.style.display = 'flex';
          setTimeout(() => {
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
          }, 10);
        } else {
          card.style.opacity = '0';
          card.style.transform = 'translateY(10px)';
          setTimeout(() => {
            card.style.display = 'none';
          }, 250);
        }
      });
    });
  });
}

/* ==========================================================
   5. COPY TO CLIPBOARD & TOAST
   ========================================================== */
function initCopyButtons() {
  const copyButtons = document.querySelectorAll('.copy-btn');
  const toast = document.getElementById('toast');

  copyButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      const textToCopy = btn.getAttribute('data-copy');
      if (textToCopy) {
        navigator.clipboard.writeText(textToCopy).then(() => {
          showToast(`Berhasil disalin: ${textToCopy}`);
        }).catch(() => {
          showToast('Gagal menyalin teks');
        });
      }
    });
  });

  function showToast(message) {
    if (!toast) return;
    toast.textContent = message;
    toast.classList.add('show');
    setTimeout(() => {
      toast.classList.remove('show');
    }, 2800);
  }
}

/* ==========================================================
   6. QUICK CONTACT FORM (WhatsApp & Email Direct Integration)
   ========================================================== */
function initContactForm() {
  const btnWA = document.getElementById('btnSendWA');
  const btnEmail = document.getElementById('btnSendEmail');
  const inputName = document.getElementById('senderName');
  const inputSubject = document.getElementById('messageSubject');
  const inputMsg = document.getElementById('senderMessage');

  function validateInputs() {
    const name = inputName.value.trim();
    const subject = inputSubject.value.trim();
    const message = inputMsg.value.trim();

    if (!name || !subject || !message) {
      alert('Harap isi Nama, Subjek, dan Pesan sebelum mengirim.');
      return null;
    }
    return { name, subject, message };
  }

  // Kirim via WhatsApp
  if (btnWA) {
    btnWA.addEventListener('click', () => {
      const data = validateInputs();
      if (!data) return;

      const waNumber = '6282184095954';
      const waText = `Halo Jose Amando,\n\nSaya: ${data.name}\nSubjek: ${data.subject}\n\nPesan:\n${data.message}`;
      const waUrl = `https://wa.me/${waNumber}?text=${encodeURIComponent(waText)}`;
      window.open(waUrl, '_blank');
    });
  }

  // Kirim via Email
  if (btnEmail) {
    btnEmail.addEventListener('click', () => {
      const data = validateInputs();
      if (!data) return;

      const emailTo = 'josetarigan29@gmail.com';
      const mailtoUrl = `mailto:${emailTo}?subject=${encodeURIComponent(data.subject + ' - dari ' + data.name)}&body=${encodeURIComponent(data.message + '\n\nSalam,\n' + data.name)}`;
      window.location.href = mailtoUrl;
    });
  }
}

/* ==========================================================
   7. SCROLL TO TOP BUTTON
   ========================================================== */
function initScrollTop() {
  const scrollTopBtn = document.getElementById('scrollTopBtn');
  if (!scrollTopBtn) return;

  window.addEventListener('scroll', () => {
    if (window.scrollY > 400) {
      scrollTopBtn.style.opacity = '1';
      scrollTopBtn.style.pointerEvents = 'auto';
    } else {
      scrollTopBtn.style.opacity = '0.5';
    }
  });

  scrollTopBtn.addEventListener('click', (e) => {
    e.preventDefault();
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  });
}
