var testFilterArray = null;
var fm = null;
var globalTableCreation = 0;
var firstTime = true; 
var prevPage="-1";
var checkArray = new Array();
var beforeStockCheck = true;
var currentProduct="-1";
var postcodeObject = null;
var arrayOfElementArrays = new Array();
var showPageLock = false;
var IFrameDoc;

// Prem Nazeer - 24/01/06 - The following parameters are introduced for retain page no. requirement
var productListstartPage = 0;
var PAGE_NOCookie = '';
var filterElementCount = 0;
var filterCookieString  = '';
var cookieFilterValues = '';
var sortOrderCookie = '';
var sortOrderValue = "DOWN";
var cookieFilterValuesArray = '';
var casFilterCookieValue = "";
var maxPrice, minPrice;  // for maxPrice and minprice values 

function getFilterValue(filterElementIndex) {
	var returnValue = noSelectedItemTxt;
	if(cookieFilterValuesArray) {
		returnValue = cookieFilterValuesArray[filterElementIndex];
	}
	return returnValue;
}

// Prem Nazeer - 25/11/05 - retrieving the value of category Id to store it in cookies
var newcategory_OID = null;

if(category_OID== "") {
	newcategory_OID= criterion;
} else {
	newcategory_OID = category_OID;
}

function getListElement(elemName, idx)
{
// NMo: now uses cache to reduce processing overhead
      var elem = null;
      if ( arrayOfElementArrays[elemName] == null )
      {
      	 arrayOfElementArrays[elemName] = document.getElementsByName(elemName);
      }

      if( arrayOfElementArrays[elemName])
      {
        elem = arrayOfElementArrays[elemName][idx];
      }
      return elem;
}

function addToCartURL(number)
{
	
	var routerOperations = ["AddToCartUnknown"];
	var data = productData[number];
	var sku = data[0];
	// Hari - 08/02/06 - Passing routerOperation=DGEAddToCart instead of routerOperation=AddToCartUnknown to fix the multibuy issue. Take a look at the Bug ID 2673
    return (sChannelUrl + "&prev_results=no&page=MultibuyRouter&sku=" + sku + "&routerOperation=DGEAddToCart" + "&category_oid=" + data[16] + "&calling_page=Product&coverplan_for=" + sku + "&installation_for=" + sku);
}

function compare(sortOrder) 
{

    var sortSearch = true;
    if(this._filterUp == "UP")
      sortSearch = false;
    else
      sortSearch = true;
  
    var compCount = 0; 
    var sParameters = sChannelUrl;
    var sEval = ""; 
    var sParams = ""; 
    var sPage = "";
    var categoryOID = category_OID;
    var sDispLength = nproductsPerPage;
    if (testFilterArray.length < nproductsPerPage)
      sDispLength=testFilterArray.length;
      
    var pCategoryOid = categoryOID;
    if (pCategoryOid != "null" )
    {
      sParameters += "&category_oid=" + categoryOID;
    }
   
       sPage = "&page=Comparison" + pResultsString;
   
  productComparision(sortOrder);       
  sParameters += "&selectValues=" + escape(fm.getValues());
  sParameters += "&filterArray=" +  escape(testFilterArray);
  if(getListElement("sortOrder",0).value != '#')
  {
      sParameters += "&direction=" +  getListElement("sortOrder",0).value;
  }
  
  for (var i=0; i<testFilterArray.length; i++) 
   { 
      if (checkArray[productData[i][14]])
      {
        sParameters += "&product" + compCount + "=" + productData[i][0]; 
          compCount++; 
      } //end if 
    } //end for
  
  if (compCount == 0 && actualPCLength == 0)
  {
    alert("Please select products to add to the product comparison table.");
    return;
  }else if (compCount>5)
  {
    alert("Please select upto 5 products only.");
    return;
  }

    sParameters += sParams; 
    sParameters += sPage + "&number=" + compCount; 
    if (sortSearch == "true") 
    {
      sParameters += "&search=match"; 
    } 
    
    var priceParams = "";
    if(maxPrice != null) priceParams += "&lmax_price=" + maxPrice;
    if(minPrice != null) priceParams += "&lmin_price=" + minPrice;

    sParameters += menuParms;
    sParameters += priceParams;
    
    location = sParameters;
} 

function postcode_changed(postCode) 
{
	
	var pcexp = new Array ();
	pcexp.push (/^([a-z]{1,2}[0-9]{1,2})(\s*)([0-9]{1}[abdefghjlnpqrstuwxyz]{2})$/i);
	pcexp.push (/^([a-z]{1,2}[0-9]{1}[a-z]{1})(\s*)([0-9]{1}[abdefghjlnpqrstuwxyz]{2})$/i);
	pcexp.push (/^(GIR)(s*)(0AA)$/i);
	var valid = false;
	for (i=0; i<pcexp.length; i++) {
		if (pcexp[i].test(postCode)) {
			return true;
		}
	}
	
	if ( postCode.length <= 4 )
	{	
		var pcexp = new Array ();
		pcexp.push (/^[a-zA-Z]{1,2}[0-9]{1,2}\s*/);
		pcexp.push (/^[a-zA-Z]{1,2}[0-9]{1}[a-z]{1}\s*/);
		for (i=0; i<pcexp.length; i++) {
			if (pcexp[i].test(postCode)) 
			{
				return true;
			}
		}
	}
	alert("Invalid postcode !");
	return false;
}

function dosetDirection(obj,val)
{       
	
  //Prem Nazeer - 30/01/06 - List page retain requirement - setting cookies
  storeSortByValues();
  document.cookie = "CATEGORY_OID=";
  document.cookie = "CATEGORY_OID=" + newcategory_OID;
  
  	
  var rd = document.getElementById("RelDrop");
  var sortOrder = document.getElementById("sortOrder");
    if(rd)
      sortOrder.removeChild(rd);
  obj.setDirection(sortOrder);  
}

function setStockStatus(statusSpan, textValue){
		if(!statusSpan)
			return;
		if(!textValue)
			textValue = "<B>Add to basket to check stock.</B>";
		var IN_STOCK = 1;						//00000001
		var FORWARD_ORDER = 2;			//00000010
		var PRE_ORDER = 4;					//00000100
		var CAS = 8;								//00001000
		var ADD_TO_BASKET = 16;			//00010000
		var CHECKING_POSTCODE = 32;	//00100000
		var DISPLAY_ALL = IN_STOCK + FORWARD_ORDER + PRE_ORDER + CAS + ADD_TO_BASKET + CHECKING_POSTCODE;
		var displayLevel = statusSpan.displayLevel;
		if(!displayLevel)
			displayLevel = "DISPLAY_ALL";
		displayLevel = eval(displayLevel);
		var showTxt = "";
		if(( (textValue == inStockTxt)||
			(textValue == soldOutTxt) ||
			(textValue == cur_inStock_no_cas) ||
			(textValue == cur_SHD_NOT_CAS) ||
			(textValue == cur_SHD_AND_CAS) ) &&
				(displayLevel & IN_STOCK))
			showTxt = textValue;
		if((displayLevel & FORWARD_ORDER)&&
			(textValue.indexOf("FORWARD_ORD=") == 0)){
			if(CAS_LAYOUT_TYPE != 1)
				showTxt = textValue.split("=")[1];
			else{
				showTxt = textValue.substring(textValue.indexOf("=")+1,textValue.length);
			}
		}
		if(( (textValue.indexOf("Collect@Store") == 0) ||
			(textValue == cur_inStock_cas) || 
			(textValue == cur_no_inStock_cas))&&
			(displayLevel & CAS ))
			showTxt = textValue;
		if((displayLevel & PRE_ORDER)&&
			(textValue.indexOf("PRE_ORD=") == 0))
			showTxt = textValue.split("=")[1];
		statusSpan.innerHTML = "";
		if((textValue.toUpperCase().indexOf("ADD TO BASKET") == 0)&&
				(displayLevel & ADD_TO_BASKET ))
			showTxt = textValue;
		if((textValue.toUpperCase().indexOf("POSTCODE") != -1)&&
				(displayLevel & CHECKING_POSTCODE ))
			showTxt = textValue;
		
		//Updated for Currys Collect @ Store 30/06/2006
		//Updated for CAS_LAYOUT_TYPE compatability 21/07/2006
//	   	if(cServiceName != "Currys" || textValue.toUpperCase().indexOf("ADD TO BASKET") == 0){
	   	if(CAS_LAYOUT_TYPE != 1 || textValue.toUpperCase().indexOf("ADD TO BASKET") == 0){
			statusSpan.innerHTML = "<B>" + showTxt + "</B>" ;
		}
		else{
			statusSpan.innerHTML = showTxt;		
		}
		//Updation Ends
}
  
// rowNumber is the display row
// productNumber is the nth product in the input table.
function populateProductRow(rowNumber, productNumber)
{ 
//return;
  function clearChildren(elem)
  {
 	elem.innerHTML = "";
  }
  
  function setElementAttributes(elemID, attrs, elem)
  {
  	var undefined;
    if(!elem)
    {
    	// this gives us the display row
      	elem = getListElement(elemID, rowNumber);
      	if (elem == undefined )
      	{
      			alert("incorrect definition for "+elemID+":"+elem+": in ProductList_Page_HTML_Creation editorial");
      	}
    }
    if(elem)
    {
      	for(var i in attrs)
      	{
      		if(i != "clearChildren")
      		{
        		elem[i] = attrs[i]
        	}
        	else
        	{
			//clearChildren(elem);
			//should be no childNodes so safe to delete innerHTML
			elem.innerHTML = "";
		}
	}
    }
    return elem;
  }
  
 function appendChildText(elem, txt)
 {
  	var chld = null;
  	if( (elem) )
  	{
//  		chld = document.createTextNode(txt.replace("DOUBLEQUOTE",'"'));
  		elem.innerHTML = txt.replace("DOUBLEQUOTE",'"');
  	}
  	return chld;
  }
  
 function updateChildText(elemID, txt)
 {
   	var elem = getListElement(elemID, rowNumber);
  	if( (elem) )
  	{
  		if(elemID!="actualPriceValue") {
  			elem.innerHTML = txt.replace("DOUBLEQUOTE",'"');
  		} else {
  			elem.innerHTML = productPriceData[productData[productNumber][0]].replace("DOUBLEQUOTE",'"');
  		}
  	}
  }

  var productNewURL= productURL + "&sku=" + productData[productNumber][0] + 
  					"&category_oid=" + productData[productNumber][16];
  setElementAttributes("smallImgLink", {href: productNewURL});
  setElementAttributes("promoLink", {href: productNewURL});
  setElementAttributes("smallImg", {src: productData[productNumber][15]});
  var pbCompareTag = setElementAttributes("pbCompare", {clearChildren: ""});
  if (pbCompareTag)
  {
    if (pbAllowComparison)
    { 
	  //Updated for Currys Collect@Store, 30/06/2006
	  //Updated for CAS_LAYOUT_TYPE compatability, 21/07/2006
//	  if(cServiceName != "Currys"){
	  if(CAS_LAYOUT_TYPE != 1){
	      var addtoComparetext = document.createTextNode("Tick to compare");
		  pbCompareTag.appendChild(addtoComparetext);
	  }
	  //Updation ends

      var checkValueTag = document.createElement("input");
      setElementAttributes(null, {type : "checkbox", id: "add_to_comparison", name: "add_to_comparison", 
        			value: productData[productNumber][0]}, checkValueTag);
      pbCompareTag.appendChild(checkValueTag);
      checkValueTag.checked = checkArray[productData[productNumber][14]];
    }
  }
  
  // create mapping array between tag names and productData fields
  var fieldsPrdDataMap = {
  				brandId: 1,	modelId: 2, typeInfoId: 3, OldPriceText1: 10, OldPriceValue1: 11,
  				OldPriceText2: 8, OldPriceValue2: 9, savingText: 6, savingValue: 7, actualPriceValue: 5,
  				coverplanText: 12, dealText: 20
  				}  
  for(var itr in fieldsPrdDataMap)
  {
  	updateChildText(itr, productData[productNumber][fieldsPrdDataMap[itr]]);
  }
  
  updateChildText("webOnlyText",webOnlyTextData[productData[productNumber][0]]);  		 

  setElementAttributes("coverplanValue", {clearChildren:""});
  if(productData[productNumber][13] != "")
  {
  		setElementAttributes("coverplanValue", {innerHTML:  "<BR>£" + productData[productNumber][13]});	
  }
  var actualpriceTextTag = setElementAttributes("actualPriceText", {clearChildren: ""});
  var imageText = productData[productNumber][4];
  if (imageText.indexOf("IMAGE") != -1) 
  {
    imageText = imageText.replace("IMAGE","");
    var webImage = document.createElement("img");
    webImage.src = cImagePath+imageText;
    if (actualpriceTextTag != null)
    {
      	actualpriceTextTag.appendChild(webImage);
    }
  }
  else
  {
    	if (actualpriceTextTag != null)
    	{
      		actualpriceTextTag.innerHTML=imageText;
      	}
  }
  if (productData[productNumber][17] != "")
  {
  	updateChildText( "deliveryId", productListDeliveryText + productData[productNumber][17]);
  }
  if(productData[productNumber][19] != "")
  {
  	productData[productNumber][18] = productData[productNumber][19];
  }
  if(CAS_LAYOUT_TYPE != 1 && productData[productNumber][18] == -3)
  {
  	productData[productNumber][18] = "Add to basket";
  }
  var addToBasketTag = getListElement("addToBasket", rowNumber);
  if(addToBasketTag){
	//Refactoring, beforeStockCheck part,
	//Try to reduce code, Made during Currys CAS, 17/08/2006
	if (beforeStockCheck){
   		if(addToBasketTag){
   			addToBasketTag.innerHTML = "";
       		var anchorTag= document.createElement("a");
   		}
   		anchorTag.href = cServiceName == "The_Link" ? productNewURL : addToCartURL(productNumber);
   		//innerCellTextList = document.createTextNode("Add to Basket"); Not Required
		
		//Add Different Images & Text for Different Cases
		var addImagePath = "";
		var tempElem = getListElement("stock_status_txt", rowNumber);

		if(productData[productNumber][18] == "-1"){
   			anchorTag.href = "javascript:displayPostcode(" + rowNumber+ ", " + productNumber +");";
			addImagePath =  cImagePath + "wheel/buttons/pl_check_availability.gif";
		}else{
			addImagePath =  cServiceName == "The_Link" ? (cImagePath + "lin_pl_add_basket.gif") : (cImagePath + "wheel/buttons/pl_gen_addtobasket.gif");
			anchorTag.href = "javascript:addToBasket( \""+anchorTag.href+"\" , '"+addImagePath+"',"+ productNumber+","+rowNumber +" );";
		}
		var productDiv = document.createElement("div");
		productDiv.id = "stock_div_"+productData[productNumber][0];
		var img = document.createElement("img");
		img.removeAttribute("width");
		img.removeAttribute("height"); 
		var ImageTag = setElementAttributes(null,{border: 0,name:"stock_" + productData[productNumber][0], alt: "Add to basket to check stock",src: addImagePath},img);

		if(CAS_LAYOUT_TYPE == 1){
       		setStockStatus(tempElem, "Add to basket to check stock");
		}
		var tempElem = getListElement("stock_status_txt", rowNumber);

		//Updated for CAS_LAYOUT_TYPE compatabililty , 08/08/2006

		//Set Text status for 
		if((productData[productNumber][18] == "-1") || (productData[productNumber][18] == "-3")){
			if(CAS_LAYOUT_TYPE != 1)
		    	setStockStatus(tempElem, "Add to basket to check stock");
			else
				if(prodTypeData[productData[productNumber][0]] == "RESERVE & COLLECT" && productData[productNumber][18] == "-1")
					setStockStatus(tempElem, cur_inStock_cas);
				else
					setStockStatus(tempElem, cur_inStock_no_cas);
		}else{
	    	setStockStatus(tempElem, "Add to basket to check stock");
		}
		if (addToBasketTag !=null){
			if(anchorTag)
				addToBasketTag.appendChild(productDiv);
		}
		anchorTag.appendChild(ImageTag);
		productDiv.appendChild(anchorTag); 
	}
	//Refactoring Ends, 17/08/2006
	//Refactoring, AfterStockCheck part,
	//Try to reduce code, Made during Currys CAS, 17/08/2006
	else {
		//Get or Create new Image Object
		var img = "";
		if(addToBasketTag.childNodes[0] && addToBasketTag.childNodes[0].childNodes[0] && addToBasketTag.childNodes[0].childNodes[0].childNodes[0]){
			img = addToBasketTag.childNodes[0].childNodes[0].childNodes[0];
	    } else {
			img = setElementAttributes(null,{name:  "stock_" + 
					productData[productNumber][0]}, document.createElement("img"));
      	}
		img.removeAttribute("width");
		img.removeAttribute("height");
		img.border = 0;
		//setStockStatus(setElementAttributes("stock_status_txt", {innerHTML:""}), "Add to basket to check stock");
		//Get or Create new anchor element
		var anc;
	    if (addToBasketTag.childNodes[0] && addToBasketTag.childNodes[0].childNodes[0]){ 
			anc = addToBasketTag.childNodes[0].childNodes[0];
	        anc.appendChild(img);
	    } else {
		    anc = document.createElement("a");
	        //addToBasketTag.appendChild(anc);
		    anc.appendChild(img);
	    }

		var productDiv = "";
		if(addToBasketTag.childNodes[0]){
			productDiv = addToBasketTag.childNodes[0];
		}
		else{
			var productDiv = document.createElement("div");
			productDiv.id = "stock_div_"+productData[productNumber][0];
	        addToBasketTag.appendChild(productDiv);
			productDiv.appendChild(anc);
		}

		//Variables to set stock status
		var tempElem = getListElement("stock_status_txt", rowNumber);
		var stockStatusTxt = "";
		if(productData[productNumber][18] == soldOutTxt){
			anc.disabled = true;
			anc.removeAttribute("href");
			setElementAttributes(null,{border:0, alt: "Out of stock", src: cImagePath + "wheel/buttons/pl_out_of_stock.gif"}, img);
			stockStatusTxt = soldOutTxt;
    	}else if(productData[productNumber][18] == "-1"){
			anc.href = "javascript:displayPostcode(" + rowNumber+ ", " + productNumber +");";
			img.alt = "";
			img.title = "";

			var imagePath = cImagePath + "wheel/buttons/pl_check.gif";
        	setElementAttributes(null, {src:imagePath}, img);
        	
			var tempElem = getListElement("stock_status_txt", rowNumber);
			//Updated for Currys Collect@Store 19/07/2006
			//Updated for CAS_LAYOUT_TYPE compatabililty , 21/07/2006
			//if(cServiceName != "Currys"){
			if(CAS_LAYOUT_TYPE != 1){
	        	stockStatusTxt = "";
			}else{
				if(prodTypeData[productData[productNumber][0]] == "RESERVE & COLLECT" )
					stockStatusTxt = cur_inStock_cas;
				else
					stockStatusTxt = cur_inStock_no_cas;
			}
			//Updation ends
		}else{
   			anc.href = cServiceName == "The_Link" ? productNewURL : addToCartURL(productNumber);
   			anc.disabled = false;
			img.alt = "add to basket";

			if(cServiceName == "The_Link"){
				setElementAttributes(null,{src: cImagePath+"lin_pl_add_basket.gif"}, img);
			}
			else{
				setElementAttributes(null,{src: cImagePath+"wheel/buttons/pl_gen_addtobasket.gif"}, img);
			}
			anc.href = "javascript:addToBasket( \""+anc.href+"\" , '"+img.src+"',"+ productNumber+","+rowNumber+");";
			
			
			if(productData[productNumber][18].indexOf("SHD") != -1){
				//Updated for CAS_LAYOUT_TYPE compatabililty , 08/08/2006
				if(CAS_LAYOUT_TYPE != 1){
	       			stockStatusTxt = "";
				}else{
					stockStatusTxt = (prodTypeData[productData[productNumber][0]] == "RESERVE & COLLECT" ) ? cur_SHD_AND_CAS : cur_SHD_NOT_CAS;
				}
				//Updation ends
			}else{
				stockStatusTxt = productData[productNumber][18];
			}
		}
   		setStockStatus(tempElem,stockStatusTxt);
		//Refactoring Ends, 17/08/2006
	}
  }
}


function displayPostcode(productNumber, arrayProdId){
	
  currentProduct=arrayProdId;
  if(!postcodeObject)
  	postcodeObject = ldcPopUp();
  else{
  if(postcodeObject.parent)
  	postcodeObject.parent.removeChild(postcodeObject);
	}
	if(postcodeObject.lastImage)
  	postcodeObject.lastImage.style.display = "";
  var postcodeEntry=getListElement("dlg_enterPostcode", productNumber);
  postcodeEntry.appendChild(postcodeObject);
  postcodeObject.parent = postcodeEntry;
  postcodeObject.statusElement = getListElement("stock_status_txt", productNumber);
  postcodeObject.lastImage = getListElement("addToBasket", productNumber);
  if(postcodeObject.lastImage)
  	postcodeObject.lastImage.style.display = "none";
  postcodeObject.style.display = "";
  var pc = dsg_getPostcode();
  if(pc){
  	postcodeObject.pcode1.value = pc[0];
  	postcodeObject.pcode2.value = pc[1];
  }
}

function addToBasket(url, addImagePath,productNumber,rowNumber){
		var addToBasketTag = getListElement("addToBasket", rowNumber);
		var img = "";
		if(addToBasketTag.childNodes[0] && addToBasketTag.childNodes[0].childNodes[0] && addToBasketTag.childNodes[0].childNodes[0].childNodes[0]){
			img = addToBasketTag.childNodes[0].childNodes[0].childNodes[0];
	        addToBasketTag.childNodes[0].childNodes[0].removeChild(addToBasketTag.childNodes[0].childNodes[0].childNodes[0]);
	    } else {
			img = setElementAttributes(null,{name:  "stock_" +productData[productNumber][0]}, document.createElement("img"));
      	}
		img.removeAttribute("width");
		img.removeAttribute("height");
		img.border = 0;

		var anc;
	    if (addToBasketTag.childNodes[0] && addToBasketTag.childNodes[0].childNodes[0]){ 
	        addToBasketTag.childNodes[0].removeChild(addToBasketTag.childNodes[0].childNodes[0]);
	    }

		var productDiv = "";
		if(addToBasketTag.childNodes[0]){
			productDiv = addToBasketTag.childNodes[0];
			productDiv.appendChild(img);
		}
		else{
			var productDiv = document.createElement("div");
			productDiv.id = "stock_div_"+productData[productNumber][0];
	        addToBasketTag.appendChild(productDiv);
			productDiv.appendChild(img);
		}
		window.location = ""+url;
	}
	
	function productComparision(sortOrder)
	{

  var filterArray = testFilterArray;
  var totalProducts = filterArray.length;
  var productsPerPage = nproductsPerPage;
  var rowsToSkip = (prevPage * productsPerPage)
  //var displayRows = 0;
  var rowsDisplayed = 0;
  if (sortOrder=="DOWN")
  {
    for(i=0; i<totalProducts; i++)
    {
      if ((filterArray[i] > -1) && (filterArray[i] != null) && (rowsDisplayed<productsPerPage))
      {
        //displayRows++;
        if (rowsToSkip==0)
        { 
          var sEval2=document.getElementsByName("add_to_comparison");
              sEval2 = sEval2.item(rowsDisplayed);
              if (sEval2 !=null)
              {
            checkArray[productData[i][14]] = sEval2.checked;
          }
          rowsDisplayed++;
        }else rowsToSkip--;
      } //else if ((filterArray[i] > -1) && (filterArray[i] != null)) 

    }
  }
  else if(sortOrder=="UP")
  {
    
    for(i=totalProducts-1; i>=0; i--)
    {
      if ((filterArray[i] > -1) && (filterArray[i] != null) && (rowsDisplayed<productsPerPage))
      {
        //displayRows++;
        if (rowsToSkip==0)
        { 
          var sEval2=document.getElementsByName("add_to_comparison");
              sEval2 = sEval2.item(rowsDisplayed);
              if (sEval2 !=null)
              {
            checkArray[productData[i][14]] = sEval2.checked;
          }
          rowsDisplayed++;
        }else rowsToSkip--;
      }
    } 
  }
  else if (sortOrder=="RANK")
  {
    for(i=0; i<totalProducts; i++)
    {
      if ((filterArray[rankingArray[i][0]] > -1) && (filterArray[rankingArray[i][0]] != null) && (rowsDisplayed<productsPerPage))
      {
        //displayRows++;
        if (rowsToSkip==0)
        { 
          var sEval2=document.getElementsByName("add_to_comparison");
              sEval2 = sEval2.item(rowsDisplayed);
              if (sEval2 !=null)
              {
            checkArray[productData[rankingArray[i][0]][14]] = sEval2.checked;
          }
          rowsDisplayed++;
        }else rowsToSkip--;
      } //else if ((filterArray[i] > -1) && (filterArray[i] != null)) 

    }
  }
}

function showPage(page, sender, drctn)
{
 // Prem Nazeer - 23/01/06 - Changes  made for rataining the page no. 
  //			    when the user return back from the product detail page.
  document.cookie = "PAGE_NO=";
  document.cookie = "CATEGORY_OID=";
  document.cookie = "PAGE_NO=" + page;
  document.cookie = "CATEGORY_OID=" + newcategory_OID;
  productListstartPage = page;

  if ( showPageLock == true )
  {
  	showPageLock = false;
  	return;
  }
  showPageLock = true;
  
var startTime = new Date();
  if(sender.sender)
    sender = sender.sender;
  if(postcodeObject){
  	postcodeObject.style.display = "none";
  	if(postcodeObject.lastImage)
  		postcodeObject.lastImage.style.display = "";
  }
  
  var oTable = document.getElementById("productsOuterTable");
  var oTbody = oTable.tBodies[0];
  var rowsDisplayed = 0;
  var productsPerPage = nproductsPerPage;
  var filterArray = testFilterArray;
  var totalProducts = filterArray.length;
  var rowsToSkip = (page * productsPerPage)
  var displayRows = 0;
  var comparison_header = "";
  var sResultsText = "";
  var sortOrder = drctn;

  productComparision(sortOrder);
  
  if (sortOrder=="DOWN")
  { 
    for(i=0; i<totalProducts; i++)
    {
      if ((filterArray[i] > -1) && (filterArray[i] != null) && (rowsDisplayed<productsPerPage))
      {
        displayRows++;
        if (rowsToSkip==0)
        { 
          oTbody.rows[rowsDisplayed].style.display = '';
          populateProductRow(rowsDisplayed,i);
          rowsDisplayed++;
        }else rowsToSkip--;
      } else if ((filterArray[i] > -1) && (filterArray[i] != null)) 
      { 
        displayRows++;
      }
    }
  }
  else if(sortOrder=="UP")
  {
    for(i=totalProducts-1; i>=0; i--)
    {
      if ((filterArray[i] > -1) && (filterArray[i] != null) && (rowsDisplayed<productsPerPage))
      {
        displayRows++;
        if (rowsToSkip==0)
        { 
          oTbody.rows[rowsDisplayed].style.display = '';
          populateProductRow(rowsDisplayed,i);
          rowsDisplayed++;
        }else rowsToSkip--;
      } else if ((filterArray[i] > -1) && (filterArray[i] != null)) 
      { 
        displayRows++;
      }
    } 
    
  }
  else if (sortOrder=="RANK")
  { 
    // default sort function just in case "sortRankFn" is not found
    // "sortRankFn" lives in productListSort.js and is configurable by chain
    function sortRankDefaultFn(a, b) {
    	return a[1] - b[1];
    }

    if (typeof sortRankFn == "function")
    	rankingArray.sort(sortRankFn);
    else
    	rankingArray.sort(sortRankDefaultFn);
    
    for(i=0; i<totalProducts; i++)
    {
      if ((filterArray[rankingArray[i][0]] > -1) && (filterArray[rankingArray[i][0]] != null) && (rowsDisplayed<productsPerPage))
      {
        displayRows++;
        if (rowsToSkip==0)
        { 
          oTbody.rows[rowsDisplayed].style.display = '';
          populateProductRow(rowsDisplayed,rankingArray[i][0]);
          rowsDisplayed++;
        }else rowsToSkip--;
      } else if ((filterArray[rankingArray[i][0]] > -1) && (filterArray[rankingArray[i][0]] != null)) 
      { 
        displayRows++;
      }
    }
  }
  //Hide the rows if rowsDisplayed < productsPerPage
  for(var i=rowsDisplayed; i<productsPerPage; i++)
  {
    oTbody.rows[i].style.display='none';
  }
    
  var pages = displayRows / productsPerPage;
  var wholePages = Math.floor(pages);
  if (pages - wholePages > 0) pages = wholePages + 1;
  
  var sResultsTextTag = document.getElementById("sResultsText_span");
  var sPrevNextfooterTag = document.getElementById("sPrevNextfooter_span");
  
  var sResultsText_footerTag = document.getElementById("sResultsText_footer");
  var sPrevNextTag = document.getElementById("sPrevNextheader_span");
  var cellTextPrev = document.createTextNode("<Previous"+"\u00a0"+"\u00a0"+"\u00a0");
  var cellTextNext = document.createTextNode("Next>");
  
  var prevAnchor = document.createElement("a")
  var nextAnchor = document.createElement("a")
  sPrevNextTag.innerHTML="";
  sPrevNextfooterTag.innerHTML="";
  
  sResultsTextTag.innerHTML="";
  sResultsText_footerTag.innerHTML="";
    
  // Prem Nazeer - 24/01/06 - If the current page is greater than the total no. of pages,
  //			      resetting the current page to 0.
  if (page > pages) {
  	page = 0;
  	document.cookie = "PAGE_NO=";
  	document.cookie = "PAGE_NO=" + page;
  	productListstartPage = page;
  }
  
  for (var i=0; i<pages; i++)
  {
    if (i==page)
    {

      var deeprednodecTag=document.createElement("span");
      deeprednodecTag.className="pagenumber-active";
      var pagingText = document.createTextNode((i+1)+" ");
      deeprednodecTag.appendChild(pagingText);
      sResultsTextTag.appendChild(deeprednodecTag);
      prevPage = i;
      prevPagerowsDisplayed=rowsDisplayed;
      
      if(i!=0)
      {
        prevAnchor.href = "javascript:showPage("+ (i-1)+ ",this,'"+sortOrder+"');document.getElementById('total_id').focus();setHistory(" + (i-1) + ");";
        prevAnchor.appendChild(cellTextPrev);
        sPrevNextTag.appendChild(prevAnchor);
      }
      if(i<pages-1)
      {
        nextAnchor.href = "javascript:showPage("+ (i+1)+ ",this,'"+sortOrder+"');document.getElementById('total_id').focus();setHistory(" + (i+1) + ");";  
        nextAnchor.appendChild(cellTextNext);
        sPrevNextTag.appendChild(nextAnchor);
      }
      
    }
    else
    { 
      var inactiveTag=document.createElement("span");
      inactiveTag.className="pagenumber-inactive";
      var pagingAnchor = document.createElement("a");
      pagingAnchor.href = "javascript:showPage("+ i+ ",this,'"+sortOrder+"');document.getElementById('total_id').focus();setHistory(" + i + ");";
      pagingAnchor.sender = sender;
      var pagingText = document.createTextNode((i+1)+" ");
      pagingAnchor.appendChild(pagingText);
      inactiveTag.appendChild(pagingAnchor);
      sResultsTextTag.appendChild(inactiveTag);
    }
  }
  sResultsText_footerTag.innerHTML=sResultsTextTag.innerHTML;
  sPrevNextfooterTag.innerHTML = sPrevNextTag.innerHTML;

  if(pbAllowComparison)
  { 
	//Updated for Currys Collect@Store , 07/07/2006
	//Updated for CAS_LAYOUT_TYPE , 21/07/2006
	//if(cServiceName != 'Currys')
	if(CAS_LAYOUT_TYPE != 1)
	    comparison_header = '<a href="JavaScript:compare(\''+sortOrder+'\');"><img src="' + 
    	cImagePath + 'wheel/buttons/pl_compare.gif" border=0 alt="To compare up to 5 products, tick the boxes and click here."></a>';
	else
	    comparison_header = '<a href="JavaScript:compare(\''+sortOrder+'\');"></a>';
	//Updation ends
    
    var cmp_txtheaderTag = document.getElementById("cmp_txt_span");
    if(cmp_txtheaderTag.innerHTML == '')
      cmp_txtheaderTag.innerHTML=cmp_txt;
  
    var comparison_headerTag = document.getElementById("comparison_header_span");
    comparison_headerTag.innerHTML=comparison_header;
    
    var comparison_footerTag = document.getElementById("comparison_footer");
    comparison_footerTag.innerHTML=comparison_header;
    
    var cmp_txt_footerTag = document.getElementById("cmp_txt_footer");
    if(cmp_txt_footerTag.innerHTML == '')
      cmp_txt_footerTag.innerHTML=cmp_txt;
    
   }
    
  var sortPrice = null;
  var sortOrderTag = document.getElementById("sortOrder_span")
  if(!document.getElementById("sortOrder"))
  {
    sortPrice = document.createElement("Select");
    sortPrice.value=sortOrder;
    sortPrice.id ="sortOrder";
    sortPrice.name="sortOrder";    
    //as the onchange event is called immediaely, make 2
    //and the first one will be deleted.......
    if (fromSearch)
    for(var i = 1; i < 2; i++){
      var option = document.createElement("option");
      
      option.value = "4";
      option.innerHTML = "Closest match";   
      option.id = "RelDrop";
      if(sortOrderCookie == option.value) 
      {
       option.selected = true;
       option.value = "4";
      }
      sortPrice.appendChild(option);
    }
    if (typeof rankingArray != "undefined") {
        var option = document.createElement("option");
        option.value = "RANK";
        option.innerHTML = rankingDescription;
        if(sortOrderCookie == option.value) {
           option.selected = true;
           option.value = "RANK";
        }
        sortPrice.appendChild(option);
    }
    
    var option = document.createElement("option");
    option.value = "DOWN";
    option.innerHTML = "price - lowest first";
    if(sortOrderCookie == option.value) {
       option.selected = true;
       option.value = "DOWN";
    }
    sortPrice.appendChild(option);

    option = document.createElement("option");
    option.value = "UP";
    option.innerHTML = "price - highest first";
    if(sortOrderCookie == option.value) 
    {
       option.selected = true;
       option.value = "UP";
    }
    sortPrice.appendChild(option);
    sortPrice.sender = sender;
    sortOrderTag.appendChild(sortPrice);   
    if(("UPDOWN".indexOf(directionVal) != -1)&&
      (directionVal != ''))
      sortPrice.value = directionVal;
      directionVal = '';
  }
  if(sortPrice != null)
  {
    sortPrice.onchange = function(){resetPageStartNo();dosetDirection(sortPrice.sender, sortPrice)};
    dosetDirection(sortPrice.sender, sortPrice);
    if(sortOrderCookie!='') {
    	drctn = sortOrderCookie;
    }
  }
  
  document.getElementById("noscriptDIV").style.visibility = "hidden";
  document.getElementById("scriptDIV").style.visibility = "visible";
  
  //var location = window.parent.location;
      
  if ( showPageLock == false )
  {
  	showPage(page, sender, drctn);	
  }
  else
  {
  	showPageLock = false;
  }
  
 
 }
 

function filterTable(filterArray,sortMethod, sender)
{
  
  var oTable = document.getElementById("productsOuterTable");
  var oTbody = oTable.tBodies[0];
  var arrLength = filterArray.length;
  if (globalTableCreation == 0)
  {
    	if (oTbody)
    	{
    		while (oTable.rows.length > 0)
    		{
      			oTable.deleteRow(0); 
      		}
        }
        else
        {
		oTbody = document.createElement("tbody");
		oTable.appendChild(oTbody);
	}
    	for (var rowIndex = 0; rowIndex < nproductsPerPage; rowIndex++)
    	{
          	var OutertableRow = document.createElement("TR");
      		var rowCell = document.createElement("TD");
      		OutertableRow.appendChild(rowCell)
      		rowCell.innerHTML = productListHTML;
      		oTbody.appendChild(OutertableRow);
    	}
    	globalTableCreation = 1;
  }
  else
  {
      	for(var i=0; i<testFilterArray.length; i++)
      	{
      		checkArray[productData[i][14]] = false;
      	}
    	
    	for(var i =0; i <nproductsPerPage; i++)
    	{
      		var sEval2=document.getElementsByName("add_to_comparison");
      		sEval2 = sEval2.item(i);
      		if (sEval2 !=null)
      		{
        		sEval2.checked = false;
      		}
    	}
  }
  var sortOrder = sortMethod;
  
  // Prem Nazeer - the parameter productListstartPage has been introduced to determine the starting page no.  
  if(PAGE_NOCookie != '') {
    	productListstartPage = PAGE_NOCookie;
  } else {
  	productListstartPage = 0;
  }
  
  showPage(productListstartPage, sender, sortMethod);
  //showPage(0, sender, sortMethod);
      
}
  
function callAddToCartURL(currentProduct,pcode1,pcode2){
  postcodeObject.style.display = "none";
  if(postcodeObject.statusElement){
	//Updated for Currys Collect@Store project, 20/07/2006
	//Updated for CAS_LAYOUT_TYPE, 21/07/2006
	//if(cServiceName != "Currys"){
	if(CAS_LAYOUT_TYPE != 1){
	  	postcodeObject.statusElement.innerHTML =  "<B>Performing postcode lookup</B>";
	}
	else{
		postcodeObject.statusElement.innerHTML = "<B>Please wait</B>";
    }
  }
  dsg_setPostcode(pcode1,pcode2);
  document.location.href=addToCartURL(currentProduct) +"&postcode1="+pcode1+"&postcode2="+pcode2;
}


function ldcPopUp(){
	
    var postcodeEntry = document.createElement("table");
    var elem = postcodeEntry;
    elem.width = "100%";
    //postcodeEntry.appendChild(elem);
    var tbody = document.createElement("tbody");
    elem.appendChild(tbody);
    elem = document.createElement("tr");
    tbody.appendChild(elem);
    var elem2 = document.createElement("td");
    elem.appendChild(elem2);
    elem2.colSpan = 4;
    elem = document.createElement("b");
    elem2.appendChild(elem);
    elem.innerHTML = "Enter&nbsp;your&nbsp;postcode";
    elem = document.createElement("tr");
    tbody.appendChild(elem);
    elem2 = document.createElement("td");
    elem.appendChild(elem2);
    elem2.align = "right";
    var pcode1 = document.createElement("input");
    pcode1.type = "text";
    pcode1.maxlength = 4;
    pcode1.size = 4;
    elem2.appendChild(pcode1);
    var pcode2 = document.createElement("input");
    pcode2.type = "text";
    pcode2.maxlength = 3;
    pcode2.size = 3;
    elem2 = document.createElement("td");
    elem.appendChild(elem2);
    elem2.appendChild(pcode2);
    elem2 = document.createElement("td");
    elem.appendChild(elem2);
    var pcodeBtn = document.createElement("input");
    pcodeBtn.type = "button";
    pcodeBtn.value = "OK";
    pcodeBtn.onclick=function(){if(postcode_changed(pcode1.value + " " + pcode2.value)) callAddToCartURL(currentProduct,pcode1.value,pcode2.value)};
    elem2.appendChild(pcodeBtn);
    postcodeEntry.style.display = "none"; 
    return postcodeEntry;
}

// Prem Nazeer - 22/02/06 - Added for Back Button functionality
function historyChange(newLocation, historyData) {

	if(newLocation == null || newLocation == '') {
		buildInitialFilterValues();
		productListstartPage = 0;
		if (typeof rankingArray == "undefined") {
		    sortOrderValue = "DOWN";
		} else {
		    sortOrderValue = "RANK";
		}
		newLocation = cookieFilterValues + ":PageNo_"+ productListstartPage + ":SortOrder_"+ sortOrderValue;
	}
	
	var newPageNo = "";
	var newFilterValues = "";
	var newSortOrderValue = "";
	if(testFilterArray!=null) {

	        var regExp = /(.*?):PageNo_(.*?):SortOrder_(.*?)$/
		var matchArray = regExp.exec(newLocation);

		if(matchArray!=null && matchArray.length>0) {
			newFilterValues = matchArray[1];
			newPageNo = matchArray[2];
			newSortOrderValue = matchArray[3];
		}
	        
	        if(newPageNo!=null && newPageNo!='') 
	        {
	        	if(newFilterValues!=null && newFilterValues!='') {
	        		cookieFilterValues = newFilterValues;
	        		document.cookie = "FILTER_VALUES=" + cookieFilterValues;
	        		cookieFilterValuesArray = cookieFilterValues.split(":");
	        	}
	        	
	        	if(newSortOrderValue!=null && newSortOrderValue!='') {
	        		sortOrderCookie  = newSortOrderValue;
	        		document.cookie = "SORT_ORDER=" + sortOrderCookie;		
				fm._filterUp = sortOrderCookie;
	        	} else {
	        		newSortOrderValue = sortOrderValue;
	        		sortOrderCookie  = newSortOrderValue;
	        		document.cookie = "SORT_ORDER=" + sortOrderCookie;		
				fm._filterUp = sortOrderCookie;
	        	}
	        	
	        	PAGE_NOCookie = newPageNo;
	        	document.cookie = "PAGE_NO=";
	  		document.cookie = "PAGE_NO=" + PAGE_NOCookie;
	  		productListstartPage = newPageNo;
  		
	  		setSortByValues(newSortOrderValue);
	  		if(filterCookieString != cookieFilterValues) {
	  		
		  		selectedValues = fm.setFilterValues();
		  		if(selectedValues){
		  			fm.setValues(selectedValues);	
		  		}
		  		fm.modifyFilterAttributes();
	  		} else {
	  			showPage(newPageNo,this,sortOrderCookie);
	  		}
	  		
	  	}
	}
}

// Prem Nazeer - 22/02/06 - Added for Back Button functionality - to setFilterValues back on filters.
function FilterManager_setFilterValues() {

	var selectedValues = new Array();
	var ref = this;
	for(var filterIndex = 0;filterIndex<filterElementCount;filterIndex++) {
		var filterObject = document.getElementById("filterElementId_" +filterIndex);
		this.oSelect = filterObject;
		currentFilterValue = getFilterValue(filterIndex);
		for(var j=0;j<filterObject.options.length;j++) {
			
			if(filterObject.options[j].value == currentFilterValue ) {
				//filterObject.options[j].value = currentFilterValue;
				//filterObject.options[j].selected = true;
				selectedValues.push(j);
			}
		}
	}
	return selectedValues;
}

// Prem Nazeer - 22/02/06 - Added for Back Button functionality - to reset the Sortby value
function setSortByValues(sortByValue) {
	
		var sortBySelectObject = document.getElementById("sortOrder");
		
		for(var j=0;j<sortBySelectObject.options.length;j++) {
			if(sortBySelectObject.options[j].value == sortByValue ) {
				sortBySelectObject.options[j].selected = true;
			}
		}
}

// Prem Nazeer - 22/02/06 - Added for Back Button functionality - to set values in Browser History
function setHistory(pageNo) {
	
	var modifiedLocation = cookieFilterValues + ":PageNo_"  + pageNo + ":SortOrder_"+ sortOrderValue;
	var historyData = "Product List - Page No :" + pageNo;
	dhtmlHistory.add(modifiedLocation, historyData);
}

function doNothing() {
// this empty function required for back button functionality
}

function pageInit()
{
	
	dhtmlHistory.initialize();
	dhtmlHistory.addListener(historyChange);
	var currLocation = dhtmlHistory.getCurrentLocation();

  	//Getting the CATEGORY_OID from cookie
  	var CATEGORY_OIDCookie = '';
	if (document.cookie.length > 0){ 
		var begin = document.cookie.indexOf("CATEGORY_OID="); 
    		if (begin != -1){
      			begin += "CATEGORY_OID=".length; 
      			end = document.cookie.indexOf(";", begin);
      			if (end == -1) end = document.cookie.length;
        		CATEGORY_OIDCookie = unescape(document.cookie.substring(begin, end)); 
    		} 
  	}
  
	//Getting the FROM_LEFT_NAV from cookie
	var FROM_LEFT_NAVCookie = '';
	if (document.cookie.length > 0){ 
		var begin = document.cookie.indexOf("FROM_LEFT_NAV="); 
		if (begin != -1){
			begin += "FROM_LEFT_NAV=".length; 
			end = document.cookie.indexOf(";", begin);
			if (end == -1) end = document.cookie.length;
			FROM_LEFT_NAVCookie = unescape(document.cookie.substring(begin, end)); 
		} 
	}
  	if(newcategory_OID==CATEGORY_OIDCookie && FROM_LEFT_NAVCookie!='TRUE') {

		//Prem Nazeer - 24/01/06 - Getting the PAGE_NO from cookie
		if (document.cookie.length > 0){ 
           		var begin = document.cookie.indexOf("PAGE_NO="); 
			if (begin != -1){
          			begin += "PAGE_NO=".length; 
          			end = document.cookie.indexOf(";", begin);
          			if (end == -1) end = document.cookie.length;
             			PAGE_NOCookie = unescape(document.cookie.substring(begin, end)); 
       			} 
      		}
	
		//Prem Nazeer - 24/01/06 - Getting the SORT_ORDER from cookie
		if (document.cookie.length > 0){ 
			var begin = document.cookie.indexOf("SORT_ORDER="); 
			if (begin != -1){
				begin += "SORT_ORDER=".length; 
				end = document.cookie.indexOf(";", begin);
				if (end == -1) end = document.cookie.length;
				sortOrderCookie = unescape(document.cookie.substring(begin, end)); 
			} 
		}
	 	
	      //Prem Nazeer - 25/01/06 - Retrieving FilterValues from the cookie
		if (document.cookie.length > 0){ 
			var begin = document.cookie.indexOf("FILTER_VALUES="); 
			if (begin != -1){
				begin += "FILTER_VALUES=".length; 
				end = document.cookie.indexOf(";", begin);
				if (end == -1) end = document.cookie.length;
				cookieFilterValues = unescape(document.cookie.substring(begin, end));
			} 
		}
         
	} else {
      	
		document.cookie = "CATEGORY_OID=";
		//Prem Nazeer - 24/01/06 - Resetting the PAGE_NO cookie if the category is different
		document.cookie = "PAGE_NO=";
		document.cookie = "FILTER_VALUES=";
		document.cookie = "SORT_ORDER=";
		document.cookie = "RESULTS_PER_PAGE=";
		PAGE_NOCookie = '';
		cookieFilterValues = '';
		sortOrderCookie = '';
      }
	
	// Prem Nazeer - 03/02/06 - Added for resetting FROM_LEFT_NAV cookie
	var FROM_LEFT_NAVCookie = 'FALSE';
	document.cookie = "FROM_LEFT_NAV=" + FROM_LEFT_NAVCookie;
	
	if(currLocation==null || currLocation=="") {
		
		if(filterCookieStringFromQuery != null || filterCookieStringFromQuery != '')
		{
				cookieFilterValues = filterCookieStringFromQuery;
		}
		else if(cookieFilterValues==null || cookieFilterValues=='') 
		{
				cookieFilterValues = filterCookieString;
		}

		if(sortOrderCookie==null || sortOrderCookie=='') {
        		if (typeof rankingArray == "undefined") {
        		    sortOrderCookie = "DOWN";
        		} else {
        		    sortOrderCookie = "RANK";
        		}
		}
		
		var pageNo = PAGE_NOCookie;
		if(PAGE_NOCookie==null || PAGE_NOCookie=='') {
			pageNo = 0;
		} 
		
		if(cookieFilterValues==null || cookieFilterValues=='') {
			storeFilterValues();
		}
	
		//setHistory(pageNo); 
	}

	cookieFilterValuesArray = cookieFilterValues.split(":");
	testFilterArray = null;
	initFactTable();
  
	if(selectValues){
		fm.setValues(selectValues);
	}
	
	// Hari - 27-July-2006 - Do not do stock checking for Instore Clone
	if (cChannelName != "STR") {	  
		setTimeout("performMultipleATPStockCheck()", 150);
	}

	document.body.onunload = function(){cleanup()}; 
}

function cleanup(){
	
	if((postcodeObject) && (postcodeObject.parent))
		postcodeObject.parent = null;
	fm.undoEvents();
	document.getElementById("sortOrder").onchange = null;		
}

function initFactTable(){
  fm = new FilterManager("aParent", 565, selectionText);
  var _priceFilter = new PriceFilter(fm);
  var _brandFilter = new BrandFilter(fm); 
  if(ifChainCasEnabled == true && IS_CHANNEL_STR == false){
	var _prodTypeFilter = new ProdTypeFilter(fm); 
  }
  var _factFilter = new FactFilter(aFactItemHeadings, fm);  
  fm.addFilter(_brandFilter);
  if(ifChainCasEnabled == true && IS_CHANNEL_STR == false){
	 fm.addFilter(_prodTypeFilter);
  }
  else{
	 removeCookie("PROD_TYPE_USER_PREF");
  }
  fm.addFilter(_factFilter);
  fm.addFilter(_priceFilter);
  fm.display();     
  if(selectValues)
    fm.setValues(selectValues);
  return fm;
}

function strToNum(str){
  str = str.replace("£", "");
  str = str.replace(/,/g,"");
  if (str.toUpperCase()=="FREE")
  str=0;
  return parseFloat(str);
}

function PriceFilter_buildPriceRange()
{
  //yadagiri
  // To get Minprice & MaxPrice values from Web page URL -  Added  20 feb 2006
  var urlquery=location.href.split("?");
  var rnurlterms=urlquery[1].split("&");
  var lgth = rnurlterms.length;
   for(var t=0; t<lgth; t++)
  {
	prams = rnurlterms[t].split("=");
	if(prams[0]=="lmax_price") maxPrice= parseInt(prams[1],10);
	if(prams[0]=="lmin_price") minPrice= parseInt(prams[1],10);
  }
  //end yadagiri	
    
  function sortFn(a, b){
    //return(strToNum(a[5]) - strToNum(b[5]));
    return(a[5] - b[5]);
  }
  
  var rowIndex;
  var price = 0;
  
  //fast array clone, as apposed to copying elements
  priceSortedData = new Array().concat(productData);
  var nNumberOfElements = 0;
  priceSortedData.sort(sortFn);
  if ((priceSortedData[0][5]).toUpperCase()=="FREE" || priceSortedData[0][5] =="" )
  var fMinPrice = 0.00;
  else
     var fMinPrice = parseFloat(priceSortedData[0][5]);
    //var fMinPrice = parseFloat(strToNum(priceSortedData[0][5]));
  
  if ((priceSortedData[priceSortedData.length - 1][5]).toUpperCase()=="FREE" || (priceSortedData[priceSortedData.length - 1][5]) =="")
  var fMaxPrice=0.00;
  else
    var fMaxPrice = parseFloat(priceSortedData[priceSortedData.length - 1][5]);
    //var fMaxPrice = parseFloat(strToNum(priceSortedData[priceSortedData.length - 1][5]));
  var priceDiff = fMaxPrice - fMinPrice;                                   
  var fIncrement = 0.00;
  if(priceDiff < 100.00)
    fIncrement = 10.00;
  else if(priceDiff < 250.00)
    fIncrement = 25.00;
  else if(priceDiff < 500.00)
    fIncrement = 50.00;
  else if(priceDiff < 1000.00)
    fIncrement = 75.00;
  else if(priceDiff < 1500.00)
    fIncrement = 100.00;
  else
    fIncrement = 150.00;
  if(fMaxPrice % fIncrement > 0)
  {
    // Round up to the nearest increment.                      
    fMaxPrice = Math.ceil(fMaxPrice / fIncrement) * fIncrement;
  }
  if(fMinPrice % fIncrement > 0)
  {                 
    // Round down to the nearest increment.
    fMinPrice = Math.floor(fMinPrice / fIncrement) * fIncrement;
  }
  // Get the number of elements.           
  nNumberOfElements = ((fMaxPrice - fMinPrice)  / fIncrement) + 1;
  // Get the array of prices.  
  
  for(var i=0; i<nNumberOfElements; i++){
    this.aPriceArray.push(fMinPrice + (fIncrement * i));
  }
  if((this.aPriceArray.length == 1)&&
  	(this.aPriceArray[0] == 0))
  	this.aPriceArray.push(1);

  //yadagiri to get minprice and maxprice values into webpage dropdown list
  var maxflag = true;
  var minflag = true;
  var xlgth = this.aPriceArray.length;
  for(var x=0; x<xlgth; x++)
  {
    xprams = this.aPriceArray[x]; 
	
    if(xprams==maxPrice) maxflag = false;
    if(xprams==minPrice) minflag = false;
  }
	
  if((maxPrice!=null)&&(maxflag)) this.aPriceArray.push(maxPrice);
  if((minPrice!=null)&&(minflag)) this.aPriceArray.push(minPrice); 
  
  //end yadagiri
}

function priceFilter_getFirstDisplayElement(table){
	
  table.appendTDs();                                                                                                                       
  this.lowOptions.buildElement(table, "", "£ ", null, noSelectedItemTxt, [this.lowOptions.itemList.length - 1],minPrice);
  this.highOptions.buildElement(table, "" + this.priceHeadings[0] + "/" + this.priceHeadings[1],  "£ ", 
    null, noSelectedItemTxt, [this.highOptions.itemList.length  - 1],maxPrice);
  this.lowOptions.setCount(true);
  this.highOptions.setCount(true);
  return true;
}
function priceFilter_getNextDisplayElement(){
	
  return false;
}

function priceFilter_getCount(){
	
  var tot = 0;
  var outArray = new Array();
  var adding = false;
  this.filterError = '';
  if(this.lowOptions.value >= this.highOptions.value){
    this.filterError = "Min value should be less than max value";
    return(outArray);
  }
  for(var i = 0; i < productData.length; i++)
    //if((strToNum(productData[i][5]) >= this.lowOptions.value)&&
    //(strToNum(productData[i][5]) <= this.highOptions.value)){
    if((productData[i][5] >= this.lowOptions.value)&&
      (productData[i][5] <= this.highOptions.value)){
          outArray[i] = 1;
    }
  return(outArray);
}


function priceFilter_setCount(){
	
  this.FilterManager.getCount();
}




function PriceFilter_getValues(){
	
  var retArray = [this.lowOptions.oSelect.selectedIndex, this.highOptions.oSelect.selectedIndex];
  return retArray;
}

function PriceFilter_setValues(arr){
  
  if(this.lowOptions.oSelect.selectedIndex != arr[0]) {
    this.lowOptions.oSelect.selectedIndex = arr[0];
    this.lowOptions.setCount();
  }
  
  if(this.highOptions.oSelect.selectedIndex != arr[1]) {
    this.highOptions.oSelect.selectedIndex = arr[1];
    this.highOptions.setCount();
  }
}

function PriceFilter_undoEvents(){
	this.lowOptions.oSelect.onchange = null;
	this.highOptions.oSelect.onchange = null;
}

function PriceFilter(manager, data){

  this.FilterManager = manager;
  this.filterError = '';
  this.ignore = false;
  this.aPriceArray = new Array();
  this.buildPriceRange = PriceFilter_buildPriceRange;
  this.getValues = PriceFilter_getValues;
  this.setValues = PriceFilter_setValues;
  this.buildPriceRange();
  this.getCount = priceFilter_getCount;
  this.setCount = priceFilter_setCount;
  this.lowOptions = new PriceOptionBuilder(this, this.aPriceArray);
  this.highOptions = new PriceOptionBuilder(this, this.aPriceArray);
  this.highOptions.sortFn = this.highOptions.sortFn2;
  this.reset = function(){};
  for(var i = 0; i < productData.length; i++){
    this.lowOptions.locateItem(productData[i][5], 1);
    this.highOptions.locateItem(productData[i][5], 1);
  }
  this.priceHeadings = ["Min Value", "Max Value"];
  this.getFirstDisplayElement = priceFilter_getFirstDisplayElement;
  this.getNextDisplayElement = priceFilter_getNextDisplayElement;
  this.undoEvents = PriceFilter_undoEvents;
  this.datumCount = 2;
}



function PriceOptionBuilder_locateItem(value, idx){
  var contains = false;
  var undefined;
  if((value == null)||    (value == '')||    (value == "undefined")||    (!value)||    (value == "null"))
  {
      contains  = true;
  }
  if(!contains)
  {
      //value = strToNum(value);
      
    for (var i = 0; (i < this.itemList.length) && !contains; i++) 
    {
      var loVal = this.itemList[i];
      var hiVal = this.itemList[i + 1];
      if((value > loVal) && (value < hiVal)){
        contains = true;
     	if(!this.itemCountList)
      	{
	        this.itemCountList = new Array();
      	}
      	if(this.itemCountList[loVal] == undefined)
      	{
	        this.itemCountList[loVal] = 0;
      	}
      	this.itemCountList[loVal]++
      }
    }
  }
}

function priceOptionBuilder_modifyFilterAttributes(val){
  this.setCount();
}

function priceOptionBuilder_setCount(justThis){
  this.value = parseFloat(this.oSelect.value);
  if(!justThis)
    this.factFilter.setCount();
}

function PriceOptionBuilder(filter, prices){
	
  this.FactOptionBuilder(filter); 
  this._isPriceOptionBuilder = true;
  this.modifyFilterAttributes = priceOptionBuilder_modifyFilterAttributes;
  this.locateItem = PriceOptionBuilder_locateItem;
  this.itemList = prices;
  this.optionList = this.itemList;
  this.sortFn = function(a, b){return a - b};
  this.sortFn2 = function(a, b){return b - a};
  this.setCount = priceOptionBuilder_setCount;
}




function BrandFilter(filterManager){
	
  this.FactFilter(null, filterManager);
  this.factTitles = ["Brand"];
  this.reset = brandFilter_reset;
  this.factTable.push(new BrandOptionBuilder(this));
  for(j = 0; j < productData.length; j++)
    this.locateItem(0, productData[j][1], j);
  this.datumCount = 1;
}

	function ProdTypeFilter(filterManager){
		this.FactFilter(null, filterManager);
		this.factTitles = ["Select a Delivery Option"];
		this.reset = prodTypeFilter_reset;
		//this.setCount = prodTypeFilter_setCount;		
		this.factTable.push(new ProdTypeOptionBuilder(this));
		for(j = 0; j < productData.length; j++){
			this.locateItem(0,prodTypeData[productData[j][0]], j);
		}
		this.datumCount = 1;
	}

	function prodTypeFilter_reset(){
  		this.factTable[0].itemList = new Array();
  		this.factTable[0].itemCountList = new Array();
		for(j = 0; j < productData.length; j++){
			this.locateItem(0,prodTypeData[productData[j][0]], j);
		}
		for(var i = 0; i < this.factTable.length; i++){
    		this.factTable[i].setCount();
		}
		this.setCount();
	}


function brandFilter_reset(){
  	this.factTable[0].itemList = new Array();
  	this.factTable[0].itemCountList = new Array();
    for(j = 0; j < productData.length; j++){
      this.locateItem(0, productData[j][1], j);
     }
     for(var i = 0; i < this.factTable.length; i++)
    	this.factTable[i].setCount();
  this.setCount();
}

function BrandOptionBuilder_buildElement(table, title, preString, allTxt, topName, selectedVal){
  this._buildElement(table, title, preString, noSelectedItemTxt, topName, selectedVal);  
}

function ProdTypeOptionBuilder_buildElement(table, title, preString, allTxt, topName, selectedVal){
  this._buildElement(table, title, preString, noSelectedItemTxt, topName, selectedVal);  
}

function BrandOptionBuilder(filter){
  this.FactOptionBuilder(filter); 
  this._buildElement = FactOptionBuilder_buildElement;
  this.buildElement = BrandOptionBuilder_buildElement;
}

	function ProdTypeOptionBuilder(filter){
		this.FactOptionBuilder(filter); 
		this._buildElement = FactOptionBuilder_buildElement;
		this.buildElement = ProdTypeOptionBuilder_buildElement;
		this.setCount = ProdTypeOptionBuilder_setCount;
		//this.temp = true;
		//this.locateItem = ProdTypeOptionBuilder_locateItem;
	}

//FACT GROUP FILTER OBJECTS


//inheritance for PriceOptionBuilder
function _FactOptionBuilder(){}
_FactOptionBuilder.prototype = FactOptionBuilder.prototype;
_FactOptionBuilder.prototype.FactOptionBuilder = FactOptionBuilder;
PriceOptionBuilder.prototype = new _FactOptionBuilder();
BrandOptionBuilder.prototype = new _FactOptionBuilder();
ProdTypeOptionBuilder.prototype = new _FactOptionBuilder();



function ___FactFilter(){}
___FactFilter.prototype = FactFilter.prototype;
___FactFilter.prototype.FactFilter = FactFilter;
BrandFilter.prototype = new ___FactFilter();
ProdTypeFilter.prototype = new ___FactFilter();


function FactOptionBuilder_locateItem(value, idx){

  if((value != null) && (value != '') && (value) && (value != "undefined") && (value != "null"))
  {
      var contains = -1;
  }
  if((value.toUpperCase() == "YES") || (value.toUpperCase() == "NO"))
  {
        value = value.toLowerCase()
  }
  else
  {
        value = value.toUpperCase()
  }
  for (var i in this.itemList) 
  {
      	if (this.itemList[i].toUpperCase() == value.toUpperCase()) 
      	{
        	contains = i;
        	break;
      	}
  }
  if(contains == -1)
  {
   	this.itemList.push(value);
  }
  if(!this.itemCountList)
  {
    	this.itemCountList = new Array();
  }
  if(!this.itemCountList[value])
  {
  	this.itemCountList[value] = new Array();
  }
  if(this.itemCountList[value][idx])
  {
    	this.itemCountList[value][idx]++
  }
  else
  {
    this.itemCountList[value][idx] = 0;
  }

}


	function ProdTypeOptionBuilder_locateItem(value, idx){
		if((value != null) && (value != '') && (value) && (value != "undefined") && (value != "null")){
			var contains = -1;
		}
		if((value.toUpperCase() == "YES") || (value.toUpperCase() == "NO")){
			value = value.toLowerCase()
		}
		else{
			value = value.toUpperCase()
		}
		for (var i in this.itemList) {
			if (this.itemList[i].toUpperCase() == value.toUpperCase()) {
				contains = i;
				break;
			}
		}
		if(contains == -1){
			this.itemList.push(value);
		}
		if(!this.itemCountList){
			this.itemCountList = new Array();
		}
		if(!this.itemCountList[value]){
			this.itemCountList[value] = new Array();
		}
		if(this.itemCountList[value][idx]){
			this.itemCountList[value][idx]++
		}
		else{
			this.itemCountList[value][idx] = 0;
		}
	}

function FactOptionBuilder_setCount(justThis){
  val = this.oSelect.value;

  this.itemCount = null;
  this.itemCount  = this.itemCountList[val];
  this.ignore = (val == noSelectedItemTxt);

  if(!justThis)
  {
      this.factFilter.setCount();
     
  }
   
}

function ProdTypeOptionBuilder_setCount(justThis){	
  val = this.oSelect.value;
  this.itemCount = null;
  this.itemCount  = this.itemCountList[val];
  this.ignore = (val == noSelectedItemTxt);
  casFilterCookieValue = val;
  //alert(" casFilterCookieValue => "+casFilterCookieValue);
  //storeProdTypeUserPreference(val);
  if(!justThis)
  {
      this.factFilter.setCount();
     
  }
   
}

// This method is responsible for generating the Html code for each filter
function FactOptionBuilder_buildElement(table, title, preString, allTxt, topName, doNotDisplayList, selectedVal){
  //inner function
  function optionItem(value, name, selectedFlag)  
  {
    var res = document.createElement("OPTION");
    res.value=value;
    res.innerHTML=name;
    res.selected = selectedFlag;
    return res;
  }
  //do heading first
  table.td.innerHTML=title;
  this.itemList.sort(); 
  this.itemList.sort(this.sortFn);
  this.oSelect = document.createElement("select");
  this.oSelectclassName = "wh-form-border";
  //Prem Nazeer - 25/01/06 - Created for PageNo retain requirement
  this.oSelect.value=getFilterValue(filterElementCount);
  
  		  
  this.oSelect.id = "filterElementId_" + filterElementCount++;
  
  var ref = this;
  this.oSelect.onchange = function(){ref.setCount();};
  var selectedFlag = false;
  if(allTxt)
  {
    this.oSelect.appendChild(optionItem(noSelectedItemTxt, allTxt, selectedFlag));
  }
  var firstIn = true;
  for (var i in this.itemList){      
        if(!preString)
          preString = '';
        var dispTxt = preString + this.itemList[i];
        if(firstIn){
          firstIn = false;
          if(topName)
            dispTxt = topName;
        }
        var dontShowIt = false;
        if(doNotDisplayList)
          for(var cntr = 0; (cntr < doNotDisplayList.length) && (!dontShowIt); cntr++)
            if(doNotDisplayList[cntr] == i){
              dontShowIt = true;
            }
        if(!dontShowIt)
        {
			selectedFlag = false;
			if(getFilterValue(filterElementCount-1) == this.optionList[i] || selectedVal == this.optionList[i]) {
				selectedFlag = true;
			}
			else if( prodTypeFilter.toUpperCase() == "true" && this.optionList[i] == "RESERVE & COLLECT"){
				selectedFlag = true;
			}
			else if(document.cookie.length > 0){
				var begin = document.cookie.indexOf("PROD_TYPE_USER_PREF="); 
				if (begin != -1){
					begin += "PROD_TYPE_USER_PREF=".length; 
					end = document.cookie.indexOf(";", begin);
					if (end == -1) {
						end = document.cookie.length;
					}
					var prodTypeUserPref = unescape(document.cookie.substring(begin, end)); 
					if(prodTypeUserPref == "CAS" && this.optionList[i] == "RESERVE & COLLECT"){
						selectedFlag = true;
					}
					/*else if(prodTypeUserPref == "DEL" && this.optionList[i] == "DELIVERY"){
						selectedFlag = true;
					}*/
				} 
			}
			this.oSelect.appendChild(optionItem(this.optionList[i], dispTxt, selectedFlag));
        }
  }
  table.td2.appendChild(this.oSelect);

  ref.setCount();
  return(true);
}


function FactOptionBuilder_sortFN_old(a, b){
  //var _a = parseFloat(strToNum(a));
  var _a = parseFloat(a);
  //var _b = parseFloat(strToNum(b));
  var _b = parseFloat(b);
  if((isNaN(_a))||(isNaN(_b)))
    return 0;
  if((_a == 0)||(_b==0))
    return 0;
  return (_a - _b);
}

function FactOptionBuilder_sortFN(a,b) 
{ 
	if (a+"" < b+"") { return -1; }
  	if (a+"" > b+"") { return 1; }
	return 0;
}

function FactOptionBuilder(filter){
  this.buildElement = FactOptionBuilder_buildElement;
  this.sortFn = FactOptionBuilder_sortFN;
  this.factFilter = filter;
  this.itemList = new Array();
  this.optionList = this.itemList;
  this.itemCountList = new Array();
  this.itemCount = null;
  this.locateItem = FactOptionBuilder_locateItem;
  this.setCount = FactOptionBuilder_setCount;
  this.ignore = true;
  this.length = 0;
}

function factFilter_locateItem(idx, itm, prodIdx){
  return(this.factTable[idx].locateItem(itm, prodIdx));
}



function factFilter_modifyFilterAttributes(){
	
    var itmCounter = 1;
    var array = this.getCount();
    var returnArray = new Array();
    for(var i = 0; i < productData.length; i++){
      if(array)
        if(array[i])
          returnArray.push(itmCounter++)
        else
          returnArray.push(-1);
      else
          returnArray.push(itmCounter++);
    }
      return(returnArray);
}


function FactFilter_setCount(){
  this.FilterManager.getCount();
}



function FactFilter_getCount(){

  var array = null;
  var outArray = null;
  var count = 0;
  for(var j = 0; (j < this.factTable.length) && (array == null); j++)
    if(!this.factTable[j].ignore)
      array = this.factTable[j].itemCount;
  if(array){
    var outArray = new Array();
    for(var i in array){
      var inAll = true;
      for(var j = 0; j < this.factTable.length; j++){
        if(!(this.factTable[j].ignore))
          if(this.factTable[j].itemCount){
            if(this.factTable[j].itemCount[i] == null)
              inAll = false;
          }
      }
      if(inAll) {
        outArray[i] = 1;
        count++;
      }
    }
  }else{
    this.count = productData.length;
    outArray = new Array();
    for(var i = 0; i < productData.length; i++)
      outArray.push(1);
    this.ignore = true;
  }
  return outArray;
}


function factFilter_reset(){
  
  for(var i = 0; i < this.factTable.length; i++){
  	this.factTable[i].itemList = new Array();
  	this.factTable[i].itemCountList = new Array();
  }
  for(var i = 0; i < this.factTable.length; i++)
    for(j = 0; j < productData.length; j++){
      this.locateItem(i, productData[j][i + 21], j);
    }
    for(var i = 0; i < this.factTable.length; i++)
    	this.factTable[i].setCount();
  this.setCount();
}

function FactFilter_getValues(){
	
  var retArray = new Array();
  for(var i = 0; i < this.factTable.length; i++){
    retArray.push(this.factTable[i].oSelect.selectedIndex);
  }
  return retArray;
}


function FactFilter_setValues(arr){
	
  for(var i = 0; i < this.factTable.length; i++){
      if(this.factTable[i]) {
    	  if(this.factTable[i].oSelect.selectedIndex != arr[i] ){
            this.factTable[i].oSelect.selectedIndex = arr[i];
            this.factTable[i].setCount();
          }
      }
  }
  if(this.factTable[0])
    this.factTable[0].setCount();
}

function factFilter_undoEvents(){
	
	for(var i = 0; i < this.factTable.length; i++){
		this.factTable[i].oSelect.onchange = null;
	}
}

function FactFilter(factTitles, filterManager, aData){
	
  this.FilterManager = filterManager;
  this.filterError = '';
  this.ignore = false;
  this.modifyFilterAttributes = factFilter_modifyFilterAttributes;
  this.factTitles = factTitles;
  this.getFirstDisplayElement = factFilter_getFirstDisplayElement;
  this.getNextDisplayElement = factFilter_getNextDisplayElement;
  this._getDisplayElement = factFilter_getDisplayElement;
  this.reset = factFilter_reset;
  this.displayItterator = 0;
  this.getValues = FactFilter_getValues;
  this.setValues = FactFilter_setValues;
  this.locateItem = factFilter_locateItem;
  this.getCount = FactFilter_getCount;
  this.setCount = FactFilter_setCount;
  this.undoEvents = factFilter_undoEvents;
  this.factTable = new Array();
  if(factTitles)
  for(var i = 0; i < factTitles.length; i++){
    this.factTable.push(new FactOptionBuilder(this));
    for(j = 0; j < productData.length; j++)
      this.locateItem(i, productData[j][i + 21].replace("DOUBLEQUOTE", "\""), j);
  }
  this.datumCount = this.factTable.length;
}


function factFilter_getFirstDisplayElement(table){
  this.displayItterator = 0;
  return this._getDisplayElement(table);
}

function factFilter_getNextDisplayElement(table){
  this.displayItterator++;
  return this._getDisplayElement(table);
}

function factFilter_getDisplayElement(table){
  if((this.displayItterator == -1)||
    (this.displayItterator == this.factTable.length))
      return false;
  //button
  else{
    table.appendTDs();
    return this.factTable[this.displayItterator].buildElement(table,  this.factTitles[this.displayItterator] , null, noSelectedItemTxt, null);  
  }
}

function filterFn(arr,dir, sender){
  testFilterArray = arr;
  filterTable(arr,dir, sender);
}


function HTMLOptionTable_appendTDs(){
  this.td = document.createElement("TD");
  this.td.align="left";
  this.td2 = document.createElement("TD");
  this.tBody.appendChild(this.td);
  this.td2.vAlign="bottom";
  this.td.vAlign="bottom";
  this.tr1.appendChild(this.td);
  this.tr2.appendChild(this.td2);
}

function HTMLOptionTable_appendTRs(){
  this.tr1 = document.createElement("TR");
  this.tr1.className="cell-shading-on";
  this.tBody.appendChild(this.tr1);
  this.tr2 = document.createElement("TR");
  this.tr2.className="cell-shading-on";
  this.tBody.appendChild(this.tr2);
}


function HTMLOptionTable_createTable(width, newParent){
  if(newParent)
    this._parent = newParent;
  this.table = document.createElement("TABLE");
  this.table.border = 0;
  if(width)
    this.table.width = width;
  this.table.cellSpacing = 8;
  this.table.cellPadding = 0;
  this.tBody = document.createElement("TBODY");
  this.table.appendChild(this.tBody);   
  if(this._parent)
    this._parent.appendChild(this.table);
}

function HTMLOptionTable(parent, width){
  this._parent = parent;
  this.createTable = HTMLOptionTable_createTable;
  this.appendTRs = HTMLOptionTable_appendTRs;
  this.appendTDs =HTMLOptionTable_appendTDs;
  this.createTable(width);
}

function FilterManager_addFilter(filter){
  this.filters.push(filter);
}

function FilterManager_resolveWidth(currentTableWidth){
	
  var currentWidth = currentTableWidth;
  if( (currentTableWidth ) > this.width){
    	var t1 = this.table.td;
    	var t2 = this.table.td2;
    	this.table.tr1.removeChild(this.table.td);
    	this.table.tr2.removeChild(this.table.td2);
    
    var br = document.createElement("BR");
    	this.parent.appendChild(br);  
    
    this.span.style.pixelWidth = this.width;
    this.span.style.position = "";
    this.span = document.createElement("span");
    this.span.id ="changed";
    this.span.style.display="inline";
  
    this.parent.appendChild(this.span);
    this.span.style.position = "absolute";
    this.table.createTable(null, this.span);
    this.table.appendTRs();
    this.table.tr1.appendChild(t1);
    this.table.tr2.appendChild(t2);
    currentWidth = 0;
  }
  return currentWidth;
}

function FilterManager_display(){
  function addOutputText(ptr, text){
      var elem = document.createElement("TD");
      ptr.appendChild(elem);
      elem.nowrap = true;
      var txt = document.createElement("B");
      elem.appendChild(txt);
      txt.innerHTML = text;
  }
  
  this.mainSpan = this.span;
  this.span.style.position = "absolute";
  var currentWidth = 0;
  try{
    this.span.style.pixelWidth = this.width;
    this.table = new HTMLOptionTable(this.span);
    this.table.appendTRs();
    for(var i = 0; i < this.filters.length; i++){
      var filter = this.filters[i];
      var elem = filter.getFirstDisplayElement(this.table);
      while(elem != false)
      {
      	td_width = this.table.td.offsetWidth;
      	currentWidth += td_width;
      	
      	currentWidth = this.resolveWidth(currentWidth);
      	if ( currentWidth == 0 )
      	{
      		currentWidth = td_width;
      	}
        elem = filter.getNextDisplayElement(this.table);        
      }
    }
    this.resolveWidth(currentWidth);
    this.table.createTable();
    this.table.appendTRs();
    this.table.appendTDs();
    this.viewButton = document.createElement("A");
    this.noItemText = document.createElement("SPAN");
    this.noItemText.style.display = "none";
    this.noItemText.innerHTML = noItemsText;    
    this.noItemText.className = "error-title";
    //this.viewButton.href="#";
	this.viewButton.href="javascript:doNothing();";
    var btnImg = document.createElement("IMG");          
    this.viewButton.appendChild(btnImg);
    btnImg.src = "/store_doc/images/wheel/buttons/pl_view_products_bg.gif";
    btnImg.border=0;
    var ref = this;   //otherwise we think were in the button
    this.viewButton.onclick = function(){resetMaxMinPrice();resetPageStartNo();ref.modifyFilterAttributes();};
    this.sortOrderSpan = document.createElement("SPAN");
    this.sortOrderSpan.id = this.sortOrderAnchor;
    this.table.td.align="left";
    this.table.td2.align="left";
    this.outputCell = this.table.td;
    this.outputCell.valign = "bottom";
    var startTxt = '';
    var midTxt = '';
    var endTxt = '';
    var startPoint = 0;
    if(this.selText.indexOf("$MATCHES") != -1){
      this.outputMatchesText = document.createElement("INPUT");
      this.outputMatchesText.height = 20;
      this.outputMatchesText.size = 1;
      this.outputMatchesText.id = "total_id";
      this.outputMatchesText.type = "text";
      this.outputMatchesText.contentEditable = false;
      this.outputMatchesText.style.filter = "progid:DXImageTransform.Microsoft.RandomDissolve(duration=1)";
      this.outputMatchesText.style.fontWeight = "bold";
      startPoint = this.selText.indexOf("$MATCHES");
      startTxt = this.selText.substring(0, startPoint);
      startPoint += 8;
    }
    if(this.selText.indexOf("$TOTAL") != -1){
      this.outputTotalText = document.createElement("INPUT");
      this.outputTotalText.type = "TEXT";
      this.outputTotalText = document.createElement("INPUT");
      this.outputTotalText.type = "TEXT";
      this.outputTotalText.contentEditable = false;
      this.outputMatchesText.id = "total_id";
      this.outputTotalText.height = 20;
      this.outputTotalText.size = 1;
      this.outputTotalText.style.filter = "progid:DXImageTransform.Microsoft.RandomBars(duration=1.5)";
      this.outputTotalText.style.fontWeight = "bold";
      midTxt = this.selText.substring(startPoint, this.selText.indexOf("$TOTAL"));
      startPoint = this.selText.indexOf("$TOTAL")  + 7;
    }
    endTxt = this.selText.substring(startPoint, this.selText.length);
    

    //create a table to hold the data
    var tbl = document.createElement("TABLE");
    this.outputCell.appendChild(tbl);
    var tbody = document.createElement("TBODY");
    tbl.appendChild(tbody);
    var ptr = document.createElement("TR");
    tbody.appendChild(ptr);
    if(startTxt != ''){
      addOutputText(ptr, startTxt);
    }
    if(this.outputMatchesText){
      elem = document.createElement("TD");
      elem.nowrap = true;
      ptr.appendChild(elem);
      elem.appendChild(this.outputMatchesText);
    }
    if(midTxt != ''){
      addOutputText(ptr, midTxt);
    }
    if(this.outputTotalText){
      elem = document.createElement("TD");
      elem.nowrap = true;
      ptr.appendChild(elem);
      elem.appendChild(this.outputTotalText);
    }
    if(endTxt != ''){
      addOutputText(ptr, endTxt);
    }
    elem = document.createElement("TD");
    ptr.appendChild(elem);
    elem.appendChild(this.viewButton);
    elem.appendChild(this.noItemText);
    elem = document.createElement("TD");
    ptr.appendChild(elem);
    var priceOrd = document.createElement("B");
    priceOrd.innerHTML = ("Sort By:&nbsp;&nbsp;&nbsp;&nbsp;");
    elem.appendChild(priceOrd);
    elem = document.createElement("TD");
    ptr.appendChild(elem);
    elem.appendChild(this.sortOrderSpan);
    
  }finally{
    this.span.style.position = "";
    this.getCount();
    this.modifyFilterAttributes();
  }
}

function resetPageStartNo() {
	
	PAGE_NOCookie = '0';
	productListstartPage = 0;
	document.cookie = "PAGE_NO=";
  	document.cookie = "PAGE_NO=" + productListstartPage;

	storeProdTypeUserPreference(casFilterCookieValue);
	casFilterCookieValue = "";

  	storeFilterValues();
  	storeSortByValues()
  	setHistory(productListstartPage);
}

function resetMaxMinPrice() {
	maxPrice = null;
	minPrice = null;	
}
 
 // Prem Nazeer - 24/02/06 - Added for Back button - to - restore Sort by values
function storeSortByValues() {
	sortOrderValue = document.getElementById("sortOrder").value;
	document.cookie = "SORT_ORDER=";
    	document.cookie = "SORT_ORDER=" + sortOrderValue;
}

// Prem Nazeer - 24/02/06 - Added for Back button - to - restore Filter values
function storeFilterValues() {
 
 	filterCookieString = '';
	if(filterElementCount >0 ) {
	  	
	  	for(i = 0; i<filterElementCount;i++) 
	  	{
	      		filterValue = document.getElementById("filterElementId_"+i).value;
	      		filterCookieString += (filterCookieString!='')? ( ":" + filterValue):filterValue ;
	  	}
	} else {
		buildInitialFilterValues();
		
	}
  
	cookieFilterValues = filterCookieString; 
	cookieFilterValuesArray = cookieFilterValues.split(":");
	document.cookie = "FILTER_VALUES=" + filterCookieString;
}

function removeCookie(cookieName){
	addCookie(cookieName,"");
}

function addCookie(cookieName, cookieValue){
	var offset = 2;
	var expireDate = new Date();
	expireDate.setHours(expireDate.getHours()+offset);
	var temp = cookieName+" = "+cookieValue + "; expires=" + expireDate.toGMTString() + "; path=/";
	document.cookie = temp;
}

function storeProdTypeUserPreference(value) {
 	var prodTypeUserPrefence = "";
	if(value != null || value != ""){
		if(value == "RESERVE & COLLECT"){
	 		prodTypeUserPrefence = "CAS";
		}
		/*else if(value == "DELIVERY"){
	 		prodTypeUserPrefence = "DEL";
		}*/
	}
	addCookie("PROD_TYPE_USER_PREF",prodTypeUserPrefence);
}

function buildInitialFilterValues() 
{
	if(aFactItemHeadings.length>0) 
	{
		filterCookieString = noSelectedItemTxt;
		for(i = 0; i<aFactItemHeadings.length;i++) 
		{	
	      		filterCookieString += (filterCookieString!='')? ( ":" + noSelectedItemTxt):noSelectedItemTxt;
	  	}
	  	filterCookieString += ":" + noSelectedItemTxt + ":" + noSelectedItemTxt;
	}
}

function FilterManager_modifyFilterAttributes(){

  arrayOfElementArrays = null;
  arrayOfElementArrays = new Array();
  // Prem Nazeer - 25/01/06 - Changes made for Page Retain Requirement then modified for back button
  storeFilterValues();
	
var startTime = new Date();
  if(fltArray){
    aOut = new Array();
    aOut = aOut.concat(fltArray);      
    fltArray = null;
    filterFn(aOut, this._filterUp, this);   
  }
  else
  {
    var array = this.getCount();
    var aOut = new Array();
    var incr = 0;
    for(var i = 0; i < productData.length; i++)
    {
      if(array[i])
        aOut.push(incr++);
      else
        aOut.push(-1);
    }   
    filterFn(aOut, this._filterUp, this);
  }

}


function FilterManager_setCountDisplay(dispElem, val, stlyist){
	
	var undefined;
	var filterEnabled = ((dispElem) && (dispElem.filters!=undefined) && (dispElem.filters.item(0)));
	if((this.outputCell)&& (dispElem))
	{//1
		
		if(stlyist - 1 != 0)
		{
			var so = document.getElementById("sortOrder")
			
			if(so)
			{
				so.disabled = false;
			}
			
			if( filterEnabled )
			{
				dispElem.filters.item(0).Apply();
			}
			
			dispElem.value = val - 1;
			this.viewButton.style.display = "";
			this.noItemText.style.display = "none";
			dispElem.style.color = "BLACK";
			
			if( filterEnabled )
			{
				dispElem.filters.item(0).Play();
			}

		}
		else
		{
			if( filterEnabled )
			{
				dispElem.filters.item(0).Apply();
			}
			
			dispElem.value = val - 1;
			
			if(this.filterError != '')
			{
				this.noItemText.innerHTML = this.filterError;
			}
			else
			{
				this.noItemText.innerHTML = noItemsText;
			}       
			var so = document.getElementById("sortOrder")
			if(so)
			{
				so.disabled = true;
			}
			
			this.viewButton.style.display = "none";
			this.noItemText.style.display = "";
			dispElem.style.color = "RED";
			
			if( filterEnabled )
			{
				dispElem.filters.item(0).Play();       
			}
		}
	}//1
}



function FilterManager_getCount(){
  this.filterError = '';
  var array = null;
  var outArray = null;
  var val = 1;
  for(var j = 0; j < this.filters.length; j++)
    if(array == null)
      array = this.filters[j].getCount();
  if(array){
    var outArray = new Array();
    for(var i in array){
      var inAll = true;
      for(var j = 0; j < this.filters.length; j++){
          var newArray = this.filters[j].getCount();
            if(!newArray[i])
              inAll = false;   
        if(this.filters[j].filterError)
          this.filterError = this.filters[j].filterError;
      }
      if(inAll) {
        outArray[i] = val++;
      }
    }
  }else
    val = productData.length + 1;     
  this.setCountDisplay(this.outputMatchesText, val, val);
  this.setCountDisplay(this.outputTotalText, productData.length + 1, val);
  return outArray;
}
  

function filterManager_setDirection(obj){
	
  var val = document.getElementById("sortOrder").value;   
  var vals = null;
  if((firstTime) &&
      (fromSearch)){
    firstTime = false;
    productData = priceSortedData;
    this.ItemList = new Array();
    this.ItemCountList = new Array();
    this._filterUp = "val";
    for(var i = 0; i < this.filters.length; i++)
        this.filters[i].reset();
    this.getCount();
  }
  this._filterUp = val;
  this.modifyFilterAttributes();
}

function filterManager_getValues(){
	
  var retArray = new Array(0);
  for(var i = 0; i < this.filters.length; i++){
    retArray = retArray.concat(this.filters[i].getValues());
  }
  return retArray;
}


function filterManager_setValues(ary){
	
  var count = 0;
  for(var i = 0; i < this.filters.length; i++){   

	    var retArray = new Array();
	    for(var j = 0; j < this.filters[i].datumCount; j++)
	      retArray.push(ary[count++]);
	    this.filters[i].setValues(retArray);
  }
  this.getCount();
}


function filterManager_undoEvents(){
	
	for(var i = 0; i < this.filters.length; i++){
		this.filters[i].undoEvents();
	}
	this.viewButton.onclick = null;
}

function FilterManager(parent_id, width, selText){ 

  this.setFilterValues = FilterManager_setFilterValues; // Added for back button functionality	
  this.sortOrderAnchor = "sortOrder_span";
  this.getValues = filterManager_getValues;
  this.selText = selText;
  this.total = productData.length;
  this.modifyFilterAttributes = FilterManager_modifyFilterAttributes;
  this.setCountDisplay = FilterManager_setCountDisplay;
  this.setDirection = filterManager_setDirection;
  this.setValues = filterManager_setValues;
  if((directionVal != '')&& ("UPDOWN".indexOf(directionVal) != -1)) {
      this._filterUp = directionVal
  }
  else
  {
    if(sortOrderCookie!='') 
    {
    	this._filterUp = sortOrderCookie;
    } 
    else 
    {
	if (typeof rankingArray == "undefined") {
	    this._filterUp = "DOWN";
	} else {
	    this._filterUp = "RANK";
	}
    }
  }
    
  this.parent = document.getElementById(parent_id);
  this.filters = new Array();
  this.addFilter = FilterManager_addFilter;
  this.getCount = FilterManager_getCount;
  this.resolveWidth = FilterManager_resolveWidth;
  this.display = FilterManager_display;
  this.span = document.createElement("span");
  this.parent.appendChild(this.span);
  this.undoEvents = filterManager_undoEvents;
  this.width = width;
  this.filterError = "";
}

function performMultipleATPStockCheck(){
  var ATP_Iframe = document.createElement("IFRAME");
  ATP_Iframe.style.display = "none";
  ATP_Iframe.src = '';
  ATP_Iframe.id = 'Iframe1';
  var checkArray = [];
  for(var i = 0; i < productData.length; i++){
    if(productData[i][18] != -1)
      checkArray.push(productData[i][0]);
  } 
  
  //Prem Nazeer - 02/02/06 - Changes made to fix the bug in the parameter BV_UseBVCookie
  ATP_Iframe.src= ("do_multiple_atp_stockcheck.jsp?calling_page=product_list&service_name=" + cServiceName + "&BV_UseBVCookie=yes&skulist=" + checkArray);
  //IFrameDoc is a global
  document.body.appendChild(ATP_Iframe);
  
}

function populateProductData(vals,a){
// NMo: now uses lookup array to reduce processing time
	if(vals)
	{
		var productLookUp = new Array();
		for ( i = 0 ; (i < productData.length) ; i++ )
		{
			productLookUp[productData[i][0]] = i;
		}
  		for(var j = 0; j < vals.length; j++)
  		{
		  	var index = productLookUp[vals[j][0]];
		  	
		  	if ( index != null )
		  	{
	       			productData[index][19] =  vals[j][1]; 
					//Added for Currys Collect @ Store 30/06/2006
					//Updated for CAS_LAYOUT_TYPE, 21/07/2006
					//if(cServiceName == "Currys"){
					if(CAS_LAYOUT_TYPE == 1){
			        	if(parseInt(vals[j][1],10) > 0)
			   				productData[index][19] = cur_inStock_no_cas;
	        			if(vals[j][1] == "CE")
		       				productData[index][19] = cur_no_inStock_cas;
						if(vals[j][1] == "BOTH")
		       				productData[index][19] = cur_inStock_cas;
					}
					//Addition end
					else{
			        	if(parseInt(vals[j][1],10) > 0)
	        				productData[index][19] = inStockTxt;
		        		if(vals[j][1] == "CE")
		        			productData[index][19] = "Collect@Store item.";
					}
	        		if(vals[j][1] <= 0)
			        	productData[index][19] = soldOutTxt;
	        		if(vals[j][1] == "SHD")
	        			productData[index][19] = "SHD";	
			}
  		}
  	}
  	beforeStockCheck = false;
  	fm.modifyFilterAttributes(); 
  	
  	return (window.status="StockCheck Complete");

  	
  	
}

////////////////////////////////////////////


var _dsgpostcode = null;

function dsgPostcode_setPostcodeCookie(code1, code2){
  if(this.postcode)
    return true;
  if(code1){
    this.postcode = [code1, code2];
    var date = new Date();
    document.cookie = "CUR_DSG_POSTCODE=" + escape(code1 + ' ' + code2);
      return true;
   }
    return false;
}



function dsgPostcode_getPostcodeCookie(){
  var postcodeCookie = '';
  if (document.cookie.length > 0){ 
    var begin = document.cookie.indexOf("CUR_DSG_POSTCODE="); 
    if (begin != -1){
      begin += "CUR_DSG_POSTCODE=".length; 
      end = document.cookie.indexOf(";", begin);
      if (end == -1) end = document.cookie.length;
        postcodeCookie = unescape(document.cookie.substring(begin, end)); 
      this.postcode = postcodeCookie.split(' ');
    } 
  }
}

function Dsg_postcode(postcode1, postcode2){
  this.postcode = null;
  this.setPostcodeCookie = dsgPostcode_setPostcodeCookie;
  this.getPostcodeCookie = dsgPostcode_getPostcodeCookie;
  if(postcode1){
    this.setPostcodeCookie(postcode1, postcode2);
  }else{
    this.getPostcodeCookie();
  } 
}

function dsg_getPostcode(){
  if(!_dsgpostcode)
    _dsgpostcode = new Dsg_postcode();
    return(_dsgpostcode.postcode);
}

function dsg_setPostcode(postcode1, postcode2){
  _dsgpostcode = new Dsg_postcode(postcode1, postcode2);
}
