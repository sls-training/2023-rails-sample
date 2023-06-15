import { CreationModal, EditationModal, DeletionModal } from '../../components/modal';
import { createRoot } from 'react-dom/client';
import React from 'react';
import User from '../../types/user';

document.addEventListener('DOMContentLoaded', () => {
  const createUserButton = document.querySelector<HTMLElement>('#create-user-button');
  const editUserButtons = document.querySelectorAll<HTMLElement>('#edit-user-button');
  const deleteUserButtons = document.querySelectorAll<HTMLElement>('#delete-user-button');
  const modal = document.getElementById('modal-component');

  const modalRoot = createRoot(modal);

  createUserButton?.addEventListener('click', () => {
    modalRoot.render(<CreationModal />);
  });

  editUserButtons.forEach((editUserButton: HTMLElement) => {
    editUserButton.addEventListener('click', function () {
      if (!editUserButton.dataset.user) return;
      const user = JSON.parse(editUserButton.dataset.user) as User;
      modalRoot.render(<EditationModal user={user} />);
    });
  });

  deleteUserButtons.forEach((deleteUserButton: HTMLElement) => {
    deleteUserButton.addEventListener('click', function () {
      if (!deleteUserButton.dataset.user) return;
      const user = JSON.parse(deleteUserButton.dataset.user) as User;
      modalRoot.render(<DeletionModal user={user} />);
    });
  });
});
