var mp_add="https://img.mediaplex.com/cgi-bin/html/0/7286/39550/689_7286_";
var mp_ifprops='width=1 height=1 marginwidth=0 marginheight=0 hspace=0 vspace=0 frameborder=0 scrolling=no bordercolor="#000000"';

mp_page = "";
 
if (tpt_pageName == "DeliveryDetails") {
    mp_page = "nest.html";
} else if ( tpt_pageName ==  "OrderConfirm" ) {
    mp_page = "nest_online.html";
} else if ( tpt_pageName ==  "CasOrderConfirmation" ) {
    mp_page = "nest_collect.html";
} else {
    mp_page = null;   
} 

function mp_getSid()
{
    mp_pattern = /@@@@(\d+\.\d+)@@@@/;
    var  result = C_BASE_URL.match(mp_pattern);
 
    return result[1].replace(/\./,"");
}

function mp_write(s)
{
    window.document.write(s);
}

function mp_getSku(s)
{
     return s.substring(s.lastIndexOf("(") + 1, s.lastIndexOf(")") );    
}

function mp_getDesc(s)
{
    return s.substring(0, s.lastIndexOf("(") ); 
}

function mp_genFrame()
{
    var s="";
   
    if (mp_page == null || s_products == "") {
        return "";
    }
    
    var mp_prods = s_products.split(",");
    var sep = "";
    
    for (i=0; i<mp_prods.length; i++) 
    {
     
           var mp_p = mp_prods[i].split(";");
       
           if (mp_p[0].match(/event/)) { // skip event data 
          
            continue;
           }
         
           count = i + 1;   
           
           s = s + sep + "factgroup" + count + "=" + mp_p[0].replace(/ /g,'_') 
           + "&" + "qty" + count + "=" + mp_p[2] 
           + "&" + "sku" + count + "=" + mp_getSku(mp_p[1])
           + "&" + "price" + count + "=" + mp_p[3];
           
           sep = "&";
    }
  
    s = s + "&mpt=" + mp_getSid();
         
    var mp_frames = "<iframe src='" + mp_add + mp_page + "?" + s + "' " + mp_ifprops+">";
        
    mp_frames +="\n</iframe>"
    
    return mp_frames;
}

mp_write(mp_genFrame());
