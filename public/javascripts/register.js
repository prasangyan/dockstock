(function($) {
    if($.trim($('.errorContainer').html()) != "")
        $('.errorContainer').show();
    $('input.lastbox').keypress(function(e)
    {
        if (e.which == 13)
        {
            $('#BtnSignUp').trigger('click');
            return false;
        }
    });
    $('#BtnSignUp').click(function() {
        var options = {
        };
        if($('#name').validateText() && $('#emailid').validateText() && $('input[type="password"]').validateText())
        {
            if($('#emailid').validateEmail())
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
                $('.errorContainer').html("Please input valid email.").show();
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
    $('form').submit(function(){
        $('#BtnSignUp').unbind('click').html('Please wait....');
    });
})(jQuery);