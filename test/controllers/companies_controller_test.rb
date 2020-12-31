require "test_helper"
require "application_system_test_case"

class CompaniesControllerTest < ApplicationSystemTestCase

  def setup
    @company = companies(:hometown_painting)
  end

  test "Index" do
    visit companies_path

    assert_text "Companies"
    assert_text "Hometown Painting"
    assert_text "Wolf Painting"
  end

  test "Show" do
    visit company_path(@company)

    assert_text @company.name
    assert_text @company.phone
    assert_text @company.email
    assert_text "City, State"
  end

  test "Update" do
    visit edit_company_path(@company)

    within('form#company-form') do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      click_button "Update Company"
    end

    assert_text "Company details updated successfully!"

    @company.reload
    assert_equal "Updated Test Company", @company.name
    assert_equal "93009", @company.zip_code
  end

  test "Create" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@test.com")
      click_button "Company details saved successfully!"
    end

    assert_text "Saved"

    last_company = Company.last
    assert_equal "New Test Company", last_company.name
    assert_equal "28173", last_company.zip_code
  end

  test 'Destroy' do
    visit companies_path

    companies_count = find('tr').all('li').size
    first('.list-group li a.btn-danger').click

    page.driver.browser.switch_to.alert.accept

    assert_text 'The company has been destroyed successfully!'
    assert_equal find('.list-group').all('li').size, (companies_count - 1)
  end

  test 'Validate Email format' do
    visit edit_company_path(@company)

    within('form#company-form') do
      fill_in('text-mail', with: 'test@xyz.com', fill_options: { clear: :backspace })
      accept_alert(with: 'Email must be a @getmainstreet.com domain based email') do
        click_button 'Update Company'
      end
    end
  end

  test 'Assign state and city to company' do
    visit edit_company_path(@company)

    within('form#company-form') do
      fill_in('company_zip_code', with: '37201', fill_options: { clear: :backspace })
      click_button 'Update Company'
    end

    @company.reload
    assert_equal 'Nashville', @company.city
    assert_equal 'TN', @company.state
  end

  test 'Set Brand Color' do
    visit edit_company_path(@company)

    within('form#company-form') do
      fill_in('company_brand_color', with: '#1ce3a1', fill_options: { clear: :backspace })
      click_button 'Update Company'
    end

    @company.reload
    assert_equal '#1ce3a1', @company.brand_color
  end
end
