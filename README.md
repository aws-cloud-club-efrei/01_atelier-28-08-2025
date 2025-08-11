# Atelier AWS - Cloud Club EFREI

> **Atelier Cloud Computing** - Démonstrations pratiques des services AWS  
> **Date de création :** 3 août 2025  
> **Dernière mise à jour :** 11 août 2025  
> **Version :** 3.0.0

Repository contenant les démonstrations et exercices pratiques pour l'atelier AWS du Cloud Club EFREI. Cet atelier couvre l'intégration complète des services EC2, S3 et Lambda à travers une application web moderne avec traitement automatisé.

## 🎯 Objectif de l'atelier

Apprendre à déployer une application web moderne sur AWS en utilisant :

- **Amazon S3** pour le stockage des images et ressources statiques
- **AWS Lambda** pour le traitement serverless automatique
- **Amazon EC2** pour l'hébergement de l'application en production
- **CloudWatch** pour le monitoring et les logs
- **Intégration complète** entre tous les services AWS

## 📁 Structure du projet

```
atelier-aws-cloud-club-efrei/
├── 📄 README.md                       # Documentation principale
├── 📄 .gitignore                      # Fichiers à ignorer par Git
├── 📁 diagrams/                       # Diagrammes d'architecture
│   ├── aws-architecture.mermaid       # Architecture AWS Mermaid
│   ├── aws-architecture.png           # Architecture AWS (image)
│   ├── sequence-diagram.mermaid       # Diagramme de séquence
│   └── sequence.png                   # Diagramme de séquence (image)
├── 📁 01_demo_s3/                     # Application Nike Store (Flask + S3)
│   ├── 🐍 app.py                      # Application Flask modulaire
│   ├── ⚙️ config.py                   # Configuration centralisée
│   ├── 📋 requirements.txt            # Dépendances Python
│   ├── 🔒 .env                        # Variables d'environnement
│   ├── 🌐 templates/                  # Templates HTML (Nike Store)
│   │   ├── index.html                 # Page d'accueil Nike Store
│   │   └── admin.html                 # Interface d'administration S3
│   ├── � servic.es/                   # Services métier (S3, produits)
│   │   ├── __init__.py
│   │   ├── s3_service.py              # Service AWS S3
│   │   └── product_service.py         # Service produits Nike
│   ├── 🛣️ routes/                     # Routes Flask (API + vues)
│   │   ├── __init__.py
│   │   ├── main_routes.py             # Routes principales
│   │   └── api_routes.py              # API REST
│   ├── �️R utils/                      # Utilitaires et validateurs
│   │   ├── __init__.py
│   │   └── validators.py              # Validation des données
│   └── 📖 README.md                   # Documentation de l'application
├── 📁 02_demo_lambda/                 # Traitement automatique serverless
│   ├── ⚡ lambda_function.py          # Fonction Lambda de traitement
│   └── 📖 README.md                   # Guide Lambda + intégration S3
└── 📁 03_demo_ec2/                    # Scripts de déploiement EC2
    ├── 🔧 01-create-ec2.sh            # Création d'instance
    ├── 📦 02-deploy-app.sh            # Déploiement automatisé
    ├── 🛠️ 03-manage-instance.sh       # Gestion de l'application
    └── 📖 README.md                   # Guide de déploiement
```

# 🚀 Démonstrations AWS - E-commerce Nike Store

Ce projet contient trois démonstrations pratiques d'utilisation des services AWS pour créer une application e-commerce complète avec traitement automatisé.

## 📁 Structure du projet

### 🛍️ `demo_s3/` - Application Nike Store avec S3

Application web Flask complète simulant un site e-commerce Nike avec intégration S3 pour la gestion des images.

**Fonctionnalités :**

- Interface utilisateur Nike Store
- Upload d'images de sneakers vers S3
- Interface d'administration S3
- Gestion des erreurs et permissions S3

**Technologies :** Python Flask, AWS S3, HTML/CSS/JavaScript, Boto3

### ⚡ `demo_lambda/` - Traitement automatique d'images

Fonction Lambda serverless qui complète l'application Nike Store en ajoutant un traitement automatique des images uploadées.

**Fonctionnalités :**

- Déclenchement automatique sur événements S3
- Création de copies horodatées dans le dossier `analyse/`
- Format de nommage (YYYY-MM-DD_HHhMMmSSs)
- Conservation de l'image originale
- Logs CloudWatch

**Technologies :** Python, AWS Lambda, CloudWatch

### �️ `demo_ec2/` - Déploiement EC2 automatisé

Scripts Bash pour déployer automatiquement l'application Nike Store sur une instance EC2.

**Fonctionnalités :**

- Configuration et déploiement de l'application sur l'instance EC2 aupréalablement créée via la console AWS
- Gestion des clés SSH et sécurité
- Scripts de diagnostic et maintenance

**Technologies :** Bash, AWS EC2, Ubuntu Server, SSH

## 🏗️ Architecture globale

```
👤 Utilisateur
    ↓ (Upload image)
🌐 Application Nike Store (Flask - Port 3000)
    ↓ (Stockage)
🪣 S3 Bucket (e-commerce-bucket-acc-efrei)
    ↓ (ObjectCreated Event)
⚡ Lambda Function (e-commerce-lambda-function-acc-efrei)
    ↓ (Copie horodatée)
📁 analyse/ (Images avec timestamp)
    ↓ (Logs)
📊 CloudWatch (Monitoring)
    ↓ (Déploiement production)
🖥️ EC2 Instance (Production)
```

## 🔄 Flux de données complet

1. **Upload** : Utilisateur upload une image via l'interface Nike Store
2. **Stockage** : Image sauvegardée dans le bucket S3
3. **Déclenchement** : Événement S3 déclenche automatiquement la Lambda
4. **Traitement** : Lambda crée une copie horodatée dans `analyse/`

## 🚀 Démarrage rapide

### Prérequis

- Compte AWS configuré
- Python 3.9+
- AWS CLI installé et configuré
- Bash (pour les scripts EC2)

### 1. Demo S3 - Application Nike Store

```bash
cd demo_s3
pip install -r requirements.txt
python app.py
# Ouvrir http://127.0.0.1:3000
```

### 2. Demo Lambda - Traitement automatique (Suite de demo_s3)

```bash
cd demo_lambda
# 1. Créer la fonction Lambda via AWS Console
# 2. Nom : e-commerce-lambda-function-acc-efrei
# 3. Copier-coller le code de lambda_function.py
# 4. Configurer le trigger S3 sur le bucket
# 5. Tester en uploadant une image via l'app Nike Store
```

### 3. Demo EC2 - Déploiement production

```bash
cd demo_ec2
chmod +x *.sh
./01-create-ec2.sh
./02-deploy-app.sh
```

## 📊 Diagrammes d'architecture

Le projet inclut plusieurs diagrammes pour visualiser l'architecture :

- `aws-architecture.mermaid` - Architecture AWS avec icônes des services
- `sequence-diagram.mermaid` - Flux temporel des 3 démonstrations

## 🔧 Configuration AWS

### Services utilisés

- **S3** : Stockage d'images et fichiers statiques
- **Lambda** : Traitement serverless automatique des images
- **EC2** : Hébergement de l'application en production
- **CloudWatch** : Monitoring et logs détaillés
- **IAM** : Gestion automatique des permissions

### Bucket S3 configuré

```
e-commerce-bucket-acc-efrei/
├── nocta.png                           ← Images originales
├── af1.jpg
└── analyse/                            ← Copies horodatées par Lambda
    ├── nocta_2025-08-11_18h30m45s.png
    └── af1_2025-08-11_18h45m12s.jpg
```

## 📝 Documentation détaillée

Chaque démonstration contient sa propre documentation :

- `demo_s3/README.md` - Guide complet de l'application Nike Store
- `demo_lambda/README.md` - Configuration Lambda et test avec demo_s3
- `demo_ec2/README.md` - Scripts de déploiement EC2

## 🧪 Tests et validation

### Workflow de test complet

1. **Lancer l'application Nike Store** (demo_s3)
2. **Uploader une image** via l'interface web
3. **Vérifier le déclenchement Lambda** dans CloudWatch
4. **Contrôler la création** du dossier `analyse/` dans S3
5. **Valider le format** de nommage horodaté
6. **Déployer l'application sur EC2** en production
7. **Refaire les memes manipulations mais via l'URL public de l'instance EC2** pour vérifier que ça marche en production

## 👥 Auteur

- **Amine MOUHOUN, AWS Cloud Captain @ EFREI**

## 📢 Support & Questions

Pour toute question ou problème ➡️ [Rejoins-nous sur Discord](https://discord.gg/METtWWV2DC)
