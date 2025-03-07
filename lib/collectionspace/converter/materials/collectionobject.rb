module CollectionSpace
  module Converter
    module Materials
      class MaterialsCollectionObject < CollectionObject
        ::MaterialsCollectionObject = CollectionSpace::Converter::Materials::MaterialsCollectionObject
        def convert
          run do |xml|
            CoreCollectionsObject.map(xml, attributes)
            MaterialsCollectionObject.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add_list xml, 'otherNumber', [{
            'numberType' => attributes["numbervalue"],
            'numberValue' => attributes["numbertype"],
          }]

          # TODO: update mapping & csv
          CSXML.add xml, 'condition', attributes["condition"]
          CSXML.add xml, 'conditionNote', attributes["conditionnote"]
          # conservation
          CSXML.add xml, 'container', attributes["container"]
          CSXML.add xml, 'containerNote', attributes["container_note"]
          # handling
          CSXML.add xml, 'handling', attributes["handling"]
          CSXML.add xml, 'handlingNote', attributes["handling_note"]
          # inventory_status
          CSXML.add xml, 'inventoryStatus', attributes["inventory_status"]
          # materialGroupList
            CSXML.add_group_list xml, 'material', [{
            "material" => attributes["material"]
          }]
          # numberOfObjects
          CSXML.add xml, 'numberOfObjects', attributes["number_of_objects"]
          # publishTo
          CSXML.add xml, 'publishTo', attributes["publish_to"]
          # collection
          CSXML.add xml, 'collection', attributes["collection"]
          # recordStatus
          CSXML.add xml, 'recordStatus', attributes["record_status"]
          # color
          CSXML.add xml, 'color', attributes["color"]
          # Dimension
          dimensions = []
          dims = split_mvf attributes, 'dimension'
          dims.each do |dim|
            dimensions << { "dimension" => dim}
          end
          CSXML.add_group_list xml, 'dimension', dimensions
          # finish
          CSXML.add xml, 'finish', attributes["finish"]
          CSXML.add xml, 'finishNote', attributes["finish_note"]
          # materialGenericColor
          CSXML.add xml, 'materialGenericColor', attributes["material_generic_color"]
          # objectStatus
          CSXML.add xml, 'objectStatus', attributes["object_status"]
          # physicalDescription
          CSXML.add xml, 'physicalDescription', attributes["physical_description"]
        end
      end
    end
  end
end
