# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'AdminUsers' do
  let!(:admin_user) { create(:user, :admin) }
  let!(:non_admin_user) { create(:user, :noadmin) }

  describe 'GET /admin/users' do
    subject { get admin_users_path }

    context 'ユーザが管理者の場合' do
      context 'パスワードがあっている場合' do
        context 'pageが0の場合' do
          xit 'ユーザ取得時のoffsetが0で200が返る' do
            # TODO: offsetが0で200が返るspecを作成する
          end

          xit 'ユーザの表示数は10' do
            # TODO: ユーザの表示数は10のspecを作成する
          end
        end

        context 'pageが1の場合' do
          xit 'ユーザ取得時のoffsetが0で200が返る' do
            # TODO: offsetが0で200が返るspecを作成する
          end

          xit 'ユーザの表示数は10' do
            # TODO: ユーザの表示数は10のspecを作成する
          end
        end

        context 'pageが2の場合' do
          xit 'ユーザ取得時のoffsetが10で200が返る' do
            # TODO: offsetが10で200が返るspecを作成する
          end

          xit 'ユーザの表示数は10' do
            # TODO: ユーザの表示数は10のspecを作成する
          end
        end
      end
    end

    context 'ユーザが管理者ではない場合' do
      before { log_in_as(non_admin_user) }

      it 'ログインページにリダイレクトしてトーストメッセージを表示する' do
        expect(subject).to redirect_to login_url
        expect(response).to have_http_status :see_other
        expect(flash[:danger]).not_to be_nil
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトしてトーストメッセージを表示する' do
        expect(subject).to redirect_to login_url
        expect(response).to have_http_status :see_other
        expect(flash[:danger]).not_to be_nil
      end
    end
  end
end
