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
    resetBinding();
    function resetBinding()
    {
        $('#BtnSendInvitation').bind('click',function () {
            SendInvitation($(this));
	    });   
    }
    function SendInvitation(This)
    {
        var mailList = "";
		$('#addedEmailIds li span').each(function() {
			mailList = $(this).html() + ";";
		});
        mailList += $('#emailInvite').val();
		if(mailList != "")
		{
			$('#emailInvite').val(mailList);
            This.unbind('click');
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
                    This.html("Please wait......................")
                },
                success: function(data) {
                    if (typeof (data) == typeof (int)) {
						$('.formError').html("Unable to reach the server. Check your internet connection. Refresh the page to continue.").show();
                        $('#fancybox-content div').eq(0).height($('.modalWindow').height() + 40);
                        $('#fancybox-content').eq(0).height($('.modalWindow').height() );
                    }
                    else if(data.indexOf("true") > -1) {
                         This.html("Invitation sent successfully");
                         $('#addedEmailIds').html('');
                         $('#emailInvite').val('');
                         $('#personalMessage').val('');
                         setTimeout(closeFancyBox,1000);
                         return;
                    }
                    else
                    {
                        $('.formError').html("Unable to reach the server. Check your internet connection. Refresh the page to continue.").show();
                    }
                    This.html("Send invitations");
                },
                error: function(request, error) {
                    $('.formError').html("Unable to reach the server. Check your internet connection. Refresh the page to continue.").show();
                    $('#fancybox-content div').eq(0).height($('.modalWindow').height() + 40);
                    $('#fancybox-content').eq(0).height($('.modalWindow').height() );
                    resetBinding();
                    This.html("Send invitations");
                }});
		}
		else
		{
			$('.formError').html("Opps looks like you not entered emails").show();
		}
    }
    function closeFancyBox()
    {
        $('#fancybox-overlay').trigger('click');
        $('#fancybox-outer').trigger('click');
        $('.fancybox-bg').trigger('click');
    }
    $('#emailInvite').focus();
});