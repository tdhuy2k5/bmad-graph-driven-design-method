export interface User {
  id: string;
  email: string;
  displayName: string;
  // TODO: Add other necessary fields based on actual domain models
}

/**
 * AuthService
 * 
 * Firebase Authentication Service
 */
export class AuthService {
  /**
   * loginWithOAuth
   * Login via Google/GitHub
   * Roles: PUBLIC
   */
  public async loginWithOAuth(provider: string): Promise<User> {
    // TODO: Implement login via Google/GitHub using Firebase Auth
    console.warn('loginWithOAuth is not fully implemented');
    return {} as User;
  }

  /**
   * loginAdmin
   * Login via Google/GitHub with email whitelist check
   * Roles: PUBLIC
   * Guard: email in ADMIN_EMAIL
   */
  public async loginAdmin(provider: string): Promise<User> {
    // TODO: Implement login via Google/GitHub with email whitelist check using Firebase Auth
    console.warn('loginAdmin is not fully implemented');
    return {} as User;
  }
}

export const authService = new AuthService();
