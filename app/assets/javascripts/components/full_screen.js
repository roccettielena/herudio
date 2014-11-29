(function() {
  var drawFullScreen = function() {
    $('.full-screen').each(function() {
      var content = $(this).find('.full-screen-inner');

      var windowHeight = $(window).height();
      var contentHeight = content.height();

      var verticalPadding = (windowHeight - contentHeight) / 2;
      verticalPadding -= $('.navbar-static-top').height() / 2;

      if (verticalPadding < 100) {
        verticalPadding = 100;
      }

      content.find('.full-screen-target').each(function() {
        $(this).css('padding-top', verticalPadding);
        $(this).css('padding-bottom', verticalPadding);
      });
    });
  };

  $(drawFullScreen);
  $(window).resize(drawFullScreen);
}());
