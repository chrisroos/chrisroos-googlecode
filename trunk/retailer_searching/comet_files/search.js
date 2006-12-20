

function getDimensionIdFromNavigationString(dimensionNavigationString) {

	var dimensionArray = dimensionNavigationString.split("+");
	
	if (dimensionArray.length > 0) {

		newDimension = dimensionArray[dimensionArray.length-1];

	}
	
	return newDimension;
}


function getRootNavigationFromNavigationString(dimensionNavigationString) {

	var dimensionArray = dimensionNavigationString.split("+");
	rootDimension = dimensionNavigationString;
	
	if (dimensionArray.length > 0) {

		rootDimension = dimensionArray[0];

	}
	
	return rootDimension;
}



function performAdvancedSearch() {
	
	var oldN = document.forms.advancedsearchform.n.value;
	var rootN = getRootNavigationFromNavigationString(oldN);
	
	//alert("oldN=" + oldN);
	//alert("rootN=" + rootN);
	var newN = rootN;
	
	/* Dimension checkboxes */	
	
	if (document.forms.advancedsearchform.dimension != null) {
		var dimensionCheckboxes;
		
		if (document.forms.advancedsearchform.dimension.length != null) {
			dimensionCheckboxes = document.forms.advancedsearchform.dimension;
		} else {
			dimensionCheckboxes = new Array(document.forms.advancedsearchform.dimension);
		}

		for (i = 0; i < dimensionCheckboxes.length; i++) {
			if (dimensionCheckboxes[i].checked) {
				var dimensionNavigationString = dimensionCheckboxes[i].value;
				var dimensionId = getDimensionIdFromNavigationString(dimensionNavigationString);
				newN = newN + "+" + dimensionId;
			}
		}
	}
	
	document.forms.advancedsearchform.n.value = newN;
	document.forms.advancedsearchform.submit();
	
}

function advancedSearchInit() {

	//alert("advancedSearchInit");
	var n = document.forms.advancedsearchform.n.value;
	
	//alert("n=" + n);
	
	var dimensionCheckboxes;
	if (document.forms.advancedsearchform.dimension != null) {
		if (document.forms.advancedsearchform.dimension.length != null) {
			dimensionCheckboxes = document.forms.advancedsearchform.dimension;
		} else {
			dimensionCheckboxes = new Array(document.forms.advancedsearchform.dimension);
		}
	}
	
	/* Calculate what checkboxes need to be ticked */
	var dimensionArray = n.split("+");
	
	if (dimensionArray.length > 0) {
	
		var rootn = dimensionArray[0];
		for (i = 1; i < dimensionArray.length; i++) {
			var dimensionToCheck = rootn + "+" + dimensionArray[i];
			
			/* check the checkboxes */
			
			if (document.forms.advancedsearchform.dimension != null) {
				for (j = 0; j < dimensionCheckboxes.length; j++) {
					if (dimensionCheckboxes[j].value == dimensionToCheck) {
					
						dimensionCheckboxes[j].checked = true;
					}
				}
			}			
		}
	}

}

function performFindSimilarSearch() {
	var oldN = document.forms.findsimilarform.n.value;
	var rootN = getRootNavigationFromNavigationString(oldN);
	
	var newN = rootN;
	/* Dimension checkboxes */	
	
	if (document.forms.findsimilarform.dimension != null) {
		var dimensionCheckboxes;
		if (document.forms.findsimilarform.dimension.length != null) {
			dimensionCheckboxes = document.forms.findsimilarform.dimension;
		} else {
			dimensionCheckboxes = new Array(document.forms.findsimilarform.dimension);
		}
		for (i = 0; i < dimensionCheckboxes.length; i++) {
			if (dimensionCheckboxes[i].checked) {
				var dimensionNavigationString = dimensionCheckboxes[i].value;
				var dimensionId = getDimensionIdFromNavigationString(dimensionNavigationString);
				if (newN != '') {
					newN = newN + "+" + dimensionId;
				} else {
					newN = dimensionId;
				}
			}
		}
	}
	
	document.forms.findsimilarform.n.value = newN;
	document.forms.findsimilarform.submit();
	
}


