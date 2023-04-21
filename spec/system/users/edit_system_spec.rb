RSpec.describe 'UsersEditSystem', type: :system do
  let(:user) { FactoryBot.create(:user) }
  describe 'Edit user info' do
    context 'with login' do
      before { log_in_as(user) }
    end

    context 'without login' do
      it 'does not allow to access' do
        visit edit_user_path(user)
        expect(page).to redirect_to
      end
    end
  end
end
