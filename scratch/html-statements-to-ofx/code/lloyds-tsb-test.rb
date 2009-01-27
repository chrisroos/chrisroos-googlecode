# TODO: Check whether I can actully upload ofx files that appear in lower case

require 'test/unit'

require 'hpricot'
require 'builder'
class LloydsTsb
  def initialize(html)
    doc = Hpricot(html)
    @currency = 'GBP'
    @sortcode = '30-96-93'
    @account_number = '00614016'
    @account_type = 'CHECKING'
    @first_transaction_date = '20080826'
    @last_transaction_date = '20080826'
    @balance_amount = 885.68
  end
  def to_ofx
    buffer = ''
    xml = Builder::XmlMarkup.new(:target => buffer, :indent => 2)
    xml.instruct!
    xml.instruct!(:OFX, :OFXHEADER => '200', :VERSION => '200', :SECURITY => 'NONE', :OLDFILEUID => 'NONE', :NEWFILEUID => 'NONE')
    xml.OFX do
      xml.BANKMSGSRSV1 do
        xml.STMTTRNRS do 
          xml.STMTRS do
            xml.CURDEF(@currency)
            xml.BANKACCTFROM do
              xml.BANKID(@sortcode)
              xml.ACCTID(@account_number)
              xml.ACCTTYPE(@account_type)
            end
            xml.BANKTRANLIST do
              xml.DTSTART(@first_transaction_date)
              xml.DTEND(@last_transaction_date)
              # transactions.each do
            end
            xml.LEDGERBAL do
              xml.BALAMT(@balance_amount)
              xml.DTASOF(@last_transaction_date)
            end
          end
        end
      end
    end
    buffer
  end
end

class LloydsTsbOfxTest < Test::Unit::TestCase

  def setup
    html = File.read('lloyds-tsb.html')
    ofx = LloydsTsb.new(html).to_ofx
    @doc = Hpricot(ofx)
  end

  def test_should_include_the_xml_processing_instruction
    xml_declaration = (@doc/'/')[0]
    assert xml_declaration.xmldecl?
    # TODO: Find a way to more reliably obtain the xml declaration
    # TODO: Find a way to check the attributes of the xml declaration
  end

  def test_should_include_the_ofx_processing_instruction
    ofx_processing_instruction = @doc.search('//').detect { |e| e.procins? }
    assert ofx_processing_instruction.procins?
    assert_match(/OFXHEADER="200"/, ofx_processing_instruction.to_s)
    assert_match(/SECURITY="NONE"/, ofx_processing_instruction.to_s)
    assert_match(/OLDFILEUID="NONE"/, ofx_processing_instruction.to_s)
    assert_match(/NEWFILEUID="NONE"/, ofx_processing_instruction.to_s)
    assert_match(/VERSION="200"/, ofx_processing_instruction.to_s)
  end

  def test_should_include_the_bank_message_set_response_within_the_root_ofx_element
    assert_xpath_node_exists ofx_root, bank_message_set_response
  end

  def test_should_include_the_statement_transaction_response_within_the_bank_message_set_response
    assert_xpath_node_exists ofx_root, bank_message_set_response, statement_transaction_response
  end

  def test_should_include_the_statement_response_within_the_statement_transaction_response
    assert_xpath_node_exists ofx_root, bank_message_set_response, statement_transaction_response, statement_response
  end

  def test_should_include_the_default_currency_within_the_statement_response
    assert_xpath_node_equal 'GBP', ofx_root, bank_message_set_response, statement_transaction_response, statement_response, default_currency
  end

  def test_should_include_the_source_bank_account_aggregate_within_the_statement_response
    assert_xpath_node_exists ofx_root, bank_message_set_response, statement_transaction_response, statement_response, source_bank_account_aggregate
  end

  def test_should_include_the_sortcode_as_the_bank_identifier_within_the_source_bank_account_aggregate
    assert_xpath_node_equal '30-96-93', ofx_root, bank_message_set_response, statement_transaction_response, statement_response, source_bank_account_aggregate, bank_identifier
  end

  def test_should_include_the_account_number_within_the_source_bank_account_aggregate
    assert_xpath_node_equal '00614016', ofx_root, bank_message_set_response, statement_transaction_response, statement_response, source_bank_account_aggregate, account_identifier
  end

  def test_should_include_the_account_type_within_the_source_bank_account_aggregate
    assert_xpath_node_equal 'CHECKING', ofx_root, bank_message_set_response, statement_transaction_response, statement_response, source_bank_account_aggregate, account_type
  end

  def test_should_include_the_statement_transaction_data_within_the_statement_response
    assert_xpath_node_exists ofx_root, bank_message_set_response, statement_transaction_response, statement_response, statement_transaction_data
  end

  def test_should_include_the_date_of_the_first_transaction_within_the_statement_transaction_data
    assert_xpath_node_equal '20080826', ofx_root, bank_message_set_response, statement_transaction_response, statement_response, statement_transaction_data, date_start
  end

  def test_should_include_the_date_of_the_last_transaction_within_the_statement_transaction_data
    assert_xpath_node_equal '20080826', ofx_root, bank_message_set_response, statement_transaction_response, statement_response, statement_transaction_data, date_end
  end

  def test_should_include_the_transaction_type_of_the_transaction
    flunk "TODO: Transactions (STMTTRN)"
    assert_xpath_node_equal 'CREDIT', ofx_root, bank_message_set_response, statement_transaction_response, statement_response, statement_transaction_data, statement_transaction, transaction_type   
  end

  def test_should_include_the_ledger_balance_aggregate_within_the_statement_response
    assert_xpath_node_exists ofx_root, bank_message_set_response, statement_transaction_response, statement_response, ledger_balance_aggregate
  end

  def test_should_include_the_balance_amount_within_the_ledger_balance_aggregate
    assert_xpath_node_equal '885.68', ofx_root, bank_message_set_response, statement_transaction_response, statement_response, ledger_balance_aggregate, balance_amount
  end

  def test_should_include_the_balance_date_within_the_ledger_balance_aggregate
    assert_xpath_node_equal '20080826', ofx_root, bank_message_set_response, statement_transaction_response, statement_response, ledger_balance_aggregate, balance_date
  end

  private
  
    def assert_xpath_node_exists(*elements)
      xpath = xpath(*elements)
      assert_not_nil @doc.at(xpath), "XPath (#{xpath}) was not found in:\n#{@doc}"
    end

    def assert_xpath_node_equal(expected, *elements)
      xpath = xpath(*elements)
      assert_not_nil @doc.at(xpath), "XPath (#{xpath}) was not found in:\n#{@doc}"
      assert_equal expected, @doc.at(xpath).inner_text
    end

    def xpath(*elements)
      elements.join('/')
    end

    def ofx_root
      'ofx'
    end

    def bank_message_set_response
      'bankmsgsrsv1'
    end

    def statement_transaction_response
      'stmttrnrs'
    end

    def statement_response
      'stmtrs'
    end

    def default_currency
      'curdef'
    end

    def source_bank_account_aggregate
      'bankacctfrom'
    end

    def bank_identifier
      'bankid'
    end

    def account_identifier
      'acctid'
    end

    def account_type
      'accttype'
    end

    def statement_transaction_data
      'banktranlist'
    end

    def date_start
      'dtstart'
    end

    def date_end
      'dtend'
    end

    def statement_transaction
      'stmttrn'
    end

    def transaction_type
      'trntype'
    end

    def ledger_balance_aggregate
      'ledgerbal'
    end

    def balance_amount
      'balamt'
    end

    def balance_date
      'dtasof'
    end

end
