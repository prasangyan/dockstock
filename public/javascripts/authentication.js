$('input.lastbox').keypress(function(e)
    {
        if (e.which == 13)
            $('form').submit();
    });