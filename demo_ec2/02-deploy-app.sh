#!/bin/bash

# Script pour déployer l'application Demo S3 sur l'instance EC2
# Auteur: Atelier Cloud Club EFREI

set -e  # Arrêter le script en cas d'erreur

echo "📦 === DÉPLOIEMENT DE L'APPLICATION DEMO S3 ==="
echo "📅 Date: $(date)"
echo ""

# Vérifier que le fichier de configuration existe
if [ ! -f "instance-config.txt" ]; then
    echo "❌ Fichier 'instance-config.txt' non trouvé."
    echo "💡 Exécutez d'abord './01-configure-instance.sh'"
    exit 1
fi

# Charger les informations de l'instance
source instance-config.txt

echo "📋 Configuration de l'instance:"
echo "   🌐 IP Publique: $PUBLIC_IP"
echo "   🔑 Clé SSH: $KEY_FILE"
echo "   👤 Utilisateur: $SSH_USER"
echo ""

# Vérifier que la clé SSH existe
if [ ! -f "$KEY_FILE" ]; then
    echo "❌ Clé SSH '$KEY_FILE' non trouvée."
    echo "💡 Placez votre fichier de clé dans ce répertoire"
    exit 1
fi

# Vérifier les permissions de la clé
chmod 400 "$KEY_FILE"

# Créer le package de l'application
echo "📦 Création du package de l'application..."
cd ../demo_s3

# Nettoyer les fichiers temporaires
echo "🧹 Nettoyage des fichiers temporaires..."
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
find . -name "*.pyc" -delete 2>/dev/null || true
find . -name ".pytest_cache" -type d -exec rm -rf {} + 2>/dev/null || true

# Créer le fichier ZIP
echo "📁 Création de l'archive..."
zip -r ../demo_ec2/demo-s3-app.zip . -x "*.git*" "node_modules/*" "*.log" "*.tmp" "__pycache__/*" "*.pyc"

cd ../demo_ec2

echo "✅ Package créé: demo-s3-app.zip ($(du -h demo-s3-app.zip | cut -f1))"
echo ""

# Fonction pour exécuter des commandes SSH
ssh_exec() {
    ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$SSH_USER@$PUBLIC_IP" "$1"
}

# Fonction pour copier des fichiers via SCP
scp_copy() {
    scp -i "$KEY_FILE" -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$1" "$SSH_USER@$PUBLIC_IP:$2"
}

# Tester la connexion SSH
echo "🔌 Test de la connexion SSH..."
if ssh_exec "echo 'Connexion SSH réussie'"; then
    echo "✅ Connexion SSH établie"
else
    echo "❌ Impossible de se connecter via SSH"
    echo "💡 Vérifiez:"
    echo "   - L'instance est démarrée"
    echo "   - Le port 22 est ouvert dans le groupe de sécurité"
    echo "   - L'IP publique est correcte"
    echo "   - Le fichier de clé est correct"
    exit 1
fi
echo ""

# Afficher les informations système
echo "💻 === INFORMATIONS SYSTÈME DE L'INSTANCE ==="
echo "🖥️ Système d'exploitation:"
ssh_exec "cat /etc/os-release | grep PRETTY_NAME || cat /etc/issue | head -1"

echo ""
echo "💾 Espace disque:"
ssh_exec "df -h / | tail -1"

echo ""
echo "🧠 Mémoire:"
ssh_exec "free -h | head -2"

echo ""
echo "🐍 Version Python:"
ssh_exec "python3 --version 2>/dev/null || python --version"

echo ""
echo "⏰ Uptime de l'instance:"
ssh_exec "uptime"
echo ""

# Installer les dépendances si nécessaire
echo "🔧 Installation des dépendances..."
ssh_exec "
# Détecter le système d'exploitation
if command -v yum &> /dev/null; then
    # Amazon Linux / CentOS / RHEL
    echo '📦 Installation sur système basé sur RHEL/Amazon Linux...'
    sudo yum update -y
    sudo yum install -y python3 python3-pip unzip
elif command -v apt &> /dev/null; then
    # Ubuntu / Debian
    echo '📦 Installation sur système basé sur Debian/Ubuntu...'
    sudo apt update
    sudo apt install -y python3 python3-pip unzip
else
    echo '⚠️ Système non reconnu, tentative d installation manuelle...'
fi

# Installer les packages Python
echo '🐍 Installation des packages Python...'
pip3 install --user flask boto3 python-dotenv || sudo pip3 install flask boto3 python-dotenv

echo '✅ Dépendances installées'
"

# Copier l'application sur l'instance
echo "📤 Upload de l'application sur l'instance..."
scp_copy "demo-s3-app.zip" "/tmp/"
echo "✅ Application uploadée"
echo ""

# Déployer l'application
echo "🚀 Déploiement de l'application..."

ssh_exec "
echo '📁 Création du répertoire d application...'
sudo mkdir -p /opt/demo-s3
sudo chown $SSH_USER:$SSH_USER /opt/demo-s3

echo '📦 Extraction de l application...'
cd /opt/demo-s3
unzip -o /tmp/demo-s3-app.zip
echo '✅ Application extraite'

echo ''
echo '⚙️ Configuration de l environnement...'
# Créer un fichier .env d'exemple
cat > /opt/demo-s3/.env << 'ENV_EOF'
AWS_ACCESS_KEY_ID=REMPLACER_PAR_VOTRE_ACCESS_KEY
AWS_SECRET_ACCESS_KEY=REMPLACER_PAR_VOTRE_SECRET_KEY
AWS_REGION=eu-west-3
S3_BUCKET_NAME=e-commerce-bucket-acc-efrei
ENV_EOF

echo '✅ Fichier .env créé'

echo ''
echo '🔧 Test des dépendances...'
cd /opt/demo-s3
python3 -c 'import flask, boto3, dotenv; print(\"✅ Toutes les dépendances sont disponibles\")' || echo '⚠️ Certaines dépendances manquent'

echo ''
echo '🎯 Démarrage de l application en arrière-plan...'
# Tuer les anciens processus s'ils existent
pkill -f 'python3 app.py' || true
sleep 2

# Démarrer l'application en arrière-plan
nohup python3 app.py > app.log 2>&1 &
APP_PID=\$!
echo \"Application démarrée avec PID: \$APP_PID\"

# Attendre un peu et vérifier si l'application démarre
sleep 5
if ps -p \$APP_PID > /dev/null; then
    echo '✅ Application démarrée avec succès'
    echo \"PID: \$APP_PID\" > app.pid
else
    echo '❌ Erreur lors du démarrage de l application'
    echo 'Logs:'
    tail -20 app.log
fi
"

echo ""
echo "🌐 Test de l'application..."
sleep 10

# Tester l'accès à l'application
echo "🔍 Vérification de l'accessibilité..."
if curl -s --connect-timeout 10 http://$PUBLIC_IP:3000 > /dev/null; then
    echo "✅ Application accessible sur http://$PUBLIC_IP:3000"
else
    echo "⚠️ Application pas encore accessible"
    echo "💡 Vérifiez que le port 3000 est ouvert dans le groupe de sécurité"
fi

echo ""
echo "🎉 === DÉPLOIEMENT TERMINÉ ==="
echo ""
echo "🔗 URLs d'accès:"
echo "   📱 Application principale: http://$PUBLIC_IP:3000"
echo "   ⚙️ Interface d'administration: http://$PUBLIC_IP:3000/admin"
echo ""
echo "🔧 Commandes utiles:"
echo "   📡 SSH: ssh -i $KEY_FILE $SSH_USER@$PUBLIC_IP"
echo "   📊 Voir les logs: tail -f /opt/demo-s3/app.log"
echo "   🔄 Redémarrer l'app: pkill -f 'python3 app.py' && cd /opt/demo-s3 && nohup python3 app.py > app.log 2>&1 &"
echo ""
echo "⚠️ CONFIGURATION REQUISE:"
echo "   1. 🔑 Éditez /opt/demo-s3/.env avec vos vraies clés AWS"
echo "   2. 📦 Uploadez les images dans votre bucket S3:"
echo "      - af1.png (Air Force 1)"
echo "      - aj4.png (Air Jordan 4)"
echo "      - muse.png (Nike Muse)"
echo "   3. 🛡️ Vérifiez que le port 3000 est ouvert dans le groupe de sécurité"
echo ""
echo "🎓 Votre application Demo S3 est maintenant déployée sur EC2 !"