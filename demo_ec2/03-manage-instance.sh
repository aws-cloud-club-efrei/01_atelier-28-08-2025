#!/bin/bash

# Script de gestion de l'instance EC2 Demo S3
# Auteur: Atelier Cloud Club EFREI

# Vérifier que le fichier de configuration existe
if [ ! -f "instance-config.txt" ]; then
    echo "❌ Fichier 'instance-config.txt' non trouvé."
    echo "💡 Exécutez d'abord './01-configure-instance.sh'"
    exit 1
fi

# Charger les informations de l'instance
source instance-config.txt

# Fonction d'aide
show_help() {
    echo "🛠️ === GESTIONNAIRE D'INSTANCE EC2 DEMO S3 ==="
    echo ""
    echo "Usage: $0 [COMMANDE]"
    echo ""
    echo "Commandes disponibles:"
    echo "  connect    - Se connecter via SSH"
    echo "  logs       - Afficher les logs de l'application"
    echo "  status     - Afficher le statut de l'application"
    echo "  restart    - Redémarrer l'application"
    echo "  stop       - Arrêter l'application"
    echo "  start      - Démarrer l'application"
    echo "  info       - Afficher les informations système"
    echo "  help       - Afficher cette aide"
    echo ""
    echo "📋 Instance configurée:"
    echo "   🌐 IP: $PUBLIC_IP"
    echo "   👤 Utilisateur: $SSH_USER"
    echo "   🔑 Clé: $KEY_FILE"
    echo "   🔗 URL: http://$PUBLIC_IP:3000"
}

# Fonction pour exécuter des commandes SSH
ssh_exec() {
    ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$SSH_USER@$PUBLIC_IP" "$1"
}

case "${1:-help}" in
    "connect")
        echo "🔌 Connexion SSH à l'instance..."
        echo "💡 Pour quitter: tapez 'exit'"
        ssh -i "$KEY_FILE" "$SSH_USER@$PUBLIC_IP"
        ;;
        
    "logs")
        echo "📝 === LOGS DE L'APPLICATION ==="
        ssh_exec "tail -50 /opt/demo-s3/app.log 2>/dev/null || echo 'Fichier de log non trouvé'"
        ;;
        
    "status")
        echo "📊 === STATUT DE L'APPLICATION ==="
        ssh_exec "
        if pgrep -f 'python3 app.py' > /dev/null; then
            PID=\$(pgrep -f 'python3 app.py')
            echo '✅ Application en cours d exécution (PID: \$PID)'
            echo '🌐 URL: http://$PUBLIC_IP:3000'
        else
            echo '❌ Application non démarrée'
        fi
        "
        ;;
        
    "restart")
        echo "🔄 Redémarrage de l'application..."
        ssh_exec "
        cd /opt/demo-s3
        pkill -f 'python3 app.py' || true
        sleep 3
        nohup python3 app.py > app.log 2>&1 &
        APP_PID=\$!
        echo 'Application redémarrée avec PID: \$APP_PID'
        echo \"\$APP_PID\" > app.pid
        "
        echo "✅ Application redémarrée"
        ;;
        
    "stop")
        echo "⏹️ Arrêt de l'application..."
        ssh_exec "pkill -f 'python3 app.py' && echo '✅ Application arrêtée' || echo '⚠️ Aucun processus trouvé'"
        ;;
        
    "start")
        echo "▶️ Démarrage de l'application..."
        ssh_exec "
        cd /opt/demo-s3
        if pgrep -f 'python3 app.py' > /dev/null; then
            echo '⚠️ Application déjà en cours d exécution'
        else
            nohup python3 app.py > app.log 2>&1 &
            APP_PID=\$!
            echo 'Application démarrée avec PID: \$APP_PID'
            echo \"\$APP_PID\" > app.pid
        fi
        "
        ;;
        
    "info")
        echo "📋 === INFORMATIONS SYSTÈME ==="
        ssh_exec "
        echo '🖥️ Système:'
        cat /etc/os-release | grep PRETTY_NAME || cat /etc/issue | head -1
        echo ''
        echo '💾 Espace disque:'
        df -h / | tail -1
        echo ''
        echo '🧠 Mémoire:'
        free -h | head -2
        echo ''
        echo '⏰ Uptime:'
        uptime
        echo ''
        echo '🐍 Python:'
        python3 --version
        echo ''
        echo '📊 Processus Python:'
        ps aux | grep python3 | grep -v grep || echo 'Aucun processus Python trouvé'
        "
        ;;
        
    "help"|*)
        show_help
        ;;
esac