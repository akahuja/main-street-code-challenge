class CompanyTest < ActiveSupport::TestCase
  test 'Invalid Company Email' do
    company = Company.new(name: 'Hometown Painting', email: 'test@gmail.com', zip_code: '93003')

    assert_not company.valid?
  end

  test 'Valid Company Email' do
    company = Company.new(name: 'Hometown Painting', email: 'test@getmainstreet.com', zip_code: '93003')

    assert company.valid?
  end

  test 'Assign zipcode and state' do
    company = Company.new(name: 'Hometown Painting', email: 'test@getmainstreet.com', zip_code: '93003')
    company.save

    zip_hash = Zipcpdes.identify(company.zip_code)
    assert_equal company.state, zip_hash[:state_code]
    assert_equal company.city, zip_hash[:city]
  end
end
