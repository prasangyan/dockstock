$(function() {
    // for Search operations
    $("#txtsearchcriteria").quicksearch(".linkrow", {
        noResults: '#noresultsrow',
        stripeRows: ['odd', 'even'],
        loader: 'span.loading',
        onBefore: function() {
            $('.linkrow').removeHighlight();
        },
        onAfter: function() {
            if ($('#txtsearchcriteria').val() != null && $('#txtsearchcriteria').val() != "")
            {
                $('.linkrow').highlight($('#txtsearchcriteria').val());
            }
        }
    });
});