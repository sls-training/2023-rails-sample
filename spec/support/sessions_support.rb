module SessionsSupport
  # include Warden::Test::Helpers
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...

  include ApplicationHelper
  include SessionsHelper

  # テストユーザとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email, password: password, remember_me: remember_me } }
  end

  # 実行前にリクエストを発行してないと失敗する！
  #
  def is_logged_in?
    !session[:user_id].nil?
  end
end

RSpec.configure { |config| config.include SessionsSupport }
