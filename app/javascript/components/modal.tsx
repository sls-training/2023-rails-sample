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
  return <div className="modal-content">{/* TDDO:ここにユーザ削除用のモーダルの中身を作成する */}</div>;
};
