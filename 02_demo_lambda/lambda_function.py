"""
Fonction Lambda - Renommage et déplacement d'images avec timestamp
"""

import json
import boto3
import urllib.parse
from datetime import datetime

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    try:
        for record in event['Records']:
            bucket_name = record['s3']['bucket']['name']
            object_key = urllib.parse.unquote_plus(record['s3']['object']['key'], encoding='utf-8')
            
            print(f"📁 Nouveau fichier détecté: {object_key}")
            
            # Ignorer les fichiers déjà dans analyse/ pour éviter la boucle
            if object_key.startswith('analyse/'):
                print(f"⚠️ Ignoré (déjà dans analyse/): {object_key}")
                continue
            
            # Traiter seulement les images
            if object_key.lower().endswith(('.jpg', '.jpeg', '.png', '.gif', '.webp')):
                move_and_rename_image(bucket_name, object_key)
            else:
                print(f"⚠️ Pas une image: {object_key}")
        
        return {'statusCode': 200, 'body': json.dumps('Images déplacées et renommées')}
        
    except Exception as e:
        print(f"❌ Erreur globale: {str(e)}")
        return {'statusCode': 500, 'body': json.dumps(f'Erreur: {str(e)}')}

def move_and_rename_image(bucket_name, object_key):
    """Renomme l'image avec timestamp et la déplace dans analyse/"""
    
    try:
        # Générer le timestamp lisible
        now = datetime.now()
        timestamp = now.strftime("%Y-%m-%d_%Hh%Mm%Ss")  # Format: 2025-08-11_18h30m45s
        
        # Extraire le nom et l'extension
        filename = object_key.split('/')[-1]
        name_without_ext = filename.rsplit('.', 1)[0]
        extension = filename.split('.')[-1].lower()
        
        # Créer le nouveau nom avec timestamp
        new_filename = f"{name_without_ext}_{timestamp}.{extension}"
        new_key = f"analyse/{new_filename}"
        
        print(f"🔄 Déplacement: {object_key} → {new_key}")
        
        # Créer une copie vers le nouveau emplacement
        s3_client.copy_object(
            Bucket=bucket_name,
            CopySource={'Bucket': bucket_name, 'Key': object_key},
            Key=new_key,
            Metadata={
                'original-name': filename,
                'original-location': object_key,
                'upload-timestamp': now.isoformat(),
                'processed-by': 'lambda-file-organizer'
            },
            MetadataDirective='REPLACE'
        )
        
        print(f"✅ Copie créée avec timestamp: {new_key}")
        print(f"   📅 Timestamp: {timestamp}")
        print(f"   📁 Original conservé: {object_key}")
        
    except Exception as e:
        print(f"❌ Erreur déplacement: {str(e)}")