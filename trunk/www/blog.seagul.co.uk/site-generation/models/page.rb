class Page
  
  attr_accessor :name, :title, :body, :created_at, :updated_at
  
  def initialize(attributes)
    attributes.each do |attribute, value|
      __send__("#{attribute}=", value)
    end
  end
  
  def self.find_all
    @pages ||= (
      pages_dir = File.join(File.dirname(__FILE__), *%w[.. .. content pages])
      Dir[File.join(pages_dir, '*.yml')].collect do |page_filename|
        page_attributes = YAML.load_file(page_filename)
        Page.new(page_attributes)
      end
    )
  end
  
  def formatted_created_date
    created_at.strftime("%a, %d %b %Y %H:%M:%S")
  end
  
  def body_html
    RedCloth.new(body).to_html(:textile)
  end
  
  def path
    PAGES_URL_ROOT
  end
  
  def url
    File.join(path, name)
  end
  
  public :binding
  
end