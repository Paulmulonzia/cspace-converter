require 'rails_helper'

RSpec.describe CSXML do
  def doc(xml)
    Nokogiri::XML(xml.to_xml)
  end

  let(:xml) { Nokogiri::XML::Builder.new(:encoding => 'UTF-8') }
  let(:source_data_date) { '1971' }
  let(:structured_date) { CSDTP.parse(source_data_date) }

  it "can 'add' correctly" do
    CSXML.add(xml, 'foo', 'bar')
    expect(doc(xml).xpath('/foo').text).to eq('bar')
  end

  it "can 'add group' correctly" do
    key = 'accessionDate'
    elements = {
      "dateDisplayDate" => '01-01-2000',
      'dateLatestDay' => '10?',
    }
    CSXML.add_group(xml, key, elements)
    expect(doc(xml).xpath(
      '/accessionDateGroup/dateDisplayDate').text).to eq('01-01-2000')
    expect(doc(xml).xpath(
      '/accessionDateGroup/dateLatestDay').text).to eq('10?')
  end

  it "can 'add group list' correctly" do
    key = 'objectProductionDate'
    elements = [
      {
        "scalarValuesComputed" => true,
        "dateEarliestSingleDay" => structured_date.earliest_day,
        "dateEarliestScalarValue" => structured_date.earliest_scalar,
        "dateLatestScalarValue" => structured_date.latest_scalar,
        "dateLatestDay" => structured_date.latest_day,
      },
      {
        "scalarValuesComputed" => false,
      }
    ]
    CSXML.add_group_list(xml, key, elements)

    expect(doc(xml).xpath(
      '/objectProductionDateGroupList/objectProductionDateGroup[position()=1]/scalarValuesComputed').text).to eq('true')
    expect(doc(xml).xpath(
      '/objectProductionDateGroupList/objectProductionDateGroup[position()=2]/scalarValuesComputed').text).to eq('false')

    expect(doc(xml).xpath(
      '/objectProductionDateGroupList/objectProductionDateGroup[position()=1]/dateEarliestScalarValue').text).to eq("1971-01-01T00:00:00.000Z")
    expect(doc(xml).xpath(
      '/objectProductionDateGroupList/objectProductionDateGroup[position()=1]/dateLatestScalarValue').text).to eq("1972-01-01T00:00:00.000Z")
  end

  it "can 'add group list' without sub key and with sub elements correctly" do
    key = 'publicartProductionDate'
    elements = [
      {
        "publicartProductionDateType" => "Commission",
      },
      {
        "publicartProductionDateType" => "Purchase",
      }
    ]
    sub_elements = [
      {
        "publicartProductionDate" => {
          "scalarValuesComputed" => true,
          "dateEarliestSingleDay" => structured_date.earliest_day,
          "dateEarliestScalarValue" => structured_date.earliest_scalar,
          "dateLatestScalarValue" => structured_date.latest_scalar,
          "dateLatestDay" => structured_date.latest_day,
        },
      },
      {
        "publicartProductionDate" => {
          "scalarValuesComputed" => false,
      },
      }
    ]
    CSXML.add_group_list(xml, key, elements, false, sub_elements)

    expect(doc(xml).xpath(
      '/publicartProductionDateGroupList/publicartProductionDateGroup[position()=1]/publicartProductionDate/scalarValuesComputed').text).to eq('true')
    expect(doc(xml).xpath(
      '/publicartProductionDateGroupList/publicartProductionDateGroup[position()=1]/publicartProductionDateType').text).to eq('Commission')

    expect(doc(xml).xpath(
      '/publicartProductionDateGroupList/publicartProductionDateGroup[position()=2]/publicartProductionDate/scalarValuesComputed').text).to eq('false')
    expect(doc(xml).xpath(
      '/publicartProductionDateGroupList/publicartProductionDateGroup[position()=2]/publicartProductionDateType').text).to eq('Purchase')
  end

  it "can 'add data' correctly" do
    data = {
      "label" => "publicartProductionDateGroupList",
      "elements" => [
        {
          "publicartProductionDateGroup" => [
            {
              "publicartProductionDate" => [
                {
                  "scalarValuesComputed" => true,
                },
              ],
              "publicartProductionDateType" => "Commission",
            },
            {
              "publicartProductionDate" => [
                {
                  "scalarValuesComputed" => false,
                }
              ],
              "publicartProductionDateType" => "Purchase",
            },
          ],
        },
      ]
    }
    CSXML.add_data(xml, data)
    expect(doc(xml).xpath(
      '/publicartProductionDateGroupList/publicartProductionDateGroup[position()=1]/publicartProductionDate/scalarValuesComputed').text).to eq('true')

    expect(doc(xml).xpath(
      '/publicartProductionDateGroupList/publicartProductionDateGroup[position()=2]/publicartProductionDate/scalarValuesComputed').text).to eq('false')
  end
end
