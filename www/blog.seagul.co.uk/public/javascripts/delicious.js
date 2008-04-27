var ul = document.createElement('ul')
for (var i=0, post; post = Delicious.posts[i]; i++) {
  var li = document.createElement('li')
  var a = document.createElement('a')
  a.setAttribute('href', post.u)
  a.appendChild(document.createTextNode(post.d))
  li.appendChild(a)
  li.appendChild(document.createTextNode(' - ' + post.n))
  ul.appendChild(li)
}
document.getElementById('deliciousContainer').appendChild(ul)