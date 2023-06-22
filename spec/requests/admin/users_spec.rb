# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'AdminUsers' do
  let!(:admin_user) { create(:user, :admin) }
  let!(:non_admin_user) { create(:user, :noadmin) }

  describe 'GET /admin/users' do
    subject { get admin_users_path }

    context 'ユーザが管理者の場合' do
      before { log_in_as(admin_user) }

      it '200が返って、アクセスできる' do
        subject
        expect(response).to be_successful
      end
    end

    context 'ユーザが管理者ではない場合' do
      before { log_in_as(non_admin_user) }

      it 'ログインページにリダイレクトしてトーストメッセージを表示' do
        expect(subject).to redirect_to login_url
        expect(response).to have_http_status :see_other
        expect(flash[:danger]).not_to be_nil
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトしてトーストメッセージを表示' do
        expect(subject).to redirect_to login_url
        expect(response).to have_http_status :see_other
        expect(flash[:danger]).not_to be_nil
      end
    end
  end

  describe 'POST /admin/users' do
    context 'ログインしていない場合' do
      xit 'ログインページにリダイレクトしてトーストメッセージを表示' do
        # TODO: specの内容を作成する
      end
    end

    context 'ログインしている場合' do
      context 'ユーザが管理者ではない場合' do
        xit 'ログインページにリダイレクトしてトーストメッセージを表示' do
          # TODO: specの内容を作成する
        end
      end

      context 'ユーザが管理者の場合' do
        xit 'ユーザ作成用のAPIを呼んでいること' do
          # TODO: specの内容を作成する
        end

        context '不正なユーザーデータが指定された場合' do
          xit 'ユーザ管理画面にリダイレクトして、作成に失敗した旨をトーストメッセージで表示する' do
            # TODO: specの内容を作成する
          end
        end

        context '正当なユーザーデータが指定された場合' do
          xit 'ユーザ管理画面にリダイレクトして、作成に成功した旨をトーストメッセージで表示する' do
            # TODO: specの内容を作成する
          end
        end
      end
    end
  end
end
