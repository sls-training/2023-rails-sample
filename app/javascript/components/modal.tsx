import { createRoot } from 'react-dom/client';
import React, { useEffect, useState } from 'react';
import User from '../types/user';

export const CreationModal = () => {
  return <div className="modal-content">{/* TDDO:ここにユーザ作成用のモーダルの中身を作成する */}</div>;
};

export const EditationModal = ({ user }: { user: User }) => {
  const [name, setName] = useState<string>(user.name);
  const [email, setEmail] = useState<string>(user.email);
  const [admin, setAdmin] = useState<boolean>(user.admin);
  const [activated, setActivated] = useState<boolean>(user.activated_at);

  useEffect(() => {
    setName(user.name);
    setEmail(user.email);
    setAdmin(user.admin);
    setActivated(user.activated);
  }, [user]);

  return (
    <div className="modal-content">
      <div className="modal-header">
        <h5 className="modal-title" id="createUserModalTitle">
          ユーザを編集
        </h5>
        <button type="button" className="btn btn-secondary close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form method="post" action={`/admin/users`}>
        <div className="modal-body">
          <label htmlFor="name">名前</label>
          <input
            className="form-control"
            value={name}
            onChange={(e) => setName(e.target.value)}
            type="text"
            id="name"
            name="name"
            autoComplete="name"
            required
          />
          <label htmlFor="email">メール</label>
          <input
            className="form-control"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            type="text"
            id="email"
            name="email"
            pattern="[\w\-\._]+@[\w\-\._]+\.[A-Za-z]+"
            title="***@*.*の形で入力してください"
            autoComplete="email"
            required
          />
          <label htmlFor="admin">管理者</label>
          <input
            className="form-check-input"
            checked={admin}
            onChange={(e) => setAdmin(e.target.value)}
            type="checkbox"
            id="admin"
            name="admin"
            required
          />
          <label htmlFor="activated">認証ずみ</label>
          <input
            className="form-check-input"
            checked={activated}
            onChange={(e) => setActivated(e.target.value)}
            type="checkbox"
            id="activated"
            name="activated"
            required
          />
        </div>
        <div className="modal-footer">
          <input type="button" className="btn btn-secondary" data-dismiss="modal" value="いいえ" />
          <input className="btn btn-primary" type="submit" value="はい" />
          <input name="authenticity_token" type="hidden" value={getCsrfToken()} />
        </div>
      </form>
    </div>
  );
};

export const DeletionModal = ({ user }: { user: User }) => {
  return <div className="modal-content">{/* TDDO:ここにユーザ削除用のモーダルの中身を作成する */}</div>;
};
