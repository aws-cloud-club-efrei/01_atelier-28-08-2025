"""Configuration de l'application"""
import os
from dotenv import load_dotenv

# Charger les variables d'environnement
load_dotenv()

class S3Config:
    """Configuration S3 centralisée"""
    def __init__(self):
        self.aws_access_key_id = os.getenv('AWS_ACCESS_KEY_ID')
        self.aws_secret_access_key = os.getenv('AWS_SECRET_ACCESS_KEY')
        self.region_name = os.getenv('AWS_REGION', 'eu-west-3')
        self.bucket_name = os.getenv('S3_BUCKET_NAME')
        
        # Validation des variables requises
        if not all([self.aws_access_key_id, self.aws_secret_access_key, self.bucket_name]):
            raise ValueError("Variables d'environnement AWS manquantes dans le fichier .env")
    
    @property
    def base_url(self):
        return f"https://{self.bucket_name}.s3.{self.region_name}.amazonaws.com"

class AppConfig:
    """Configuration générale de l'application"""
    DEBUG = True
    PORT = 3000
    HOST = '0.0.0.0'