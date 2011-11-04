// JavaScript Document
// Code taken from http://web.enavu.com/tutorials/how-to-make-a-completely-reusable-jquery-modal-window/
$(document).ready(function(e) {
    $('#shareDocument').click(function() {
        $(".modalWindow").show();
    });
	// Hide modal window
	$(".modalWindow").each(function(e){
		// Get the height and width of the page
		var windowWidth = $(window).width();
		var windowHeight = $(window).height();
		// Postioning the modal window
		var modalWidth = $(this).width();
		var modalHeight = $(this).height();
		// Calculating the postion of the modal window
		var left = (windowWidth - modalWidth)/2;
		var top = (windowHeight - modalHeight)/2;	
		$(this).css({'top': top, 'left': left});
	});
	$('.activateModal').click(function(){
		var modalId = $(this).attr('name');
		// Showing the modal window
		show_modal(modalId);
	});
	$('.closeModal').click(function(){
		close_modal();
	});
});
// Functions
function show_modal(modalId){
	// Set display to block and opacity to 0 so we can fadeTo
	$('#mask').css({'display':'block',opacity:0});
	//fade in the mask to opacity 0.8
    $('#mask').fadeTo(500,0.5);  
	//show the modal window
	$('.'+modalId).fadeIn(500); 
}

function close_modal(){
	$('#mask').fadeOut(500);
	$('.modalWindowContainer').fadeOut(500);
}