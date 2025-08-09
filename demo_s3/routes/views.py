"""Routes pour les vues HTML"""
from flask import Blueprint, render_template

def create_view_routes():
    """Créer les routes pour les vues"""
    views = Blueprint('views', __name__)

    @views.route('/')
    def index():
        """Page principale avec les produits"""
        return render_template('index.html')

    @views.route('/admin')
    def admin():
        """Page d'administration S3"""
        return render_template('admin.html')

    return views