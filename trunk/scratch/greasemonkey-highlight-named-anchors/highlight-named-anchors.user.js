var interestingNodes = ['a'];

for (var nodeIndex = 0; nodeIndex < interestingNodes.length; nodeIndex++) {
  var nodeName = interestingNodes[nodeIndex];
  
  var elements = Array.slice(document.getElementsByTagName(nodeName)); // We slice in order to convert the 'live' NodeList to a static array.
  for (var elementIndex = 0; elementIndex < elements.length; elementIndex++) {
    var element = elements[elementIndex];
    
    var target = element.getAttribute('name') || element.getAttribute('id');
    if (target) {
      var anchor = document.createElement('a');
      anchor.setAttribute('href', '#' + target);
      anchor.setAttribute('style', 'color: #f00; background-color: #ff0;')
      anchor.appendChild(document.createTextNode('#'));
      element.parentNode.insertBefore(anchor, element);
    }
  }
}