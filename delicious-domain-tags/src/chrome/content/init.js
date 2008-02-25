// Crappy way to add our initialisation to the onload of the addBookmark dialog
// Sets the onload attribute to be a string containing the initial value plus our own initializer

var yAddBookmarkDialog = document.getElementById('dlg_AddYBookMark');
var yAddBookmarkOnload = yAddBookmarkDialog.getAttribute('onload');
var onload = 'deliciousDomainTags.addDomainTag()';
yAddBookmarkDialog.setAttribute('onload', [yAddBookmarkOnload, onload].join(';'))