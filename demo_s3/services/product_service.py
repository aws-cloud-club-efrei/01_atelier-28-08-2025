"""Service pour la gestion des produits"""

# Données des produits Nike
PRODUCTS = [
    {
        "id": 1, 
        "name": "Air Force 1 '07", 
        "price": 119.99, 
        "image": "af1.png",
        "description": "L'icône intemporelle. Créée en 1982, l'Air Force 1 reste fidèle à ses racines avec son cuir souple et son style classique.",
        "category": "Lifestyle",
        "colors": ["Blanc/Blanc", "Noir/Noir", "Blanc/Noir"],
        "sizes": ["36", "37", "38", "39", "40", "41", "42", "43", "44", "45"]
    },
    {
        "id": 2, 
        "name": "Air Jordan 4 Retro", 
        "price": 199.99, 
        "image": "aj4.png",
        "description": "Inspirée par le vol, l'Air Jordan 4 Retro apporte un style audacieux avec ses détails en mesh et sa semelle visible Air.",
        "category": "Basketball",
        "colors": ["Blanc/Cement Grey", "Bred", "Black Cat"],
        "sizes": ["36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46"]
    },
    {
        "id": 3, 
        "name": "Nike Muse", 
        "price": 89.99, 
        "image": "muse.png",
        "description": "Confort moderne et style épuré. La Nike Muse offre une expérience de port exceptionnelle pour le quotidien.",
        "category": "Lifestyle",
        "colors": ["Blanc/Gris", "Noir/Blanc", "Rose/Blanc"],
        "sizes": ["36", "37", "38", "39", "40", "41", "42", "43", "44"]
    }
]

class ProductService:
    """Service pour la gestion des produits"""
    def __init__(self, s3_service):
        self.s3_service = s3_service
    
    def get_all_products(self):
        """Récupérer tous les produits avec URLs S3"""
        products_with_urls = []
        for product in PRODUCTS:
            product_copy = product.copy()
            product_copy['image_url'] = self.s3_service.get_image_url(product['image'])
            products_with_urls.append(product_copy)
        return products_with_urls