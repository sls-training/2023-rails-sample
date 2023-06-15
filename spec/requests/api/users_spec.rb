# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApiUsers' do
  describe 'GET /api/users' do
    subject do
      get('/api/users', headers:, params:)
      response
    end

    let!(:current_user) { create(:user, :admin) }

    context 'アクセストークンがない場合' do
      let(:params) { {} }

      it 'エラーメッセージを出力して、404を返す' do
        expect(subject).to be_bad_request
        expect(subject.parsed_body).to have_key('errors')
      end
    end

    context 'アクセストークンがある場合' do
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: current_user.email) }
        let(:params) { {} }

        it 'エラーメッセージを出力して、401を返す' do
          expect(subject).to be_unauthorized
          expect(subject.parsed_body).to have_key('errors')
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        context 'クエリにorder_byがある場合' do
          let(:params) { { order_by: } }

          context 'order_byがascの場合' do
            let(:order_by) { 'asc' }

            it 'ユーザの配列を名前の昇順で取得できて、200を返す' do
              expect(subject).to be_successful
              expect(subject.parsed_body).to eq(subject.parsed_body.sort_by { |a| a['name'] })
            end
          end

          context 'order_byがdescの場合' do
            let(:order_by) { 'desc' }

            it 'ユーザの配列を名前の降順で取得できて、200を返す' do
              expect(subject).to be_successful
              expect(subject.parsed_body).to eq(subject.parsed_body.sort { |a, b| b['name'] <=> a['name'] })
            end
          end
        end

        context 'クエリにorder_byがない場合' do
          let(:params) { {} }

          it 'ユーザの配列を名前の昇順で取得できて、200を返す' do
            expect(subject).to be_successful
            expect(subject.parsed_body).to eq(subject.parsed_body.sort_by { |a| a['name'] })
          end
        end

        context 'クエリにsort_keyがある場合' do
          context 'sort_keyがidの場合' do
            # TODO: idの昇順でuserの配列を取得できて、200を返すテストを作成する
          end

          context 'sort_keyがnameの場合' do
            # TODO: nameの昇順でuserの配列を取得できて、200を返すテストを作成する
          end

          context 'sort_keyがemailの場合' do
            # TODO: emailの昇順でuserの配列を取得できて、200を返すテストを作成する
          end

          context 'sort_keyがactivated_atの場合' do
            # TODO: activated_atの昇順でuserの配列を取得できて、200を返すテストを作成する
          end

          context 'sort_keyがcreated_atの場合' do
            # TODO: created_atの昇順でuserの配列を取得できて、200を返す'
          end

          context 'sort_keyがupdated_atの場合' do
            # TODO: updated_atの昇順でuserの配列を取得できて、200を返す'
          end

          context 'sort_keyがid, name, email, activated_at, created_at, updated_at以外の場合' do
            # TODO: nameの昇順でuserの配列を取得できて、200を返すテストを作成する
          end
        end

        context 'クエリにsort_keyがない場合' do
          # TODO: nameの昇順でuserの配列を取得できて、200を返すテストを作成する
        end

        context 'クエリにlimitがある場合' do
          let(:params) { { limit: } }

          context 'limitが1000件を超過する場合' do
            let(:limit) { 1001 }

            context 'ユーザ数が1000件未満の場合' do
              before { create_user_list 1 }

              it 'ユーザ情報を全件取得し、200を返す' do
                expect(subject).to be_successful
                expect(subject.parsed_body.count).to eq User.count
              end
            end

            context 'ユーザ数が1000件以上の場合' do
              before { create_user_list limit }

              it 'ユーザ情報を1000件取得し、200を返す' do
                expect(subject).to be_successful
                expect(subject.parsed_body.count).to eq 1000
              end
            end
          end

          context 'limitが1000件以下の場合' do
            let(:limit) { 100 }

            context 'ユーザ数がlimit未満の場合' do
              before { create_user_list 1 }

              it 'ユーザ情報を全件取得し、200を返す' do
                expect(subject).to be_successful
                expect(subject.parsed_body.count).to eq User.count
              end
            end

            context 'ユーザ数がlimit以上の場合' do
              before { create_user_list 101 }

              it 'ユーザ情報をlimit数分取得し、200を返す' do
                expect(subject).to be_successful
                expect(subject.parsed_body.count).to eq limit
              end
            end
          end
        end

        context 'クエリにlimitがない場合' do
          let(:params) { {} }

          context 'ユーザ数が50件未満の場合' do
            before { create_user_list 1 }

            it 'ユーザ情報を全件取得し、200を返す' do
              expect(subject).to be_successful
              expect(subject.parsed_body.count).to eq User.count
            end
          end

          context 'ユーザ数が50件以上の場合' do
            before { create_user_list 51 }

            it 'ユーザ情報を50件分取得し、200を返す' do
              expect(subject).to be_successful
              expect(subject.parsed_body.count).to eq 50
            end
          end
        end

        context 'クエリにoffsetがある場合' do
          let(:params) { { offset: } }
          let(:offset) { 25 }

          it 'offset件数飛ばしてユーザの配列をnameの昇順で取得し、200を返す' do
            expect(subject).to be_successful
            users = User
                      .order(name: :asc)
                      .offset(offset)
                      .limit(50)
                      .pluck('id')
            expect(subject.parsed_body.pluck('id')).to eq users
          end
        end

        context 'クエリにoffsetがない場合' do
          let(:params) { {} }

          it 'ユーザの配列をnameの昇順で取得し、200を返す' do
            expect(subject).to be_successful
            users = User
                      .order(name: :asc)
                      .limit(50)
                      .pluck('id')
            expect(subject.parsed_body.pluck('id')).to eq users
          end
        end
      end
    end
  end

  describe 'GET /api/users/:id' do
    subject do
      get("/api/users/#{target_user.id}", headers:)
      response
    end

    let(:current_user) { create(:user, :admin) }
    let(:target_user) { create(:user, :noadmin) }

    context 'アクセストークンがない場合' do
      it '400でエラーメッセージを出力して失敗する' do
        expect(subject).to be_bad_request
        expect(subject.parsed_body).to have_key('errors')
      end
    end

    context 'アクセストークンがある場合' do
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: current_user.email) }

        it '401でエラーメッセージを出力して失敗する' do
          expect(subject).to be_unauthorized
          expect(subject.parsed_body).to have_key('errors')
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        it 'ターゲットのIDのユーザ情報をレスポンスとして取得できる' do
          expect(subject).to be_successful
          expect(subject.parsed_body.symbolize_keys).to include(
            {
              id:           target_user.id,
              name:         target_user.name,
              admin:        target_user.admin,
              activated:    target_user.activated,
              activated_at: target_user.activated_at&.iso8601(2),
              created_at:   target_user.created_at.iso8601(2),
              updated_at:   target_user.updated_at.iso8601(2)
            }
          )
        end
      end
    end
  end

  describe 'POST /api/users' do
    subject { post '/api/users', headers:, params: }

    context 'アクセストークンがない場合' do
      let(:params) do
        { name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password(min_length: 6) }
      end

      it '400でエラーメッセージを出力して失敗する' do
        expect { subject }.not_to change(User, :count)
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to have_key('errors')
      end
    end

    context 'アクセストークンがある場合' do
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }
      let!(:user) { create(:user, :admin) }

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: user.email) }
        let(:params) do
          { name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password(min_length: 6) }
        end

        it '401でエラーメッセージを出力して失敗する' do
          expect { subject }.not_to change(User, :count)
          expect(response).to be_unauthorized
          expect(response.parsed_body).to have_key('errors')
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: user.email).encode }

        context 'パラメータが適切でない場合' do
          let(:name) { Faker::Name.name }
          let(:email) { Faker::Internet.email }
          let(:password) { Faker::Internet.password(min_length: 6) }
          let(:wrong_cases) do
            [
              { name: '', email:, password: },
              { name:, email: '', password: },
              { name:, email:, password: '' },
              * %w[
                user@example,com user_at_foo.org user.name@example. foo@bar_baz.com
                foo@bar+baz.com
              ].map do |wrong_email|
                { name:, email: wrong_email, password: }
              end,
              { name: 'a' * 51, email:, password: },
              {
                name:, email: "#{'a' * 244}@example.com", password:
              },
              { name:, email:, password: 'a' * 5 }
            ]
          end

          it '400が返って、エラーメッセージを返すこと' do
            wrong_cases.each do |wrong_case|
              expect { post '/api/users', headers:, params: wrong_case }.not_to change(User, :count)
              expect(response).to be_bad_request
              expect(response.parsed_body).to have_key('errors')
            end
          end
        end

        context 'パラメータが適切な場合' do
          context 'ユーザが存在しない場合' do
            let(:params) do
              {
                name: Faker::Name.name, email: Faker::Internet.email,
                password: Faker::Internet.password(min_length: 6)
              }
            end

            it '201が返って、作成したユーザを返すこと' do
              expect { subject }.to change(User, :count).by(1)
              expect(response).to be_created
              expect(response.parsed_body).to include(
                *%w[id name admin activated activated_at created_at updated_at]
              )
            end
          end

          context 'ユーザが存在する場合' do
            let(:params) do
              { name: Faker::Name.name, email: user.email, password: Faker::Internet.password(min_length: 6) }
            end

            it '422が返って、エラーメッセージを返すこと' do
              expect { subject }.not_to change(User, :count)
              expect(response).to have_http_status(:unprocessable_entity)
              expect(response.parsed_body).to have_key('errors')
            end
          end
        end
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    subject do
      delete("/api/users/#{target_id}", headers:)
      response
    end

    let!(:current_user) { create(:user, :admin) }
    let!(:target_user) { create(:user) }

    context 'アクセストークンがない場合' do
      let(:target_id) { current_user.id }

      it 'ユーザの削除に失敗し、エラーメッセージと400を返す' do
        expect(subject).to be_bad_request
        expect(subject.parsed_body).to have_key('errors')
      end
    end

    context 'アクセストークンがある場合' do
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: current_user.email) }
        let(:target_id) { current_user.id }

        it 'ユーザの削除に失敗し、ユーザのエラーメッセージと401を返す' do
          expect(subject).to be_unauthorized
          expect(subject.parsed_body).to have_key('errors')
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        context '自分のユーザIDの場合' do
          let(:target_id) { current_user.id }

          it 'ユーザの削除に失敗し、エラーメッセージと422を返す' do
            expect(subject).to have_http_status :unprocessable_entity
            expect(subject.parsed_body).to have_key('errors')
          end
        end

        context '自分以外のユーザIDの場合' do
          context 'ユーザが存在しない場合' do
            let(:target_id) { 1_000_000 }

            it 'ユーザの削除に失敗し、エラーメッセージと404を返す' do
              expect(subject).to have_http_status :not_found
              expect(subject.parsed_body).to have_key('errors')
            end
          end

          context 'ユーザが存在する場合' do
            let(:target_id) { target_user.id }

            it 'ユーザが削除され、204を返す' do
              expect { subject }.to change(User, :count).by(-1)
              expect(subject).to have_http_status :no_content
            end
          end
        end
      end
    end
  end
end
