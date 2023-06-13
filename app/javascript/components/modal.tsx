import React from 'react';
import User from '../types/user';

export const CreationModal = () => (
  <div className="modal-content">
    <div className="modal-header">
      <h5 className="modal-title" id="createUserModalTitle">
        ユーザを作成
      </h5>
      <button type="button" className="btn btn-secondary close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <form method="post" action={`/admin/users`}>
      <div className="modal-body">
        <label htmlFor="name">名前</label>
        <input className="form-control" type="text" id="name" name="name" required />
        <label htmlFor="email">メール</label>
        <input className="form-control" type="text" id="email" name="email" required />
        <label htmlFor="password">パスワード</label>
        <input className="form-control" type="text" id="password" name="password" required />
        <label htmlFor="password_confirmation">パスワードをもう一度入力</label>
        <input className="form-control" type="text" id="password_confirmation" name="password_confirmation" required />
      </div>
      <div className="modal-footer">
        <input type="button" className="btn btn-secondary" data-dismiss="modal" value="いいえ" />

        <input className="btn btn-primary" type="submit" value="はい" />
        <input name="authenticity_token" type="hidden" value={getCsrfToken()} />
        <input name="_method" type="hidden" value="POST" />
      </div>
    </form>
  </div>
);

export const EditationModal = ({ user }: { user: User }) => {
  return <div className="modal-content">{/* TDDO:ここにユーザ編集用のモーダルの中身を作成する */}</div>;
};

export const DeletionModal = ({ user }: { user: User }) => {
  return <div className="modal-content">{/* TDDO:ここにユーザ削除用のモーダルの中身を作成する */}</div>;
};
