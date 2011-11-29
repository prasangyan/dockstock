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
            'height': 230,
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
    $('#downloadSyncTool').live('click',function () {
        $.fancybox.close();
    });
    // auto complete code starts here
    var previousCriteria = '';
    $('#searchInput').keyup(function(e) {
       // get keywords from server
        switch(e.which)
        {
            case 27:
            {
                hideAutopoupBoxes();
                return;
            }
        }
        var keyword = $.trim($(this).val());
        if(keyword != "" && keyword != previousCriteria)
		{
            previousCriteria = keyword;
			 // Requesting here
            $.ajax({
                url: "/auto_complete/" + keyword ,
                timeout: 10000,
                //datatype: 'xml',
                cache: false,
                data: {} ,
                type: "POST",
                //contentType: "application/xml; charset=utf-8",
                beforeSend: function() {
                    //hideAutopoupBoxes();
                },
                success: function(data) {
                    if (typeof (data) == typeof (int)) {
                        // need to do error handling somehow
						hideAutopoupBoxes();
                    }
                    else {
                         if(data.folders != null)
                         {
                            if($('.searchResults').find('.result').size() > 0)
                            {
                                var ul_box = $('.searchResults').find('.result').eq(0).find('ul');
                                ul_box.empty();
                                for(var i=0;i<data.folders.length;i++)
                                {
                                    ul_box.append("<li>" + data.folders[i] + "</li>")
                                }
                            }
                            if($('.searchResults').find('.result').size() > 1)
                            {
                                ul_box = $('.searchResults').find('.result').eq(1).find('ul');
                                ul_box.empty();
                                for(var i=0;i<data.files.length;i++)
                                {
                                    ul_box.append("<li>" + data.files[i] + "</li>")
                                }
                            }
                            showAutopoupBoxes();
                         }
                         else
                         {
                            // need to do error handling somehow
                         }
                    }
                },
                error: function(request, error) {
                    // need to do error handling somehow
                    hideAutopoupBoxes();
                }});
		}
        else if(keyword == '')
        {
            hideAutopoupBoxes();
            previousCriteria = '';
        }

    });

    function hideAutopoupBoxes()
    {
        if($('.searchArrow:visible').length != 0)
        {
            $('.searchArrow').hide();
            $('.searchResults').hide();
        }
    }
    function showAutopoupBoxes()
    {
        if($('.searchArrow:visible').length == 0)
        {
            $('.searchArrow').fadeIn('fast');
            $('.searchResults').fadeIn('fast');
        }
    }
});

