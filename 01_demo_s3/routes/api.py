"""Routes API de l'application"""
from flask import Blueprint, jsonify, request
import logging

logger = logging.getLogger(__name__)

def create_api_routes(s3_service, product_service, file_validator):
    """Créer les routes API avec les services injectés"""
    api = Blueprint('api', __name__, url_prefix='/api')

    @api.route('/products')
    def get_products():
        """API pour récupérer les produits avec URLs S3"""
        try:
            products = product_service.get_all_products()
            return jsonify(products)
        except Exception as e:
            logger.error(f"Erreur lors de la récupération des produits: {e}")
            return jsonify({'error': 'Erreur lors du chargement des produits'}), 500

    @api.route('/s3-config')
    def get_s3_config():
        """API pour récupérer la config S3 (sans les clés secrètes)"""
        return jsonify({
            'bucket_name': s3_service.config.bucket_name,
            'region': s3_service.config.region_name,
            'base_url': s3_service.config.base_url
        })

    @api.route('/s3-images')
    def get_s3_images():
        """API pour lister les images dans le bucket S3"""
        try:
            images = s3_service.list_images()
            return jsonify(images)
        except Exception as e:
            logger.error(f"Erreur lors du listing des images: {e}")
            return jsonify({'error': str(e)}), 500

    @api.route('/upload', methods=['POST'])
    def upload_image():
        """API pour uploader une image vers S3"""
        try:
            file = request.files.get('file')
            file_validator.validate_file(file)
            
            result = s3_service.upload_image(file, file.filename)
            return jsonify(result)
            
        except ValueError as e:
            return jsonify({'error': str(e)}), 400
        except PermissionError as e:
            return jsonify({'error': str(e)}), 403
        except Exception as e:
            logger.error(f"Erreur lors de l'upload: {e}")
            return jsonify({'error': str(e)}), 500

    @api.route('/delete/<filename>', methods=['DELETE'])
    def delete_image(filename):
        """API pour supprimer une image de S3"""
        try:
            result = s3_service.delete_image(filename)
            return jsonify(result)
            
        except FileNotFoundError as e:
            return jsonify({'error': str(e)}), 404
        except PermissionError as e:
            return jsonify({'error': str(e)}), 403
        except Exception as e:
            logger.error(f"Erreur lors de la suppression: {e}")
            return jsonify({'error': str(e)}), 500

    return api