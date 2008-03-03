subject = 'National Rail Enquiries'
sender = '"Ross, Alastair" <Alastair.Ross@atoc.org>'
received = '29th Feb 2008, 11:18'
recipient = 'chris@seagul.co.uk'
body = DATA.read

require 'erb'
include ERB::Util

template = File.open('template.html.erb') { |f| f.read }
erb = ERB.new(template)
File.open('email.html', 'w') { |f| f.puts(erb.result) }

__END__
Chris,



Just came across your blog and the integration work that you've done
with Twitter and our website.  Unfortunately our terms and conditions
<http://www.nationalrail.co.uk/contact/tandc/>  prohibit the use of our
site in the manner you are using it and I have to ask you to stop, close
down and remove any software of yours that uses information from
nationalrial.co.uk.



Many thanks,





________________________________

Alastair Ross
Service Delivery Manager - National Rail Enquiries

Add National Rail Enquiries to your iGoogle Home Page! - Click Here
<http://www.google.com/ig/adde?source=ignsrc1&moduleurl=http%3A//hosting
.gmodules.com/ig/gadgets/file/114104797270144350469/ojp.xml> 

Most Innovative Approach to Cycle-Rail Integration - National Rail Cycle
Awards 2007
Best Use of Technology Partnership - CCA Excellence Awards 2007
TrainTracker(tm) - Innovation of the Year - Transport Innovations 2007
Rail Supplier of the Year - Rail Business Awards 2006
Best Outsourced Call Centre - CCA Excellence Awards 2005
TrainTracker(tm) - Product of the Year, European Call Centre Awards 2005

TrainTracker(tm): 0871 200 49 50
TrainTracker Text(tm): SMS your station name to 8 49 50

Web: www.nationalrail.co.uk <http://www.nationalrail.co.uk> 
WAP: wap.nationalrail.co.uk


P Please consider the environment. Print less, recycle more, travel by
train.




****************************************************************************
The contents of this email and any associated files are for the addressee only and should be treated as confidential.  Unless you are the named addressee you cannot copy, use or disclose it to anyone else. If you have received this email in error please notify the sender immediately.  The email has originated from the Association of Train Operating Companies (an unincorporated trade association) or one of it’s corporate entities: ATOC Limited (3069033), Rail Settlement Plan Limited (3069042), Rail Staff Travel Limited (3069020) or NRES Limited (3691898) each of these companies are registered in England and Wales and with a common registered address - 3rd Floor, 40 Bernard Street, London WC1N 1BY.  Neither entity listed herein shall be liable for any defamatory statements.  Outbound messages are checked for all currently known viruses.
****************************************************************************