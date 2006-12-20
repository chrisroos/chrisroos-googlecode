var numRVPProductsToKeep = 5;
var numRVPProductsToShow = 4;

var numCompareProductsToKeep = 4;
var numCompareProductsToShow = 4;

var numCompareCategories = 5;

var cookieLifetime = 30;
var cookiePath = "/";
var prod30 = "http://www.comet.co.uk/comet/dyn_imgs/prods/prod_30/";
var tooManyCompareProductsMessage = "There are already 4 items in your comparison list. Please remove an item before attempting to add another";
var productExistsMessage = "This item is already in your comparison list";

/*
The functions in this javascript file setup and access the compareproducts and recentlyviewedproducts
cookies.
The compareproducts cookie is of the format:
category1##sku:::name:::description:::image*+*sku:::name:::description:::image*:*category2##sku:::name:::description:::image*+*sku:::name:::description:::image*:*

The recentlyviewedproducts cookie is of the format:
sku:::name:::description:::image:::packageindicator*+*sku:::name:::description:::image:::packageindicator

*/



/*
  name - name of the desired cookie
  return string containing value of specified cookie or null
  if cookie does not exist
*/

function getCookie(name) {
  var dc = document.cookie;
  var prefix = name + "=";
  var begin = dc.indexOf("; " + prefix);
  if (begin == -1) {
    begin = dc.indexOf(prefix);
    if (begin != 0) return "nocookie";
  } else {
    begin += 2;
  }
  var end = document.cookie.indexOf(";", begin);
  if (end == -1) {
    end = dc.length;
  }
  return unescape(dc.substring(begin + prefix.length, end));
}


/*
   name - name of the cookie
   value - value of the cookie
   [expires] - expiration date of the cookie
     (defaults to end of current session)
   [path] - path for which the cookie is valid
     (defaults to path of calling document)
   [domain] - domain for which the cookie is valid
     (defaults to domain of calling document)
   [secure] - Boolean value indicating if the cookie transmission requires
     a secure transmission
   * an argument defaults when it is assigned null as a placeholder
   * a null placeholder is not required for trailing omitted arguments
*/

function setCookie(name, value, expires, path, domain, secure) {
  var curCookie = name + "=" + escape(value) +
      ((expires) ? "; expires=" + expires.toGMTString() : "") +
      ((path) ? "; path=" + path : "") +
      ((domain) ? "; domain=" + domain : "") +
      ((secure) ? "; secure" : "");
  document.cookie = curCookie;
}


/*
   name - name of the cookie
   [path] - path of the cookie (must be same as path used to create cookie)
   [domain] - domain of the cookie (must be same as domain used to
     create cookie)
   path and domain default if assigned null or omitted if no explicit
     argument proceeds
*/

function deleteCookie(name, path, domain) {
  if (getCookie(name)) {
    document.cookie = name + "=" +
    ((path) ? "; path=" + path : "") +
    ((domain) ? "; domain=" + domain : "") +
    "; expires=Thu, 01-Jan-70 00:00:01 GMT";
  }
}


// date - any instance of the Date object
// * hand all instances of the Date object to this function for "repairs"

function fixDate(date) {
  var base = new Date(0);
  var skew = base.getTime();
  if (skew > 0)
    date.setTime(date.getTime() - skew);
}

/*
   sku - sku of the product
   name - name of the product
   description - short description of the product
   image - image name of the product
   category - category this product is in
   package - whether this is a package or not (yes/no)
   
   returns a string of the format sku:::name:::description:::image:::packageindicator
*/
function buildRVPProductString(sku,name,description,image,package) {

	var returnString = sku + ":::" + name + ":::" + description + ":::" + image + ":::" + package;
	return returnString;
	
}

/*
   sku - sku of the product
   name - name of the product
   description - short description of the product
   image - image name of the product
   category - category this product is in
   
   returns a string of the format sku:::name:::description:::image
*/
function buildCompareProductString(sku,name,description,image) {

	var returnString = sku + ":::" + name + ":::" + description + ":::" + image;
	return returnString;
	
}

/*
	category - category this product is in
	productString - a string of the format sku:::name:::description:::image*+*sku:::name:::description:::image
	for this product
	
	returns a string of the format category##sku:::name:::description:::image*+*sku:::name:::description:::image*:*
	
*/
function buildCategoryString(category, productString) {

	//alert("buildCategoryString. category=" + category + "  productString=" + productString);
	var returnString = category + "##" + productString;
	//alert("buildCategoryString. returning=" + returnString);
	return returnString;
	
}


/*
	category - the category id whose products we want to find in the cookie string
	cookieString - the cookie string we are looking in
	
	returns the string that corresponds to this category
*/
function getCategoryString(category, cookieString) {
  
  var categoryString = category + "##";
  var begin = cookieString.indexOf(categoryString);
  if (begin == -1) {
    return "nocategory";
  } 
  var end = cookieString.indexOf("*:*", begin);
  if (end == -1) {
    end = cookieString.length;
  }
  //alert("getCategoryString=" + unescape(cookieString.substring(begin, end)));
  
  return unescape(cookieString.substring(begin, end));
}


/*
	sku - sku of the product we are looking for
	cookieString - the cookie string we are looking in
	
	Its pretty safe to just search for the existance of the sku in the string. dont think we will
	get a false positive doing this
*/
function getRVPProductExists(sku, cookieString) {
	var begin = cookieString.indexOf(sku);
  if (begin == -1) {
  	return "false";
  }
  else
  {
  	return "true";
  }
}

/*
	sku - sku of the product we are looking for
	categoryString - the category we are looking in
	
	Its pretty safe to just search for the existance of the sku in the string. dont think we will
	get a false positive doing this
*/
function getCompareProductExists(sku, categoryString) {
	var begin = categoryString.indexOf(sku);
  if (begin == -1) {
  	return "false";
  }
  else
  {
  	return "true";
  }
}


/*
	cookieString - the RVP cookie
*/
function checkTooManyRVPProducts(cookieString) {
	var productArray = cookieString.split("*+*");
	if (productArray.length >= numRVPProductsToKeep) {
		return "true";
	}
	else
	{
		return "false";
	}

}



/*
	categoryString - the string for the category we are looking in
*/
function checkTooManyCompareProducts(categoryString) {
	var productArray = categoryString.split("*+*");
	if (productArray.length >= numCompareProductsToKeep) {
		return "true";
	}
	else
	{
		return "false";
	}

}

/*
*/
function bumpProducts(numProductsToKeep, cookieString) {
	var productArray = cookieString.split("*+*");
	var newCookieString = "";
	var count = 0;
	while ((count < productArray.length - 1) && (count < numProductsToKeep)) {
		var product = productArray[count];
		if (newCookieString == "") {
			newCookieString = product;
		}
		else {
			newCookieString = newCookieString + "*+*" + product;
		}
		count = count + 1;		
	}
	
	return newCookieString;

}


function prependRVPProduct(newProductString, rvpCookie) {
	var newCookie = newProductString + "*+*" + rvpCookie;
	return newCookie;
}


function prependCompareProduct(categoryId, newProductString, categoryString) {
 
	//alert("prependCompareProduct. newProductString=" + newProductString + "  categoryString=" + categoryString);
 
	if (categoryString != "nocategory") {
		var categoryStringPieces = categoryString.split("##");

		if (categoryStringPieces.length > 1) {

			var categoryProducts = categoryStringPieces[1];
			var newCategoryString = categoryId + "##" + newProductString + "*+*" + categoryProducts;

		}

		//alert("prependCompareProduct. returning=" + newCategoryString);
	}
	else
	{
		var newCategoryString = categoryId + "##" + newProductString;
	}
	
  return newCategoryString;

}



function reAssembleCompareCookie(categoryId, newCategoryString, compareCookie) {

	//alert("reAssembleCompareCookie. newCategoryString=" + newCategoryString + "  compareCookie=" + compareCookie);


	// first split the compareCookie into categoryStrings
	var categoriesArray = compareCookie.split("*:*");
	var categoryStringReplaced = "false";
	
	
	var newCompareCookie = "";
	
	if (categoriesArray.length > 0) {

		for (var i = 0; i < categoriesArray.length; i++)
		{
			var thisCategoryString = categoriesArray[i];
			if (thisCategoryString != "") {
			
				//alert("reAssembleCompareCookie. thisCategoryString[" + i + "]=" + thisCategoryString);


				// is this the category we are replacing?
				if (thisCategoryString.indexOf(categoryId) != -1) {
					thisCategoryString = newCategoryString;
					categoryStringReplaced = "true";
				}
				if (newCompareCookie != "") {
					newCompareCookie = newCompareCookie + "*:*" + thisCategoryString;
				}
				else 
				{
					newCompareCookie = thisCategoryString;
				}
			}
		}
		
		if (categoryStringReplaced == "false") {
			newCompareCookie = newCategoryString + "*:*" + newCompareCookie;
		}
	}
	
	//alert("reAssembleCompareCookie. returning=" + newCompareCookie);
	
	return newCompareCookie;

}



/*
   sku - sku of the product
   name - name of the product
   description - short description of the product
   image - image url of the product
   category - category this product is in
   package - whether this is a package or not

*/

function addToRecentlyViewed(sku,name,description,image,package) {
	
	// get the recently viewed products cookie
  var rvpCookie = getCookie("recentlyviewedproducts");
  rvpCookie = unescape(rvpCookie);
  
  //alert("Old cookie: " + rvpCookie);
  
  
  // make a cookie expiry date object for 'cookieLifetime' days in the future
  var cookieExpiryDate = new Date();
  cookieExpiryDate.setDate(cookieExpiryDate.getDate() + cookieLifetime);
  
  // if the cookie exists then parse it for the products

  if (rvpCookie != "nocookie") {
		
		// check if the product has already been saved
		var productExists = getRVPProductExists(sku, rvpCookie);
		
		//alert("productExists?: " + productExists);

		// If the product isnt already there then proceed, otherwise dont bother. 
		// We dont want to move it to the top or anything
		if(productExists == "false") {
		
			// check if there are already 'numRVPProductsToKeep' products, if so then bump the last one off
			var tooManyProds = checkTooManyRVPProducts(rvpCookie);
			//alert("tooManyProds?: " + tooManyProds);
			if(tooManyProds == "true") {
				rvpCookie = bumpProducts(numRVPProductsToKeep - 1, rvpCookie);
				//alert("new rvpCookie: " + rvpCookie);
			}
			var newProductString = buildRVPProductString(sku,name,description,image,package);
			//alert("newProductString: " + newProductString);
			var newCookieString = prependRVPProduct(newProductString, rvpCookie);
			//alert("newCookieString: " + newCookieString);
			setCookie("recentlyviewedproducts", escape(newCookieString), cookieExpiryDate, cookiePath, null, null);
		}
  } 
  else 
  {

  	var newProductString = buildRVPProductString(sku,name,description,image,package);
  	//alert("newProductString: " + newProductString);
  	setCookie("recentlyviewedproducts", escape(newProductString), cookieExpiryDate, cookiePath, null, null);
  
  }
 

}

function deleteCompareProductFromCategory(sku, categoryString) {
 	var newCategoryString = "";
 	
	if (categoryString != "nocategory") {
		var categoryStringPieces = categoryString.split("##");

		if (categoryStringPieces.length > 1) {
			newCategoryString = categoryStringPieces[0] + "##";
			var categoryProducts = categoryStringPieces[1];
			var productArray = categoryProducts.split("*+*");
			var productAddedBack = "false";
			
			for (var i = 0; i < productArray.length; i++)
			{
				var thisProduct = productArray[i];
				var productInfoArray = thisProduct.split(":::");
				if (productInfoArray[0] != sku) {
					// add it back in
					if (productAddedBack == "true") {
						newCategoryString = newCategoryString + "*+*" + thisProduct;
					}
					else
					{
						newCategoryString = newCategoryString + thisProduct;
						productAddedBack = "true";
					}
				}
			}
			if (productAddedBack == "false") {
				newCategoryString = "";
			}
			
		}
	}
	else
	{
		var newCategoryString = categoryString;
	}
	
  return newCategoryString;

}


function deleteCompareProduct(category,sku) {

	
	// get the compare cookie
  var compareCookie = getCookie("compareproducts");
  compareCookie = unescape(compareCookie);
  
  //alert("existing cookie: " + compareCookie);
  
  
  // make a cookie expiry date object for 'cookieLifetime' days in the future
  var cookieExpiryDate = new Date();
  cookieExpiryDate.setDate(cookieExpiryDate.getDate() + cookieLifetime);
  
  // if the cookie exists then parse it for the correct category

  if (compareCookie != "nocookie") {
  
		var categoryString = getCategoryString(category, compareCookie);
		//alert("categoryString=" + categoryString);
		
		if (categoryString != "nocategory") {

			var newCategoryString = deleteCompareProductFromCategory(sku, categoryString);
			var newCookieString = reAssembleCompareCookie(category, newCategoryString, compareCookie);
			setCookie("compareproducts", escape(newCookieString), cookieExpiryDate, cookiePath, null, null);
		
		}
	}
}



/*
   sku - sku of the product
   name - name of the product
   description - short description of the product
   image - image url of the product
   category - category this product is in
   package - whether this is a package or not

*/

function addToCompare(category,sku,name,description,image) {
	
	// get the compare cookie
  var compareCookie = getCookie("compareproducts");
  compareCookie = unescape(compareCookie);
  
  //alert("existing cookie: " + compareCookie);
  
  
  // make a cookie expiry date object for 'cookieLifetime' days in the future
  var cookieExpiryDate = new Date();
  cookieExpiryDate.setDate(cookieExpiryDate.getDate() + cookieLifetime);
  
  // if the cookie exists then parse it for the correct category

  if (compareCookie != "nocookie") {
  
		var categoryString = getCategoryString(category, compareCookie);
		//alert("categoryString=" + categoryString);
		
		if (categoryString != "nocategory") {
			//alert("categoryString is not null");
			//alert("categoryString=" + categoryString);
			var productExists = getCompareProductExists(sku, categoryString);
			if(productExists == "false") {
				var tooManyProducts = checkTooManyCompareProducts(categoryString);
				if (tooManyProducts == "true") {
					alert(tooManyCompareProductsMessage);
				}
				else
				{
					var newProductString = buildCompareProductString(sku,name,description,image);
					var newCategoryString = prependCompareProduct(category, newProductString, categoryString);
					var newCookieString = reAssembleCompareCookie(category, newCategoryString, compareCookie);
					setCookie("compareproducts", escape(newCookieString), cookieExpiryDate, cookiePath, null, null);
				}
			}
			else
			{
				alert(productExistsMessage);
			}
		}
		else
		{
			//alert("categoryString is null");
			var newProductString = buildCompareProductString(sku,name,description,image);
			var newCategoryString = prependCompareProduct(category, newProductString, "nocategory");
			
			var newCookieString = reAssembleCompareCookie(category, newCategoryString, compareCookie);
			setCookie("compareproducts", escape(newCookieString), cookieExpiryDate, cookiePath, null, null);

		}
  } 
  else 
  {

  	var newProductString = buildCompareProductString(sku,name,description,image);
  	var newCategoryString = buildCategoryString(category, newProductString);
  	setCookie("compareproducts", escape(newCategoryString), cookieExpiryDate, cookiePath, null, null);
  
  }

}


function drawRecentlyViewedProductsBox(sku) {

	var recentlyViewedProductsHtml = getRecentlyViewedProductsHtml(sku);
	//alert(recentlyViewedProductsHtml);
	
	// replace the html in the recentlyviewedproductsbox area with the computed html
	
	var recentlyViewedProductsBox = document.getElementById("recentlyviewedproductsbox");
	if ((recentlyViewedProductsHtml != "nohtml") && (recentlyViewedProductsHtml != "")) {
		recentlyViewedProductsBox.innerHTML = recentlyViewedProductsHtml;
	}
	
}


function drawCompareProductsBox(category) {

	var compareProductsHtml = getCompareProductsHtml(category);
	//alert(compareProductsHtml);
	
	// replace the html in the compareproductsbox area with the computed html
	
	var compareProductsBox = document.getElementById("compareproductsbox");
	if ((compareProductsHtml != "nohtml") && (compareProductsHtml != "")) {
		compareProductsBox.innerHTML = compareProductsHtml;
	}
	
}


function drawMyCometLoginLink() {

  //alert( " inside comet login"  );
  //var curCookie = "userLoggedIn=Y";
  //document.cookie = curCookie;

  var loginCookie = getCookie("userLoggedIn");
  loginCookie = unescape(loginCookie);
  var loginLinkElement = document.getElementById("mycometloginlink");
  if (loginCookie != "nocookie") {
	loginLinkElement.innerHTML = '<a href="Javascript:Logout();">Logout of My Comet</a>';
  } else {
	loginLinkElement.innerHTML = '<a href="Javascript:Login();">My Comet Login</a>';
  }
}


function getRecentlyViewedProductsHtml(sku) {

  var recentlyViewedProductsHtml = "";
	
	// get the recently viewed products cookie
  var rvpCookie = getCookie("recentlyviewedproducts");
  rvpCookie = unescape(rvpCookie);
  
  if (rvpCookie != "" && rvpCookie != "nocookie") {
  
		var productArray = rvpCookie.split("*+*");
		
		// check for the obscure condition when there is only one product and its the sku we are 
		// currently looking at - in this case we dont want to show the recently viewed box
		if (productArray.length == 1) {
				var oneproduct = productArray[0];

				//sku:::name:::description:::image:::packageindicator
				var oneProductInfoArray = oneproduct.split(":::");
				if (oneProductInfoArray[0] == sku) {
					return "";
				}
		}
		
		// in all other cases

		if (productArray.length > 0) {

			recentlyViewedProductsHtml =
			"<div id='recentlyviewed'>"
			+"<span class='recentlyviewedproducts'><strong>Recently viewed products</strong></span>"
			+"<table cellpadding='0' cellspacing='0' summary='Recently viewed products'>"
			+"<thead>"
			+"	<tr>"
			+"		<th scope='col'>Product image</th><th scope='col'>Product details</th>"
			+"	</tr>"
			+"</thead>"
			+"<tbody>";

			// we may have 5 prods in the array but only want to show 4
			// so check that both conditions are met
			for (var i = 0; (i < productArray.length && i < numRVPProductsToShow); i++)
			{
				var product = productArray[i];

				//sku:::name:::description:::image:::packageindicator
				var productInfoArray = product.split(":::");
				
				//alert(product);
				// dont add the current product (the sku passed in) to the recently viewed products box
				if (sku != productInfoArray[0]) {
				recentlyViewedProductsHtml = recentlyViewedProductsHtml
					+"<tr>"
					+"	<td><a href='/cometbrowse/product.do?sku=" + productInfoArray[0] + "'><img alt='" + productInfoArray[1] + "' src='" + prod30 + productInfoArray[3] + "' /></a></td>"
					+"	<td><strong><a href='/cometbrowse/product.do?sku=" + productInfoArray[0] + "'>" + productInfoArray[1] + "</a></strong> " + productInfoArray[2] + "<span><a href='/cometbrowse/product.do?sku=" + productInfoArray[0] + "' class='hideforcic'>More info</a></span></td>"
					+"</tr>"
				}

			}

			var recentlyViewedProductsHtml = recentlyViewedProductsHtml
			+"</tbody>"
			+"</table>"
			+""
			+"</div>";

		}
	}
  
  return recentlyViewedProductsHtml;

}


function addToRVPAndDrawBox(sku,name,description,image,package) {

	drawRecentlyViewedProductsBox(sku) ;
	addToRecentlyViewed(sku,name,description,image,package);
	
}

function getNoCompareProductsHtml() {

	var noCompareProductsHtml =
	"<div class='greyboxtop'>"
	+"		<span class='greyboxul'></span><span class='compareproducts'><strong>Compare products</strong></span><span class='greyboxur'></span>"
	+"</div>"
	+"<div class='greyboxbody'>"
	+"	<div id='compareproducts' class='greyboxbodypad'>"
	+"		To add a product for comparison click its 'compare' link"
	+"   </div> "
	+"</div>"
	+"<div class='greyboxbottom'>"
	+"		<span class='greyboxdl'></span><span class='greyboxdr'></span>"
	+"</div>";
	
	return noCompareProductsHtml;
	
}


function getCompareProductsHtmlFromProductArray(category,productsArray) {

	var compareLink = "categoryId=" + category;
	var compareProductsHtml =
	"<div class='greyboxtop'>"
	+"		<span class='greyboxul'></span><span class='compareproducts'><strong>Compare products</strong></span><span class='greyboxur'></span>"
	+"</div>"
	+"<div class='greyboxbody'>"
	+"	<div id='compareproducts' class='greyboxbodypad'>"
	+"		For a side-by-side comparison of up to 4 products, click the ADD TO COMPARE link on each item. Then when you’ve made your list, click COMPARE below."
	+"		<p>Click <span class='deletelegend'><strong>X</strong></span> to remove</p>"
	+"		<table cellpadding='0' cellspacing='0' summary='List of products to compare'>"
	+"		<thead>"
	+"			<tr>"
	+"				<th scope='col'>Product image</th>"
	+"				<th scope='col'>Product name and description</th>"
	+"				<th scope='col'>Link to remove the product</th>"
	+"			</tr>"
	+"		</thead>"
	+"		<tbody>";
	

	
	for (var i = 0; i < productsArray.length; i++) {
		var product = productsArray[i];
		//sku:::name:::description:::image
		var productInfoArray = product.split(":::");
		compareProductsHtml = compareProductsHtml + 
		"			<tr>"
		+"				<td><a href='/cometbrowse/product.do?sku=" + productInfoArray[0] + "'><img alt='" + productInfoArray[1] + "' src='" + prod30 + productInfoArray[3] + "' /></a></td>"
		+"				<td><strong><a href='/cometbrowse/product.do?sku=" + productInfoArray[0] + "'>" + productInfoArray[1] + "</a></strong> " + productInfoArray[2] + "</td>"
		+"				<td class='delete'><span><a title='Click here to remove the " + productInfoArray[1] + " from the 'compare' list' href='javascript:deleteCompareProductAndDrawBox(\"" + category + "\",\"" + productInfoArray[0] + "\")'><strong>X</strong></a></span></td>"
		+"			</tr>";
		compareLink = compareLink + "&sku=" + productInfoArray[0];
	}
	
	compareProductsHtml = compareProductsHtml + 
	"		</tbody>"
	+"	</table>"
	+"	<div class='bottom'>"
	+"		<span class='btncompare'><a href='/cometbrowse/compare.do?" + compareLink + "'><strong>Compare</strong></a></span>"
	+"	</div> "
	+"   </div> "
	+"</div>"
	+"<div class='greyboxbottom'>"
	+"		<span class='greyboxdl'></span><span class='greyboxdr'></span>"
	+"</div>";
	
	return compareProductsHtml;

}



function getCompareProductsHtml(category) {

	// get the compare cookie
  var compareCookie = getCookie("compareproducts");
  compareCookie = unescape(compareCookie);
  
  // if the cookie exists then parse it for the correct category

  if (compareCookie != "nocookie") {
  
		var categoryString = getCategoryString(category, compareCookie);
		//alert("categoryString=" + categoryString);
		
		if (categoryString != "nocategory") {	
			var categoryStringPieces = categoryString.split("##");

			if (categoryStringPieces.length > 1) {

				var categoryProducts = categoryStringPieces[1];
				var productsArray = categoryProducts.split("*+*");
				return getCompareProductsHtmlFromProductArray(category,productsArray);
				
			}
			else
			{
				return getNoCompareProductsHtml();
			}
		}
		else
		{
			return getNoCompareProductsHtml();
		}
	}
	else
	{
		return getNoCompareProductsHtml();
	}
	
}	


function addToCompareAndDrawBox(category,sku,name,description,image) {

	addToCompare(category,sku,name,description,image);
	drawCompareProductsBox(category);
	
}


function drawRecentlyViewedAndCompareProductsBox(category) {
	drawRecentlyViewedProductsBox('');
	drawCompareProductsBox(category);

}


function deleteCompareProductAndDrawBox(category,sku) {
	deleteCompareProduct(category,sku);
	drawCompareProductsBox(category);

}