# frozen_string_literal: true

module UserSupport
  def create_user_list(count)
    users = build_list(:user, count)
    User.insert_all users.map(&:attributes)
  end

  def user_to_api_user(user)
    {
      id:           user.id,
      name:         user.name,
      email:        user.email,
      admin:        user.admin,
      activated:    user.activated,
      activated_at: user.activated_at&.iso8601(2),
      created_at:   user.created_at.iso8601(2),
      updated_at:   user.updated_at.iso8601(2)
    }
  end
end
RSpec.configure { |config| config.include UserSupport }
