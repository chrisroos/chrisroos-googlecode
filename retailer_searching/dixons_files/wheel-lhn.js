// initialise global variables
var prevMenu = "defaultMenu";
var prevTopMenu = "defaultMenu";
var same = false;
var prevEle;
var level2Menus = new Array();
var level1Bullets = new Array();
var menuTags = new Array();
var trTags;

//var tmp = '';

function hideSub(topMenu, ele)
{
	//var d = new Date();
	var i = 0;
	var j = 0;
	var k = 0;
	var l = 0;

	if ((topMenu == "init") && (ele == "init"))
	{
		trTags = document.getElementsByTagName('tr');

		var tabTags = document.getElementsByTagName('table');
		for( var i=0; i<tabTags.length; i++)
		if (tabTags[i].id.indexOf('menu') != -1)
			menuTags[j++] = tabTags[i];

		j = 0;

		var tdTags = document.getElementsByTagName('td');
		for( i=0; i<tdTags.length; i++)
			if( tdTags[i].className.indexOf( 'L1B') != -1)
				level1Bullets[j++] = tdTags[i];

		j = 0;

		for ( i = trTags.length - 1; i >= 0; i--)
		{
			if ((trTags[i].id != null) &&
			    (trTags[i].id.indexOf("menu") != -1) &&
			    (trTags[i].id.indexOf("Gap") == -1) &&
			    (trTags[i].id.indexOf("_option") == -1))
				if( trTags[i].className == "L2") level2Menus[k++] = trTags[i];
		}
	}
	
	if ((prevEle == ele) && (ele != null))
	{
		return false
	}
	else
	{
		for( l = 0 ; l < menuTags.length; l++)
		{
			if( document.getElementById(topMenu+"_"+l))
			{
				document.getElementById(topMenu+"_"+l+"TopGap").style.display = "none";
				document.getElementById(topMenu+"_"+l+"BottomGap").style.display = "none";
				if( document.getElementById(topMenu+"_"+l).className != "")
				document.getElementById(topMenu+"_"+l).className = "L1";
				if( document.getElementById(topMenu+"_"+l+"Bullet").className == "wh-level1BulletOpen") 
					document.getElementById(topMenu+"_"+l+"Bullet").className="L1B";
			}
		}
		hideLevel2();
	}
	
	//tmp += "hidesub " + (new Date() - d) + " menu " + "\n";
}

function hideLevel2()
{
	//var d = new Date();
	for ( var i = level2Menus.length-1; i >= 0; i--)
	{
		level2Menus[i].style.display = "none";
	}
	//tmp += "hidelevel2 " + (new Date() - d) + "\n";
}

function toggleRows(ele)
{
	//var d = new Date();
	var bullet = ele+"Bullet";
	var total = 0;

	docEleObj = document.getElementById(ele);
	docObj = document.getElementById(bullet);

	if (docObj.className == "L1B")
	{
		for (var i=0; i<level2Menus.length; i++)
		{
			if (level2Menus[i].id.indexOf(ele+"_") != -1)
			{
				if (window.sidebar)
				{
					document.getElementById(ele+"_"+total).style.display = "table-row";
					document.getElementById(ele+"TopGap").style.display = "table-row";
					document.getElementById(ele+"BottomGap").style.display = "table-row";
				}
				else
				{
					document.getElementById(ele+"_"+total).style.display = "block";
					document.getElementById(ele+"TopGap").style.display = "block";
					document.getElementById(ele+"BottomGap").style.display = "block";
				}
				total++;
			}
		}
		docEleObj.className = "wh-current1"; // level 1 current
		docObj.className = "wh-level1BulletOpen";

		if ((prevEle != null) && (prevEle != ele))
		{
			document.getElementById(prevEle+"TopGap").style.display = "none";
			document.getElementById(prevEle+"BottomGap").style.display = "none";
		}
	}
	else
	{
		for (var i=0; i<level2Menus.length; i++)
		{
			if (level2Menus[i].id.indexOf(ele+"_") != -1)
			{
				document.getElementById(ele+"_"+total).className = "L2";
				document.getElementById(ele+"_"+total).style.display = "none";
				total++;
			}
		}
		document.getElementById(ele+"TopGap").style.display = "none";
		document.getElementById(ele+"BottomGap").style.display = "none";

		docEleObj.className = "L1";
		docObj.className = "L1B";
	}
	prevEle = ele;
	//tmp += "toggleRows " + (new Date() - d) + "\n";
	//alert( tmp);
	//tmp = "";
}

function hideAll(ele)
{
	//var d = new Date();
	docObj = document.getElementById(ele);
	prevDocObj = document.getElementById(prevTopMenu);
	
	if (prevTopMenu != "defaultMenu")
	{
		prevDocObj = document.getElementById(prevTopMenu+"_option");
	}

	for( var i=0; i<menuTags.length; i++)
		if ( menuTags[i].id.indexOf(ele) == -1 &&
		     menuTags[i].style.display != "")
		{
			menuTags[i].style.display = "none";
		}

	for( i=0; i<level1Bullets.length; i++)
		if( level1Bullets[i].className == "wh-level1BulletOpen")
			level1Bullets[i].className = "L1B";

	if (prevTopMenu != ele) prevDocObj.className = "wh-level0";

	prevTopMenu = ele;

	//tmp += "hideall " + (new Date() - d) + "\n";
}

function toggleVis(ele,level)
{
	//var d = new Date();
	docObj = document.getElementById(ele);
	if( docObj == null) return;
	prevDocObj = document.getElementById(prevMenu);
	
	if (prevMenu==ele)
	{
		var displayState = ((docObj.style.display=="") || ((docObj.style.display=="none"))) ? "block" : "none";
			docObj.style.display = displayState;
	}
	else
	{
		var displayState = ((docObj.style.display=="") || ((docObj.style.display=="none"))) ? "block" : "none";
		document.getElementById(ele+"_option").className = "wh-current"+level;
			docObj.style.display = displayState;
	}

	var classState = ((displayState=="") || (displayState=="none")) ? "wh-level"+level : "wh-level"+level+"open";
	prevMenu = ele;
	//tmp += "toggleVis " + (new Date() - d) + "\n";
}

function sc(ele)
{
	//var d = new Date();
	var localEle = ele;
	var delimiter = "_";
	var splitArray = localEle.split(delimiter);
	var j = 0;

	var menuItem1 = "";
	var menuItem2 = "";
	
	menuItem1 = splitArray[0];
	menuItem2 = menuItem1 + delimiter + splitArray[1];

	if (document.getElementById(ele).id.indexOf("_option") != -1)
	{
		if (document.getElementById(ele).className == "wh-current0")
		{
			document.getElementById(ele).className="wh-level0"; // level0 current
		}
		else
		{
			document.getElementById(ele).className="wh-current0";
		}
	}
	else
	{
		for (var i=0; i<trTags.length; i++)
		{
			if (trTags[i].id.indexOf(menuItem2+delimiter) != -1)
			{
				document.getElementById(menuItem2+delimiter+j).className='L2';
				if (eval(splitArray[2]) == j)
				{
					document.getElementById(menuItem2+delimiter+j).className='wh-current';
				}
				j++;
			}
		}
	}
}

function menuPath(menuItem)
{
	var localMenuItem = menuItem;
	var delimiter = "_";

	var menuStr1 = "";
	var menuStr2 = "";

	var splitArray = localMenuItem.split(delimiter);

	menuStr1 = splitArray[0];
	menuStr2 = menuStr1 + delimiter + splitArray[1];

	toggleVis(menuStr1, 0);
	toggleRows(menuStr2);
	highLightMenuItem(localMenuItem);
}

function highLightMenuItem(menuItem)
{
	docObj = document.getElementById(menuItem);
	docObj.className = "wh-current";
}

function makeBigMenuGoNow()
{
	hideSub('init','init')
}

function openMenu()
{
	if (typeof FM != "undefined" && FM != "undefined" && FM != null)
	{
	    var top = 'menu' + FM;
		hideAll(top, 0);
		hideSub(top, null);
		sc(top + '_option');
		toggleVis(top  ,0);
	
		if(typeof SM != "undefined" &&  SM != "undefined" && SM != null)
		{	 
			var mid = top + '_' + SM;
			toggleRows(mid);
					
			if(typeof TM != "undefined" &&  TM != "undefined" && TM != null)
			{	
				sc(mid + '_' + TM);				
			}		
		}	
	}
}

function mnu(type,link,l1,l2,l3,shC)
{
	var urlSuffix = "";
	var sc = "";	
	
	if (l1=="") {
		l1 = "undefined";
	}
	
	if (l2=="") {
		l2 = "undefined";
	}
	
	if (l3=="") {
		l3 = "undefined";
	}
		
	if (type == "L")
	{
		urlSuffix = "&page=LeafCategory&category_oid=" + link + "&fm=" + l1 + "&sm=" + l2 + "&tm=" + l3;
	}
	if (type == "P")
	{
		if (shC == "C")
		{
			sc = "&use_category=true";
		}
		else
		{
			sc = "&show_all=true";
		}
		urlSuffix = "&page=ProductList&category_oid=" + link + "&fm=" + l1 + "&sm=" + l2 + "&tm=" + l3 + sc;
	}
	if (type == "C")
	{
		urlSuffix = "&page=Category&category_oid=" + link + "&fm=" + l1 + "&sm=" + l2 + "&tm=" + l3;
	}	
	if (type == "E")
	{
		urlSuffix = "&page=GenericEditorial&genericeditorial=" + link + "&fm=" + l1 + "&sm=" + l2 + "&tm=" + l3;
	}
	// Prem Nazeer - 03/02/06 - the following cookie added to indicate 
	//			    the product list page opens from left navigation link.
	document.cookie = "FROM_LEFT_NAV=TRUE";
	
	window.location = C_BASE_URL + urlSuffix;
}

function openPopupWin(name, dest)
{
	var sParams = "toolbar=yes,menubar=yes,resizable=yes,height=600,width=800";
	var newWindow = window.open(dest, name, sParams);
	newWindow.focus();
}

function openGenericPopupWin(sThisURL,psThisWidth,psThisHeight)
{
	var sThisParams = "toolbar=no,scrollbars=1,resizable=1, menubar=no, width="+psThisWidth+",left =200,top=150,height="+psThisHeight;
	var psWindowGeneric = 'GenericEditorial';
	var newLeft = window.width/2  ;
	var GenericPopupWindow = window.open(sThisURL,psWindowGeneric,sThisParams);
	GenericPopupWindow.focus();
}

function openPopupWindow(url)
{
	var newWindow = window.open(url);
	newWindow.focus();
}

function up1 (level1) 
{   
	var mnu = "menu" + level1;

	hideAll(mnu,level1); 
	hideSub(mnu, null); 
	sc(mnu + "_option"); 
	toggleVis(mnu,level1); 
	return false;	
}

function up2 (level1, level2) 
{   

	hideSub("menu" + level1, "menu" + level1 + "_" + level2); 
	toggleRows("menu" + level1 + "_" + level2); 
	return false;
}
