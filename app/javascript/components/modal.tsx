import React from 'react';
import User from '../types/user';

export const getCsrfToken = (): string => {
  const metaElement = document.querySelector("meta[name='csrf-token']");
  if (!metaElement) throw Error('meta[name=csrf-token] is not founded.');

  const csrfToken = metaElement.getAttribute('content');
  if (!csrfToken) throw Error('csrf token is not set');

  return csrfToken;
};

export const CreationModal = () => {
  return <div className="modal-content">{/* TDDO:ここにユーザ作成用のモーダルの中身を作成する */}</div>;
};

export const EditationModal = ({ user }: { user: User }) => {
  return <div className="modal-content">{/* TDDO:ここにユーザ編集用のモーダルの中身を作成する */}</div>;
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
