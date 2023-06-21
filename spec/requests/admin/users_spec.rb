# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'AdminUsers' do
  let!(:admin_user) { create(:user, :admin) }
  let!(:non_admin_user) { create(:user, :noadmin) }

  describe 'GET /admin/users' do
    subject { get admin_users_path }

    context 'ユーザが管理者の場合' do
      context 'クエリパラメータにpageがない場合' do
        xit 'ユーザ取得時にoffsetを0個かけて取得し、200が返る' do
          # TODO: ユーザ取得時にoffsetを0個かけて取得し、200が返るspecを作成する
        end

        xit 'ユーザの表示数は10' do
          # TODO: ユーザの表示数は10のspecを作成する
        end
      end

      context 'クエリパラメータにpageがある場合' do
        context 'pageの値が0の場合' do
          xit 'ユーザ取得時にoffsetを0個かけて取得し、200が返る' do
            # TODO: ユーザ取得時にoffsetを0個かけて取得し、200が返るspecを作成する
          end

          xit 'ユーザの表示数は10' do
            # TODO: ユーザの表示数は10のspecを作成する
          end
        end

        context 'pageの値が1の場合' do
          xit 'ユーザ取得時にoffsetを0個かけて取得し、200が返る' do
            # TODO: ユーザ取得時にoffsetを0個かけて取得し、200が返るspecを作成する
          end

          xit 'ユーザの表示数は10' do
            # TODO: ユーザの表示数は10のspecを作成する
          end
        end

        context 'pageの値が2の場合' do
          xit 'ユーザ取得時にoffsetを10個かけて取得し、200が返る' do
            # TODO: ユーザ取得時にoffsetを10個かけて取得し、200が返るspecを作成する
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
