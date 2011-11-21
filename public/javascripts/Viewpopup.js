$(function() {
    $.fancybox({
        'content': $('#Resetpasswordbox').html(),
        'padding' : 20,
        'width': 450,
        'height': 140,
        'autoDimensions':false,
        onClosed: function()
        {
            $('#Resetpasswordbox').remove();
        }
    });
    $('#closebox').live('click',function(){
        $.fancybox.close();
    });
});