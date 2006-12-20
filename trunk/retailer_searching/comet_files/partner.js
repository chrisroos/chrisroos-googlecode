// get the key value pairs from the query string

var qsParm = new Array();

function qs() {
var query = window.location.search.substring(1);
var parms = query.split('&');
for (var i=0; i<parms.length; i++) {
   var pos = parms[i].indexOf('=');
   if (pos > 0) {
      var key = parms[i].substring(0,pos);
      var val = parms[i].substring(pos+1);
      qsParm[key] = val;
      }
   }
}

// set the array field to pick up cm_ven field from the query string
qsParm["cm_ven"] = null;
qs();

// finishing getting key value pairs from the query string



// function to create a cookie

function createCookie(name,value,days)
{
//alert("1");
	if (days)
	{
	//alert("2");
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();

	}
	else var expires = "";
	//alert("host=" + host);
	
	if(host == "www.comet.co.uk") {
	
		document.cookie = name+"="+value+expires+"; path=/; domain=comet.co.uk; false";
	}
	else {
		document.cookie = name+"="+value+expires+"; path=/; false";
	}
	//alert("Cookie expires=" + expires);
}


// set the partnerName value from the query string array

partnerName=qsParm["cm_ven"];

// if the partner name is not null create a cookie to expire in 30 days

if (partnerName) {
	//alert("create cookie, partner name=" + partnerName);
	createCookie("cm_ven", partnerName, 30);
}


// this function is currently not used
function eraseCookie(name)
{
	createCookie(name,"",-1);
}