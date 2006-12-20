//might be useful to add a boolean to say whether swap should involve visibility or display property
function swapElementDisplay(Elem1,Elem2){
	elem1=document.getElementById(Elem1);
	elem2=document.getElementById(Elem2);

	if(elem1 && elem2){
		elem1.style.display="block";
		elem2.style.display="none";
	}
}


// set up the host name to redirect to secure
host=window.location.host;
secureHost = "";
cometHost = "";

if (host == "www.comet.co.uk") {
	secureHost= "https://secure.comet.co.uk";
} else if (host == "ev2origin.ekingfisher.com") {
	secureHost = "https://ev2secure.ekingfisher.com";
} else if (host == "test.comet.co.uk") {
	secureHost = "https://ev2secure.ekingfisher.com";
} else {
	secureHost= "https://" + host;
}

if (host == "secure.comet.co.uk") {
	cometHost = "http://www.comet.co.uk";
} else if (host == "ev2secure.ekingfisher.com") {
	cometHost = "http://ev2origin.ekingfisher.com";
} else {
	cometHost= "http://" + host;
}

if (host == "preview.multimap.com" || host == "www.multimap.com") {
	secureHost= "https://secure.comet.co.uk";
	cometHost = "http://www.comet.co.uk";
}


function changecolor (ID,nOptions) {
var elem = document.getElementById('option'+ID);            
elem.className = "orange";
 for (i=1;i<=nOptions;i++)
 {
    if (i!=ID)
    {
      var elem = document.getElementById('option'+i); 
      elem.className = "grey70";
    }
 }
} 


/*
button behavoir set up on mouseover e.g. onmouseover="hoverButton(this.id, 'off', 'search')"
styles in general.css - now obsolete but left for legacy in case any hover function calls remain 
- these should be removed from the html as they are no longer needed
*/

function hoverButton(id, state, button) {
	if(document.getElementById) { // check for presence of method used
		if(state == "on") {
			document.getElementById(id).src = "/comet/ev2/images/buttons/" + button + "_on.gif"
		} else if (state == "off") {
			document.getElementById(id).src = "/comet/ev2/images/buttons/" + button + "_off.gif"
		}
	}
}

/* unobtrusive javascript input rollovers from http://www.onlinetools.org/articles/unobtrusivejavascript/chapter2.html
	instead of attaching the event in the html, we attach it here.
	in this way the html code is kept clean of javascript "onmouseover" etc
	and we attain a good separation of style (rollovers) and content (buttons)	
	also it degrades gracefully with no errors in the case of a user not having javascript enabled
*/

function findimg() {
	var inputs, i;
	// loop through all inputs of the document 
	inputs=document.getElementsByTagName('input');
	for(i=0;i<inputs.length;i++) {
		// test if the class 'button' exists 
		if(/button/.test(inputs[i].className)) {
			// add the function roll to the image onmouseover and onmouseout and send 
			// the image itself as an object 
		   inputs[i].onmouseover=function(){roll(this);};
		   inputs[i].onmouseout=function(){roll(this);};
		}
	}
}

function roll(o) {
	var src, ftype, newsrc;
	// get the src of the image, and find out the file extension 
	src = o.src;
	ftype = src.substring(src.lastIndexOf('.'), src.length);
	// check if the src already has an _on and replace with _off, if that is the case  
	if(/_on/.test(src)) {
		newsrc = src.replace('_on','_off');
	} else {
		// else, the button is in the off state, replace "_off" with "_on"  to hover.
		newsrc = src.replace("_off", "_on");
	}
	o.src=newsrc;
}


/* global function to clear display text from form fields 
	use like so: 
	onfocus="clearDefaultText(this.value, this)"
	onfocus is a device independent event handler for accessibility
	in this way we keep the html free from javascript 
	and if the default text changes we do not need to change the html (except for the default value!)
*/

function clearDefaultText(defaultText, el) {
	if(el.value == defaultText) {
		el.value = "";
	}
}


/*
Display/hide elements by swapping classes
*/


function switchOff (headerID) { 
var elem = document.getElementById(headerID);            
elem.className = "off"; 
} 

function switchOn (headerID) { 
var elem = document.getElementById(headerID); 
elem.className = "on";
}


/* Cookie functions  
	use as follows:
	setCookie("name", "value", "optional_var", optional_var);
	var myCookie = getCookie("name_of_cookie");
*/ 

function setCookie(name, value, expires, path, domain, secure) {
	//alert("name: " + name + " value: " + value);
    document.cookie= name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires.toGMTString() : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}

function getCookie(name) {
    var dc = document.cookie;
    var prefix = name + "=";
    var begin = dc.indexOf("; " + prefix);

    if (begin == -1) {
        begin = dc.indexOf(prefix);
        if (begin != 0) return null;
    } else {
        begin += 2;
    }

    var end = document.cookie.indexOf(";", begin);

    if (end == -1) {
        end = dc.length;
    }
    return unescape(dc.substring(begin + prefix.length, end));
}



/* keep window.onload at the bottom of the script  
	so that we will always have all functions loaded before this is called
*/
window.onload=function(){findimg();}
/* 
  This function is triggered when search button in the topbar is clicked		
*/
function go() {
   var searchBoxValue;
   var searchValueToValidate;

   searchBoxValue = escape(document.search.searchfield.value);
   searchBoxValueToValidate=trim(searchBoxValue);	

	if ((searchBoxValueToValidate=="") || (searchBoxValueToValidate=="e.g. Plasma TV"))
	{
		alert('The search box is empty - please enter a keyword or product code to continue.');
	}
	else
	{
   		location.href = cometHost + "/cometbrowse/search.do?n=0&searchTerm=" +searchBoxValue 
   	}
}
  
/* 
  To trim the  field
*/

function trim(a){
	var nonSpace=false;
	a = unescape(a);

	for(j=0;j<a.length;j++)
	{
		if(a.charAt(j)!=' ')
		{
			nonSpace=true;
		}
	}
	if (nonSpace==false)
	{
		a=""
	}
	return a;
}


/* code for popup windows */

/*STATIC win object references. Do not reassign*/
var CIC_WIN = {name:"cic_win",options:"width=600,height=300,scrollbars,resizable"};
var CIC_WIN_L = {name:"cic_winbig",options:"width=500,height=420,scrollbars,resizable"};
var WIN = {name:"comet_win",options:"width=550,height=580,scrollbars"}
var WIN_S = {name:"comet_win_small",options:"width=580,height=250,scrollbars"};
var WIN_M = {name:"winmedium",options:"width=550,height=400,scrollbars"};
var WIN_M_RESIZE = {name:"winmedium",options:"width=600,height=500,scrollbars,resizable"};
var MYC_HELP = {name:"comet_mychelp",options:"width=570,height=580,scrollbars,resizable"};
var MYCOMET_FORGOTTEN_PASSWORD_WIN = {name:"comet_win",options:"width=550,height=280"};

function win(url,windowType){

	newwin = window.open(url,windowType.name,windowType.options);
	newwin.focus();
	
	return false;
}

/* end code for popup windows */


// (Used in checkout - copied from checkout.js)
function getRadioValue(radio) {

	if (radio.length == null) {
	    if(radio.checked == true)
		return true;
	    else
		return false;
	}

	for (index=0; index<radio.length; index++) {
	   if (radio[index].checked == true) {
		return true;

	   }
	}

	return false;
}


// (Used by checkout)
function getRadioName(radio) {
var vName = 'noConnection';


	for (index=0; index<radio.length; index++) {
	   if (radio[index].checked == true) {
		vName = radio[index].value ;

	   }
	}

	return vName;
}


// Return true if in web mode - whether we should display web price etc.
//
// Note:
// We can not tell the difference between web users and internal users acting as web users, because
// the 'usertype' cookie also gets set to 'N' for external users when they click 'make further selections' on 
// the basket page. If this was fixed, we could check for usertype = 'null', meaning that they are an external web user.
//
// Author: Chris Cook 4/7/05
// (Used in checkout)
function isWebMode() {
	var webMode = true;
	var cookieprice = getCookie("mainprice");
	if (cookieprice != null && cookieprice == "National") {
		// CIC / store user or manager who wants to see 'national' price
		webMode = false;
	}
	return webMode;
}

// Return true if this is a store user.
// Author: Chris Cook 4/7/05
// (Used in checkout)
function isStoreMode() {
	var usertype = getCookie("usertype");
	if (usertype == "ST") {
		return true;
	} else {
		return false;
	}
}

// Return true if this is an internal (CIC) sales user.
// Author: Chris Cook 4/7/05
// (Used in checkout)
function isSalesMode() {
	var usertype = getCookie("usertype");
	if (usertype == "S") {
		return true;
	} else {
		return false;
	}
}

// Remove 'http://www.comet.co.uk' from front of url
// Need to remove this for running locally - full domain needs to be in the href in case they have js switched off
// (Used in checkout)
function removeDomain(url,windowType){
	var returnUrl = url;
	if (url.indexOf("http://www.comet.co.uk") >= 0) {
		returnUrl = url.substr(22);
	}
	return returnUrl;
}


// Open a window containing a page from the non-secure (browse) part of the site
// (Used in checkout)
function winNonSec(url,windowType){
	url = removeDomain(url);
	return win(cometHost + url, windowType);
}

// Forward to another page on the non-secure (browse) part of the site
// (Used in checkout)
function forwardNonSec(url){
	url = removeDomain(url);
	top.location.replace(cometHost + url);
	return false;
}

// Forward to another page
// (Used in checkout)
function openStoreFinder(url){
	if (isSalesMode() || isStoreMode())	{
		win(url,CIC_WIN_L);
	} else {
		top.location.replace(url);
	}
	return false;
}

// Set up the host name to redirect to secure
function getSecureHost() {
	return secureHost;
}

// Function for forwarding out of the secure area of the site
function getNonSecureHost() {
	return cometHost;
}

function isValidEmailAddress(myString) {
	
		var result = false;
		
		if (myString) {
			var aEmail = myString.split('@');
			
			if (aEmail.length == 2) {
				var aaEmail = aEmail[1].split('.');
				
				if (aaEmail.length >= 2) {
					if ( !myString.match(/\(|\)|&#60;|&#62;|,|;|:|\\|\"|\[|\]|\s/) ) // check there are no illegal characters in the email address
					{
						result = true;
					}
				}
			}
		}
		
		return result;
}
	
function sendEmail(inForm)	{

		if (!isValidEmailAddress(inForm.recipientEmail.value))
		{
			alert('You have not entered a valid email address to send the email to');
		}
		else if (!isValidEmailAddress(inForm.senderEmail.value))
		{
			alert('Your own email address is not valid');
		}
		else
		{
			inForm.submit();
		}
}

function linkToBasket() {
	top.window.location.href = secureHost + "/webapp/wcs/stores/servlet/CometOrderItemDisplay?langId=-1&storeId=10001&catalogId=10001&orderId=.";
}


//linked to named anchor <a name="foo"> on the page
function gotoNamedAnchor(anchorName){
	if(document.location.href.indexOf("#")==-1){
		document.location+="#"+anchorName;
	}else{
		url=document.location.href.substring( 0,document.location.href.indexOf("#") )+"#"+anchorName;
		window.location.href=url;
	}
}

// This function adds a single item to the wish list

function AddToWishList(sku) {
	
	url = secureHost + '/webapp/wcs/stores/servlet/AddToWishList?storeId=10001&sku=' + sku; 
	window.location = url;
	
}


// This function goes to the login page for my comet.

function Login() {

	url = secureHost + '/webapp/wcs/stores/servlet/MyCometLoginView?storeId=10001'; 
	window.location = url;
	
}

// This function logs the user out of my comet.

function Logout() {

	url = secureHost + '/webapp/wcs/stores/servlet/MyCometLogout'; 
	window.location = url;
	
}

// This function adds a single item to the wish list

function GoToWishList() {

	url = secureHost + '/webapp/wcs/stores/servlet/MyWishList?storeId=10001'; 
	window.location = url;
	
}

// This function allows the CIC to start a new customer
function NewCustomer() {
	location.href = secureHost + "/webapp/wcs/stores/servlet/TeleSalesSearchOptonView" 
}

// This function allows the CIC to log out
function LogOut() {
	location.href = secureHost + "/webapp/wcs/stores/servlet/Logoff?page=logoff&URL=/webapp/wcs/stores/servlet/CometCICMenu" 
}


// Reevoo link
function openReevoo(urlId){
	url = "http://www.revieworld.com/affiliate/reviews/CMT?id=" + urlId;
	window.open(url,"reevoo","scrollbars=yes,menubar=no,location=no,resizeable=no,status=no,toolbar=no,dependent=yes,width=424,height=645,left=100,top=100"); 
}

// Third party function to output the commercial team email address in an 
// encoded form to avoid spam. Uses 'hiveware encoder' http://automaticlabs.com/products/enkoderform/
// Moved here by Chris Cook 4/7/05
function outputCommercialEmail(){var kode=
"kode=\"oked\\\"=rnhg%@nrgh%_n@gr_h_%u_k@(qjjiCsut{4kxzz}(ogknbk.&B__Cxblb("+
"gbrsuo}zh@uksixsokrikguFki4suzbisbbDy(xBtzDusmoK&gnr&zuksixsokrizgg&Bkysx5"+
"tzDu5mDB/g(b(A~A-CA-ul.xCoA6Boq.ju4kkrmtnz73A/1o8C\\\\/00~1C1uqkji4gnGx.z1"+
"o/7q1ju4knixgzGo._/3__3u_k3~q.jBCu1korqtjz4EkumkniqgjG4.nuxkzrqtjz43k/m-n/"+
"7_@-__A>%@{**i>url+3@l>n?gr1hhojqkwl>..~,@frnhgf1dkFugrDh+w,l60l>+i?f,3.f4"+
"@;5{>@.wVlujqi1ruFpdkFugr+h,f0\\\\00rnhg{@_>@%*{i*u>lr3+l@+>r?hnogq1wh0j,k"+
"l4@>,.{5@~r.hnfgd1Dk+u.w,ln4g.1rkhufwdlD\\\\+00,0nrgh@{.+l?nrgh1ohqjwkBnrg"+
"h1fkduDw+nrgh1ohqjwk04,=**,%>{>*@>*ri+u@l>3?ln+gr1hhojqkw40>,.l5@~,.{n@gr1"+
"hkfudwDl+4..,rnhgf1dkDu+w,l0\\\\00rnhg{@+.?lrnhgo1qhwjBkrnhgf1dkDu+wrnhgo1"+
"qhwj0k,4*=,*\\\">x;'=;'of(r=i;0<iokedl.netg;h+i)+c{k=do.ehcraoCedtAi(-);3f"+
"ic(0<c)=+21;8+xS=rtni.grfmohCraoCedc(})okedx=\";x='';for(i=0;i<(kode.lengt"+
"h-1);i+=2){x+=kode.charAt(i+1)+kode.charAt(i)}kode=x+(i<kode.length?kode.c"+
"harAt(kode.length-1):'');"
;var i,c,x;while(eval(kode));}


//added for mycomet links dynamic population
function  onLoadCallWithRecentlyViewedProductsBox(id){
	drawRecentlyViewedProductsBox(id);
    drawMyCometLoginLink();	
}

function  onLoadCallWithProductPackagePageInit(){
	productPackagePageInit();
    drawMyCometLoginLink();	
}

function  onLoadCallWithSetupAddToBasket(){
	setupAddToBasket();
    drawMyCometLoginLink();	
}

function  onLoadCallWithAdvancedSearchInit(){
	advancedSearchInit();
    drawMyCometLoginLink();	
}

function  onLoadCallFunction(){
    drawMyCometLoginLink();	
}

// This function is for the giftfinder box which is used by content.
function submitGiftFinder() {

	giftFinderURL = '/cometbrowse/giftFinder.do?&n=601';


	if (document.giftfinder.agegroup.value && document.giftfinder.agegroup.value != "nopreference") {

		giftFinderURL =  giftFinderURL + "\+" + document.giftfinder.agegroup.value;
	}

	if (document.giftfinder.budget.value && document.giftfinder.budget.value != "nopreference") {

		giftFinderURL =  giftFinderURL + "\+" + document.giftfinder.budget.value;
	}

	if (document.giftfinder.who.value && document.giftfinder.who.value != "nopreference") {

		giftFinderURL =  giftFinderURL + "\+" + document.giftfinder.who.value;
	}

	if (document.giftfinder.budgetamount.value && document.giftfinder.budgetamount.value != "nopreference") {

		giftFinderURL =  giftFinderURL + "\+" + document.giftfinder.budgetamount.value;
	}

	//alert(giftFinderURL);
	location.href = cometHost + giftFinderURL;
}



