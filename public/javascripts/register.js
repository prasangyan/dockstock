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
                    submit_form();
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
    function showError(msg)
    {
        $('.errorContainer').html(msg).show();
            setTimeout(hideflash,5000);
    }
    $('form').submit(function(){
        submit_form();
        return false;
        //$('#BtnSignUp').unbind('click').html('Please wait....');
    });
    function submit_form()
    {
        $.ajax({
            url: "/createuser",
            timeout: 20000,
            async: true,
            //datatype: 'xml',
            cache: false,
            data: $('form').serialize(),
            type: "POST",
            //contentType: "application/xml; charset=utf-8",
            beforeSend: function() {
                $('#BtnSignUp').unbind('click').html('Please wait....');
            },
            success: function(data) {
                if (typeof (data) == typeof (int)) {
                    showError("Unable to reach the server. Check your internet connection. Refresh the page to continue.");
                }
                else if(data.indexOf("success") > -1) {
                    var content = $('.modalWindow').html();
                    $.fancybox({
                        'content': content,
                        'padding' : 20,
                        'width': 500,
                        'height': 300,
                        'autoDimensions':false,
                        onClosed: function()
                        {
                            window.location = "/dashboard";
                        }
                    });
                }
                else
                {
                    $('body').html(data);
                    //showError(data);
                }
            },
            error: function(request, error) {
                showError("Unable to reach the server. Refresh the page to continue.");
            }});
    }
})(jQuery);