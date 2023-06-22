# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'AdminUsers' do
  describe 'GET /admin/users' do
    context 'ログインしている場合' do
      context 'ユーザが管理者の場合' do
        let(:admin_user) { create(:user, :admin) }
        let(:access_token) { AccessToken.new(email: admin_user.email).encode }

        let(:limit) { 10 }
        let(:sort_key) { 'name' }
        let(:order_by) { 'asc' }

        before do
          email = admin_user.email
          password = admin_user.password

          # テスト用のユーザを事前に作成
          create_list(:user, 50)

          # トークン作成用のAPI
          WebMock
            .stub_request(:post, 'http://localhost:3000/api/token')
            .with(body: { email:, password: })
            .to_return(body: { access_token: }.to_json, status: 200, headers: { 'Content-Type' => 'application/json' })

          # ログインする
          post login_path,
               params: { session: { email:, password:, remember_me: '1' } }
        end

        context 'クエリパラメータにpageがない場合' do
          subject { get admin_users_path }

          let(:offset) { 0 }

          before do
            WebMock
              .stub_request(:get, 'http://localhost:3000/api/users')
              .with(
                query:   { limit:, offset:, order_by:, sort_key: },
                headers: { Authorization: "Bearer #{access_token}" }
              )
              .to_return(
                body:    User
                         .order(sort_key => order_by)
                         .limit(limit)
                         .offset(offset)
                         .map { |user| user_to_api_user(user) }
                         .to_json,
                status:  200,
                headers: { 'Content-Type' => 'application/json' }
              )
          end

          it 'ユーザー取得APIにoffset=0パラメータをつけて呼び出すこと' do
            subject
            expect(WebMock).to have_requested(:get, 'http://localhost:3000/api/users')
                                 .with(
                                   query:   { limit:, offset:, order_by:, sort_key: },
                                   headers: { Authorization: "Bearer #{access_token}" }
                                 )
          end

          it 'ステータスコード200とともに、先頭から10件分のユーザーを返すこと' do
            subject
            expect(response).to be_successful
            users = controller.instance_variable_get(:@users)
            expect(users.map(&:id)).to eq User
                                            .order(name: :asc)
                                            .limit(10)
                                            .pluck('id')
          end
        end

        context 'クエリパラメータにpageがある場合' do
          subject { get admin_users_path, params: { page: } }

          before do
            WebMock
              .stub_request(:get, 'http://localhost:3000/api/users')
              .with(
                query:   { limit:, offset:, order_by:, sort_key: },
                headers: { Authorization: "Bearer #{access_token}" }
              )
              .to_return(
                body:    User
                         .order(sort_key => order_by)
                         .limit(limit)
                         .offset(offset)
                         .map { |user| user_to_api_user(user) }
                         .to_json,
                status:  200,
                headers: { 'Content-Type' => 'application/json' }
              )
          end

          context 'pageの値が0の場合' do
            let(:page) { 0 }
            let(:offset) { 0 }

            it 'ユーザー取得APIにoffset=0パラメータをつけて呼び出すこと' do
              subject
              expect(WebMock).to have_requested(:get, 'http://localhost:3000/api/users')
                                   .with(
                                     query:   { limit:, offset:, order_by:, sort_key: },
                                     headers: { Authorization: "Bearer #{access_token}" }
                                   )
            end

            it 'ステータスコード200とともに、先頭から10件分のユーザーを返すこと' do
              subject
              expect(response).to be_successful
              users = controller.instance_variable_get(:@users)
              expect(users.map(&:id)).to eq User
                                              .order(name: :asc)
                                              .limit(10)
                                              .pluck('id')
            end
          end

          context 'pageの値が1の場合' do
            let(:page) { 1 }
            let(:offset) { 0 }

            it 'ユーザー取得APIにoffset=0パラメータをつけて呼び出すこと' do
              subject
              expect(WebMock).to have_requested(:get, 'http://localhost:3000/api/users')
                                   .with(
                                     query:   { limit:, offset:, order_by:, sort_key: },
                                     headers: { Authorization: "Bearer #{access_token}" }
                                   )
            end

            it 'ステータスコード200とともに、先頭から10件分のユーザーを返すこと' do
              subject
              expect(response).to be_successful
              users = controller.instance_variable_get(:@users)
              expect(users.map(&:id)).to eq User
                                              .order(name: :asc)
                                              .limit(10)
                                              .pluck('id')
            end
          end

          context 'pageの値が2の場合' do
            let(:page) { 2 }
            let(:offset) { 10 }

            it 'ユーザー取得APIにoffset=10パラメータをつけて呼び出すこと' do
              subject
              expect(WebMock).to have_requested(:get, 'http://localhost:3000/api/users')
                                   .with(
                                     query:   { limit:, offset:, order_by:, sort_key: },
                                     headers: { Authorization: "Bearer #{access_token}" }
                                   )
            end

            it 'ステータスコード200とともに、先頭から11件目〜20件目のユーザーを返すこと' do
              subject
              expect(response).to be_successful
              users = controller.instance_variable_get(:@users)
              expect(users.map(&:id)).to eq User
                                              .order(name: :asc)
                                              .offset(10)
                                              .limit(10)
                                              .pluck('id')
            end
          end
        end
      end

      context 'ユーザが管理者ではない場合' do
        subject { get admin_users_path }

        let(:non_admin_user) { create(:user, :noadmin) }

        before { log_in_as(non_admin_user) }

        it 'ログインページにリダイレクトしてトーストメッセージを表示する' do
          expect(subject).to redirect_to login_url
          expect(response).to have_http_status :see_other
          expect(flash[:danger]).not_to be_nil
        end
      end
    end

    context 'ログインしていない場合' do
      subject { get admin_users_path }

      it 'ログインページにリダイレクトしてトーストメッセージを表示する' do
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
