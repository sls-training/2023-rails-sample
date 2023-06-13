import React, { useState, useEffect } from 'react';
import User from '../types/user';

export const CreationModal = () => {
  const [password, setPassword] = useState<string>('');
  const [confirmPassword, setConfirmPassword] = useState<string>('');

  function onChangeConfirmPassword(e: React.ChangeEventHandler<HTMLInputElement>) {
    const changedValue = e.target.value;
    const validateText = password != changedValue ? 'パスワードが上の入力と違います' : '';
    e.target.setCustomValidity(validateText);

    setConfirmPassword(changedValue);
  }

  return (
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
          <input className="form-control" type="text" id="name" name="name" autoComplete="name" required />
          <label htmlFor="email">メール</label>
          <input
            className="form-control"
            type="text"
            id="email"
            name="email"
            pattern="[\w\-\._]+@[\w\-\._]+\.[A-Za-z]+"
            title="***@*.*の形で入力してください"
            autoComplete="email"
            required
          />
          <label htmlFor="password">パスワード</label>
          <input
            className="form-control"
            type="password"
            id="password"
            name="password"
            minLength={6}
            required
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <label htmlFor="password_confirmation">パスワードをもう一度入力</label>
          <input
            className="form-control"
            type="password"
            id="password_confirmation"
            name="password_confirmation"
            minLength={6}
            required
            value={confirmPassword}
            onChange={onChangeConfirmPassword}
          />
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
};

export const EditationModal = ({ user }: { user: User }) => {
  return <div className="modal-content">{/* TDDO:ここにユーザ編集用のモーダルの中身を作成する */}</div>;
};

export const DeletionModal = ({ user }: { user: User }) => {
  return <div className="modal-content">{/* TDDO:ここにユーザ削除用のモーダルの中身を作成する */}</div>;
};
