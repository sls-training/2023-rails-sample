# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'AdminUsers' do
  let!(:admin_user) { create(:user, :admin) }
  let!(:non_admin_user) { create(:user, :noadmin) }

  describe 'GET /admin/users' do
    context 'ログインしていない場合' do
      subject { get admin_users_path }

      it 'ログインページにリダイレクトしてトーストメッセージを表示する' do
        expect(subject).to redirect_to login_url
        expect(response).to have_http_status :see_other
        expect(flash[:danger]).not_to be_nil
      end
    end

    context 'ログインしている場合' do
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

      context 'ユーザが管理者の場合' do
        let(:order_by) { 'asc' }
        let(:sort_key) { 'name' }
        let(:limit) { 10 }
        let(:access_token) { AccessToken.new(email: admin_user.email).encode }
        let(:admin_user) { create(:user, :admin) }

        before do
          allow(Api::AccessToken).to receive(:create).and_return(Api::AccessToken.new(value: access_token))
          post login_path,
               params: { session: { email: admin_user.email, password: admin_user.password, remember_me: '1' } }
        end

        context '例外が返ってきた場合' do
          subject { get admin_users_path }

          before { allow(Api::User).to receive(:get_list).and_raise(StandardError) }

          it 'ホーム画面にリダイレクトして、取得に失敗した旨をトーストメッセージで表示する' do
            expect(subject).to redirect_to root_url
            expect(Api::User).to have_received(:get_list)
            expect(response).to have_http_status :see_other
            expect(flash[:danger]).to be_present
          end
        end

        context 'ユーザの配列が返ってきた場合' do
          before do
            user_list = create_list(:user, 20)
            api_users = user_list.take(limit).map do |user|
              Api::User.new(
                id: user.id, name: user.name, email: user.email, admin: user.admin, activated: user.activated,
                activated_at: user.activated_at, created_at: user.created_at, updated_at: user.updated_at
              )
            end

            allow(Api::User).to receive(:get_list).and_return(api_users)
          end

          context 'クエリパラメータにpageがない場合' do
            subject { get admin_users_path }

            it 'ユーザー取得の関数にoffset=0パラメータをつけて呼び出す' do
              subject
              expect(Api::User).to have_received(:get_list).with(access_token:, limit:, offset: 0)
            end

            it 'ステータスコード200とともに、10件分のユーザーを表示する' do
              subject
              expect(response).to be_successful
              users = controller.instance_variable_get(:@users)
              expect(users.count).to be 10
            end
          end

          context 'クエリパラメータにpageがある場合' do
            subject { get admin_users_path, params: { page: } }

            context 'pageの値が0の場合' do
              let(:page) { 0 }

              it 'ユーザー取得の関数にoffset=0パラメータをつけて呼び出す' do
                subject
                expect(Api::User).to have_received(:get_list).with(access_token:, limit:, offset: 0)
              end

              it 'ステータスコード200とともに、10件分のユーザーを表示する' do
                subject
                expect(response).to be_successful
                users = controller.instance_variable_get(:@users)
                expect(users.count).to be 10
              end
            end

            context 'pageの値が1の場合' do
              let(:page) { 1 }

              it 'ユーザー取得の関数にoffset=0パラメータをつけて呼び出すこと' do
                subject
                expect(Api::User).to have_received(:get_list).with(access_token:, limit:, offset: 0)
              end

              it 'ステータスコード200とともに、10件分のユーザーを表示する' do
                subject
                expect(response).to be_successful
                users = controller.instance_variable_get(:@users)
                expect(users.count).to be 10
              end
            end

            context 'pageの値が2の場合' do
              let(:page) { 2 }

              it 'ユーザー取得APIにoffset=10パラメータをつけて呼び出すこと' do
                subject
                expect(Api::User).to have_received(:get_list).with(access_token:, limit:, offset: 10)
              end

              it 'ステータスコード200とともに、10件分のユーザーを表示する' do
                subject
                expect(response).to be_successful
                users = controller.instance_variable_get(:@users)
                expect(users.count).to be 10
              end
            end
          end
        end
      end
    end
  end

  describe 'POST /admin/users' do
    context 'ログインしていない場合' do
      xit 'ログインページにリダイレクトしてトーストメッセージを表示する' do
        # TODO: specの内容を作成する
      end
    end

    context 'ログインしている場合' do
      context 'ユーザが管理者ではない場合' do
        xit 'ログインページにリダイレクトしてトーストメッセージを表示する' do
          # TODO: specの内容を作成する
        end
      end

      context 'ユーザが管理者の場合' do
        context '例外が返ってきた場合' do
          xit 'ユーザ管理画面にリダイレクトして、作成に失敗した旨をトーストメッセージで表示する' do
            # TODO: specの内容を作成する
          end
        end

        context 'ユーザが返ってきた場合' do
          xit 'ユーザ管理画面にリダイレクトして、作成に成功した旨をトーストメッセージで表示する' do
            # TODO: specの内容を作成する
          end
        end
      end
    end
  end

  describe 'PATCH /admin/users/:id' do
    context 'ログインしていない場合' do
      xit 'ログインページにリダイレクトしてトーストメッセージを表示する' do
        # TODO: specの内容を作成する
      end
    end

    context 'ログインしている場合' do
      context 'ユーザが管理者ではない場合' do
        xit 'ログインページにリダイレクトしてトーストメッセージを表示する' do
          # TODO: specの内容を作成する
        end
      end

      context 'ユーザが管理者の場合' do
        context '例外が返ってきた場合' do
          xit 'ユーザ管理画面にリダイレクトして、編集に失敗した旨をトーストメッセージで表示する' do
            # TODO: specの内容を作成する
          end
        end

        context 'ユーザが返ってきた場合' do
          xit '編集に成功した旨をトーストメッセージで表示して、200を返す' do
            # TODO: specの内容を作成する
          end
        end
      end
    end
  end
end
