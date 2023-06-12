import { createRoot } from 'react-dom/client';
import React from 'react';
import User from '../types/user';

const CreationModal = () => {
  return <div className="modal-content">{/* TDDO:ここにユーザ作成用のモーダルの中身を作成する */}</div>;
};

const EditationModal = ({ user }: { user: User }) => {
  return <div className="modal-content">{/* TDDO:ここにユーザ編集用のモーダルの中身を作成する */}</div>;
};

const DeletionModal = ({ user }: { user: User }) => {
  return <div className="modal-content">{/* TDDO:ここにユーザ削除用のモーダルの中身を作成する */}</div>;
};

document.addEventListener('DOMContentLoaded', () => {
  const createUserButton = document.querySelector<HTMLElement>('#create-user-button');
  const editUserButtons = document.querySelectorAll<HTMLElement>('#edit-user-button');
  const deleteUserButtons = document.querySelectorAll<HTMLElement>('#delete-user-button');
  const modal = document.getElementById('modal-component');
});
