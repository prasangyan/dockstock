$(function() {
    function hideerror(){
        $('.error').hide();
    }
    hideerror();
    $('#txtprojectname').focus();
    $('form').submit(function () {
        if($('#txtprojectname')[0].value == "")
        {
            $('.error').html("input project name.").fadeIn(500);
            setTimeout(hideerror,3000);
            $('#txtprojectname').focus();
            return false;
        }
        else
        {
            $('#btnsubmit')[0].value = "creating ....";
        }
    });
});