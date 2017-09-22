module CollectionSpace
  module Converter
    module Vanilla
      include Default

      class VanillaLoanIn < LoanIn

        def convert
          run do |xml|
            #loanInNumber
            CSXML.add xml, 'loanInNumber', attributes["loan_in_number"]

            #lenderGroupList
            CSXML.add_group_list xml, 'lender', [{
              "lender" => CSXML::Helpers.get_authority_urn('orgauthorities', 'organization', attributes["lender"]),
              "lendersAuthorizer" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["lender's_authorizer"]),
            }] if attributes["lender's_authorizer"]

            #borrowersAuthorizer
            CSXML::Helpers.add_persons xml, 'borrowersAuthorizer', [attributes["borrower's_authorizer"]]

            #loanStatusGroupList
            CSXML.add_group_list xml, 'loanStatus', [{
              "loanStatus" =>  CSXML::Helpers.get_vocab_urn('loanoutstatus', attributes["loan_status"]),
              "loanStatusDate" => attributes["loan_status_date"],
            }] if attributes["loan_status"]

            #loanInDate
            CSXML.add xml, 'loanInDate', attributes["loan_in_date"]

            #loanInNote
            CSXML.add xml, 'loanInNote', scrub_fields([attributes["loan_in_note"]])

          end
        end

      end

    end
  end
end
