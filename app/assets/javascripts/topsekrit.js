$(document).ready(function() {
  $('.btn-lead-outline').click(function() {
        $('.btn-lead-outline').hide();
        $('.auth-form').removeClass('hidden');
  });

  $('.datepicker').pickadate();
});