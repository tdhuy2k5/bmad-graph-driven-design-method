export interface Product {
  id: string;
  slug: string;
  name: string;
  price: number;
  description: string;
  // TODO: Add other necessary fields based on actual domain models
}

/**
 * CatalogService
 * 
 * Service to read static product data from JSON.
 * Domain: Product Catalog
 */
export class CatalogService {
  /**
   * getProducts
   * Read all products from static JSON file for SSG
   * Roles: PUBLIC
   */
  public async getProducts(): Promise<Product[]> {
    // TODO: Implement reading from static JSON file
    // Example: const data = await import('../../data/products.json');
    // return data.default as Product[];
    console.warn('getProducts is not fully implemented');
    return [];
  }

  /**
   * getProductBySlug
   * Read specific product details by slug for SSG
   * Roles: PUBLIC
   */
  public async getProductBySlug(slug: string): Promise<Product | null> {
    // TODO: Implement reading specific product details
    const products = await this.getProducts();
    const product = products.find(p => p.slug === slug);
    if (!product) {
        return null;
    }
    return product;
  }
}

export const catalogService = new CatalogService();
