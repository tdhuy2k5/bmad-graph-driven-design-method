import { Product } from './CatalogService';

export interface CartItem {
  product: Product;
  quantity: number;
}

export interface DeliveryInfo {
  name: string;
  phone: string;
  address: string;
  notes?: string;
}

/**
 * CartService
 * 
 * Client-side cart and checkout handoff service (localStorage).
 * Domain: Cart & Checkout Handoff
 */
export class CartService {
  private readonly CART_STORAGE_KEY = 'app_cart';
  private readonly DELIVERY_STORAGE_KEY = 'app_delivery_info';

  private getCartFromStorage(): CartItem[] {
    if (typeof window === 'undefined') return [];
    try {
      const data = localStorage.getItem(this.CART_STORAGE_KEY);
      return data ? JSON.parse(data) : [];
    } catch (e) {
      console.error('Failed to parse cart from storage', e);
      return [];
    }
  }

  private saveCartToStorage(cart: CartItem[]): void {
    if (typeof window === 'undefined') return;
    localStorage.setItem(this.CART_STORAGE_KEY, JSON.stringify(cart));
  }

  /**
   * addToCart
   * Add item to cart and save to localStorage
   * Roles: PUBLIC
   */
  public addToCart(product: Product, quantity: number): CartItem[] {
    const cart = this.getCartFromStorage();
    const existingItem = cart.find(item => item.product.id === product.id);

    if (existingItem) {
      existingItem.quantity += quantity;
    } else {
      cart.push({ product, quantity });
    }

    this.saveCartToStorage(cart);
    return cart;
  }

  /**
   * updateCartItem
   * Update item quantity in cart
   * Roles: PUBLIC
   */
  public updateCartItem(productId: string, quantity: number): CartItem[] {
    let cart = this.getCartFromStorage();
    const itemIndex = cart.findIndex(item => item.product.id === productId);

    if (itemIndex > -1) {
      if (quantity <= 0) {
        cart.splice(itemIndex, 1);
      } else {
        cart[itemIndex].quantity = quantity;
      }
      this.saveCartToStorage(cart);
    }

    return cart;
  }

  /**
   * removeCartItem
   * Remove item from cart
   * Roles: PUBLIC
   */
  public removeCartItem(productId: string): CartItem[] {
    let cart = this.getCartFromStorage();
    cart = cart.filter(item => item.product.id !== productId);
    this.saveCartToStorage(cart);
    return cart;
  }

  /**
   * saveDeliveryInfo
   * Save delivery details to localStorage
   * Roles: PUBLIC
   */
  public saveDeliveryInfo(info: DeliveryInfo): void {
    if (typeof window === 'undefined') return;
    localStorage.setItem(this.DELIVERY_STORAGE_KEY, JSON.stringify(info));
  }

  /**
   * generateCheckoutLink
   * Generate deep link for Zalo/Messenger handoff
   * Roles: PUBLIC
   */
  public generateCheckoutLink(cart: CartItem[], info: DeliveryInfo): string {
    if (cart.length === 0) return '';

    let message = '🛒 Đơn hàng mới:\n\n';
    let total = 0;
    
    cart.forEach(item => {
      const itemTotal = (item.product.price || 0) * item.quantity;
      total += itemTotal;
      message += `- ${item.product.name} x${item.quantity} (${itemTotal}đ)\n`;
    });

    message += `\n💰 Tổng cộng: ${total}đ\n`;
    message += `\n📍 Thông tin giao hàng:\n`;
    message += `Tên: ${info.name}\n`;
    message += `SĐT: ${info.phone}\n`;
    message += `Địa chỉ: ${info.address}\n`;
    if (info.notes) {
      message += `Ghi chú: ${info.notes}\n`;
    }

    // TODO: Move zaloNumber to config or environment variable
    const zaloNumber = '0123456789'; 
    const encodedMessage = encodeURIComponent(message);
    
    return `https://zalo.me/${zaloNumber}?text=${encodedMessage}`;
  }
}

export const cartService = new CartService();
