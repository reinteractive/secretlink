$(document).ready(function() {
  $('.datepicker').pickadate();
  $('form').on('submit', function(e){
    $(e.target).find('input[type="submit"]').prop('disabled', true);
  });
});
