$(function() {
    $('.addPersonalMessage').click(function() {
        $('#personalMessage').toggle();
        $('#fancybox-content div').eq(0).height($('.modalWindow').height() + 40);
        $('#fancybox-content').eq(0).height($('.modalWindow').height() );
        $('#personalMessage').focus();
    });
    $('#emailInvite').bind('keypress', function(e){
        if(e.which == 13)
        {
            $('#addedEmailIds').append("<li><span>" + $(this).val() + "</span><img src='/images/emailCloseIcon.png' class='emailCloseIcon' /></li>");
            $(this).val('');
			$('.formError').html('');
            $('#fancybox-content div').eq(0).height($('.modalWindow').height() + 40);
            $('#fancybox-content').eq(0).height($('.modalWindow').height() );
            $('#emailInvite').focus();
            return false;
        }
    });
    $('.emailCloseIcon').live('click',function () {
        $(this).parents('li').eq(0).remove();
    });
    $('form').bind('submit', function() {
        return false;
    });
	$('#BtnSendInvitation').bind('click',function () {
		var mailList = "";
		$('#addedEmailIds li span').each(function() {
			mailList = $(this).html() + ";";
		});
		var This = $(this);
		if(mailList != "")
		{
			$('#emailInvite').val(mailList);
			 // Sending here
            $.ajax({
                url: "/SendInvitation",
                timeout: 10000,
                //datatype: 'xml',
                cache: false,
                data: $('form').serialize(),
                type: "POST",
                //contentType: "application/xml; charset=utf-8",
                beforeSend: function() {
                    This.val("Please wait......................")        
                },
                success: function(data) {
                    if (typeof (data) == typeof (int)) {
						$('.formError').html("Unable to reach the server. Check your internet connection. Refresh the page to continue.").show();
                    }
                    else if(data.indexOf("success") > -1) {
                         This.val("Invitation sent successfully");
						 setTimeout($.fancybox.close(),2000);
                    }
                    else
                    {
                        showError(errorBox,data);                        
                    }
                    This.val("Add link");
                },
                error: function(request, error) {
                    $('.formError').html("Unable to reach the server. Check your internet connection. Refresh the page to continue.").show();
                    This.val("Add link");
                }});
		}
		else
		{
			$('.formError').html("Opps looks like you not entered emails").show();
		}
	});
});