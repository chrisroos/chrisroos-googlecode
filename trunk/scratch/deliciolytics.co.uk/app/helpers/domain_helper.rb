module DomainHelper
  
  def domain_host(domain)
    URI.parse(domain.domain).host
  end
  
  def link_to_domain_host(domain)
    link_to domain_host(domain), domain_path(domain)
  end
  
end