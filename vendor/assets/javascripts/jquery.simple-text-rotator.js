!function($){

  var defaults = {
    animation: "dissolve",
    separator: ",",
    speed: 2000
  };

  $.fx.step.textShadowBlur = function(fx) {
    $(fx.elem).prop('textShadowBlur', fx.now).css({textShadow: '0 0 ' + Math.floor(fx.now) + 'px black'});
  };

  $.fn.textrotator = function(options){
    var settings = $.extend({}, defaults, options);

    return this.each(function(){
      var el = $(this)
      var array = [];
      $.each(el.text().split(settings.separator), function(key, value) {
        array.push(value);
      });
      el.text(array[0]);

      // animation option
      var rotate = function() {
        switch (settings.animation) {
          case 'dissolve':
            el.animate({
              textShadowBlur:20,
              opacity: 0
            }, 500 , function() {
              index = $.inArray(el.text(), array)
              if((index + 1) == array.length) index = -1
              el.text(array[index + 1]).animate({
                textShadowBlur:0,
                opacity: 1
              }, 500 );
            });
          break;

          case 'flip':
            if(el.find(".back").length > 0) {
              el.html(el.find(".back").html())
            }

            var initial = el.text()
            var index = $.inArray(initial, array)
            if((index + 1) == array.length) index = -1

            el.html("");
            $("<span class='front'>" + initial + "</span>").appendTo(el);
            $("<span class='back'>" + array[index + 1] + "</span>").appendTo(el);
            el.wrapInner("<span class='rotating' />").find(".rotating").hide().addClass("flip").show().css({
              "-webkit-transform": " rotateY(-180deg)",
              "-moz-transform": " rotateY(-180deg)",
              "-o-transform": " rotateY(-180deg)",
              "transform": " rotateY(-180deg)"
            })

          break;

          case 'flipUp':
            if(el.find(".back").length > 0) {
              el.html(el.find(".back").html())
            }

            var initial = el.text()
            var index = $.inArray(initial, array)
            if((index + 1) == array.length) index = -1

            el.html("");
            $("<span class='front'>" + initial + "</span>").appendTo(el);
            $("<span class='back'>" + array[index + 1] + "</span>").appendTo(el);
            el.wrapInner("<span class='rotating' />").find(".rotating").hide().addClass("flip up").show().css({
              "-webkit-transform": " rotateX(-180deg)",
              "-moz-transform": " rotateX(-180deg)",
              "-o-transform": " rotateX(-180deg)",
              "transform": " rotateX(-180deg)"
            })

          break;

          case 'flipCube':
            if(el.find(".back").length > 0) {
              el.html(el.find(".back").html())
            }

            var initial = el.text()
            var index = $.inArray(initial, array)
            if((index + 1) == array.length) index = -1

            el.html("");
            $("<span class='front'>" + initial + "</span>").appendTo(el);
            $("<span class='back'>" + array[index + 1] + "</span>").appendTo(el);
            el.wrapInner("<span class='rotating' />").find(".rotating").hide().addClass("flip cube").show().css({
              "-webkit-transform": " rotateY(180deg)",
              "-moz-transform": " rotateY(180deg)",
              "-o-transform": " rotateY(180deg)",
              "transform": " rotateY(180deg)"
            })

          break;

          case 'flipCubeUp':
            if(el.find(".back").length > 0) {
              el.html(el.find(".back").html())
            }

            var initial = el.text()
            var index = $.inArray(initial, array)
            if((index + 1) == array.length) index = -1

            el.html("");
            $("<span class='front'>" + initial + "</span>").appendTo(el);
            $("<span class='back'>" + array[index + 1] + "</span>").appendTo(el);
            el.wrapInner("<span class='rotating' />").find(".rotating").hide().addClass("flip cube up").show().css({
              "-webkit-transform": " rotateX(180deg)",
              "-moz-transform": " rotateX(180deg)",
              "-o-transform": " rotateX(180deg)",
              "transform": " rotateX(180deg)"
            })

          break;

          case 'spin':
            if(el.find(".rotating").length > 0) {
              el.html(el.find(".rotating").html())
            }
            index = $.inArray(el.text(), array)
            if((index + 1) == array.length) index = -1

            el.wrapInner("<span class='rotating spin' />").find(".rotating").hide().text(array[index + 1]).show().css({
              "-webkit-transform": " rotate(0) scale(1)",
              "-moz-transform": "rotate(0) scale(1)",
              "-o-transform": "rotate(0) scale(1)",
              "transform": "rotate(0) scale(1)"
            })
          break;

          case 'fade':
            el.fadeOut(settings.speed, function() {
              index = $.inArray(el.text(), array)
              if((index + 1) == array.length) index = -1
              el.text(array[index + 1]).fadeIn(settings.speed);
            });
          break;
        }
      };
      setInterval(rotate, settings.speed);
    });
  }

}(window.jQuery);

$(document).ready(function () {
  $(".rotate").textrotator({
    animation: "flipUp", // You can pick the way it animates when rotating through words. Options are dissolve (default), fade, flip, flipUp, flipCube, flipCubeUp and spin.
    separator: ",", // If you don't want commas to be the separator, you can define a new separator (|, &, * etc.) by yourself using this field.
    speed: 2000 // How many milliseconds until the next word show.
  });
});

