<!--
/*
 * cmdatatagutils.js
 *
 * Coremetrics Tag v4.0, 4/18/2004
 * COPYRIGHT 1999-2002 COREMETRICS, INC. 
 * ALL RIGHTS RESERVED. U.S.PATENT PENDING
 *
 * The following functions aid in the creation of Coremetrics data tags.
 *
 */

// TAG GENERATING FUNCTIONS ---------------------------------------------------


/*
 * Calling this function points tags to the production database
 */
function cmSetProduction(){
	cm_HOST="ww2.comet.co.uk/eluminate?"; 
}

/*
 * Creates a Tech Props tag.
 * pageID		: required. Page ID to set on this Pageview tag
 */
function cmCreateTechPropsTag(pageID, categoryID) {

	if(pageID == null) {
		pageID = cmGetDefaultPageID();
	}

	var cm=new _cm("tid", "6", "vn2", "e4.0");
	cm.pc="Y";
	cm.pi = pageID;
	cm.cg = categoryID;

	

	cm.rf = removeKryptoParameter(document.referrer); 

    cm.ul = removeKryptoParameter(window.location.href);

	// if available, override the referrer with the frameset referrer
	if (parent.cm_ref != null) {
		cm.rf = parent.cm_ref;
		parent.cm_ref = document.URL;
	}

	// if parent had mmc variables and this is the first pageview, add mmc to this url
	if(parent.cm_set_mmc) {
		cm.ul = document.location.href + 
				((document.location.href.indexOf("?") < 0) ? "?" : "&") + 
				parent.cm_mmc_params; 
		parent.cm_ref = cm.ul;
		parent.cm_set_mmc = false;
	}

	cm.addTP();
	cm.writeImg();
	
}
/*
 * Creates a Pageview tag with the given Page ID
 *
 * pageID	: required. Page ID to set on this Pageview tag
 * categoryID	: optional. Category ID to set on this Pageview tag
 * searchString	: optional. Internal search string enterred by user to reach
 *				  this page.
 *
 * returns nothing, causes a document.write of an image request for this tag.
 */
function cmCreatePageviewTag(pageID, categoryID, searchString, searchResults) {
	if (pageID == null) {
		pageID = cmGetDefaultPageID();
	}

	var cm = new _cm("tid", "1", "vn2", "e4.0");
	cm.pi = pageID;
	if (searchString) {
		cm.se = searchString;
	}
	cm.sr = searchResults;
	if (categoryID) {
		cm.cg = categoryID;
	}

	cm.rf = removeKryptoParameter(document.referrer); 

    cm.ul = removeKryptoParameter(window.location.href);

	// if available, override the referrer with the frameset referrer
	if (parent.cm_ref != null) {
		cm.rf = parent.cm_ref;
		parent.cm_ref = document.URL;
	}

	// if parent had mmc variables and this is the first pageview, add mmc to this url
	if(parent.cm_set_mmc) {
		cm.ul = document.location.href + 
				((document.location.href.indexOf("?") < 0) ? "?" : "&") + 
				parent.cm_mmc_params; 
		parent.cm_ref = cm.ul;
		parent.cm_set_mmc = false;
	}

	cm.writeImg();
}

/*
 * Creates a Pageview tag with the default value for Page ID. 
 * Format of Page ID is "x/y/z/MyPage.asp"
 *
 * returns nothing, causes a document.write of an image request for this tag.
 */
function cmCreateDefaultPageviewTag(categoryID) {
	cmCreatePageviewTag(cmGetDefaultPageID(), categoryID, null);
}

/*
 * Creates a Productview Tag
 * Also creates a Pageview Tag by setting pc="Y"
 * Format of Page ID is "PRODUCT: <Product Name> (<Product ID>)"
 *
 * productID	: required. Product ID to set on this Productview tag
 * productName	: required. Product Name to set on this Productview tag
 * categoryID	: optional. Category ID to set on this Productview tag 
 *
 * returns nothing, causes a document.write of an image request for this tag.
 */
function cmCreateProductviewTag(productID, productName, categoryID) {
	var cm = new _cm("tid", "5", "vn2", "e4.0");

	if (productName == null) {
		productName = "";
	}

	cm.rf = removeKryptoParameter(document.referrer); 

    cm.ul = removeKryptoParameter(window.location.href);


	// if available, override the referrer with the frameset referrer
	if (parent.cm_ref != null) {
		cm.rf = parent.cm_ref;
		parent.cm_ref = document.URL;
	}

	// if parent had mmc variables and this is the first pageview, add mmc to this url
	if(parent.cm_set_mmc) {
		cm.ul = document.location.href + 
				((document.location.href.indexOf("?") < 0) ? "?" : "&") + 
				parent.cm_mmc_params; 
		parent.cm_ref = cm.ul;
		parent.cm_set_mmc = false;
	}

	cm.pr = productID;
	cm.pm = productName;
	cm.cg = categoryID;

	cm.pc = "Y";
	cm.pi = "PRODUCT: " + productName + " (" + productID + ")";

	cm.writeImg();
}

/*
 * Variables and Arrays to support Lineitem Aggregation
 */

var cmShopProducts = new Array();
var cmShopIds = new Array();
var cmShopCats = new Array();
var cmShopQtys = new Array();
var cmShopPrices = new Array();
var cmShopCounter = 0;
var cmShopOrderIds = new Array();
var cmShopCustomerIds = new Array();
var cmShopOrderPrices = new Array();
var cmShopSKUs = "";

/* Internal, to support aggregation */
function cmGetProductIndex(id){
	var i =0;
	for (i=0; i<cmShopCounter; i++)
	{
		if (id==cmShopIds[i])
		{
			return i;
		}
	}
	return -1;
}

/*
 * Creates a Shop tag with Action 5 (Shopping Cart)
 *
 * productID	: required. Product ID to set on this Shop tag
 * quantity	: required. Quantity to set on this Shop tag
 * productPrice	: required. Price of one unit of this product
 * categoryID	: optional. Category to set on this Shop tag
 *
 * returns nothing, causes a document.write of an image request for this tag.
 */
function cmCreateShopAction5Tag(productID, productName, productQuantity, productPrice, categoryID) {

	productID = productID.toUpperCase();

	var index = cmGetProductIndex(productID);
	if(index!=-1){
		var oldPrice = cmShopPrices[index];
		var oldQty = cmShopQtys[index];
		var newQty = oldQty + parseInt(productQuantity);
		var newPrice = (oldPrice*oldQty + parseInt(productQuantity)*parseFloat(productPrice))/(newQty);

		cmShopPrices[index] = newPrice;
		cmShopQtys[index] = newQty;
	} else {
		if (!categoryID) {
			categoryID = "";
		}

		cmShopProducts[cmShopCounter] = productName;
		cmShopIds[cmShopCounter] = productID;
		cmShopCats[cmShopCounter] = categoryID;
		cmShopQtys[cmShopCounter] = parseInt(productQuantity);
		cmShopPrices[cmShopCounter] = parseFloat(productPrice);
		cmShopCounter++;

	}

	cmShopSKUs = cmGetOSK();

}

/* render the aggregated cart lineitems with Shop 5 tags*/
function cmDisplayShop5s(){
	var i;
	for(i=0; i<cmShopCounter;i++){
		var cm = new _cm("tid", "4", "vn2", "e4.0");
		cm.at = "5";
		cm.pr = cmShopIds[i]; 
		cm.pm = cmShopProducts[i];
		cm.cg = cmShopCats[i];
		cm.qt = cmShopQtys[i] ;
		cm.bp = cmShopPrices[i];
		cm.pc = "N";

	cm.rf = removeKryptoParameter(document.referrer); 

    cm.ul = removeKryptoParameter(window.location.href);

		cm.writeImg();
	}
	cmShopSKUs = cmGetOSK();

	cmShopCounter=0;
}

/*
 * Creates a Shop tag with Action 9 (Order Receipt / Confirmed)
 *
 * productID	: required. Product ID to set on this Shop tag
 * productName	: required. Product Name to set on this Shop tag
 * quantity	: required. Quantity to set on this Shop tag
 * productPrice	: required. Price of one unit of this product
 * customerID	: required. ID of customer making the purchase
 * orderID	: required. ID of order this lineitem belongs to
 * orderTotal	: required. Total price of order this lineitem belongs to
 * categoryID	: optional. Category to set on this Shop tag
 *
 * returns nothing, causes a document.write of an image request for this tag.
 */
function cmCreateShopAction9Tag(productID, productName, productQuantity,
				productPrice, customerID, orderID,
				orderTotal, categoryID) {

	productID = productID.toUpperCase();

	var index = cmGetProductIndex(productID);
	if(index!=-1){
		var oldPrice = cmShopPrices[index];
		var oldQty = cmShopQtys[index];
		var newQty = oldQty + parseInt(productQuantity);
		var newPrice = (oldPrice*oldQty + parseInt(productQuantity)*parseFloat(productPrice))/(newQty);

		cmShopPrices[index] = newPrice;
		cmShopQtys[index] = newQty;
	} else {
		if (!categoryID) {
			categoryID = "";
		}
		cmShopProducts[cmShopCounter] = productName;
		cmShopIds[cmShopCounter] = productID;			
		cmShopOrderIds[cmShopCounter] = orderID;
		cmShopOrderPrices[cmShopCounter] = orderTotal;
		cmShopCustomerIds[cmShopCounter] = customerID;
		cmShopCats[cmShopCounter] = categoryID;
		cmShopQtys[cmShopCounter] = parseInt(productQuantity);
		cmShopPrices[cmShopCounter] = parseFloat(productPrice);
		cmShopQtys[index] = newQty;
		cmShopCounter++;
	}
	cmShopSKUs = cmGetOSK();

}


/* render the aggregated order lineitems with Shop 9 tags*/
function cmDisplayShop9s(){
	var i;
	for(i=0; i<cmShopCounter;i++){
		var cm = new _cm("tid", "4", "vn2", "e4.0");
		cm.at = "9";
		cm.pr = cmShopIds[i]; 
		cm.pm = cmShopProducts[i];
		cm.cg = cmShopCats[i];
		cm.qt = cmShopQtys[i] ;
		cm.bp = cmShopPrices[i];
		cm.cd = cmShopCustomerIds[i];
		cm.on = cmShopOrderIds[i];
		cm.tr = cmShopOrderPrices[i];

		cm.rf = removeKryptoParameter(document.referrer); 

	    cm.ul = removeKryptoParameter(window.location.href);
		
		cm.pc = "N";
		cm.writeImg();

	}
	cmShopSKUs = cmGetOSK();

	cmShopCounter=0;
}

/*
 * Creates an Order tag
 *
 * orderID			: required. Order ID of this order
 * orderTotal		: required. Total of this order (minus tax and shipping)
 * orderShipping	: required. Shipping charge for this order
 * customerID		: required. Customer ID that placed this order
 * customerCity		: optional. City of Customer that placed this order
 * customerState	: optional. State of Customer that placed this order
 * customerZIP		: optional. Zipcode of Customer that placed this order
 *
 * returns nothing, causes a document.write of an image request for this tag.
 */
function cmCreateOrderTag(orderID, orderTotal, orderShipping, customerID, 
			  customerCity, customerState, customerZIP) {
	
		var cm = new _cm("tid", "3", "vn2", "e4.0");
		cm.on = orderID;
		cm.tr = orderTotal;
		cm.osk = cmShopSKUs;
		cm.sg = orderShipping;
		cm.cd = customerID;
		cm.sa = customerState;
		cm.ct = customerCity;
		cm.zp = customerZIP;

		cm.rf = removeKryptoParameter(document.referrer); 
	    cm.ul = removeKryptoParameter(window.location.href);

		cm.writeImg();
	
}

function cmGetOSK() {
	var i =0;
	var result = "";
	for (i=0; i<cmShopCounter; i++)
	{
		result += "|" + cmShopIds[i] + "|" + cmShopPrices[i] + "|" + cmShopQtys[i] + "|";
	}
	return result;
}

/*
 * Creates a Registration tag and/or a Newsletter tag
 *
 * customerID		: required for Registration. ID of Customer to register.
 * customerEmail	: required for Newsletters. Optional for Registration.
 * customerCity		: optional. City of Customer that placed this order
 * customerState	: optional. State of Customer that placed this order
 * customerZIP		: optional. Zipcode of Customer that placed this order
 * newsletterName	: required for Newsletters. The name of the Newsletter.
 * subscribe		: required for Newsletters. Either "Y" or "N"
 *
 * returns nothing, causes a document.write of an image request for this tag.
 */
function cmCreateRegistrationTag(customerID, customerEmail, customerCity,
				customerState, customerZIP, newsletterName, 
				subscribe) {
	var cm = new _cm("tid", "2", "vn2", "e4.0");
	cm.cd = customerID;
	cm.em = customerEmail;
	cm.sa = customerState;
	cm.ct = customerCity;
	cm.zp = customerZIP;

	if (newsletterName && subscribe) {
		cm.nl = newsletterName;
		cm.sd = subscribe;
	}
	
	cm.rf = removeKryptoParameter(document.referrer); 

    cm.ul = removeKryptoParameter(window.location.href);

	cm.writeImg();
}

/* Creates an Error Tag
 *
 * returns nothing, causes a document.write of an image request for this tag.
 */
function cmCreateErrorTag(pageID, categoryID) {
	var cm=new _cm("tid", "404", "vn2", "e4.0");  //DO NOT CHANGE THESE PARAMETERS
	
	cm.rf = removeKryptoParameter(document.referrer); 

    cm.ul = removeKryptoParameter(window.location.href);

	
	// get the referrer from the frameset
	if (parent.cm_ref != null) {
		cm.rf = parent.cm_ref;
		parent.cm_ref = document.URL;
	}

	// if parent had mmc variables and this is the first pageview, add mmc to this url
	if(parent.cm_set_mmc) {
		cm.ul = document.location.href + 
				((document.location.href.indexOf("?") < 0) ? "?" : "&") + 
				parent.cm_mmc_params; 
		parent.cm_ref = cm.ul;
		parent.cm_set_mmc = false;
	}

	cm.pc = "Y";
	if(pageID == null) {
		cm.pi = cmGetDefaultPageID();
	} else {
		cm.pi = pageID;
	}
	cm.cg = categoryID;
	cm.writeImg();
}


/* Custom Tag to capture data referring to Product Finder Attributes
 *
 * pageID	    : required. Page ID of the page for which the attributes 
 *				  live on
 * categoryID	: optional. Category ID of the page for which the attributes
 *				  live on
 */
function cmCreateProductFinderTag(pageID
								, categoryID
								, brand
								, loPrice
								, hiPrice
								, feature1
								, value1
								, feature2
								, value2
								, feature3
								, value3
								, feature4
								, value4
								, feature5
								, value5)
{
	if (pageID == null) {
		pageID = cmGetDefaultPageID();
	}

	var cm = new _cm("tid", "7", "vn2", "e4.0");

	cm.li = 1;
	cm.ps1 = pageID;
	if (categoryID) {
		cm.ps2 = categoryID;
	}
	cm.ps3  = brand;
	cm.ps4  = loPrice;
	cm.ps5  = hiPrice;
	cm.ps6  = feature1;
	cm.ps7  = value1;
	cm.ps8  = feature2;
	cm.ps9  = value2;
	cm.ps10 = feature3;
	cm.ps11 = value3;
	cm.ps12 = feature4;
	cm.ps13 = value4;
	cm.ps14 = feature5;
	cm.ps15 = value5;

	cm.rf = removeKryptoParameter(document.referrer); 

    cm.ul = removeKryptoParameter(window.location.href);

	
	// if available, override the referrer with the frameset referrer
	if (parent.cm_ref != null) {
		cm.rf = parent.cm_ref;
		parent.cm_ref = document.URL;
	}

	// if parent had mmc variables and this is the first pageview, add mmc to this url
	if(parent.cm_set_mmc) {
		cm.ul = document.location.href + 
				((document.location.href.indexOf("?") < 0) ? "?" : "&") + 
				parent.cm_mmc_params; 
		parent.cm_ref = cm.ul;
		parent.cm_set_mmc = false;
	}

	cm.writeImg();
}


/* Custom Tag to capture data referring to the Refinement Options of an Onsite Search
 *
 * pageID	    : required. Page ID of the page for which the refinement links 
 *				  live on
 * categoryID	: optional. Category ID of the page for which the page
 *				  links live on
 */
function cmCreateRefinementOptionsTag( pageID
								     , categoryID
								     , searchTerm
								     , option1
									 , option2
									 , option3
									 , option4
									 , option5)
{
	if (pageID == null) {
		pageID = cmGetDefaultPageID();
	}

	var cm = new _cm("tid", "7", "vn2", "e4.0");

	cm.li = 2;
	cm.ps1 = pageID;
	if (categoryID) {
		cm.ps2 = categoryID;
	}
	cm.ps3 = searchTerm;
	cm.ps4 = option1;
	cm.ps5 = option2;
	cm.ps6 = option3;
	cm.ps7 = option4;
	cm.ps8 = option5;


	cm.rf = removeKryptoParameter(document.referrer); 

    cm.ul = removeKryptoParameter(window.location.href);


	// if available, override the referrer with the frameset referrer
	if (parent.cm_ref != null) {
		cm.rf = parent.cm_ref;
		parent.cm_ref = document.URL;
	}

	// if parent had mmc variables and this is the first pageview, add mmc to this url
	if(parent.cm_set_mmc) {
		cm.ul = document.location.href + 
				((document.location.href.indexOf("?") < 0) ? "?" : "&") + 
				parent.cm_mmc_params; 
		parent.cm_ref = cm.ul;
		parent.cm_set_mmc = false;
	}

	cm.writeImg();
}

/* Custom Tag to capture item added to a Wish List
 */
function cmCreateWishlistTag(productID, productName, productQuantity, productPrice, categoryID) {
	var cm = new _cm("tid", "7", "vn2", "e4.0");
	cm.li = 3;
	cm.ps1  = productID;
	cm.ps2  = productName;
	cm.ps3  = productQuantity;
	cm.ps4  = productPrice;
	cm.ps5  = categoryID;
	cm.writeImg();

}

// HELPER FUNCTIONS -----------------------------------------------------------
/* These functions are used by the tag-generating functions and/or may be used
 * in in general as convenience functions
 */

/* Shortens Referral URL and Destination URL */

function cmRemoveParameter(inS, value) { 
      var begin = inS.indexOf(value); 
      if (begin == -1) { 
           return inS; 
      } else { 
           var end = inS.indexOf("&", begin); 
           if (end == -1) { 
                end = inS.indexOf("%26", begin); 
                if (end==-1) { 
                     end = inS.length; 
                } 
           } 
           if ((end<inS.length) && (inS.charAt(end) == "&")){ 
                end = end +1; 
           } else { 
                if ((end+2<inS.length) && (inS.charAt(end) == "%") && (inS.charAt(end+1) == "2") && (inS.charAt(end+2) == "6"))  
                     end = end + 3; 
           } 
  
           return inS.substring(0, begin) + inS.substring(end, inS.length); 
      } 
 }

 function removeKryptoParameter(inString) { 
      return cmRemoveParameter(inString,"krypto");
 }


/*
 * Creates an acceptable default Page ID value to use for Pageview tags.
 * The default Page ID is based on the URL, and consists of the path and
 * filename (without the protocol, domain and query string).
 * 
 * example:
 * returns "x/y/MyPage.asp" for the URL http://www.mysite.com/x/y/MyPage.asp
 */
function cmGetDefaultPageID() { 
	var pageName = window.location.pathname; 

	// eliminates everything after "?" (for Opera browswers)
	var tempIndex1 = pageName.indexOf("?");
	if (tempIndex1 != -1) {
		pageName = pageName.substr(0, tempIndex1);
	}
	// eliminates everything after "#" (for Opera browswers)
	var tempIndex2 = pageName.indexOf("#");
	if (tempIndex2 != -1) {
		pageName = pageName.substr(0, tempIndex2);
	}
	// eliminates everything after ";"
	var tempIndex3 = pageName.indexOf(";");
	if (tempIndex3 != -1) {
		pageName = pageName.substr(0, tempIndex3);
	}

	var slashPos = pageName.lastIndexOf("/");
	if (slashPos == pageName.length - 1) {
		pageName = pageName + "default.asp"; /****************** SET TO DEFAULT DOC NAME */
	}

	while (pageName.indexOf("/") == 0) {
		pageName = pageName.substr(1,pageName.length);
	}

	return(pageName); 
} 

if (defaultNormalize == null) { var defaultNormalize = null; }

function myNormalizeURL(url, isHref) {
    var newURL = url;
    // ... transform newURL here ...
    if (defaultNormalize != null) {
        newURL = defaultNormalize(newURL, isHref);
    }
    return newURL;
}

// install normalization
if (document.cmTagCtl != null) {
    var func = "" + document.cmTagCtl.normalizeURL;
    if (func.indexOf('myNormalizeURL') == -1) {
        defaultNormalize = document.cmTagCtl.normalizeURL;
        document.cmTagCtl.normalizeURL = myNormalizeURL;
    }
}


function cmSafeFormSubmit(id) {

            CI();
            cO(id,"S");
            CA(1);
            CJ(1);
            CE();

			return true;
}

function cP(e){

            CI();
            if (typeof e == typeof e123_x) {
                        var e = this;
            }
            else {
                        var e=CG(e);
            }
            cO(e?e.cM1:-1,"S");
            CA(1);
            CJ(1);
            CE();
}

//-->