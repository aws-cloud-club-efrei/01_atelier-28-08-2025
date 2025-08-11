"""Application Flask principale"""
from flask import Flask
import logging

# Configuration du logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Imports des modules
from config import S3Config, AppConfig
from services.s3_service import S3Service
from services.product_service import ProductService
from utils.validators import FileValidator
from routes.api import create_api_routes
from routes.views import create_view_routes

def create_app():
    """Factory pour créer l'application Flask"""
    app = Flask(__name__)
    
    try:
        # Initialisation des services
        s3_config = S3Config()
        s3_service = S3Service(s3_config)
        product_service = ProductService(s3_service)
        file_validator = FileValidator()
        
        logger.info(f"Application initialisée avec le bucket: {s3_config.bucket_name}")
        
        # Enregistrement des blueprints
        app.register_blueprint(create_view_routes())
        app.register_blueprint(create_api_routes(s3_service, product_service, file_validator))
        
        return app
        
    except Exception as e:
        logger.error(f"Erreur d'initialisation: {e}")
        raise

# Création de l'application
app = create_app()

if __name__ == '__main__':
    try:
        logger.info("🚀 Démarrage de l'application S3 Demo")
        app.run(
            debug=AppConfig.DEBUG,
            port=AppConfig.PORT,
            host=AppConfig.HOST
        )
    except Exception as e:
        logger.error(f"Impossible de démarrer l'application: {e}")
        exit(1)