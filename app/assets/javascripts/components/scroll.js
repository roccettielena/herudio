//= require jquery.scrollTo/jquery.scrollTo

$(function() {
  $('a[href*=\\#]').click(function() {
    if (
      location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'')
      && location.hostname == this.hostname
      && $(this.hash).length > 0
    ) {
      var offset = -parseInt($(this.hash).css('margin-top'));
      offset -= parseInt($(this.hash).css('padding-top'));

      $.scrollTo(this.hash, {
        duration: 500,
        offset: offset
      });

      return false;
    }
  });
});
