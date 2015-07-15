$(document).ready(function() {
  $('.btn-lead-outline').click(function(e) {
    $('.btn-lead-outline').hide();
    $('.auth-form').removeClass('hidden');
    e.preventDefault();
  });

  $('.datepicker').pickadate();
  $('form').on('submit', function(e){
    $(e.target).find('input[type="submit"]').prop('disabled', true);
  });
});
