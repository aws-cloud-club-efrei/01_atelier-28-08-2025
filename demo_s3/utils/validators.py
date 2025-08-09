"""Validateurs pour l'application"""
import os

class FileValidator:
    """Validateur pour les fichiers uploadés"""
    ALLOWED_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.gif', '.webp'}
    MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB
    
    @classmethod
    def validate_file(cls, file):
        """Valider un fichier uploadé"""
        if not file or file.filename == '':
            raise ValueError('Aucun fichier fourni')
        
        # Vérifier l'extension
        file_ext = os.path.splitext(file.filename)[1].lower()
        if file_ext not in cls.ALLOWED_EXTENSIONS:
            raise ValueError(f'Type de fichier non autorisé. Utilisez: {", ".join(cls.ALLOWED_EXTENSIONS)}')
        
        # Vérifier la taille (si possible)
        file.seek(0, os.SEEK_END)
        file_size = file.tell()
        file.seek(0)
        
        if file_size > cls.MAX_FILE_SIZE:
            raise ValueError(f'Fichier trop volumineux. Taille max: {cls.MAX_FILE_SIZE // (1024*1024)}MB')