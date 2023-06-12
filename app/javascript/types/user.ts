type User = {
  id: number;
  name: string;
  email: string;
  admin: boolean;
  activated_at: Date | null;
  created_at: Date;
  updated_at: Date;
};

export default User;
