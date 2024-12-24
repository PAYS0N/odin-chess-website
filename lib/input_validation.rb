# frozen_string_literal: true

module OdinChess
  # methods to get clean input from user
  class InputValidation
    # pass text and a block to ask user for input that when the block returns true, the input is validated. returns
    # valid input as inputted string
    def self.verify_input(prompt, error_msg = "Invalid, try again.", prep_proc = ->(x) { x.chomp }, test = ->(val) { !val.empty? }) # rubocop:disable Layout/LineLength
      puts prompt
      input = prep_proc.call(gets)
      until test.call(input)
        puts error_msg
        input = prep_proc.call(gets)
      end
      input
    end
  end
end
