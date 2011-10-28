var linkLocation;
$(function() {
    $('#shareDocument').fancybox({
        'transitionIn'	: 'elastic',
		'transitionOut'	: 'elastic',
        'type'			: 'ajax',
        'width'         : '420',
        'height'        : '300',
        'autoScale'     : false,
        'autoDimensions': false,
        'onComplete'    : function () {
            $('#fancybox-content').height($('.modalWindow').height() + 10);
        }
    });
    $('#fileNavOptions').hover(over,out);
    /*Changing the image to the blue image*/
	function over(){
	    $(this).attr("src","/images/options-blue.png");
    }
	/*Changing the image back to the original image*/
	function out(){
	    $(this).attr("src","/images/options.png");
    }
    /*Click events*/
	$('#fileNavOptions').click(function(){

	});
    $('#fileNavOptions').hover(function(e) {
    	$(this).hover("attr","/images/options-blue.png");
	});
    $("#optionsSubMenuContainer").hide();
    $('.optionsTopStyling').hide();
    $(".fileList a").click(function(a){
    	a.preventDefault();
	    linkLocation = $(this).attr("href");
		$(".previewContainer").prepend('<img src='+linkLocation+' alt="Image">');
    });
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

