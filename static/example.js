jQuery(document).ready(function($){
  $('.postcode_field').on('keyup change', function () {
    var postcode_field = $(this);
    var postcode = this.value;
    if (postcode.length == 6 &&
        !$('.region_field', postcode_field.parents("form")).val().length) {
      jQuery.ajax({ 
        dataType: "jsonp",
        url: '/'+postcode+'.json?callback=?',
        success: function(data){
          postcode_field.val(data.index);
          $('#address_region').val(data.region);
          $('#address_area').val(data.area);
          $('#address_city').val(data.city);
          if (data.index != postcode) {
              var message = "Вы ввели устаревший почтовый индекс: "+postcode+", ваш текущий индекс: "+data.index;
              $('<p class="description notice"></p>').text(message).appendTo($("td:last-child", postcode_field.parents("tr")))
          }
        },
        error: function (jqxhr, status, e) {
          alert('Ошибка: '+status);
          console.debug(jqxhr, status, e);
        }
      });     
    }
  });
});