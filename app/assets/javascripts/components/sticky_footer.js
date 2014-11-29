(function() {
  $(function() {
    var bodyHeight = $(document).height();
    var viewportHeight = $(window).height();

    if (viewportHeight >= bodyHeight) {
      $('.footer-and-credits')
        .css('position', 'absolute')
        .css('bottom', 0)
        .css('width', '100%')
      ;
    }
  })
}());
