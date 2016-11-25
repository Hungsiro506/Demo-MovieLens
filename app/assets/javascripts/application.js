//= require jquery
//= require jquery_ujs
//= require star-rating
//= require turbolinks

$(document).on('page:change', function() {
  // External Links
  $('a[rel~="external"]').on('click', function(event) {
    event.preventDefault();
    window.open(this.href);
  });
});

$(document).ready(function(){
  $("#input-id").rating();
  $('#input-id').on('rating.change', function(event, value, caption) {
    $.ajax({
      url: "/rate",
      data: {rate: value, movie_id: $(this).data("movie")}
    });
  });
});
