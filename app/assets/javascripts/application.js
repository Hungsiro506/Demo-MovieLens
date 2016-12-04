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




var ready = function() {
  var engine = new Bloodhound({
      datumTokenizer: function(d) {
          console.log(d);
          return Bloodhound.tokenizers.whitespace(d.title);
      },
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
          url: '../search/typeahead/%QUERY'
      }
  });

  var promise = engine.initialize();

  promise
      .done(function() { console.log('success'); })
      .fail(function() { console.log('error') });

  $("#term").typeahead(null, {
    name: "article",
    displayKey: "title",
    source: engine.ttAdapter()
  })
};

$(document).ready(ready);
$(document).on('page:load', ready);
