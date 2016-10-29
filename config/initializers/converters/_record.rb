module CollectionSpace
  module Converter
    module Default

      # used for remote actions
      # the authority is hard coded, so may want to make that configurable in future
      def self.service(type)
        {
          "Acquisition" => {
            path: "acquisitions", schema: "acquisitions"
          },
          "CollectionObject" => {
            path: "collectionobjects", schema: "collectionobjects"
          },
          "ConditionCheck" => {
            path: "conditionchecks", schema: "conditionchecks"
          },
          "Conservation" => {
            path: "conservation", schema: "conservation"
          },
          "LoanOut" => {
            path: "loansout", schema: "loansout"
          },
          "Location" => {
            path: "locationauthorities/urn:cspace:name(location)/items", schema: "locations"
          },
          "Media" => {
            path: "media", schema: "media"
          },
          "Movement" => {
            path: "movements", schema: "movements"
          },
          "ObjectExit" => {
            path: "objectexit", schema: "objectexit"
          },
          "Organization" => {
            path: "orgauthorities/urn:cspace:name(organization)/items", schema: "organizations"
          },
          "Person" => {
            path: "personauthorities/urn:cspace:name(person)/items", schema: "persons"
          },
          "Place" => {
            path: "placeauthorities/urn:cspace:name(place)/items", schema: "places"
          },
          "Relationship" => {
            path: "relations", schema: "relations"
          },
          "Taxon" => {
            path: "taxonomyauthority/urn:cspace:name(taxon)/items", schema: "taxon"
          },
          "ValuationControl" => {
            path: "valuationcontrols", schema: "valuationcontrols"
          },
        }[type]
      end

      def self.validate_authority!(authority)
        unless [ "Concept", "Location", "Material", "Person", "Place", "Organization", "Taxon", "Work" ].include? authority
          raise "Invalid authority #{authority}"
        end
      end

      # set which procedures can be created from model
      def self.validate_procedure!(procedure, converter)
        valid_procedures = converter.registered_procedures
        unless valid_procedures.include?("all") or valid_procedures.include?(procedure)
          raise "Invalid procedure #{procedure}, not permitted by configuration."
        end
      end

      class Record
        attr_reader :attributes

        def initialize(attributes)
          @attributes = attributes
        end

        # default implementation used by authorities
        # overriden by sub-classes for procedures, returns converted record
        def convert
          run do |xml|
            CollectionSpace::XML.add xml, 'shortIdentifier', attributes["shortIdentifier"]
            CollectionSpace::XML.add_group_list xml, attributes["termType"], [{
              "termDisplayName" => attributes["termDisplayName"],
            }]
          end
        end

        def run(document, service, common)
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.document(name: document) {
              if common
                xml.send(
                  "ns2:#{document}_common",
                  "xmlns:ns2" => "http://collectionspace.org/services/#{service}",
                  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
                ) do
                  # applying namespace breaks import
                  xml.parent.namespace = nil
                  yield xml
                end
              else
                yield xml # entire document (for extensions)
              end
            }
          end
          builder.to_xml
        end

        # return an array of fields as a string
        def scrub_fields(fields = [])
          fields.compact.join(". ").squeeze(".").gsub(/\n|\t/, "").strip
        end

        # process multivalued fields by splitting them and returning a flat array of all elements
        def split_mvf(attributes, *fields)
          values = []
          fields.each do |field|
            # TODO: log a warning ? may be noisy ...
            next unless attributes.has_key? field
            values << attributes[field]
              .to_s
              .split(Rails.application.config.csv_mvf_delimiter)
              .map(&:strip)
          end
          values.flatten.compact
        end

      end

      class Acquisition < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'acquisitions', 'acquisition', common
        end

      end

      class CollectionObject < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'collectionobjects', 'collectionobject', common
        end

      end

      class ConditionCheck < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'conditionchecks', 'conditioncheck', common
        end

      end

      class Conservation < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'conservation', 'conservation', common
        end

      end

      class LoanOut < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'loansout', 'loanout', common
        end

      end

      class Location < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'locations', 'location', common
        end

      end

      class Media < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'media', 'media', common
        end

      end

      class Movement < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'movements', 'movement', common
        end

      end

      class ObjectExit < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'objectexit', 'objectexit', common
        end

      end

      class Organization < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'organizations', 'organization', common
        end

      end

      class Person < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'persons', 'person', common
        end

      end

      class Place < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'places', 'place', common
        end

      end

      class Relationship < Record

        # override the default authority convert method inline
        def convert
          run do |xml|
            CollectionSpace::XML.add xml, 'subjectCsid', attributes["to_csid"]
            CollectionSpace::XML.add xml, 'subjectDocumentType', attributes["to_doc_type"]
            CollectionSpace::XML.add xml, 'relationshipType', "affects"
            CollectionSpace::XML.add xml, 'predicate', "affects"
            CollectionSpace::XML.add xml, 'objectCsid', attributes["from_csid"]
            CollectionSpace::XML.add xml, 'objectDocumentType', attributes["from_doc_type"]
          end
        end

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'relations', 'relation', common
        end

      end

      class Taxon < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'taxon', 'taxonomy', common
        end

      end

      class ValuationControl < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'valuationcontrols', 'valuationcontrol', common
        end

      end

    end
  end
end
