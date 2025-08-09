# Atelier AWS - Cloud Club EFREI

> **Atelier Cloud Computing** - Démonstrations pratiques des services AWS  
> **Date de création :** 9 janvier 2025  
> **Dernière mise à jour :** 10 janvier 2025  
> **Version :** 2.0.0

Repository contenant les démonstrations et exercices pratiques pour l'atelier AWS du Cloud Club EFREI. Cet atelier couvre l'intégration des services EC2 et S3 à travers une application web complète.

## 🎯 Objectif de l'atelier

Apprendre à déployer une application web moderne sur AWS en utilisant :

- **Amazon EC2** pour l'hébergement de l'application
- **Amazon S3** pour le stockage des ressources statiques
- **Intégration complète** entre les services AWS

## 📁 Structure du projet

```
01_atelier-09-07-2025/
├── 📄 README.md              # Documentation principale
├── 📁 demo_s3/               # Application Nike Store (Flask + S3)
│   ├── 🐍 app.py             # Application Flask modulaire
│   ├── ⚙️ config.py          # Configuration centralisée
│   ├── 📋 requirements.txt   # Dépendances Python
│   ├── 🌐 templates/         # Templates HTML (Nike Store)
│   ├── 🔧 services/          # Services métier (S3, produits)
│   ├── 🛣️ routes/            # Routes Flask (API + vues)
│   ├── 🛠️ utils/             # Utilitaires et validateurs
│   └── 📖 README.md          # Documentation de l'application
├── 📁 demo_ec2/              # Scripts de déploiement EC2
│   ├── 🔧 01-configure-instance.sh  # Configuration interactive
│   ├── 📦 02-deploy-app.sh          # Déploiement automatisé
│   ├── 🛠️ 03-manage-instance.sh     # Gestion de l'application
│   └── 📖 README.md                 # Guide de déploiement
└── 📁 demo_lambda/           # Démonstrations Lambda (à venir)
```

## 🏪 Demo S3 - Nike Store Application

### 📋 Description

Application web moderne simulant un site e-commerce Nike avec :

- **Interface utilisateur** : Design Nike authentique avec TailwindCSS
- **Catalogue produits** : 3 baskets iconiques (Air Force 1, Air Jordan 4, Nike Muse)
- **Intégration S3** : Images stockées et servies depuis Amazon S3
- **Interface d'administration** : Gestion des images S3 avec upload/suppression
- **Architecture modulaire** : Code Python organisé en services et routes

### 🚀 Fonctionnalités

- ✅ **Affichage dynamique** des produits avec images S3
- ✅ **Interface d'administration** pour gérer les images
- ✅ **Upload/Suppression** d'images vers/depuis S3
- ✅ **Gestion d'erreurs** avec diagnostic des permissions
- ✅ **Design responsive** optimisé mobile/desktop
- ✅ **API REST** pour l'intégration

### 🛠️ Technologies utilisées

- **Backend** : Python 3.9+, Flask 2.3+
- **AWS SDK** : Boto3 pour l'intégration S3
- **Frontend** : HTML5, TailwindCSS, JavaScript ES6
- **Configuration** : python-dotenv pour les variables d'environnement

## 🖥️ Demo EC2 - Déploiement automatisé

### 📋 Description

Scripts Bash pour automatiser le déploiement de l'application Nike Store sur une instance EC2 :

- **Configuration interactive** des informations d'instance
- **Déploiement automatisé** avec gestion des dépendances
- **Gestion complète** de l'application en production

### 🚀 Fonctionnalités

- ✅ **Configuration guidée** des paramètres d'instance
- ✅ **Déploiement en un clic** avec vérifications automatiques
- ✅ **Gestion d'application** (start, stop, restart, logs)
- ✅ **Diagnostic système** et monitoring
- ✅ **Support multi-OS** (Amazon Linux, Ubuntu)
- ✅ **Sécurisation SSH** et gestion des permissions

### 🛠️ Technologies utilisées

- **Scripts** : Bash 4.0+
- **Déploiement** : SSH, SCP
- **Monitoring** : Logs système et application
- **Packaging** : ZIP pour le transfert d'application

## 🎓 Parcours d'apprentissage

### Étape 1 : Développement local (demo_s3)

```bash
cd demo_s3
pip install -r requirements.txt
# Configurer le .env avec vos clés AWS
python app.py
# Accéder à http://localhost:3000
```

### Étape 2 : Déploiement sur EC2 (demo_ec2)

```bash
cd demo_ec2
chmod +x *.sh
./01-configure-instance.sh  # Configuration
./02-deploy-app.sh          # Déploiement
./03-manage-instance.sh     # Gestion
```

### Étape 3 : Configuration S3

1. **Créer un bucket S3** : `e-commerce-bucket-acc-efrei`
2. **Uploader les images** : `af1.png`, `aj4.png`, `muse.png`
3. **Configurer les permissions** S3 appropriées
4. **Tester l'intégration** via l'interface d'administration

## 📚 Concepts AWS abordés

### 🖥️ Amazon EC2

- **Instances** : Création, configuration, gestion
- **Groupes de sécurité** : Règles de pare-feu
- **Clés SSH** : Authentification sécurisée
- **Déploiement d'applications** : Bonnes pratiques

### 📦 Amazon S3

- **Buckets** : Création et configuration
- **Objets** : Upload, téléchargement, suppression
- **Permissions** : Politiques IAM et bucket policies
- **Intégration applicative** : SDK Boto3

### � Sécurité AWS

- **Variables d'environnement** : Gestion sécurisée des clés
- **Permissions granulaires** : Principe du moindre privilège
- **Diagnostic d'erreurs** : Explicit Deny vs Allow

## 🛠️ Prérequis techniques

### 💻 Environnement de développement

- **Python** 3.9+ avec pip
- **Git** pour le versioning
- **Éditeur de code** (VS Code recommandé)
- **Terminal** Unix/Linux (WSL2 sur Windows)

### ☁️ Compte AWS

- **Compte AWS** actif (Free Tier suffisant)
- **Clés d'accès** IAM configurées
- **Permissions** EC2 et S3 requises

### 🔧 Outils système

- **SSH client** pour la connexion aux instances
- **curl** pour les tests HTTP
- **zip/unzip** pour le packaging

## 🚀 Démarrage rapide

### 1. Clone du repository

```bash
git clone <repository-url>
cd 01_atelier-09-07-2025
```

### 2. Test en local

```bash
cd demo_s3
pip install -r requirements.txt
cp .env.example .env
# Éditer .env avec vos clés AWS
python app.py
```

### 3. Déploiement sur EC2

```bash
# Créer une instance EC2 via la console AWS
cd ../demo_ec2
./01-configure-instance.sh
./02-deploy-app.sh
```

## 💡 Bonnes pratiques démontrées

### 🏗️ Architecture

- **Séparation des responsabilités** : Services, routes, utilitaires
- **Configuration externalisée** : Variables d'environnement
- **Gestion d'erreurs** : Logging et diagnostic

### 🔒 Sécurité

- **Clés AWS** : Jamais dans le code source
- **Permissions SSH** : Clés avec permissions 400
- **Groupes de sécurité** : Ports minimaux ouverts

### 📊 Monitoring

- **Logs applicatifs** : Suivi des opérations
- **Métriques système** : CPU, RAM, disque
- **Tests de connectivité** : Vérifications automatiques

## 💰 Estimation des coûts

### 🆓 Free Tier (12 premiers mois)

- **EC2 t2.micro** : 750h/mois gratuit
- **S3** : 5 GB gratuit
- **Transfert** : 15 GB sortant gratuit

### 💳 Coût estimé pour l'atelier

- **Durée** : 4 heures
- **Instance EC2** : ~0.05€
- **Stockage S3** : ~0.01€
- **Total** : **~0.06€**

## 📞 Support et ressources

### 🔗 Documentation officielle

- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [AWS S3 Documentation](https://docs.aws.amazon.com/s3/)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Boto3 Documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/)

### 👥 Contact

- **Organisateur** : Cloud Club EFREI
- **Support technique** : Via les issues GitHub
- **Documentation** : README.md dans chaque dossier

## ⚠️ Notes importantes

### 🔐 Sécurité

- **Ne jamais commiter** vos clés AWS dans Git
- **Utiliser des variables d'environnement** pour la configuration
- **Arrêter les instances EC2** après l'atelier

### 💸 Gestion des coûts

- **Surveiller** votre usage AWS
- **Supprimer les ressources** après l'atelier
- **Utiliser AWS Cost Explorer** pour le monitoring

---

🎓 **Bon atelier et bonne découverte d'AWS !**

---

_Dernière mise à jour : 10 janvier 2025 - Version 2.0.0_
