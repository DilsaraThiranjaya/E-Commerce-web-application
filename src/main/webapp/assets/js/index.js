$(document).ready(function() {
  const $slides = $('.slide');
  const $dots = $('.slider-dots');
  let currentSlide = 0;
  let isAnimating = false;
  let autoSlideInterval;


  // Create dots
  $slides.each((index) => {
    $dots.append(`<div class="dot ${index === 0 ? 'active' : ''}"></div>`);
  });

  // Function to change slide
  function goToSlide(index, direction = 'next') {
    if (isAnimating) return;
    isAnimating = true;

    $slides.removeClass('active');
    $('.dot').removeClass('active');

    currentSlide = index;
    if (currentSlide < 0) currentSlide = $slides.length - 1;
    if (currentSlide >= $slides.length) currentSlide = 0;

    const $currentSlide = $slides.eq(currentSlide);
    $currentSlide.addClass('active');
    $('.dot').eq(currentSlide).addClass('active');

    // Reset animation after transition
    setTimeout(() => {
      isAnimating = false;
    }, 800);

    // Reset auto-slide timer
    resetAutoSlide();
  }

  // Auto slide function
  function startAutoSlide() {
    autoSlideInterval = setInterval(() => {
      goToSlide(currentSlide + 1);
    }, 5000);
  }

  // Reset auto slide timer
  function resetAutoSlide() {
    clearInterval(autoSlideInterval);
    startAutoSlide();
  }

  // Next slide
  $('.next').click(() => {
    goToSlide(currentSlide + 1, 'next');
  });

  // Previous slide
  $('.prev').click(() => {
    goToSlide(currentSlide - 1, 'prev');
  });

  // Dot navigation
  $('.dot').click(function() {
    const index = $(this).index();
    if (index > currentSlide) {
      goToSlide(index, 'next');
    } else {
      goToSlide(index, 'prev');
    }
  });

  // Pause auto-slide on hover
  $('.slider-container').hover(
      () => clearInterval(autoSlideInterval),
      () => startAutoSlide()
  );

  // Start auto-slide
  startAutoSlide();

  // Keyboard navigation
  $(document).keydown(function(e) {
    if (e.keyCode === 37) { // Left arrow
      $('.prev').click();
    } else if (e.keyCode === 39) { // Right arrow
      $('.next').click();
    }
  });

  // ----------------------------------------

  // Testimonial Slider
  const $testimonials = $('.testimonial');
  const $testimonialDots = $('.testimonial-dots');
  let currentTestimonial = 0;
  let testimonialInterval;

  // Create testimonial dots
  $testimonials.each((index) => {
    $testimonialDots.append(`<div class="testimonial-dot ${index === 0 ? 'active' : ''}"></div>`);
  });

  function changeTestimonial(index) {
    $testimonials.removeClass('active');
    $('.testimonial-dot').removeClass('active');

    currentTestimonial = index;
    if (currentTestimonial < 0) currentTestimonial = $testimonials.length - 1;
    if (currentTestimonial >= $testimonials.length) currentTestimonial = 0;

    $testimonials.eq(currentTestimonial).addClass('active');
    $('.testimonial-dot').eq(currentTestimonial).addClass('active');
  }

  function startTestimonialSlider() {
    testimonialInterval = setInterval(() => {
      changeTestimonial(currentTestimonial + 1);
    }, 6000);
  }

  function resetTestimonialSlider() {
    clearInterval(testimonialInterval);
    startTestimonialSlider();
  }

  $('.testimonial-dot').click(function() {
    const index = $(this).index();
    changeTestimonial(index);
    resetTestimonialSlider();
  });

  $('.testimonials').hover(
      () => clearInterval(testimonialInterval),
      () => startTestimonialSlider()
  );

  startTestimonialSlider();

  // -------------------------------------------

  // Newsletter Form Submission
  $('.newsletter-form').on('submit', function(e) {
    e.preventDefault();
    const email = $(this).find('input[type="email"]').val();

    // Here you would typically send this to your backend
    console.log('Newsletter signup:', email);

    // Clear the input and show success message
    $(this).find('input[type="email"]').val('');
    alert('Thank you for subscribing to our newsletter!');
  });
});