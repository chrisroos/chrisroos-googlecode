require 'hpricot'

html = File.read('smile')
doc = Hpricot(html)

module Smile
  class Number
    def initialize(number)
      @number = number
      remove_pound_sign
      move_negative_sign_if_applicable
      convert_to_float
    end
    private
      def remove_pound_sign
        @number.gsub!(/\243/, '')
      end
      def move_negative_sign_if_applicable
        @number.gsub!(/(.*)-/, '-\1')
      end
      def convert_to_float
        @number = Float(@number)
      end
  end
  require 'date'
  class Date
    def initialize(date)
      @date = ::Date.strptime("26/08/2008", "%d/%m/%Y")
    end
  end
  class Account
    attr_accessor :number, :sort_code
    def balance=(balance)
      @balance = Number.new(balance)
    end
    def available_balance=(available_balance)
      @available_balance = Number.new(available_balance)
    end
    def overdraft_limit=(overdraft_limit)
      @overdraft_limit = Number.new(overdraft_limit)
    end
  end
  class Transaction
    attr_accessor :date, :details, :credit, :debit
    def date=(date)
      @date = Date.new(date)
    end
  end
end


def account_details_table?(table)
  (table/'tr').length == 3 and (table/'tr:nth(0)'/'td:nth(0)').inner_text == 'account number'
end

account = Smile::Account.new
(doc/'table').each do |table|
  next unless account_details_table?(table)

  account.number            = (table/'tr:nth(0)'/'td:nth(1)').inner_text
  account.sort_code         = (table/'tr:nth(1)'/'td:nth(1)').inner_text
  account.available_balance = (table/'tr:nth(0)'/'td:nth(3)').inner_text
  account.balance           = (table/'tr:nth(1)'/'td:nth(3)').inner_text
  account.overdraft_limit   = (table/'tr:nth(2)'/'td:nth(1)').inner_text

  p account
end

transaction = Smile::Transaction.new
(doc/'table.summarytable'/'tbody'/'tr').each do |table_row|
  transaction.date    = (table_row/'td:nth(0)').inner_text
  transaction.details = (table_row/'td:nth(1)').inner_text
  transaction.credit  = (table_row/'td:nth(2)').inner_text
  transaction.debit   = (table_row/'td:nth(3)').inner_text
  break
end
p transaction
