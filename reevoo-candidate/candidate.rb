secret_message = "
**************************************************************************************
Woohoo, you found this very poorly hidden, mega-secret, message.

I say mega-secret, but to be honest, this is just a thinly veiled job advert for
reevoo.com.  Sorry, but I was bored on the train...

Anyhoo, if you fancy working with us then check Ben's post[1] and apply, apply, apply.

[1] http://www.reevoo.com/blogs/bengriffiths/2007/04/03/rails-developer-job/
**************************************************************************************

"
encoded_message = [secret_message].pack('m')

raw_code =<<-END_CODE
class Candidate
  def initialize(top_secret_password = nil)
    @secret_message = nil
    if top_secret_password == 'ruby is cool'
      @secret_message = "#{encoded_message}"
    end
  end
  def knows_the_secret_password?
    @secret_message
  end
  def loves_learning?
    true
  end
  def loves_ruby?
    true
  end
  def loves_problem_solving?
    true
  end
  def is_a_job_agency?
    false
  end
  def secret_message
    raise "Uh oh, looks like you have one other little method to implement..."
  end
end

class Test::Unit::TestCase
  def i_know_it_so_please_show_me_the_money(candidate)
    raise "Uh oh, that's not the right password" unless candidate.knows_the_secret_password?
    puts Candidate.new('ruby is cool').secret_message
  end
end
END_CODE

puts [raw_code].pack('m')