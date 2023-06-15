import React, { useState, useEffect } from 'react';

import User from '../types/user';

export const getCsrfToken = (): string => {
  const metaElement = document.querySelector("meta[name='csrf-token']");
  if (!metaElement) throw Error('meta[name=csrf-token] is not founded.');

  const csrfToken = metaElement.getAttribute('content');
  if (!csrfToken) throw Error('csrf token is not set');

  return csrfToken;
};

export const CreationModal = () => {
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  function onChangeConfirmPassword(e) {
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
  const [name, setName] = useState(user.name);
  const [email, setEmail] = useState(user.email);
  const [isCheckedPassword, setIsCheckedPasword] = useState(false);
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [admin, setAdmin] = useState(user.admin);
  const [activated, setActivated] = useState(user.activated_at);

  function onChangeConfirmPassword(e) {
    const changedValue = e.target.value;
    const validateText = password != changedValue ? 'パスワードが上の入力と違います' : '';
    e.target.setCustomValidity(validateText);

    setConfirmPassword(changedValue);
  }

  useEffect(() => {
    setName(user.name);
    setEmail(user.email);
    setPassword('');
    setConfirmPassword('');
    setIsCheckedPasword(false);
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
      <form method="post" action={`/admin/users/${user.id}`}>
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

          <div className="form-check">
            <label htmlFor="password_change">パスワードを変更するか</label>
            <input
              className="form-check-input"
              checked={isCheckedPassword}
              onChange={(_) => setIsCheckedPasword(!isCheckedPassword)}
              type="checkbox"
              id="password_change"
              name="password_change"
            />
          </div>
          {isCheckedPassword && (
            <div>
              {isCheckedPassword}
              <label htmlFor="password">パスワード</label>
              <input
                className="form-control"
                type="password"
                id="password"
                name="password"
                minLength={6}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
              <label htmlFor="password_confirmation">パスワードをもう一度入力</label>
              <input
                className="form-control"
                type="password"
                id="password_confirmation"
                name="password_confirmation"
                minLength={6}
                value={confirmPassword}
                onChange={onChangeConfirmPassword}
                required
              />
            </div>
          )}
          <div class="form-check-inline">
            <label htmlFor="admin">管理者</label>
            <input
              className="form-check-input"
              checked={admin}
              onChange={(_) => setAdmin(!admin)}
              type="checkbox"
              id="admin"
              name="admin"
            />
          </div>
          <div class="form-check-inline">
            <label htmlFor="activated">認証ずみ</label>
            <input
              className="form-check-input"
              checked={activated}
              onChange={(_) => setActivated(!activated)}
              type="checkbox"
              id="activated"
              name="activated"
            />
          </div>
        </div>
        <div className="modal-footer">
          <input type="button" className="btn btn-secondary" data-dismiss="modal" value="いいえ" />
          <input className="btn btn-primary" type="submit" value="はい" />
          <input name="authenticity_token" type="hidden" value={getCsrfToken()} />
          <input name="_method" type="hidden" value="PATCH" />
        </div>
      </form>
    </div>
  );
};

export const DeletionModal = ({ user }: { user: User }) => {
  return (
    <div className="modal-content">
      <div className="modal-header">
        <h5 className="modal-title" id="userModalTitle">
          ユーザを削除しますか？
        </h5>
        <button type="button" className="btn btn-secondary close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div className="modal-body">
        <div>
          <div>ユーザ情報</div>
          <li>id : {user.id}</li>
          <li>name : {user.name}</li>
          <li>email : {user.email} </li>
        </div>
      </div>
      <form method="post" action={`/admin/users/${user.id}`} className="modal-footer">
        <input type="button" className="btn btn-secondary" data-dismiss="modal" value="いいえ" />

        <div>
          <input className="btn btn-danger" type="submit" value="はい" />
          <input name="authenticity_token" type="hidden" value={getCsrfToken()} />
          <input name="_method" type="hidden" value="DELETE" />
        </div>
      </form>
    </div>
  );
};
