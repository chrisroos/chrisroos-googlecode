
/*
*
* The functions in this javascript file deal with the 'add to basket' URL. 
* AddToBasket from Product or Package page calls the function OrderProcess
* AddToBasket from a listing page (category, search, homepage, package finder) calls OrderProcessFromListing
* All the functions need to know whether we need to forward to the intermediate promotion page
* (depending on whether the product has a complex promotion or not) because if we do then we need to
* forward to promotion.do instead of forwarding straight to the basket.
*
*/



// Global variables
var defaultMemberId=-2000;
var memberId;
var hasNoPackageDetails;
var sku;
var simplePromotionSku;
var simplePromotionId;
var complexPromotionId;
var componentSkuList;
var extraPackageComponentSkuList;
var url = "";
// set up a counter to count the number of products for naming commerce suite fields for the OrderItemAdd command
var chosenProductCount = 0;
var comppartCount = 200;
var timestamp;
var accessorypackagetimestamp;


function setUpGlobals(
	hasNoPackageDetails1,
	sku1,
	simplePromotionSku1,
	simplePromotionId1,
	componentList1) {

	memberId = defaultMemberId;
	hasNoPackageDetails = hasNoPackageDetails1;
	sku = sku1;
	simplePromotionSku = simplePromotionSku1;
	simplePromotionId = simplePromotionId1;
	componentSkuList = componentList1;
	
	url = secureHost + "/webapp/wcs/stores/servlet/CometOrderItemAdd?";	
		/* setup the constant part of the URL */
	url += "storeId=10001&langId=-1&catalogId=10001&URL=CometOrderItemDisplay";
}



/* this method returns the main product or package components part of the Add to Basket url */
/* any simple promotion gets added as well */
/* NOTE: call setUpGlobals() before you call this. This function assumes that global variables have been setup */

function getMainProductOrPackageUrl() {

	mainProductUrl = "";

	/*start counting the number of products*/
	chosenProductCount++;	
	comppartCount++;
	var currenttime = new Date();
	timestamp = currenttime.getTime();
	

	/* set up the values for the main product*/
		
	if (hasNoPackageDetails == true) {
		mainProductUrl += "&partNumber_" + chosenProductCount + "=" + sku;
		mainProductUrl += "&memberId_" + chosenProductCount + "=" + memberId;
		mainProductUrl += "&quantity_" + chosenProductCount + "=1";		
		mainProductUrl += "&field2_" + chosenProductCount + "=" + "P" + timestamp;
		
		/* if there is a simple promotion, link it to the parent product */
		
		if (simplePromotionSku != null && simplePromotionSku != '') {
			// promo link for parent
			mainProductUrl += "&promotion_"  + chosenProductCount + "=" + simplePromotionId;
			
			// Increment chosenProductCount for when we add in the child for a simple promotion
			chosenProductCount++;

		} else if (complexPromotionId != null && complexPromotionId != '') {
			// complex promo link for parent
			mainProductUrl += "&promotion_"  + chosenProductCount + "=" + complexPromotionId;
			
			// Increment chosenProductCount for when we add in the child for a complex promotion
			chosenProductCount++;

		}
	
	}
	else {
	
		/* Add any componentsku (if there are any) to the url*/

		for (i = 0; i < componentSkuList.length; i++) {

			mainProductUrl += "&";
			mainProductUrl += "partNumber_";
			mainProductUrl += comppartCount;
			mainProductUrl += "=";
			mainProductUrl += componentSkuList[i];
			mainProductUrl += "&memberId_";
			mainProductUrl += comppartCount;
			mainProductUrl += "=";
			mainProductUrl += memberId;
			mainProductUrl += "&quantity_";
			mainProductUrl += comppartCount;
			mainProductUrl += "=1";
			mainProductUrl += "&field2_";
			mainProductUrl += comppartCount;
			mainProductUrl += "=P";
			mainProductUrl += timestamp;
			mainProductUrl += "&";
			mainProductUrl += "package_";
			mainProductUrl += comppartCount;
			mainProductUrl += "=";
			mainProductUrl += sku;

			
			/* if there is a simple promotion, link it to the first component */
			
			// promo link for parent

			if (simplePromotionSku != null && simplePromotionSku != '' && i == 0) {
				
				mainProductUrl += "&promotion_"  + comppartCount + "=" + simplePromotionId;
				
			} else if (complexPromotionId != null && complexPromotionId != '' && i == 0) {
			
				mainProductUrl += "&promotion_"  + comppartCount + "=" + complexPromotionId;
			
			}
			
			comppartCount++;
		}			
		
	}	
	
	/* Add in the child for a simple promotion */	
	if (simplePromotionSku != '') {
		mainProductUrl += "&partNumber_" + chosenProductCount + "=" + simplePromotionSku;
		mainProductUrl += "&memberId_" + chosenProductCount + "=" + memberId;
		mainProductUrl += "&quantity_" + chosenProductCount + "=1";	
		mainProductUrl += "&field2_" + chosenProductCount + "=" + "C" + timestamp;
		mainProductUrl += "&promotion_"  + chosenProductCount + "=" + simplePromotionId;
	}		
	
	return mainProductUrl;
		
}


/* This function returns the package url part of the add to basket url - TO BE CALLED 
		ON PACKAGE ACCESSORIES ONLY
		packageSkuString = package123456
		packageComponentsString = 456789+123789+456783
  */
function getSecondaryPackageUrl(packageSkuString, packageComponentsString) {

	var packageComponentUrl = "";
	var packageComponentSkuList = packageComponentsString.split("+");
	var packageSku = packageSkuString.substring(7);
	
	accessorypackagetimestamp = accessorypackagetimestamp + 999;	// just to make sure its different everytime
	
	for (i = 0; i < packageComponentSkuList.length; i++) {

		packageComponentUrl += "&";
		packageComponentUrl += "partNumber_";
		packageComponentUrl += comppartCount;
		packageComponentUrl += "=";
		packageComponentUrl += packageComponentSkuList[i];
		packageComponentUrl += "&memberId_";
		packageComponentUrl += comppartCount;
		packageComponentUrl += "=";
		packageComponentUrl += memberId;
		packageComponentUrl += "&quantity_";
		packageComponentUrl += comppartCount;
		packageComponentUrl += "=1";
		packageComponentUrl += "&field2_";
		packageComponentUrl += comppartCount;
		packageComponentUrl += "=P";
		packageComponentUrl += accessorypackagetimestamp;
		packageComponentUrl += "&";
		packageComponentUrl += "package_";
		packageComponentUrl += comppartCount;
		packageComponentUrl += "=";
		packageComponentUrl += packageSku;
		
		comppartCount++;

	}
	
	return packageComponentUrl;
}


/* this method returns the accessories, recommended products (you might consider) and 
		non-hardware promotions part of the Add to Basket url 
		If a selected accessory is a package then it adds all the package components in the 
		correct format to the url		*/
/* NOTE: call setUpGlobals() and getMainProductOrPackageUrl() before you call this */

function getAccessoryUrl() {

	// setup the accessory package timestamp just incase there are accessory packages selected
	var currenttime = new Date();
	accessorypackagetimestamp = currenttime.getTime();
	
	/* set up the accessories url*/
	var accessoryUrl = "";	

	
	/* check if any promos, extras or recommended products have been selected*/	
	
	/* Accessory Promos */
	if (document.overviewForm != null) {
		if (document.overviewForm.promo != null) {
			var promoCheckboxes;
			if (document.overviewForm.promo.length != null) {
				promoCheckboxes = document.overviewForm.promo;
			} else {
				promoCheckboxes = new Array(document.overviewForm.promo);
			}

			for (i = 0; i < promoCheckboxes.length; i++) {
			
				if (promoCheckboxes[i].checked) {
				
					// set the quantity - if one is set
					promo_quantity = 1;
					promo_id = promoCheckboxes[i].id;
					if (eval("document.overviewForm.promo_quantity_" + promo_id) != null) {
						promo_quantity_form = eval("document.overviewForm.promo_quantity_" + promo_id);
						promo_quantity = promo_quantity_form.value;
					}
					// end set quantity
				
					chosenProductCount++;			// set the sku
					accessoryUrl += "&"
					accessoryUrl += "partNumber_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=";
					accessoryUrl += promoCheckboxes[i].value;				// set the member Id
					accessoryUrl += "&";
					accessoryUrl += "memberId_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=";
					accessoryUrl += memberId;				// set the quantity
					accessoryUrl += "&";
					accessoryUrl += "quantity_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=";
					accessoryUrl += promo_quantity;
					accessoryUrl += "&";
					accessoryUrl += "field2_"; 		// set the relationship with the parent product
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=C";
					accessoryUrl += timestamp;
					accessoryUrl += "&";
					accessoryUrl += "promotion_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=";
					accessoryUrl += promoCheckboxes[i].id;
				}
			}
		}
	
		/* Extras */	
		if (document.overviewForm.extra != null) {
			var extraCheckboxes;
			if (document.overviewForm.extra.length != null) {
				extraCheckboxes = document.overviewForm.extra;
			} else {
				extraCheckboxes = new Array(document.overviewForm.extra);
			}

			for (j = 0; j < extraCheckboxes.length; j++) {
				
				if (extraCheckboxes[j].checked) {
					chosenProductCount++;
					
					// check if its a package accessory
					if (extraCheckboxes[j].value.indexOf("package") != -1) {

						accessoryUrl += getSecondaryPackageUrl(extraCheckboxes[j].value, extraCheckboxes[j].id);
					
					} else {
					
						accessoryUrl += "&"
						accessoryUrl += "partNumber_";
						accessoryUrl += chosenProductCount;
						accessoryUrl += "=";
						accessoryUrl += extraCheckboxes[j].value;				// set the member Id
						accessoryUrl += "&";
						accessoryUrl += "memberId_";
						accessoryUrl += chosenProductCount;
						accessoryUrl += "=";
						accessoryUrl += memberId;				// set the quantity
						accessoryUrl += "&";
						accessoryUrl += "quantity_";
						accessoryUrl += chosenProductCount;
						accessoryUrl += "=1";							// set the relationship with the parent product
						accessoryUrl += "&";
						accessoryUrl += "field2_";
						accessoryUrl += chosenProductCount;
						accessoryUrl += "=C";
						accessoryUrl += timestamp;
					}
				}
			}
		}
	}
	
	/* Recommended products (you might consider) */	
	
	if (document.recProductForm != null) {
		if (document.recProductForm.recProduct != null) {
			var recProductCheckboxes;
			if (document.recProductForm.recProduct.length != null) {
				recProductCheckboxes = document.recProductForm.recProduct;
			} else {
				recProductCheckboxes = new Array(document.recProductForm.recProduct);
			}

			for (k = 0; k < recProductCheckboxes.length; k++) {
				if (recProductCheckboxes[k].checked) {
					chosenProductCount++;			// set the sku
					accessoryUrl += "&"
					accessoryUrl += "partNumber_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=";
					accessoryUrl += recProductCheckboxes[k].value;				// set the member Id
					accessoryUrl += "&";
					accessoryUrl += "memberId_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=";
					accessoryUrl += memberId;				// set the quantity
					accessoryUrl += "&";
					accessoryUrl += "quantity_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=1";							// set the relationship with the parent product
					accessoryUrl += "&";
					accessoryUrl += "field2_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=C";
					accessoryUrl += timestamp;
				}
			}
		}
	}
	
	return accessoryUrl;
}


/* this method returns the medium hardware promotions part of the Add to Basket url */
/* NOTE: call setUpGlobals() and getMainProductOrPackageUrl() before you call this */

function getMediumHardwarePromosUrl(targetSkus, promoId, promoQuantity) {

	/* set up the promotions url*/
	var promoUrl = "";	
	
	for (i = 0; i < targetSkus.length; i++) {
			chosenProductCount++;			// set the sku
			promoUrl += "&"
			promoUrl += "partNumber_";
			promoUrl += chosenProductCount;
			promoUrl += "=";
			promoUrl += targetSkus[i];				// set the member Id
			promoUrl += "&";
			promoUrl += "memberId_";
			promoUrl += chosenProductCount;
			promoUrl += "=";
			promoUrl += memberId;				// set the quantity
			promoUrl += "&";
			promoUrl += "quantity_";
			promoUrl += chosenProductCount;
			promoUrl += "="+promoQuantity;
			promoUrl += "&";
			promoUrl += "field2_";
			promoUrl += chosenProductCount;
			promoUrl += "=C";
			promoUrl += timestamp;
			promoUrl += "&";
			promoUrl += "promotion_";
			promoUrl += chosenProductCount;
			promoUrl += "=";
			promoUrl += promoId;
	}

	
	return promoUrl;
}


/* 
This method returns the selected accessories, non-hardware promotions and 
recommended products (you might consider) to be appended to the url  
FOR USE WHEN FORWARDING TO PROMOTION.DO ONLY 
*/

function getPromoPageSelectedItemsUrl() {

	accessoryUrl = "";
	/* check if any promos, extras or recommended products have been selected*/	
	
	/* Accessory Promos */
	if (document.overviewForm != null) {
		if (document.overviewForm.promo != null) {
			var promoCheckboxes;
			if (document.overviewForm.promo.length != null) {
				promoCheckboxes = document.overviewForm.promo;
			} else {
				promoCheckboxes = new Array(document.overviewForm.promo);
			}
			
			for (i = 0; i < promoCheckboxes.length; i++) {
				if (promoCheckboxes[i].checked) {
				
					// set the quantity - if one is set
					promoQuantity = 1;
					promo_id = promoCheckboxes[i].id;
					if (eval("document.overviewForm.promo_quantity_" + promo_id) != null) {
						promo_quantity_form = eval("document.overviewForm.promo_quantity_" + promo_id);
						promoQuantity = promo_quantity_form.value;
					}
					// end set quantity
				
					accessoryUrl += "&"
					accessoryUrl += "promo";
					accessoryUrl += "=";
					accessoryUrl += promoCheckboxes[i].value + ":" + promoCheckboxes[i].id + ":" + promoQuantity;  // in the format sku:promoid:qty
				}
			}
		}
	
		/* Extras */	
		if (document.overviewForm.extra != null) {
			var extraCheckboxes;
			if (document.overviewForm.extra.length != null) {
				extraCheckboxes = document.overviewForm.extra;
			} else {
				extraCheckboxes = new Array(document.overviewForm.extra);
			}

			for (i = 0; i < extraCheckboxes.length; i++) {
				if (extraCheckboxes[i].checked) {
					accessoryUrl += "&"
					accessoryUrl += "extra";
					accessoryUrl += "=";
					accessoryUrl += extraCheckboxes[i].value; //sku			
				}
			}
		}
	}
	
	/* Recommended products (you might consider) */	
	
	if (document.recProductForm != null) {
		if (document.recProductForm.recProduct != null) {
			var recProductCheckboxes;
			if (document.recProductForm.recProduct.length != null) {
				recProductCheckboxes = document.recProductForm.recProduct;
			} else {
				recProductCheckboxes = new Array(document.recProductForm.recProduct);
			}

			for (i = 0; i < recProductCheckboxes.length; i++) {
				if (recProductCheckboxes[i].checked) {
					accessoryUrl += "&"
					accessoryUrl += "recProduct";
					accessoryUrl += "=";
					accessoryUrl += recProductCheckboxes[i].value; //sku		
				}
			}
		}
	}
	
	return accessoryUrl;	

}

/* 
This method returns the selected medium hardware promo to be appended to the url  
FOR USE WHEN FORWARDING TO PROMOTION.DO ONLY 
*/

function getPromoPageSelectedMediumHardwarePromoUrl(targetSkus, promoId, promoQuantity) {

	/* set up the promotions url*/
	var targetSkusUrl = "&mediumHWPromo=";
	
	for (i = 0; i < targetSkus.length; i++) {
	
			targetSkusUrl += targetSkus[i] + "*";

	}
	var promoUrl = targetSkusUrl + ":" + promoId + ":" + promoQuantity;

	return promoUrl;
}


/* This function gets called from the Product or Package page */

function OrderProcess(forwardToPromoPage) {
	
	if (forwardToPromoPage) {
	
		// setup the url for the complex promotions page. Pass in the skus of the selected accessories
		url = "/cometbrowse/promotion.do?sku=" + sku;
		url += getPromoPageSelectedItemsUrl();
		
	} else {
		
		// forward directly to the basket
		url += getMainProductOrPackageUrl();
		url += getAccessoryUrl();
		
	}

	window.location = url;
}

/* This function gets called from the Medium Hardware promotion panel */

function OrderProcessFromMediumHardwarePromo(targetSkus, promoId, promoQuantity, forwardToPromoPage) {
	
	if (forwardToPromoPage) {
	
		// setup the url for the complex promotions page. 
		// Pass in the skus of the selected accessories and medium hw promo
		url = "/cometbrowse/promotion.do?sku=" + sku;
		url += getPromoPageSelectedItemsUrl();
		url += getPromoPageSelectedMediumHardwarePromoUrl(targetSkus, promoId, promoQuantity);
		
	} else {
		
		// forward directly to the basket
		url += getMainProductOrPackageUrl();
		url += getAccessoryUrl();
		url += getMediumHardwarePromosUrl(targetSkus, promoId, promoQuantity);
		
	}

	window.location = url;
	
}


/* This function gets called from the package or product listing page or hero (category, homepage, search, collections, package finder)*/

function OrderProcessFromListing(sku1, hasNoPackageDetails1, simplePromotionSku1, simplePromotionId1, componentSkuList1, forwardToPromoPage) {

	if (forwardToPromoPage) {
	
		// setup the url for the complex promotions page. No accessories etc could have been selected.
		url = "/cometbrowse/promotion.do?sku=" + sku1;
		
	} else {
	
		setUpGlobals(
			hasNoPackageDetails1,
			sku1,
			simplePromotionSku1,
			simplePromotionId1,
			componentSkuList1
		);

		url += getMainProductOrPackageUrl();
		
	}
	
	window.location = url;
	
}



/***********************************************************

		Functions relating to the complex promotions page
		
************************************************************/




/* this method returns the accessories, recommended products (you might consider) and 
		non-hardware promotions part of the Add to Basket url FROM THE COMPLEX PROMO PAGE */
/* NOTE: call setUpGlobals() and getMainProductOrPackageUrl() before you call this */

function getAccessoryUrlFromPromotionsPage() {

	/* set up the accessories url*/
	var accessoryUrl = "";	

	/* check if any promos, extras or recommended products have been selected*/	
	
	/* Accessory Promos */
	if (document.promotionForm != null) {
	
		if (document.promotionForm.promos != null && document.promotionForm.promos.value != "") {	

		var promosArray = document.promotionForm.promos.value.split("*");

			for (i = 0; i < promosArray.length; i++) {
			
				var promoPiecesArray = promosArray[i].split(":"); // split the promo into sku and id
				
				chosenProductCount++;			// set the sku
				accessoryUrl += "&"
				accessoryUrl += "partNumber_";
				accessoryUrl += chosenProductCount;
				accessoryUrl += "=";
				accessoryUrl += promoPiecesArray[0];				// set the member Id
				accessoryUrl += "&";
				accessoryUrl += "memberId_";
				accessoryUrl += chosenProductCount;
				accessoryUrl += "=";
				accessoryUrl += memberId;
				accessoryUrl += "&";
				accessoryUrl += "quantity_";
				accessoryUrl += chosenProductCount;
				accessoryUrl += "=" + promoPiecesArray[2];				// set the quantity
				accessoryUrl += "&";
				accessoryUrl += "field2_"; 		// set the relationship with the parent product
				accessoryUrl += chosenProductCount;
				accessoryUrl += "=C";
				accessoryUrl += timestamp;
				accessoryUrl += "&";
				accessoryUrl += "promotion_";
				accessoryUrl += chosenProductCount;
				accessoryUrl += "=";
				accessoryUrl += promoPiecesArray[1];

			}
		}
	
		/* Extras */	
		if (document.promotionForm.extras != null && document.promotionForm.extras.value != "") {
		
			var extrasArray = document.promotionForm.extras.value.split("*");

			for (i = 0; i < extrasArray.length; i++) {

					chosenProductCount++;			// set the sku
					accessoryUrl += "&"
					accessoryUrl += "partNumber_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=";
					accessoryUrl += extrasArray[i];				// set the member Id
					accessoryUrl += "&";
					accessoryUrl += "memberId_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=";
					accessoryUrl += memberId;				// set the quantity
					accessoryUrl += "&";
					accessoryUrl += "quantity_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=1";							// set the relationship with the parent product
					accessoryUrl += "&";
					accessoryUrl += "field2_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=C";
					accessoryUrl += timestamp;			

			}
		}

	
	/* Recommended products (you might consider) */	

		if (document.promotionForm.recProducts != null && document.promotionForm.recProducts.value != "") {

			var recProductsArray = document.promotionForm.recProducts.value.split("*");

			for (i = 0; i < recProductsArray.length; i++) {

					chosenProductCount++;			// set the sku
					accessoryUrl += "&"
					accessoryUrl += "partNumber_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=";
					accessoryUrl += recProductsArray[i];				// set the member Id
					accessoryUrl += "&";
					accessoryUrl += "memberId_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=";
					accessoryUrl += memberId;				// set the quantity
					accessoryUrl += "&";
					accessoryUrl += "quantity_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=1";							// set the relationship with the parent product
					accessoryUrl += "&";
					accessoryUrl += "field2_";
					accessoryUrl += chosenProductCount;
					accessoryUrl += "=C";
					accessoryUrl += timestamp;

			}
		}
	}
	
	return accessoryUrl;
}


function getMediumHWPromoUrlFromPromotionsPage() {

	/* set up the promotions url*/
	var promoUrl = "";	
	
	if (document.promotionForm.mediumHWPromo != null && document.promotionForm.mediumHWPromo.value != "") {
	
	var mediumHWPromoPieces = document.promotionForm.mediumHWPromo.value.split(":");

	var targetSkusString = mediumHWPromoPieces[0];
	var mediumHWPromoId = mediumHWPromoPieces[1];
	var promoQuantity = mediumHWPromoPieces[2];
	
	var targetSkus = targetSkusString.split("*");
	
		for (i = 0; i < targetSkus.length; i++) {
			if (targetSkus[i] != "") {
				chosenProductCount++;			// set the sku
				promoUrl += "&"
				promoUrl += "partNumber_";
				promoUrl += chosenProductCount;
				promoUrl += "=";
				promoUrl += targetSkus[i];				// set the member Id
				promoUrl += "&";
				promoUrl += "memberId_";
				promoUrl += chosenProductCount;
				promoUrl += "=";
				promoUrl += memberId;				// set the quantity
				promoUrl += "&";
				promoUrl += "quantity_";
				promoUrl += chosenProductCount;
				promoUrl += "=" + promoQuantity;
				promoUrl += "&";
				promoUrl += "field2_";
				promoUrl += chosenProductCount;
				promoUrl += "=C";
				promoUrl += timestamp;
				promoUrl += "&";
				promoUrl += "promotion_";
				promoUrl += chosenProductCount;
				promoUrl += "=";
				promoUrl += mediumHWPromoId;
			}
		}
	}

	
	return promoUrl;
	
}


/* This function gets called from the Complex Promotion page */

function OrderProcessFromPromotion(yesNoSelection, complexPromotionId1) {
	
	if (yesNoSelection == 'Yes') {
		complexPromotionId = complexPromotionId1;
	}
	
	// forward directly to the basket
	url += getMainProductOrPackageUrl();
	url += getAccessoryUrlFromPromotionsPage();
	url += getMediumHWPromoUrlFromPromotionsPage();
	
		
	window.location = url;
}
