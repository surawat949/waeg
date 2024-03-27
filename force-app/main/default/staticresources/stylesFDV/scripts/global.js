function numbersonly(myfield, e, dec)
{
	var key;
	var keychar;
	
	if (window.event)
	   key = window.event.keyCode;
	else if (e)
	   key = e.which;
	else
	   return true;
	keychar = String.fromCharCode(key);
	
	// control keys
	if ((key==null) || (key==0) || (key==8) ||  (key==9) || (key==13) || (key==27) )
	   return true;
	
	// numbers
	else if ((("0123456789.,").indexOf(keychar) > -1))
	   return true;
	
	// decimal point jump
	else if (dec && (keychar == "."))
	   {
	   myfield.form.elements[dec].focus();
	   return false;
	   }
	else
	   return false;
}

/* Remise a zero d'un formulaire      */
function razForm(formulaire)
{
	for(var i=0; i < formulaire.length ; i++) {
		if(formulaire.elements[i].type=='text' || formulaire.elements[i].type=='checkbox'|| formulaire.elements[i].type=='select-one'){
			formulaire.elements[i].value='';
		}
	} 
}

/* Ouverture d'une popup minimaliste */
function openPopup(href,width,height) {
		window.open(href,'','menubar=no, status=no, scrollbars=yes, width='+width+', height='+height);
}
/* Supprime les espaces inutiles en début et fin de la chaîne passée en paramètre. */
function trim(aString) {
	var regExpBeginning=/^\s+/;
	var regExpEnd      =/\s+$/;
	
    return aString.replace(regExpBeginning, "").replace(regExpEnd, "");
}

function patienterLight(message){
	//document.getElementById('waiting').style.display='block';
	document.getElementById('messageAttente').innerHTML=message;
	$("div#waiting").fadeIn("slow");
}
function patienterDone(){
	document.getElementById('waiting').style.display='none';
	document.getElementById('appbody').style.opacity='1';
}

function patienter(message){
	//document.getElementById('waiting').style.display='block';
	$("div#waiting").fadeIn("slow");
	document.getElementById('appbody').style.opacity='0.5';
	document.getElementById('waiting').style.opacity='1';
	document.getElementById('messageAttente').innerHTML=message;
}

function checkNumericValue(field){
	var value=field.value;
	var newValue = value.replace(/\./g, ",");
	field.value = newValue;
}
