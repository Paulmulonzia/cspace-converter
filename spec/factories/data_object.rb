FactoryGirl.define do

  factory :data_object do
    converter_profile 'cataloging'
    import_batch 'cataloging1'
    import_category 'Procedures'
    import_file 'cataloging1.csv'
    object_data { { id: '1' } }
  end

end
