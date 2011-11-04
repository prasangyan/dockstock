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
       if(validateForm())
         $('form').submit();
    });
    function validateForm()
    {
        if($('#emailid').validateText())
        {
            if($('#emailid').validateEmail())
            {
                $('#BtnResetPassword').unbind('click');
                $('#BtnResetPassword').html('Submitting, Please wait ...');
                return true;
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
    }
    $('form').submit(function() {
        return validateForm();
    });
    function hideflash()
    {
      $('.errorContainer').fadeOut(1000);
    }
})(jQuery);