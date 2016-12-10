//= require pickadate/lib/picker
//= require pickadate/lib/picker.date
//= require pickadate/lib/translations/it_IT

$(function() {
  $('.datepicker').each(function() {
    var minDate = $(this).data('date-min').split('-');
    var maxDate = $(this).data('date-max').split('-');

    minDate = [
      parseInt(minDate[0]),
      parseInt(minDate[1]),
      parseInt(minDate[2])
    ];

    maxDate = [
      parseInt(maxDate[0]),
      parseInt(maxDate[1]),
      parseInt(maxDate[2])
    ];

    $(this).pickadate({
      format: 'yyyy-mm-dd',
      selectYears: true,
      selectMonths: true,
      min: new Date(minDate[0], minDate[1], minDate[2]),
      max: new Date(maxDate[0], maxDate[1], maxDate[2])
    });
  });
});
