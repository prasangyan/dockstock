var linkLocation;
$(function() {
    $('#shareDocument').fancybox({
        'transitionIn'	: 'elastic',
		'transitionOut'	: 'elastic',
        'onClosed' : function () {
            $('#SendInvitation').hide();
        },
        'onStart': function () {
            $('#SendInvitation').show();
            $('.modalWindow').show();
            $('#BtnSendInvitation').html("Send invitations");
        }
    });
    $("#optionsSubMenuContainer").hide();
    $('.optionsTopStyling').hide();
    $('.documentList').hide();
    $('li > div > a').hover(over_a,out_a);
	function over_a(){
	    $(this).parent('div').parent('li').children('ul').show();
	}
	function out_a(){
    }
    $('.documentList').mouseleave(function() { $(this).hide(); });
    if($('#WelcomeBox').size() > 0)
    {
        $.fancybox({
            'content': $('#WelcomeBox').html(),
            'padding' : 20,
            'width': 500,
            'height': 300,
            'autoDimensions':false,
            onClosed: function()
            {
                $('#WelcomeBox').remove();
            }
        });
    }
    $('#LnkCloseFancyBox').live('click',function(){
        $.fancybox.close();
    });
});

