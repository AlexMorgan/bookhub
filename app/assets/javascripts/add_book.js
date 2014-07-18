$(document).ready(function(){
  var $bookTitle = $('#book_title');
  var $bookISBN = $('#book_isbn13');
  var $priceToggle = $('.price_toggle');

  $bookTitle.keyup(function() {
    if ($(this).val().length > 0) {
      $bookISBN.parent().hide('medium');
    } else {
      $bookISBN.parent().show('medium');
    }
  });

  $bookISBN.keyup(function() {
    if ($(this).val().length > 0) {
      $bookTitle.parent().hide('medium');
    } else {
      $bookTitle.parent().show('medium');
    }
  });

  $priceToggle.click(function(){
    if ($('.book_price_input').is(':visible')) {
      $('.book_price_input').hide();
      $(this).parent().attr('class', 'col-xs-12');
    } else {
      $('.book_price_input').show();
      $(this).parent().attr('class', 'col-sm-2 col-xs-12');
    }
  });
});
