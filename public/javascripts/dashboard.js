var linkLocation;
$(function() {
    $('#shareDocument').fancybox({
        'transitionIn'	: 'elastic',
		'transitionOut'	: 'elastic',
        'onClosed'       : function () {
            $('#SendInvitation').hide();
        },
        'onStart'       : function () {
            $('#SendInvitation').show();            
        }
    });
    $("#optionsSubMenuContainer").hide();
    $('.optionsTopStyling').hide();
    $('.documentList').hide();
	/*todo: Need to find a better way of targeting the folder links*/
    $('li > div > a').hover(over_a,out_a);
	function over_a(){
	    $(this).parent('div').parent('li').children('ul').show();
	}
	function out_a(){
	/* Todo: Figure out how to hide this when they click on the link again
	$(this).parent('div').parent('li').children('ul').hide();
	*/
    }
});

