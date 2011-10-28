$(function () {
     $('.menu-button a').fancybox({
        'transitionIn'	: 'elastic',
		'transitionOut'	: 'elastic',
        'type'			: 'iframe'
    });
    $('.link_add_comments').fancybox({
        'transitionIn'	: 'elastic',
		'transitionOut'	: 'elastic',
        'type'			: 'ajax'
    });
});