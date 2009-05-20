require 'tmail'
require 'test/unit'
require 'pp'

module Permailink
  class Email
    attr_reader :forwarded_by
    def initialize(filename)
      @tmail = TMail::Mail.load(filename)
      @forwarded_by = @tmail.from.first
      @tmail = TMail::Mail.parse(@tmail.attachments.first.string)
    end
    def received_at
      @tmail.date
    end
    def subject
      @tmail.subject
    end
    def sender
      @tmail.from_addrs.first.to_s
    end
    def to
      @tmail.to_addrs.first.to_s
    end
  end
end

class PermailinkTestCase < Test::Unit::TestCase
  include Permailink
  def test_;
    # need a test to stop test::unit from crying
  end
  def email_fixture(filename)
    File.join(File.dirname(__FILE__), 'fixtures', filename)
  end
end

class PlainTextForwardInlineAlaGmailTest < PermailinkTestCase
  
  def test_council_ukplanning
    flunk "I need to do some special parsing for emails forwarded inline"
    tmail = TMail::Mail.load(email_fixture('inline-thanet-council-ukplanning'))
    email_body = tmail.body.sub(/.*Forwarded message.*/, '')
    a = TMail::Mail.parse(email_body)
    p a.body
#    email = Email.new email_fixture('inline-thanet-council-ukplanning')
#    assert_equal 'chris@seagul.co.uk', email.sender
#    assert_equal 'Thu, Aug 7, 2008 at 10:04 AM', email.received_at
  end

  def test_activeplaces_data
    flunk "I need to do some special parsing for emails forwarded inline"
    email = Email.new email_fixture('inline-active-places-data')
    assert_equal 'chris@seagul.co.uk', email.sender
  end

  def test_tlf_new_swimming_pool
    flunk "I need to do some special parsing for emails forwarded inline"
    email = Email.new email_fixture('inline-thanet-leisure-force-new-swimming-pool')
    assert_equal 'chris@seagul.co.uk', email.sender
  end

end
require 'parsedate'
class PlainTextForwardAsAttachmentAlaThunderbird < PermailinkTestCase

  def test_nat_rail_enquiries
    email = Email.new email_fixture('plain-text-attachment-national-rail-enquiries')
    assert_equal 'chris@seagul.co.uk', email.forwarded_by
    assert_equal Time.gm(*ParseDate.parsedate("Tue, 11 Mar 2008 06:51:58 -0000")), email.received_at
    assert_equal 'RE: National Rail Enquiries', email.subject
    assert_equal '"Ross, Alastair" <Alastair.Ross@atoc.org>', email.sender
    assert_equal 'Chris Roos <chris@seagul.co.uk>', email.to # to_addrs strips off the quotes around the name, where from_addrs doesn't
  end

end

class MultipartForwardAsAttachmentAlaThunderbird < PermailinkTestCase

  def test_tlf_new_swimming_pool
    email = Email.new email_fixture('multipart-attachment-thanet-leisure-force-new-swimming-pool')
    assert_equal 'chris@seagul.co.uk', email.sender
  end

end
