module CollectionSpace
  module Converter
    module PublicArt
      include Default

      class PublicArtOrganization < Organization

        def convert
          run(wrapper: "document") do |xml|

            xml.send(
                "ns2:organizations_common",
                "xmlns:ns2" => "http://collectionspace.org/services/organization",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              # CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["name"])

              term_short_id = self.term_short_id
              CSXML.add xml, 'shortIdentifier', term_short_id


              CSXML.add_group_list xml, 'orgTerm',
                                   [{
                                        "termDisplayName" => attributes["termdisplayname"],
                                        "mainBodyName" => attributes["mainbodyname"],
                                    }]
            end

            xml.send(
                "ns2:organizations_publicart",
                "xmlns:ns2" => "http://collectionspace.org/services/organization/local/publicart",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              CSXML.add xml, 'currentPlace', CSXML::Helpers.get_authority_urn('placeauthorities', 'place', attributes["currentPlace"])
            end

          end
        end

      end

    end
  end
end
