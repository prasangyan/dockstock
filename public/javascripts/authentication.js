(function($) {
    if($.trim($('.errorContainer').html()) == "")
        $('.errorContainer').hide();
    /*$('input.lastbox').keypress(function(e)
    {
        if (e.which == 13)
            $('form').submit();
    });*/
    $("#loginForm").validate({
        errorLabelContainer: ".errorContainer",
        wrapper: "li",
        submitHandler: function() {}
    });
})(jQuery);