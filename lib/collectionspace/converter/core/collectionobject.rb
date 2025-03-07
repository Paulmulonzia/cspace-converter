module CollectionSpace
  module Converter
    module Core
      class CoreCollectionObject < CollectionObject
        ::CoreCollectionObject = CollectionSpace::Converter::Core::CoreCollectionObject
        def convert
          run do |xml|
            CoreCollectionObject.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'objectNumber', attributes["objectnumber"]
          CSXML.add xml, 'numberOfObjects', attributes["numberofobjects"]
          CSXML::Helpers.add_title(xml, attributes)

          CSXML.add_list xml, 'objectName', [{
            "objectName" => attributes["objectname"],
          }], 'Group' if attributes["objectname"]

          CSXML.add_repeat xml, 'briefDescriptions', [{
            "briefDescription" => scrub_fields([attributes["briefdescription"]])
          }]

          CSXML.add_repeat xml, 'responsibleDepartments', [{
            "responsibleDepartment" => attributes["responsibledepartment"]
          }] if attributes["responsibledepartment"]

          CSXML.add xml, 'collection', attributes["collection"]
          CSXML.add xml, 'recordStatus', attributes["recordstatus"]

          CSXML.add_repeat xml, 'comments', [{
            "comment_" => scrub_fields([attributes["comments"]])
          }]

          # measuredPartGroupList
          overall_data = {
            "measuredPart" => attributes["dimensionpart"],
            "dimensionSummary" => attributes["dimensionsummary"],
          }
          dimensions = []
          dims = split_mvf attributes, 'dimension'
          values = split_mvf attributes, 'value'
          unit = attributes["unit"]
          dims.each_with_index do |dim, index|
            dimensions << { "dimension" => dim, "value" => values[index], "measurementUnit" => unit }
          end
          CSXML.add_group_list xml, 'measuredPart', [overall_data], 'dimension', dimensions

          if attributes["contentperson"]
            contentpersons = split_mvf attributes, 'contentperson'
            CSXML::Helpers.add_persons xml, 'contentPerson', contentpersons, :add_repeat
          end

          CSXML.add xml, 'copyNumber', attributes["copynumber"]
          CSXML.add xml, 'editionNumber', attributes["editionnumber"]
          CSXML.add_repeat xml, 'forms', [{ "form" => attributes["form"] }]

          CSXML.add_group_list xml, 'textualInscription', [{
            inscriptionContentInscriber => CSURN.get_authority_urn('personauthorities', 'person', attributes["inscriber"]),
            inscriptionContentMethod => attributes["method"],
          }] if attributes["inscriber"]

          # materialGroupList
          mgs = []
          materials = split_mvf attributes, 'material'
          materials.each do |m|
            mgs << { "material" => m }
          end
          CSXML.add_group_list xml, 'material', mgs

          CSXML.add_list xml, 'objectStatus', [{
            "objectStatus" => attributes["objectstatus"]
          }] if attributes["objectstatus"]

          CSXML.add xml, 'phase', attributes["phase"]
          CSXML.add xml, 'sex', attributes["sex"]
          CSXML.add_repeat xml, 'styles', [{ "style" => attributes["style"] }]

          CSXML.add_group_list xml, 'technicalAttribute', [{
            "technicalAttribute" => attributes["techattribute"],
          }] if attributes["techattributes"]

          CSXML.add_group_list xml, "objectComponent", [{
            "objectComponentName" => attributes["objectcomponentname"]
          }] if attributes["objectcomponentname"]

          CSXML.add_group_list xml, "objectProductionDate", [{
            "dateDisplayDate" => attributes["productionddate"]
          }] if attributes["productionddate"]

          CSXML.add_group_list xml, 'objectProductionOrganization', [{
            "objectProductionOrganization" => CSURN.get_authority_urn('orgauthorities', 'organization', attributes["productionorg"]),
            "objectProductionOrganizationRole" => attributes["organizationrole"],
          }] if attributes["productionorg"]

          CSXML.add_group_list xml, 'objectProductionPeople', [{
            "objectProductionPeople" => attributes["productionpeople"]
          }] if attributes["productionpeople"]

          CSXML.add_group_list xml, 'objectProductionPerson', [{
            "objectProductionPerson" => CSURN.get_authority_urn('personauthorities', 'person', attributes["productionperson"]),
            "objectProductionPersonRole" => attributes["personrole"],
          }] if attributes["productionperson"]

          CSXML.add_group_list xml, 'objectProductionPlace', [{
            "objectProductionPlace" => attributes["productionplace"]
          }] if attributes["productionplace"]

          # techniqueGroupList
          tgs = []
          techniques = split_mvf attributes, 'technique'
          techniques.each do |t|
            tgs << { "technique" => t }
          end
          CSXML.add_group_list xml, 'technique', tgs

          CSXML.add_repeat xml, 'fieldColEventNames', [{
            "fieldColEventName" => attributes["fieldcollectioneventname"]
          }]
        end
      end
    end
  end
end
