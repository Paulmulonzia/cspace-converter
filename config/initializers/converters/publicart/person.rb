module CollectionSpace
  module Converter
    module PublicArt
      include Default

      class PublicArtPerson < Person

        def convert
          run(wrapper: "document") do |xml|

            xml.send(
                "ns2:persons_common",
                "xmlns:ns2" => "http://collectionspace.org/services/person",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              # CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["name"])

              term_short_id = self.term_short_id
              CSXML.add xml, 'shortIdentifier', term_short_id


              CSXML.add_group_list xml, 'personTerm',
                                   [{
                                        "termDisplayName" => attributes["termdisplayname"],
                                        "termType" => CSXML::Helpers.get_vocab_urn('persontermtype', attributes["termtype"]),
                                    }]
            end

            xml.send(
                "ns2:persons_publicart",
                "xmlns:ns2" => "http://collectionspace.org/services/person/local/publicart",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              # organizations
              organization_urns = []
              organizations = split_mvf attributes, 'organization'
              organizations.each do |organization|
                organization_urns << { "organization" => CSXML::Helpers.get_authority_urn('orgauthorities', 'organization', organization, true) }
              end
              CSXML.add_repeat(xml, 'organizations', organization_urns) if attributes["organization"]
            end

          end
        end

      end

    end
  end
end
