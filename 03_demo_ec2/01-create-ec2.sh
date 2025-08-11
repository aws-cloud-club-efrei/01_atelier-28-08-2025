#!/bin/bash

# Script de configuration des informations d'instance EC2
# OBLIGATOIRE :  création manuelle au préalable de l'instance EC2 via la console AWS.

echo "⚙️ === CONFIGURATION DE L'INSTANCE EC2 ==="
echo ""
echo "📝 Remplissez les informations de votre instance créée via la console AWS"
echo ""

read -p "🌐 Adresse IP publique de l'instance: " PUBLIC_IP
read -p "🔑 Nom du fichier de clé SSH (ex: ma-cle.pem): " KEY_FILE
read -p "👤 Nom d'utilisateur SSH (ex: ec2-user, ubuntu): " SSH_USER
read -p "🆔 Instance ID (optionnel): " INSTANCE_ID
read -p "🌍 Région AWS (ex: eu-west-3): " REGION

# Valeurs par défaut
SSH_USER=${SSH_USER:-ec2-user}
REGION=${REGION:-eu-west-3}
INSTANCE_ID=${INSTANCE_ID:-"non-specifie"}

echo ""
echo "✅ Configuration enregistrée:"
echo "   🌐 IP: $PUBLIC_IP"
echo "   🔑 Clé: $KEY_FILE"
echo "   👤 Utilisateur: $SSH_USER"
echo "   🆔 Instance: $INSTANCE_ID"
echo "   🌍 Région: $REGION"

# Sauvegarder les informations dans un fichier
cat > instance-config.txt << EOF
# Configuration de l'instance EC2 - Demo S3
PUBLIC_IP=$PUBLIC_IP
KEY_FILE=$KEY_FILE
SSH_USER=$SSH_USER
INSTANCE_ID=$INSTANCE_ID
REGION=$REGION
CONFIGURED_DATE="$(date)"
EOF

echo ""
echo "💾 Configuration sauvegardée dans 'instance-config.txt'"
echo ""
echo "🔧 Vérifications à faire:"
echo "   1. Le fichier '$KEY_FILE' existe dans ce répertoire (si ce n'est pas le cas, déplacer le fichier contenant la clé dans le répertoire courant)"
echo "   2. Les permissions de la clé: chmod 400 $KEY_FILE"
echo "   3. Le port 22 (SSH) est ouvert dans le groupe de sécurité"
echo "   4. Le port 3000 est ouvert pour l'application Flask dans le groupe de sécurité"
echo ""
echo "🚀 Exécutez maintenant: ./02-deploy-app.sh"