$(document).ready(function() {

	$('.stepper-plus').unbind('click').bind('click', function () {
	    
		var number_input = $(this).closest('li').find('[type=number]');
		var value = number_input.val();
		value++;
		number_input.val(value);
	});

	$('.stepper-minus').unbind('click').bind('click', function () {
		
		var number_input = $(this).closest('li').find('[type=number]');
		var value = number_input.val();
		value--;
		number_input.val(value);
	});
});


