$(document).ready(function() {
  $('.btn-lead-outline').click(function() {
        $('.btn-lead-outline').hide();
        $('.auth-form').removeClass('hidden');
  });

  $('.datepicker').pickadate();
  $('form').on('submit', function(e){
    $(e.target).find('input[type="submit"]').prop('disabled', true);
  });
});
