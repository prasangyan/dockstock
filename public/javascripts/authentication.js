(function($) {
    if($.trim($('.errorContainer').html()) != "")
        $('.errorContainer').show();
    $('input.lastbox').keypress(function(e)
    {
        if (e.which == 13)
            $('#BtnLogIn').trigger('click');        
    });
    $('#BtnLogIn').click(function() {
        var options = {
        };
        if($('#emailid').validateText() && $('input[type="password"]').validateText())
        {
            if($('#emailid').validateEmail())
            {
                $('input[type="password"]')[0].value = $.trim($('input[type="password"]')[0].value);
                $('form').submit();
            }
            else
            {
                $('.errorContainer').html("Invalid email address or password. Please try again.").show();
                setTimeout(hideflash,5000);
            }
        }
        else
        {
            $('.errorContainer').html("Invalid email address or password. Please try again.").show();
            setTimeout(hideflash,5000);     
        }
    });
    function hideflash()
    {
      $('.errorContainer').fadeOut(1000);
    }
    $('form').submit(function() {
        $('#BtnLogIn').unbind('click').html('Logging in...');
    });
    $('#emailid').focus();
})(jQuery);
