function quitFdv(){window.opener = self; self.close();}

//for iphone/ipad
function processingRoutine() {
	var swipedElement = document.getElementById(triggerElementID);
	if ( swipeDirection == 'left' ) {
	} else if ( swipeDirection == 'right' ) {
		var next = document.getElementById('idNext');
		next.click();
	} else if ( swipeDirection == 'up' ) {	
	} else if ( swipeDirection == 'down' ) {}
}


/**
 * preparation.js
 */
 function semainePrecedente(){
	window.document.semainierForm.action.value='semainePrecedente';
	patienter(null, null, 'Chargement');
}
function semaineSuivante(){
	window.document.semainierForm.action.value='semaineSuivante';
	patienter(null, null, 'Chargement');
}
function chargerSemaine(){
	window.document.semainierForm.action.value='semaineChargement';
	window.document.getElementById('navsecteur').value=window.document.getElementById('recsecteur').value;
	patienter('Chargement');
	window.document.semainierForm.submit();
}
function chargerSecteur(){
	window.document.semainierForm.action.value='secteurChargement';
	window.document.getElementById('navsecteur').value=window.document.getElementById('recsecteur').value;
	patienter('Chargement');
	window.document.semainierForm.submit();
}
/*
 * permet d'effacer un element drag&droppable
 */
function deleteChild(jour, id) {
	var child=null;
	var ul=document.getElementById(jour);
	var size=ul.childElementCount;
	for(var i=0; i<size; i++){
		var li=ul.children[i];
		if(li.id == 'li'+id)
			child=li;
	}
	if(child!=null){
		var disparu=document.getElementById(jour).removeChild(child);
		var temp=document.getElementById('temp_'+id);
		if (temp != null) {
			document.getElementById('rechercheClientForm').removeChild(temp);
		}
	}
}
/*
 * permet d'effacer un element semainier deja sauvegarder
 */
function deleteChildOracle(annee, semaine, jour, codeClient) {
	$.ajax({
		type:"POST",
		url: "visite/ajaxDeleteVisite.action",
		data: "annee_d=" + annee + "&semaine_d=" + semaine + "&jour_d=" + jour + "&codeClient_d=" + codeClient,
		success: function(msg){
			if(msg=='KO')
			{
				alert('Une erreur est survenue lors de la suppression.');
			}
			else{
				deleteChild(jour, codeClient);
			}
		}
	});
}
function desactiveDragDrop(id, jour) {
	var child=null;
	var ul=document.getElementById(jour);
	
	if(ul!=null){
		var size=ul.childElementCount;
		for(var i=0; i<size; i++){
			var li=ul.children[i];
			if(li.id == 'li'+id)
				child=li;
		}
	}
	else
		child=document.getElementById('li'+id);
	child.onmousedown='';
}
function activeDragDrop(id, jour){
	var child=null;

	var ul=document.getElementById(jour);
	if(ul!=null){
		var size=ul.childElementCount;
		for(var i=0; i<size; i++){
			var li=ul.children[i];
			if(li.id == 'li'+id)
				child=li;
		}
	}
	else
		child=document.getElementById('li'+id);
	child.onmousedown=initDrag;
}
/**
 * visites.js
 */
function ajoutercontact(){
	var nb=document.contactForm.nbcontacts.value;
	var newRow=document.getElementById('contacts').insertRow(-1);
	
	var cellDel=newRow.insertCell(0);
	cellDel.innerHTML='<a href="#" onclick="javascript:supprimerContact(this, false)"><img src="/fdv/images/delete.gif"/></a>';
	
	var cellNom=newRow.insertCell(1);
	cellNom.innerHTML='<input type="text" name="contactNom'+nb+'"/>';
	
	var cellPrenom=newRow.insertCell(2);
	cellPrenom.innerHTML='<input type="text" name="contactPrenom'+nb+'"/>';
	
	var cellRole=newRow.insertCell(3);
	var select='<select name="contactRole'+nb+'">';
	//on copie toutes les options tel quel par rapport au contenu cach� pour initialis� le select
	var options=document.getElementById('hidden_contact').getElementsByTagName('select')[0].getElementsByTagName('option');
	for(var i=0 ; i<options.length ; i++){
		select += '<option name='+options[i].value+'>'+options[i].value+'</option>';
	}
	cellRole.innerHTML += select+'</select>';

	var cellInfo=newRow.insertCell(4);
	cellInfo.innerHTML='<input type="text" name="contactInfo'+nb+'" size="50"/>';
	
	nb++;
	document.contactForm.nbcontacts.value=nb;
}
function supprimerContact(ancre, isOnOracle){
	//creation d'un input hidden pour memoriser contact a effacer
	if(isOnOracle){
		var newInput=document.createElement('input');
		newInput.type='hidden';
		newInput.name='deleteContact'+document.getElementById('contacts').rows[ancre.parentNode.parentNode.rowIndex].getElementsByTagName('td')[4].getElementsByTagName('input')[1].value;
		newInput.value=document.getElementById('contacts').rows[ancre.parentNode.parentNode.rowIndex].getElementsByTagName('td')[4].getElementsByTagName('input')[1].value;
		document.contactForm.appendChild(newInput);
	}
	//suppression du dom de la ligne a supprimer
	document.getElementById('contacts').deleteRow(ancre.parentNode.parentNode.rowIndex);
}

function setStatut(value, check){
	document.initVisiteForm.statutValue.value=value;
}
/**
 * permet d'ajouter une ligne vierge dans la liste des remarques
 * ecran: consultationVisite.jsp
 */
function ajouterRemarque(){
	var nb=document.initVisiteForm.nbRemarques.value;
	var newRow=document.getElementById('tableRemarques').insertRow(-1);

	var cellMotif=newRow.insertCell(0);
	var select='<select id="remarqueList[' + nb + '].idRubrique" name="remarqueList[' + nb + '].idRubrique">';
	//on copie toutes les options tel quel par rapport au contenu cach� pour initialis� le select
	var options=document.getElementById('hidden_motif').getElementsByTagName('select')[0].getElementsByTagName('option');
	for(var i=0 ; i<options.length ; i++){
		select += '<option value='+options[i].value+'>'+options[i].innerHTML+'</option>';
	}
	cellMotif.innerHTML += select+'</select>';
	
	var cellDescription=newRow.insertCell(1);
	cellDescription.innerHTML='<textarea cols="97" rows="1" name="remarqueList['+nb+'].question" id="remarqueList['+nb+'].question"/>';
	
	nb++;
	document.initVisiteForm.nbRemarques.value=nb;
}

/**
 * permet d'ajouter une ligne vierge dan la liste des actions
 * ecran: consultationVisite.jsp
 */
function ajouterAction(){
	var nb=document.initVisiteForm.nbActions.value;
	var newRow=document.getElementById('tableActions').insertRow(-1);
	
	var cellEcheance=newRow.insertCell(0);
	cellEcheance.innerHTML='<input type="text" name="actionEcheance'+nb+'" onchange="checkRemarqueDate(this);" size="6" maxlength="8"/>';

	var cellDescription=newRow.insertCell(1);
	cellDescription.innerHTML='<textarea cols="97" rows="1" name="actionDescription'+nb+'"/>';
	
	nb++;
	document.initVisiteForm.nbACtions.value=nb;
}

function consulterVisite(id, code){
	window.location="/fdv/visite/ficheVisite.action?idVisite="+id+"&codeClient="+code;
}
/**
 * client.js
 */
function consulterClient2(code, newMode, newCrit){
	document.rechercheClientForm.down.value='on';
	window.location="/fdv/client/rechercheClient.action?code="+code+"&mode="+newMode+"&action=search&newCrit="+newCrit;
}
function consulterClient(code, mode){
	if(document.forms[0]==null || document.forms[0].down==null || document.forms[0].down.value=='off')
		window.location="/fdv/client/ficheClientInit.action?codeClient="+ code + "&mode=" + mode;
}
function consulterGroupement(code){
	if(document.forms[0].down.value=='off'){
		document.getElementById('rechercheClientForm_critere_mode').value = 'consulterGroupement';
	}
	window.location="/fdv/client/ficheClient.action?codeClient="+code+"&mode="+document.getElementById('rechercheClientForm_critere_mode').value;
}
function consulterProprietaire(code){
	if(document.rechercheClientForm.down.value=='off'){
		document.getElementById('rechercheClientForm_critere_mode').value = 'consulterProprietaire';
	}
	window.location="/fdv/client/ficheClient.action?codeClient="+code+"&mode="+document.getElementById('rechercheClientForm_critere_mode').value;
}
function consulterCentrale(code){
	if(document.rechercheClientForm.down.value=='off'){
		document.getElementById('rechercheClientForm_critere_mode').value='consulterCentrale';
	}
	window.location="/fdv/client/ficheClient.action?codeClient="+code+"&mode="+document.getElementById('rechercheClientForm_critere_mode').value;
}
function consulterOphta(code){
	window.location="/fdv/client/ficheClient.action?codeClient="+code+"&mode="+document.rechercheClientForm.mode.value;
}

/* gesteCo.js */
function deleteGeste(){
	if(confirm('Etes-vous sur de vouloir supprimer cette demande ?')) {
		return false;
	}
}

function detailGeste(id){
	//var action=document.getElementById("formAction").value;
	//if(action!='delete' && action!='valider')
	window.location='/fdv/reclamation/detailGesteCo.action?code='+id;
}

function fermeture(){parent.window.close();}
function OpenSuiviActivite(codeClient, secteur)
{
	var url;
	url="/fdv/jsp/synthesePrint.jsp?type=synthese&groupement=false&codeClient="+codeClient+"&secteur="+secteur;
	window.open(url, "", "toolbar=no, title=no, location=no, directories=no, status=no, scrollbars=no,  width=600, height=220, left=150, top=150");
}

function openFicheOphta(code){
	window.location = '/fdv/sante/initFicheOphta.action?code=' + code;
}
function createProspect()
{	
	var url;
	url="/fdv/createProspect.xsql";
	location=url;
}
function checkQuestionnaireDepotPLV(id,groupe,rubrique,nomChamp, reponse)
{
	var champUpdate="reponse";
	if (nomChamp == 'date')
	{
		if (isDateValidJJMMAA(reponse.value) == 'false')
		{
			alert ("Veuillez saisir une date au format jj/mm/aa");		
			var champ=document.getElementById('date'+rubrique);
			champ.value="";
			champ.focus();
			return;
		}
	}
	if (nomChamp == 'quantite')
	{	
		if (isNaN(parseInt(reponse.value))) {
			var champ=document.getElementById('quantite'+rubrique);
			alert ("Veuillez saisir un nombre.");
			champ.value="";	
			champ.focus();
			return;
		}
		champUpdate="reponseBis";
	}	
}

/* si date format�e en JJ/MM/AA retourne aaaammjj si non retourne false */
function isDateValidJJMMAA(chaineDate) {
	
   if (chaineDate == "") return "";
 
   var dateArray=(chaineDate).split("/");
   if ((dateArray.length != 3) || isNaN(parseInt(dateArray[0])) || isNaN(parseInt(dateArray[1])) || isNaN(parseInt(dateArray[2]))) return 'false';
   
   var anneeAAAA=dateArray[2];
   if (dateArray[2].length == 2)   
   		anneeAAAA='20'+dateArray[2];
   		
   var unedate=new Date(eval(anneeAAAA),eval(dateArray[1])-1,eval(dateArray[0]));
   var annee=unedate.getYear();
   if ((Math.abs(annee)+"").length < 4) annee=annee+1900;

   if ((unedate.getDate() == eval(dateArray[0])) && (unedate.getMonth() == eval(dateArray[1])-1) && (annee == eval(anneeAAAA)))
   {
	   var mm=dateArray[1];
	   var dd=dateArray[0];
	   if (mm.length == 1) {
		   mm='0'+mm;
	   }
	   if (dd.length == 1) {
		   dd='0'+dd;
	   }
	   return  anneeAAAA+''+mm+''+dd;
   }
   else
   	return 'false';
}

function checkAction (id, rang, nomChamp, valeur)
{
	var champ=document.getElementById (nomChamp+"Action"+rang);
	var valueChamp=valeur.value;
	
	if (nomChamp == 'echeance')
	{	
		if (valueChamp != 'prochaine visite')
		{
			valueChamp=isDateValidJJMMAA(valueChamp);
			if ((valueChamp == 'false') || (valueChamp.length == 0))
			{
				alert ("Veuillez saisir une date au format jj/mm/aa.");
				champ.value="prochaine visite";
				champ.focus();
				return false;
			}
		}
	}

	if 	(nomChamp == 'description')
	{
		if (valueChamp.length > 4000)
		{
			alert ("La description ne peut d�passer 4000 caract�res.");
			champ.focus();
			return false;
		}
	}
}


function checkRemarqueDate(date)
{
	var dateValue=isDateValidJJMMAA(date.value);
	
	if ((dateValue == 'false') || (dateValue.length == 0))
	{
		alert ("Veuillez saisir une date au format jj/mm/aa.");
		date.value="";
		date.focus();
		return;
	}

}

function genererPdf(id, idPrec)
{
	var url;
	url="/fdv/getSyntheseVisite?visiteId="+escape(id)+"&visiteIdPrec="+escape(idPrec);
	openPopup(url,800,600);
}

function genererExcel(id, jour, codeClient)
{
	var url;
	url="/fdv/jsp/genExcel.jsp?id="+escape(id)+"&jour="+escape(jour)+ "&codeClient="+escape(codeClient);
	openPopup(url, 800, 600);
}

function genererExcelVierge()
{
	var url;
	url="/fdv/jsp/genExcel.jsp";
	openPopup(url, 800, 600);
}

function genererBilanVisitesExcel(codeClient)
{
	var url;
	url="/fdv/genBilanVisitesExcel.jsp?codeClient="+escape(codeClient);
	openPopup(url, 800, 600);
}

// Envoie un rendez-vous outlook par email
// Sujet : sujet de l'email et du rendez-vous
// Description : description � afficher dans le rendez-vous
// Email recupere en session (SFA_mail)
// Lieu : lieu du rendez-vous
// Date : date du rdv (format YYYYMMDD)
// Heure : heure du rdv en france (format HHMMSS)

function envoieRdvOutlook (sujet, description,lieu,date,heure)
{
	var serverSideURL="/fdv/jsp/outlookmail.jsp?sujet="+escape(sujet)+
				"&description="+escape(description) +
				"&lieu="+escape(lieu)+
				"&date="+escape(date)+
				"&heure="+ escape(heure);
	//alert(description);
	var ajaxRequest=new HTTPRequestObject(serverSideURL);
    ajaxRequest.sendSynchro();
}

/* Affichage d'une div d'information transparent au milieu de l'ecran **********/
function divInfo(message/*,tempo*/)
{
	Nom=navigator.appName;
	ns=(Nom == 'Netscape') ? 1:0;
	ie=(Nom == 'Microsoft Internet Explorer') ? 1:0;
	
	top.document.getElementById('divInfo').style.backgroundColor='yellow';
	top.document.getElementById("messageZone").innerHTML=message;
	top.document.getElementById("divInfo").style.display='';
	if(ie) {
		top.document.getElementById('divInfo').style.filter='alpha(opacity=70)';
	}
	else {
		top.document.getElementById('divInfo').style.opacity='0.70';
	}

	posDivInfo();
}

function posDivInfo()
{
	if (document.documentElement && document.documentElement.scrollTop) {
		offsety=document.documentElement.scrollTop;
		offsetx=document.documentElement.scrollLeft;
	}
	else if (document.body) {
		offsety=document.body.scrollTop;
		offsetx=document.body.scrollLeft;
	}
	else {
		offsety=window.pageYOffset;
  		offsetx=window.pageXOffset;
	}

	top.document.getElementById('divInfo').style.marginLeft=-300+offsetx+"px";
	top.document.getElementById('divInfo').style.marginTop=-75+offsety+"px";	
	
	if(top.document.getElementById('divInfo').style.display == '')
		setTimeout("posDivInfo();",10);
}

/* Affichage d'une div d'erreur transparent au milieu de l'ecran ***************/
function divError(message,tempo)
{
	Nom=navigator.appName;
	ns=(Nom == 'Netscape') ? 1:0;
	ie=(Nom == 'Microsoft Internet Explorer') ? 1:0;
	
	top.document.getElementById('divInfo').style.backgroundColor='red';
	top.document.getElementById("messageZone").innerHTML=message;
	top.document.getElementById("divInfo").style.display='';
	if(ie)
		top.document.getElementById('divInfo').style.filter='alpha(opacity=70)';
	else
		top.document.getElementById('divInfo').style.opacity='0.70';

	posDivInfo();	
	if(tempo!=0) {
		for(i=0.70;i>=0.1;i=i-0.05) {	
			if(ie) setTimeout("top.document.getElementById('divInfo').style.filter='alpha(opacity="+i*100+")';",tempo-(i*1000));
			else setTimeout("top.document.getElementById('divInfo').style.opacity="+i+";",tempo-(i*1000));

		}
		setTimeout("top.document.getElementById('divInfo').style.display='none';",tempo);
	}
}

/* Fonction a appeler sur une page HTML pour utiliser la div d'information *****/
function useDivInfo()
{
	Nom=navigator.appName;
	ns=(Nom == 'Netscape') ? 1:0;
	ie=(Nom == 'Microsoft Internet Explorer') ? 1:0;
	
   	if(ie) document.write('<div id="divInfo" style="height:150px; width:600px; position: absolute; left: 50%; top: 50%; margin-top: -75px; margin-left: -300px; filter: alpha(opacity=70); background-color:yellow; display:none; border-width: 5px; border-style: solid; border-color: blue;">');
   	else document.write('<div id="divInfo" style="height:150px; width:600px; position: absolute; left: 50%; top: 50%; margin-top: -75px; margin-left: -300px; opacity: 0.70; background-color:yellow; display:none; border-width: 5px; border-style: solid; border-color: blue;">');
	document.write('<table width="100%">');
	document.write('<tr style="height:140px"><td align="center" valign="middle" style="font-size: 10pt; font-weight: bold;" id="messageZone"></td></tr>');
	document.write('</table>');
	document.write('</div>');
}

/*****************************************************/
/* M�thodes utilis� pour l'ouverture d'une div popup */
/*****************************************************/
function posDivPopUp(id)
{
	var documentValid=top.document;
	if (document.documentElement && document.documentElement.scrollTop) {
		offsety=document.documentElement.scrollTop;
		offsetx=document.documentElement.scrollLeft;
	}
	else if (document.body) {
		offsety=document.body.scrollTop;
		offsetx=document.body.scrollLeft;
	}
	else {
		offsety=window.pageYOffset;
  		offsetx=window.pageXOffset;
	}
	documentValid.getElementById(id).style.marginLeft=-425+offsetx+"px";
	documentValid.getElementById(id).style.marginTop=-217+offsety+"px";	
	if(documentValid.getElementById(id).style.display == 'block') {
		setTimeout("posDivPopUp('"+id+"');",10);
	}
}


/* escape adresse pour maps */
function showMap(adresse,ville,pays) {
var url="http://maps.google.com?q="+escape(adresse)+","+escape(ville)+","+escape(pays);
window.open(url,"Carte");
}

/***********************************************************************/
/**				Controle Ajax magasin/secteur/facture/commande		  **/
/**				utilis� par l'ecran creation geste commercial		  **/
/***********************************************************************/
function checkMagasinSecteur(magasinField, factureField, commandeField, secteur, mode)
{
	var codeMagasin=magasinField.value;

	var parameters="";

	if(mode=='magasin'){
		if(codeMagasin.length==0){
			return;
		}
		if(codeMagasin.length!=5){
			alert('Veuillez entrer un code � 5 chiffres.');
			magasinField.focus();
			return;
		}
		parameters="code="+escape(codeMagasin)+"&secteur="+secteur+"&mode=magasin";
	}
	else if(mode=='facture'){
		if(magasinField.value==''){
			alert('Veuillez renseigner le code magasin.');
			factureField.value='';
			magasinField.focus();
			return;
		}
		else{
			parameters="code="+escape(codeMagasin)+"&codeFacture="+factureField.value+ "&mode=facture";
		}
	}
	else if(mode=='commande'){
		document.getElementById('commande').innerHTML='<img src="/fdv/images/rondAnim.gif"/><span style="color:red;"> Chargement de la commande</span>';
		if(magasinField.value==''){
			alert('Veuillez renseigner le code magasin.');
			commandeField.value='';
			magasinField.focus();
			document.getElementById('commande').innerHTML='';
			return;
		}
		else{
			
			parameters="code="+escape(codeMagasin)+"&codeCommande="+commandeField.value+ "&mode=commande";
		}
	}
	var result ='';;
	var error = false;

	//controle du code commande par appel ajax jquery
	$.ajax({
		type: "POST",
		url: "reclamation/ajaxCheckGeste.action",
		data: parameters,
		async:false,
		success: function(msg){
			if(msg.indexOf('KO')==-1) {
				result = msg;
			} else {
				error = true;
				result = msg;
			}
	}
	});
	
	if (error) {
		if(mode=='magasin'){
			divError('Code magasin '+magasinField.value+' inconnu pour le secteur', 4000);
			magasinField.value='';
			magasinField.focus();
		}
		else if(mode=='facture'){
			divError('Code facture '+factureField.value+' inconnu pour le magasin '+codeMagasin, 4000);
			factureField.value='';
			factureField.focus();
		}
		else if(mode=='commande'){
			divError('Numero de commande '+commandeField.value+' inconnu pour le magasin '+codeMagasin, 4000);
			commandeField.value='';
			commandeField.focus();
			document.getElementById('commande').innerHTML='';
		}
	}else if(mode=='commande'){
		//remplacer le code html pour afficher la commande
		document.getElementById('commande').innerHTML=result;
	}

}

function checkCodeFacture(field){
	var expr=new RegExp("[0-9][0-9][0-9][0-9][0-9][0-9]");
	var code=field.value;
	if (code!='' && !code.match(expr)){
		alert("Le code facture doit �tre un code � 6 chiffres.");
		field.value='';
		field.focus();
	}
	else
	{
		checkMagasinSecteur(document.creationGesteForm.codeClient, document.creationGesteForm.codeFacture, null, document.creationGesteForm.secteur.value, 'facture');
	}
}

function checkCodeCommande(field){
	var expr=new RegExp("[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]");
	var code=field.value;
	if (code!='' && !code.match(expr)){
		alert("Le code commande doit �tre un code � 8 chiffres.");
		field.value='';
		field.focus();
		document.getElementById('commande').innerHTML='';
	}
	else
	{
		checkMagasinSecteur(document.creationGesteForm.codeClient, null, document.creationGesteForm.codeCommande, document.creationGesteForm.secteur.value, 'commande');
	}
}

function checkDateValidAAAMM(champDate) {
	var reg=new RegExp("[0-9][0-9][0-9][0-9][0-9][0-9]");
	var result=false;
	if(champDate.value.match(reg) || champDate.value.length==0)
		result=true;
	else{
		champDate.value='';
		alert('L\'ann�e et le mois doivent �tre saisis sous la forme AAAAMM');
		champDate.focus();
		}
}

function checkDateValidAAAMMJJ(champDate) {
	var reg=new RegExp("[0-2][0-1][0-9][0-9][0-9][0-9][0-9][0-9]");
	var result=false;
	if(champDate.value.match(reg) || champDate.value.length==0)
		result=true;
	else{
		champDate.value='';
		alert('L\'ann�e et le mois doivent �tre saisis sous la forme AAAAMMJJ');
		champDate.focus();
		}
}

/**
 * ouverture popup pour visualiser une synthese
 */
function ouvre_popup(page) {
    window.open(page,"erreur_telechargement","resizable=yes menubar=no, status=no, scrollbars=no, menubar=no, width=950, height=600");
}
/**
 * soumet le formulaire avec la variable action=rechercher
 * affiche la div 'recherche en cours'
 */
function patienter(form, action, message){
	document.getElementById('waiting').style.display='block';
	document.getElementById('appbody').style.opacity='0.5';
	document.getElementById('waiting').style.opacity='1';
	document.getElementById('messageAttente').innerHTML=message;
	if(form!=null){
		form.action.value=action;
	}
}


function changeStyleSelectPotentiel(){
	select=window.document.getElementById('potentiel');
	if(select!=null){
		select.className='selectMedium';
		if(select.value=='AB0') select.className=select.className+' carre0';
		if(select.value=='CD0') select.className=select.className+' carre0b';
		if(select.value=='AB12') select.className=select.className+' carre1';
		if(select.value=='AB34') select.className=select.className+' carre2';
		if(select.value=='CD12') select.className=select.className+' carre3';
		if(select.value=='CD34') select.className=select.className+' carre4';
	}
}

/**
 * drag drop
 */
var boxSizeArray=[12,12,12,12,12,12,12];
var arrow_offsetX=-5;
var arrow_offsetY=0;
var arrow_offsetX_firefox=-6;
var arrow_offsetY_firefox=-13;
var verticalSpaceBetweenListItems=3;
var indicateDestionationByUseOfArrow=true;
var cloneSourceItems=true;	
var cloneAllowDuplicates=false;
/* END VARIABLES YOU COULD MODIFY */
var dragDropTopContainer=false;
var dragTimer=-1;
var dragContentObj=false;
var contentToBeDragged=false;
var contentToBeDragged_src=false;
var contentToBeDragged_next=false; 
var destinationObj=false;
var dragDropIndicator=false;
var ulPositionArray=new Array();
var mouseoverObj=false;

var MSIE=navigator.userAgent.indexOf('MSIE')>=0?true:false;
var navigatorVersion=navigator.appVersion.replace(/.*?MSIE (\d\.\d).*/g,'$1')/1;
var indicateDestinationBox=false;
function getTopPos(inputObj)
{		
  var returnValue=inputObj.offsetTop;
  while((inputObj=inputObj.offsetParent) != null){
  	if(inputObj.tagName!='HTML')returnValue += inputObj.offsetTop;
  }
  return returnValue;
}

function getLeftPos(inputObj)
{
  var returnValue=inputObj.offsetLeft;
  while((inputObj=inputObj.offsetParent) != null){
  	if(inputObj.tagName!='HTML')returnValue += inputObj.offsetLeft;
  }
  return returnValue;
}
	
function cancelEvent(){return false;}
function initDrag(e)// Mouse button is pressed down on a LI
{
	if(document.all)e=event;
	var st=Math.max(document.body.scrollTop,document.documentElement.scrollTop);
	var sl=Math.max(document.body.scrollLeft,document.documentElement.scrollLeft);
	
	dragTimer=0;
	dragContentObj.style.left=e.clientX+sl+'px';
	dragContentObj.style.top=e.clientY+st+'px';
	contentToBeDragged=this;
	contentToBeDragged_src=this.parentNode;
	contentToBeDragged_next=false;
	if(this.nextSibling){
		contentToBeDragged_next=this.nextSibling;
		if(!this.tagName && contentToBeDragged_next.nextSibling)contentToBeDragged_next=contentToBeDragged_next.nextSibling;
	}
	timerDrag();

	return false;
}

function timerDrag()
{
	if(dragTimer>=0 && dragTimer<10){
		dragTimer++;
		setTimeout('timerDrag()',10);
		return;
	}
	if(dragTimer==10){
		
		if(cloneSourceItems){
			newItem=contentToBeDragged.cloneNode(true);
			newItem.onmousedown=contentToBeDragged.onmousedown;
			contentToBeDragged=newItem;
		}
		dragContentObj.style.display='block';
		dragContentObj.appendChild(contentToBeDragged);
	}
}

function moveDragContent(e)
{
	if(dragTimer<10){
		if(contentToBeDragged){
			if(contentToBeDragged_next){
				contentToBeDragged_src.insertBefore(contentToBeDragged,contentToBeDragged_next);
			}else{
				//contentToBeDragged_src.appendChild(contentToBeDragged);
			}	
		}
		return;
	}
	if(document.all)e=event;
	var st=Math.max(document.body.scrollTop,document.documentElement.scrollTop);
	var sl=Math.max(document.body.scrollLeft,document.documentElement.scrollLeft);
	
	
	dragContentObj.style.left=e.clientX+sl+'px';
	dragContentObj.style.top=e.clientY+st+'px';
	
	if(mouseoverObj)mouseoverObj.className='';
	destinationObj=false;
	dragDropIndicator.style.display='none';
	if(indicateDestinationBox)indicateDestinationBox.style.display='none';
	var x=e.clientX+sl;
	var y=e.clientY+st;
	var width=dragContentObj.offsetWidth;
	var height=dragContentObj.offsetHeight;
	
	var tmpOffsetX=arrow_offsetX;
	var tmpOffsetY=arrow_offsetY;
	if(!document.all){
		tmpOffsetX=arrow_offsetX_firefox;
		tmpOffsetY=arrow_offsetY_firefox;
	}

	for(var no=0;no<ulPositionArray.length;no++){
		var ul_leftPos=ulPositionArray[no]['left'];	
		var ul_topPos=ulPositionArray[no]['top'];	
		var ul_height=ulPositionArray[no]['height'];
		var ul_width=ulPositionArray[no]['width'];
		
		if((x+width) > ul_leftPos && x<(ul_leftPos+ul_width) && (y+height)> ul_topPos && y<(ul_topPos+ul_height)){
			var noExisting=ulPositionArray[no]['obj'].getElementsByTagName('LI').length;
			if(indicateDestinationBox && indicateDestinationBox.parentNode==ulPositionArray[no]['obj'])noExisting--;
			if(noExisting<boxSizeArray[no-1] || no==0){
				dragDropIndicator.style.left=ul_leftPos+tmpOffsetX+'px';
				var subLi=ulPositionArray[no]['obj'].getElementsByTagName('LI');
				
				var clonedItemAllreadyAdded=false;
				if(cloneSourceItems && !cloneAllowDuplicates){
					for(var liIndex=0;liIndex<subLi.length;liIndex++){
						if(contentToBeDragged.id == subLi[liIndex].id)clonedItemAllreadyAdded=true;
					}
					if(clonedItemAllreadyAdded)continue;
				}
				
				for(var liIndex=0;liIndex<subLi.length;liIndex++){
					var tmpTop=getTopPos(subLi[liIndex]);
					if(!indicateDestionationByUseOfArrow){
						if(y<tmpTop){
							destinationObj=subLi[liIndex];
							indicateDestinationBox.style.display='block';
							subLi[liIndex].parentNode.insertBefore(indicateDestinationBox,subLi[liIndex]);
							break;
						}
					}else{							
						if(y<tmpTop){
							destinationObj=subLi[liIndex];
							dragDropIndicator.style.top=tmpTop+tmpOffsetY - Math.round(dragDropIndicator.clientHeight/2)+'px';
							dragDropIndicator.style.display='block';
							break;
						}	
					}					
				}
				
				if(!indicateDestionationByUseOfArrow){
					if(indicateDestinationBox.style.display=='none'){
						indicateDestinationBox.style.display='block';
						ulPositionArray[no]['obj'].appendChild(indicateDestinationBox);
					}
					
				}else{
					if(subLi.length>0 && dragDropIndicator.style.display=='none'){
						dragDropIndicator.style.top=getTopPos(subLi[subLi.length-1])+subLi[subLi.length-1].offsetHeight+tmpOffsetY+'px';
						dragDropIndicator.style.display='block';
					}
					if(subLi.length==0){
						dragDropIndicator.style.top=ul_topPos+arrow_offsetY+'px';
						dragDropIndicator.style.display='block';
					}
				}
				
				if(!destinationObj)destinationObj=ulPositionArray[no]['obj'];
				mouseoverObj=ulPositionArray[no]['obj'].parentNode;
				mouseoverObj.className='mouseover';
				return;
			}
		}
	}
}

/* End dragging 
Put <LI> into a destination or back to where it came from.
*/	
function dragDropEnd(e)
{
	if(dragTimer==-1)return;
	if(dragTimer<10){
		dragTimer=-1;
		return;
	}
	dragTimer=-1;
	if(document.all)e=event;	
	
	if(cloneSourceItems && (!destinationObj || (destinationObj && (destinationObj.id=='allItems' || destinationObj.parentNode.id=='allItems')))){
		contentToBeDragged.parentNode.removeChild(contentToBeDragged);
	}else{	
		
		if(destinationObj){

			if(destinationObj.tagName=='UL'){
				destinationObj.appendChild(contentToBeDragged);
				//alert('depot dans'+destinationObj.id);
				var magsCode=contentToBeDragged.getElementsByTagName('div')[0].id;
				var newname=destinationObj.id+'_'+magsCode;
				var child='document.getElementById("li'+magsCode+ '" )';

				if(window.ActiveXObject)
					contentToBeDragged.getElementsByTagName('a')[0].style.display='inline';
				else
					contentToBeDragged.firstElementChild.children[1].style.display='inline';
				document.getElementById('delete'+magsCode).setAttribute('onClick', 'javascript:deleteChild("' +destinationObj.id +'","'+magsCode+'")');
				contentToBeDragged.getElementsByTagName('input')[0].name=newname;
				
				//creation des elements en hidden dans le formulaire rechercheClientForm
				//afin de les detecter et sauvegarder lors d'une action displaytag
				var divParent=document.getElementById('rechercheClientForm');
				var newInput=document.createElement('input');
				newInput.type='hidden';
				newInput.name=newname;
				newInput.value=magsCode;
				newInput.id='temp_'+magsCode;
				divParent.appendChild(newInput);
				
				
				//l'affichage de l'indicator gene le clic sur l'element image suppression
				//-> on le deplace de 100px pour etre tranquille
				dragDropIndicator.style.top=-1000+'px';
				
			}else{
				destinationObj.parentNode.insertBefore(contentToBeDragged,destinationObj);
			}
			mouseoverObj.className='';
			destinationObj=false;
			dragDropIndicator.style.display='none';
			if(indicateDestinationBox){
				indicateDestinationBox.style.display='none';
				document.body.appendChild(indicateDestinationBox);
			}
			contentToBeDragged=false;
			return;
		}		
		if(contentToBeDragged_next){
			contentToBeDragged_src.insertBefore(contentToBeDragged,contentToBeDragged_next);
		}else{
			contentToBeDragged_src.appendChild(contentToBeDragged);
		}
	}
	contentToBeDragged=false;
	dragDropIndicator.style.display='none';
	if(indicateDestinationBox){
		indicateDestinationBox.style.display='none';
		document.body.appendChild(indicateDestinationBox);
	}
	mouseoverObj=false;
}

function saveDragDropNodes()
{
	var saveString="";
	var uls=dragDropTopContainer.getElementsByTagName('UL');
	for(var no=0;no<uls.length;no++){	// LOoping through all <ul>
		var lis=uls[no].getElementsByTagName('LI');
		for(var no2=0;no2<lis.length;no2++){
			if(saveString.length>0)saveString=saveString+";";
			saveString=saveString+uls[no].id+'|'+lis[no2].id;
		}
	}
	document.getElementById('saveContent').innerHTML='<h1>Ready to save these nodes:</h1> '+saveString.replace(/;/g,';<br>')+'<p>Format: ID of ul |(pipe) ID of li;(semicolon)</p><p>You can put these values into a hidden form fields, post it to the server and explode the submitted value there</p>';
}

function initDragDropScript()
{
	dragContentObj=document.getElementById('dragContent');
	dragDropIndicator=document.getElementById('dragDropIndicator');
	dragDropTopContainer=document.getElementById('dragDropContainer');
	document.documentElement.onselectstart=cancelEvent;
	var listItems=dragDropTopContainer.getElementsByTagName('LI');	// Get array containing all <LI>

	var itemHeight=false;
	for(var no=0;no<listItems.length;no++){
		listItems[no].onmousedown=initDrag;
		listItems[no].onselectstart=cancelEvent;
		if(!itemHeight)itemHeight=listItems[no].offsetHeight;
		if(MSIE && navigatorVersion/1<6){
			listItems[no].style.cursor='hand';
		}			
	}	
	var mainContainer=document.getElementById('mainContainer');
	var uls=mainContainer.getElementsByTagName('UL');
	itemHeight=itemHeight+verticalSpaceBetweenListItems;
	
	var leftContainer=document.getElementById('listOfItems');
	var itemBox=leftContainer.getElementsByTagName('UL')[0];
	
	document.documentElement.onmousemove=moveDragContent;	// Mouse move event - moving draggable div
	document.documentElement.onmouseup=dragDropEnd;	// Mouse move event - moving draggable div
	
	var ulArray=dragDropTopContainer.getElementsByTagName('UL');
	for(var no=0;no<ulArray.length;no++){
		ulPositionArray[no]=new Array();
		ulPositionArray[no]['left']=getLeftPos(ulArray[no]);	
		ulPositionArray[no]['top']=getTopPos(ulArray[no]);	
		ulPositionArray[no]['width']=ulArray[no].offsetWidth;
		ulPositionArray[no]['height']=ulArray[no].clientHeight;
		ulPositionArray[no]['obj']=ulArray[no];
	}
	if(!indicateDestionationByUseOfArrow){
		indicateDestinationBox=document.createElement('LI');
		indicateDestinationBox.id='indicateDestination';
		indicateDestinationBox.style.display='none';
		document.body.appendChild(indicateDestinationBox);
	}
}
function validerBudget(field){
	window.document.budgetForm.submit();
}
function checkDisplaySpecialite(field){
	var complement = document.getElementById('complement');
	if(field.value == 'OPHTALMOLOGISTE'){
		complement.style.display='block';
	}else{
		complement.style.display='none';
	}
}

function checkStateDate(checkbox, idTarget){
	if(checkbox.checked==true){
		document.getElementById(idTarget).value = '';
	}
}

function checkCaVerre(caVerre){
	var oldValue = document.getElementById("oldCaVerre").value;
	var newValue = caVerre.value;
	if(newValue>=oldValue*1.10 || newValue<=oldValue*0.90){
		if(confirm('La nouvelle valeur repr�sente une variation de plus de 10%. Etes-vous de vouloir appliquer cette valeur?')){
			
		}
		else{
			caVerre.value = oldValue;
		}
	}
}

function setDelFournisseur(code){
	//document.forms[1].competitorCodeDelete.value = code;
	document.getElementById('ficheClient_competitorCodeDelete').value=code;
}

function initContactForm(id, prenom, nom, role, info, telephone, email, portailUserName){
	document.getElementById("contactId").value = id;
	document.getElementById("prenom").value = prenom;
	document.getElementById("nom").value = nom;
	document.getElementById("role").value = role;
	document.getElementById("infoperso").value = info;
	document.getElementById("telephone").value = telephone;
	document.getElementById("email").value = email;
	document.getElementById('portailContactUsername').value = portailUserName;
}

function initEservicesForm(code, username){
	document.getElementById('updateCompte').style.display='block';
	document.getElementById('portailCode').value = code;
	document.getElementById('portailUsername').value = username;
}

function consultAvoir(ref){
	//document.getElementById('idreference').value = ref;
	//document.forms[0].submit();
	window.location="/fdv/reclamation/consultAvoir.action?reference=" + ref;
}

function openDocument(id){

	window.open('/fdv/downloadDocument.action?id=' + id, "document", "toolbar=no, location=no, directories=no, status=no, copyhistory=no, width=400, height=400, left=100, top=130");
}

function viewContratVisureal(id){
	window.location="/fdv/client/contratVisurealView.action?id=" + id;
}

function vr_ajax_periode(dateDebut) {
	//patienterLight('Mise a jour des donnees');
	$.ajax({
		type: "POST",
		url: "client/contratVisurealAjax.action",
		data: "dateDebut=" + dateDebut.value,
		async:false,
		dataType: "xml",
		complete: function(data, status){
			xmlToContrat(data);}
	});
	//patienterDone();
}

function vr_ajax_caDemande(caDemande) {
	//patienterLight('Mise à jour des données');
	$.ajax({
		type: "POST",
		url: "client/contratVisurealAjax.action",
		data: "caDemande=" + caDemande.value,
		async:false,
		dataType: "xml",
		complete: function(data, status){
			xmlToContrat(data);
		}
	});
	//patienterDone();
}

function vr_ajax_signataire(field, type) {
	//patienterLight('Mise à jour des données');
	$.ajax({
		type: "POST",
		url: "client/contratVisurealAjax.action",
		data: type + "=" + field.value,
		async:false,
		dataType: "xml",
		complete: function(data, status){
			xmlToContrat(data);
		}
	});
	//patienterDone();
}

function xmlToContrat(dataxml){
	var contrat = dataxml.responseText;
	$(contrat).find('contrat').each(
			function(){
				var caDemande = $(this).find('caDemande').text();
				var progression = $(this).find('progression').text();
				var caRedresse = $(this).find('caRedresse').text();
				var caRealise = $(this).find('caRealise').text();
				var dateDebut = $(this).find('datedebut').text();
				var dateFin = $(this).find('datefin').text();
				var part =  $(this).find('partMarche').text();
				var nom =  $(this).find('nomSignataire').text();
				var prenom =  $(this).find('prenomSignataire').text();
				//var caMiniPADAir = $(this).find('caMiniPADAir').text();
				//var margeInvestissement = $(this).find('margeInvestis').text();
				var categorie = $(this).find('categorie').text();
				
				if(categorie!='STD_VRP' && categorie!='LYNX_VRP' && categorie!='AUCHAN_VRP'){
					//table article
					var rowsArt = window.document.getElementById('displayTableArticle').getElementsByTagName('tbody')[0].getElementsByTagName('tr');
//					if(caMiniPADAir!=null && !caMiniPADAir==''){
//						// objectif pas assez eleve pour debloquer l'ipad air
//						document.getElementById('caManquantiPADAir').innerHTML='le ratio marge/investissement : '+ margeInvestissement +'<br/> 1500 &euro; minimum pour autoriser l\'iPad Air<br/>Montant objectif minimum: ' + caMiniPADAir;
//						document.getElementById('contrat.articleList[4].quantiteDemande').setAttribute('readonly','readonly');
//						document.getElementById('contrat.articleList[4].quantiteDemande').value='0';
//						rowsArt[4].className = 'odd textBarre';//ligne ipad air barre
//					} else {
						// on autorise l'ipad air
//						document.getElementById('contrat.articleList[4].quantiteDemande').removeAttribute('readonly');
//						document.getElementById('caManquantiPADAir').innerHTML='';
//						rowsArt[4].className = 'odd';//ligne ipad air non barre
//					}
			}
				
				$(this).find('echeancier').find('ligne').each(
						function(typeObjectif) {
							var libelle = $(this).find('libelle').text();
							var libelleComplement = $(this).find('libelleComplement').text();
							var caObjectif = $(this).find('caObjectif').text();
							var caRedresse = $(this).find('lcaRedresse').text();
							var caProgression = $(this).find('lprogression').text();
							var montantAvoir = $(this).find('montantAvoir').text();
							var typeObjectif = $(this).find('typeObjectif').text();
							if(typeObjectif=='euro')
								typeObjectif = "&euro;";
							var index = $(this).find('index').text();
							
							if(libelle!='') {
								var rows = window.document.getElementById('displayTableEch').getElementsByTagName('tbody')[0].getElementsByTagName('tr');
								rows[index].getElementsByTagName('td')[1].innerHTML = libelleComplement;
								rows[index].getElementsByTagName('td')[2].innerHTML = caRedresse + '&nbsp;&euro;';
								rows[index].getElementsByTagName('td')[4].innerHTML = caProgression + '&nbsp;%';
								rows[index].getElementsByTagName('td')[5].innerHTML = montantAvoir + '&nbsp;&euro;';
								if(libelle=='Annuelle'){
									rows[index].getElementsByTagName('td')[3].innerHTML = caObjectif + '&nbsp;' + typeObjectif;
								}
							}
						}
				);
				
				
				$(this).find('echeancierAdditionnel').each(
						function() {
							var caAdditionnel = $(this).find('caAdditionnel').text();
							var margeAdditionnel = $(this).find('margeAdditionnel').text();
							var rapportCaAdditionnel = $(this).find('rapportCaAdditionnel').text();
							var investissement = $(this).find('investissement').text();
							var margeInvestissement = $(this).find('margeInvestissement').text();
							var margeInvestissementPourcent = $(this).find('margeInvestissementPourcent').text();
							var rapportInvestissementCa = $(this).find('rapportInvestissementCa').text();

							if(document.getElementById('caAdditionnel')!=null) {
								document.getElementById('caAdditionnel').innerHTML = caAdditionnel + '&nbsp;&euro;';
								document.getElementById('margeAdditionnel').innerHTML = margeAdditionnel + '&nbsp;&euro;';
								document.getElementById('rapportCaAdditionnel').innerHTML = rapportCaAdditionnel + '&nbsp;&euro;';
								document.getElementById('investissement').innerHTML = investissement + '&nbsp;&euro;';
								document.getElementById('margeInvestissement').innerHTML = margeInvestissement + '&nbsp;&euro;';
								document.getElementById('margeInvestissementPourcent').innerHTML = margeInvestissementPourcent + '&nbsp;%';
								document.getElementById('rapportInvestissementCa').innerHTML = rapportInvestissementCa + '&nbsp;%';
							}
						}
				);
				document.getElementById('contrat.dateDebut').value=dateDebut;
				document.getElementById('contrat.dateFin').innerHTML=dateFin;
				document.getElementById('caobjectif').innerHTML = caDemande + '&nbsp;&euro;';
				document.getElementById('caRealise').innerHTML = caRealise + '&nbsp;&euro;';
				document.getElementById('caRedresse').innerHTML = caRedresse + '&nbsp;&euro;';
				if(document.getElementById('contratVisureal_contrat_ech_caObjectif')!=null) {
					document.getElementById('contratVisureal_contrat_ech_caObjectif').value = caDemande;
				}
				document.getElementById('progression').innerHTML = progression + '&nbsp;%';
				document.getElementById('partMarche').innerHTML = part;
				//seuls les RS on un champ input sur les champs suivants
				try {
					document.getElementById('nomSignataire').value=nom;
					document.getElementById('prenomSignataire').value=prenom;
				} catch (e) {
				}
			}
	);
}


function loadEquipement(index) {
	
	$.ajax({
		type: "POST",
		url: "client/loadEquipementAjax.action",
		data: "index=" + index,
		async:false,
		dataType: "xml",
		complete: function(data, status){
			xmlToEquipementView(data);
		}
	});
	document.getElementById('detailInstrument').style.display='block';
}

function xmlToEquipementView(dataxml) {
	var xml = $(dataxml.responseXML).find('MagasinInstrument');
	var contrat = $(xml).find('Contrat');
	document.getElementById('reference').innerHTML = contrat.find("ref").text();
	document.getElementById('dateEmission').innerHTML = getFormattedDateFromXmlData(contrat.find("dateEmission").text());
	document.getElementById('dateReception').innerHTML = getFormattedDateFromXmlData(contrat.find("dateReception").text());
	document.getElementById('dateDebut').innerHTML = getFormattedDateFromXmlData(contrat.find("dateDebut").text());
	document.getElementById('dateFin').innerHTML = getFormattedDateFromXmlData(contrat.find("dateFin").text());
	document.getElementById('usrcrt').innerHTML = contrat.find("usrcrt").text();
	document.getElementById('contratEtat').innerHTML = contratEtatLibelle(contrat.find("contratEtat").text());
	document.getElementById('serialNo').innerHTML = xml.find("serialNo").text();
}

function getFormattedDateFromXmlData(dateIn) {
	if(dateIn==null)
		return '';
	if(dateIn.length<10)
		return '';
	var day = dateIn.substring(8, 10);
	var month = dateIn.substring(5,7);
	var year = dateIn.substring(0,4);
	return day + '/' + month + '/' + year;
}
function contratEtatLibelle(code) {
	var libelle = '';
	if(code=='APP') libelle = 'Approuv�';
	if(code=='EMI') libelle = 'Emis';
	if(code=='OLD_TR') libelle = 'Ancien traceur';
	
	return libelle;
}
function avoirCheckMagsCode(field){
	var niveau = document.getElementById('creationAvoir_avoir_avoir_niveau').value;
	if(niveau=='MAGASIN') {
		$.ajax({
			type: "POST",
			url: "avoirCheckMagasinAjax.action",
			data: "magsCode=" + field.value,
			async:false,
			dataType: "xml",
			complete: function(data, status){
				xmlCheckAvoirMagasinSecteur(data);
			}
		});
	}
}
function xmlCheckAvoirMagasinSecteur(dataxml) {
	var xml = $(dataxml.responseXML).find('ctrl');
	var status = $(xml).find('status').text();
	var nom = $(xml).find('nom').text();
	document.getElementById('nomClient').innerHTML = nom;
	document.getElementById('errorList').innerHTML='';

	if('ERROR'==status) {
		$(xml).find('errorList').find('error').each(
				function(){
					var zone = document.getElementById('errorList');
					zone.innerHTML += $(this).text() + '</br>';
				});
	}
}

function formationSelect(field){
	if(field.value=='5'){
		$("div#formation").fadeIn("slow");
	}else{
		$("div#formation").fadeOut();
	}
}

function visiteToFormationSession(id, idVisite){
	window.location = "/fdv/client/initSessionFormation.action?fsId=" + id + "&idVisite="+idVisite;
}

function formationSessionToVisite(id, magsCode){
	window.location="/fdv/visite/ficheVisite.action?idVisite="+id+"&codeClient="+magsCode
}

function lanceStatistique(formID, mode){
	document.getElementById('mode').value=mode;
	var form = document.getElementById(formID);
	var button = document.getElementById(formID+'__search');
	button.click();
}