jQuery(document).ready(function($){
  $('.postcode_field').on('keyup change', function () {
    // Найдём все поля
    var postcode_field = $(this);
    var form = postcode_field.parents("form");
    var region_field = $('.region_field', form);
    var autonom_field= $('.autonom_field', form);
    var area_field   = $('.area_field', form);
    var city_field   = $('.city_field', form);
    // Очистим все поля
    region_field.val('');
    autonom_field.val('');
    area_field.val('');
    city_field.val('');
    // Если индекс введён полностью - загрузим информацию о нём
    var postcode = this.value;
    if (postcode.length == 6) {
      jQuery.ajax({ 
        dataType: "jsonp",
        url: 'http://postindexapi.ru/'+postcode+'.json?callback=?',
        beforeSend: function() { // Уведомим пользователя, что загрузка идёт
          $("td:last-child p.description.notice, td:last-child p.description.alert", postcode_field.parents("tr")).remove();
          $('<p class="description notice loading"></p>').text("Загрузка…").appendTo($("td:last-child", postcode_field.parents("tr")))
        },
        success: function(data){
          postcode_field.val(data.index);
          region_field.val(data.region);
          autonom_field.val(data.autonom);
          area_field.val(data.area);
          city_field.val(data.city);
          if (data.index != postcode) {
              var message = "Вы ввели устаревший почтовый индекс: "+postcode+", ваш текущий индекс: "+data.index;
              $('<p class="description notice"></p>').text(message).appendTo($("td:last-child", postcode_field.parents("tr")))
          }
        },
        error: function (jqxhr, status, e) {
          var message = 'Произошла ошибка при загрузке адреса по почтовому индексу!'+e;
          if (e == 'Not Found') message = 'Почте России такой почтовый индекс не известен';
          if (status == 'timeout') message = 'Сервер с почтовыми индексами не отвечает. Попробуйте ещё раз.';
          $('<p class="description alert"></p>').text(message).appendTo($("td:last-child", postcode_field.parents("tr")))
          console.debug(jqxhr, status, e);
        },
        complete: function () { // Уберём плашку
          $("td:last-child p.description.loading", postcode_field.parents("tr")).remove();
        }
      });     
    }
  });
});