        M3_zoneids = '';
        for (var zonename in M3_zones) M3_zoneids += M3_zones[zonename] + "|";
    
        var M3_p=location.protocol=='https:'?'https:':'http:';
        var M3_r=Math.floor(Math.random()*99999999);
        var MAX_output = new Array();
    
        var M3_spc="<"+"script language='JavaScript' type='text/javascript' ";
        M3_spc+="src='"+M3_p+"//d.m3.net/fc.php?MAX_type=spc&zones="+M3_zoneids;
        M3_spc+="&channel="+M3_channel+"&r="+M3_r;
        if (window.location) M3_spc+="&loc="+escape(window.location);
        if (document.referrer) M3_spc+="&referer="+escape(document.referrer);
        M3_spc+="'><"+"/script>";
        document.write(M3_spc);
    
        function M3_writeAd(name) {
            if ((typeof(M3_zones[name]) == 'undefined') || (typeof(MAX_output[M3_zones[name]]) == 'undefined')) {
                return;
            } else {
                document.write(MAX_output[M3_zones[name]]);
            }
        }