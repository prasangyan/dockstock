// JavaScript Document
// Todo: Need to change the hover icon to the hand icon
$(document).ready(function(e) {
	$("#personalMessage").hide();
	// Adding a hover state to the email ids remove button that are added
	$(".modalWindow #addedEmailIds LI IMG").hover(
		function () {
			$(this).attr("src","img/emailCloseIconHover.png");
		},
		function () {
			$(this).attr("src","img/emailCloseIcon.png");
		}
	);
	// Opening the add personal message text box
	$(".addPersonalMessage").click(function(e) {
		$("#personalMessage").show();
	});
	
	// Adding the email addresses when enter is pressed in the text box
	$("#emailInvite").keypress(function(e) {
		if(e.keyCode == 13){
			var emailEntered;
			emailEntered = $(this).val();
			$('#addedEmailIds').append('<li>'+emailEntered+'<img src="img/emailCloseIcon.png"></li>');
			$(this).val('');
		}
	});
	
});


