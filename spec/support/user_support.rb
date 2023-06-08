# frozen_string_literal: true

module UserSupport
  def create_user_list(count)
    users = build_list(:user, count)
    User.insert_all users.map(&:attributes)
  end
end
RSpec.configure { |config| config.include UserSupport }
