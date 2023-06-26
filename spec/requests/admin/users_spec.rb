# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'AdminUsers' do
  let!(:admin_user) { create(:user, :admin) }
  let!(:non_admin_user) { create(:user, :noadmin) }

  describe 'GET /admin/users' do
    subject { get admin_users_path }

    context 'ログインしている場合' do
      context 'ユーザが管理者の場合' do
        context 'ユーザー取得の関数の実行時に例外が返ってきた場合' do
          xit 'ホーム画面にリダイレクトして、取得に失敗した旨をトーストメッセージで表示' do
            # TODO: specの内容を作成する
          end
        end

        context 'ユーザー取得の関数の実行時にユーザの配列が返ってきた場合' do
          context 'クエリパラメータにpageがない場合' do
            xit 'ユーザー取得の関数にoffset=0パラメータをつけて呼び出すこと' do
              # TODO: specの内容を作成する
            end

            xit 'ステータスコード200とともに、10件分のユーザーを表示すること' do
              # TODO: specの内容を作成する
            end
          end

          context 'クエリパラメータにpageがある場合' do
            context 'pageの値が0の場合' do
              xit 'ユーザー取得の関数にoffset=0パラメータをつけて呼び出すこと' do
                # TODO: specの内容を作成する
              end

              xit 'ステータスコード200とともに、10件分のユーザーを表示すること' do
                # TODO: specの内容を作成する
              end
            end

            context 'pageの値が1の場合' do
              xit 'ユーザー取得の関数にoffset=0パラメータをつけて呼び出すこと' do
                # TODO: specの内容を作成する
              end

              xit 'ステータスコード200とともに、10件分のユーザーを表示すること' do
              end
            end

            context 'pageの値が2の場合' do
              xit 'ユーザー取得の関数にoffset=10パラメータをつけて呼び出すこと' do
                # TODO: specの内容を作成する
              end

              xit 'ステータスコード200とともに、10件分のユーザーを表示すること' do
                # TODO: specの内容を作成する
              end
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
    end

    context 'ログインしていない場合' do
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
        context 'ユーザ作成の関数の実行時に例外が返ってきた場合' do
          xit 'ユーザ管理画面にリダイレクトして、作成に失敗した旨をトーストメッセージで表示する' do
            # TODO: specの内容を作成する
          end
        end

        context 'ユーザ作成の関数の実行時に成功が返ってきた場合' do
          xit 'ユーザ管理画面にリダイレクトして、作成に成功した旨をトーストメッセージで表示する' do
            # TODO: specの内容を作成する
          end
        end
      end
    end
  end

  describe 'PATCH /admin/users/:id' do
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
        context 'ユーザ更新の関数の実行時に例外が返ってきた場合' do
          xit 'ユーザ管理画面にリダイレクトして、編集に失敗した旨をトーストメッセージで表示' do
            # TODO: specの内容を作成する
          end
        end

        context 'ユーザ更新の関数の実行時にユーザが返ってきた場合' do
          context '更新するパラメータにpasswordがない場合' do
            xit '編集に成功した旨をトーストメッセージで表示して、200を返す' do
              # TODO: specの内容を作成する
            end
          end
        end
      end
    end
  end
end
