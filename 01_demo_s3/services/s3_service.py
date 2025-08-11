"""Service pour les opérations S3"""
import boto3
import logging
from botocore.exceptions import ClientError, NoCredentialsError

logger = logging.getLogger(__name__)

class S3Service:
    """Service pour les opérations S3"""
    def __init__(self, config):
        self.config = config
        self.client = self._create_client()
    
    def _create_client(self):
        """Créer le client S3 avec gestion d'erreurs"""
        try:
            return boto3.client(
                's3',
                region_name=self.config.region_name
            )
        except NoCredentialsError:
            logger.error("Credentials AWS non trouvées")
            raise
    
    def get_image_url(self, image_name: str) -> str:
        """Générer l'URL S3 pour une image"""
        return f"{self.config.base_url}/{image_name}"
    
    def list_images(self) -> list:
        """Lister les images dans le bucket S3"""
        try:
            response = self.client.list_objects_v2(Bucket=self.config.bucket_name)
            
            if 'Contents' not in response:
                return []
            
            images = []
            allowed_extensions = ('.jpg', '.jpeg', '.png', '.gif', '.webp')
            
            for obj in response['Contents']:
                if obj['Key'].lower().endswith(allowed_extensions):
                    images.append({
                        'name': obj['Key'],
                        'size': obj['Size'],
                        'last_modified': obj['LastModified'].isoformat(),
                        'url': self.get_image_url(obj['Key'])
                    })
            
            return images
            
        except ClientError as e:
            logger.error(f"Erreur lors du listing S3: {e}")
            raise
    
    def upload_image(self, file, filename: str) -> dict:
        """Uploader une image vers S3"""
        try:
            self.client.upload_fileobj(
                file,
                self.config.bucket_name,
                filename,
                ExtraArgs={
                    'ContentType': file.content_type,
                }
            )
            
            return {
                'message': 'Upload réussi',
                'filename': filename,
                'url': self.get_image_url(filename)
            }
            
        except ClientError as e:
            error_code = e.response['Error']['Code']
            if error_code == 'AccessDenied':
                raise PermissionError('Permission refusée. Vérifiez que votre politique S3 inclut "s3:PutObject" et "s3:PutObjectAcl"')
            else:
                raise Exception(f'Erreur S3: {str(e)}')
    
    def delete_image(self, filename: str) -> dict:
        """Supprimer une image de S3"""
        try:
            # Vérifier que le fichier existe
            self.client.head_object(Bucket=self.config.bucket_name, Key=filename)
            
            # Supprimer le fichier
            self.client.delete_object(Bucket=self.config.bucket_name, Key=filename)
            
            return {'message': f'Fichier "{filename}" supprimé avec succès'}
            
        except ClientError as e:
            error_code = e.response['Error']['Code']
            if error_code == 'NoSuchKey':
                raise FileNotFoundError('Fichier non trouvé')
            elif error_code == 'AccessDenied':
                raise PermissionError('Permission refusée. Vérifiez que votre politique S3 inclut "s3:DeleteObject"')
            else:
                raise Exception(f'Erreur S3: {str(e)}')