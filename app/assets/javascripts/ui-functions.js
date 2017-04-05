if($(window).width() < 676) {
  $("[data-slidetarget]").on("click", function(){
    var target = $(this).data("slidetarget");
    $("[data-slide=" + target + "]").slideToggle("fast");
  });  
};


