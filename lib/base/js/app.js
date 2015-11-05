$(document).ready(function() {
		
	$('.codemagic').click(function(event) {
		event.preventDefault();
				
		var magic = $('#magic');
		
		var codemagic = magic.val();
		
		codemagic += " @";
		codemagic += this.name;
		codemagic += ". ";
				
		$('#magic').val(codemagic);

		return false;
	});
			
});
