$(function() {
  // Add smooth scrolling to all header links
  $('.main-nav__links a[href^="/#"], .footer-links a[href^="/#"]').on('click', function(event) {
    smoothScrolling(event);
  });
});

function smoothScrolling(event) {
  var link = event.target;

  if (link.hash !== "") {
    var hash    = link.hash;
    var target  = $(hash).length > 0;

    // Scroll a little higher to account for the sticky header
    var headerHeight = 50;
    var yValue = $(hash).offset().top - headerHeight;

    if (target) {
      $('html, body').animate({
        scrollTop: yValue
      }, 800);
    }
  }
}
