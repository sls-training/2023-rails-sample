RSpec::Matchers.define :have_error do |name, message|
  match do |actual|
    actual.parsed_body['errors'].include?({ 'name' => name, 'message' => message })
  end
end
