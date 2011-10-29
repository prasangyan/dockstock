(function($) {
    if($.trim($('.errorContainer').html()) != "")
        $('.errorContainer').show();
    $('#emailid').keypress(function(e)
    {
        if (e.which == 13)
        {
            $('#BtnResetPassword').trigger('click');
            return false;
        }
    });
    $('#BtnResetPassword').click(function() {
        var options = {
        };
        if($('#emailid').validateText())
        {
            if($('#emailid').validateEmail())
            {
                $('form').submit();
            }
            else
            {
                $('.errorContainer').html("Oops please input valid email.").show();
                setTimeout(hideflash,5000);
                return false;
            }
        }
        else
        {
            $('.errorContainer').html("Oops please input email.").show();
            setTimeout(hideflash,5000);
            return false;
        }
    });
    function hideflash()
    {
      $('.errorContainer').fadeOut(1000);
    }
})(jQuery);