"""Configuration de l'application"""
import os
from dotenv import load_dotenv

# Charger les variables d'environnement
load_dotenv()

class S3Config:
    """Configuration S3"""
    def __init__(self):
        self.region_name = os.getenv('AWS_REGION', 'eu-west-3')
        self.bucket_name = os.getenv('S3_BUCKET_NAME')
       
    @property
    def base_url(self):
        return f"https://{self.bucket_name}.s3.{self.region_name}.amazonaws.com"

class AppConfig:
    """Configuration générale de l'application"""
    DEBUG = True
    PORT = 3000
    HOST = '0.0.0.0'