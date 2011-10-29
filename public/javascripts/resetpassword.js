(function($) {
    if($.trim($('.errorContainer').html()) != "")
        $('.errorContainer').show();
    $('input.lastbox').keypress(function(e)
    {
        if (e.which == 13)
        {
            $('#Btnresetpassword').trigger('click');
            return false;
        }
    });
    $('#Btnresetpassword').click(function() {
        var options = {
        };
        if($('input[type="password"]').validateText())
        {
            $('input[type="password"]')[0].value = $.trim($('input[type="password"]')[0].value);
            $('input[type="password"]')[1].value = $.trim($('input[type="password"]')[1].value);
            if($('input[type="password"]')[0].value == $('input[type="password"]')[1].value)
                $('form').submit();
            else
            {
                $('.errorContainer').html("Confirm password not matched!.").show();
                setTimeout(hideflash,5000);
            }
        }
        else
        {
            $('.errorContainer').html("Please input the fields properly.").show();
            setTimeout(hideflash,5000);
        }
    });
    function hideflash()
    {
      $('.errorContainer').fadeOut(1000);
    }
})(jQuery);