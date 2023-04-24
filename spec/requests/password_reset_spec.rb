RSpec.describe 'PasswordReset', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before { ActionMailer::Base.deliveries.clear }

  describe 'POST /password_resets' do
    context 'with valid info' do
      it 'resets with valid email' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        @reset_user = controller.instance_variable_get('@user')
        expect(user.reset_digest).not_to eq @reset_user.reset_digest
        expect(ActionMailer::Base.deliveries.size).to eq 1
        expect(flash.empty?).to be_falsey
        expect(response).to redirect_to root_url
      end
    end

    context 'with invalid info' do
      it 'reset path with invalid email' do
        post password_resets_path, params: { password_reset: { email: '' } }
        expect(response).to have_http_status :unprocessable_entity
        expect(flash.empty?).to be_falsey
      end
    end
  end

  describe 'PATCH /password_resets' do
    before do
      # パスワードリセットのトークンを作成する
      post password_resets_path, params: { password_reset: { email: user.email } }
      @reset_user = controller.instance_variable_get('@user')
    end

    context 'with valid info' do
      it 'update with valid password and confirmation' do
        patch password_reset_path(@reset_user.reset_token),
              params: {
                email: @reset_user.email,
                user: {
                  password: 'foobaz',
                  password_confirmation: 'foobaz'
                }
              }
        assert is_logged_in?
        assert_not flash.empty?
        assert_redirected_to @reset_user
      end

      context 'passwordリセットした後のテスト' do
        before do
          # トークンを手動で失効させる
          @reset_user.update_attribute(:reset_sent_at, 3.hours.ago)
          # ユーザーのパスワードの更新を試みる
          patch password_reset_path(@reset_user.reset_token),
                params: {
                  email: @reset_user.email,
                  user: {
                    password: 'foobar',
                    password_confirmation: 'foobar'
                  }
                }
        end

        it 'redirects to the password-reset page' do
          expect(response).to redirect_to new_password_reset_url
        end

        it "includes the word 'expired' on the password-reset page" do
          follow_redirect!
          ## bodyにexpireが含まれているかどうかを検証
          assert_match /expired/i, response.body
        end
      end
    end

    context 'with invalid info' do
      it 'update with invalid password and confirmation' do
        patch password_reset_path(@reset_user.reset_token),
              params: {
                email: @reset_user.email,
                user: {
                  password: 'foobaz',
                  password_confirmation: 'barquux'
                }
              }
        assert_select 'div#error_explanation'
      end

      it 'update with empty password' do
        patch password_reset_path(@reset_user.reset_token),
              params: {
                email: @reset_user.email,
                user: {
                  password: '',
                  password_confirmation: ''
                }
              }
        assert_select 'div#error_explanation'
      end
    end
  end
end
