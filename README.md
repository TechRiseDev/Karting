# 🏎️ System Karting en complet FiveM

`Ce script est entièrement modifiable et adaptable le selon vos besoins.`

Système complet de **Karting** pour FiveM permettant aux joueurs de louer un kart, participer à une session et rouler sur un circuit configuré.

Idéal pour :

- 🎮 Activités RP
- 💰 Business karting
- 🏁 Événements / courses
- 🎉 Animation serveur
- 🗺️​ Mapping integrer

---

## 🚀 Fonctionnalités

- ✅ Location de kart
- ✅ Spawn automatique du véhicule
- ✅ Téléportation sur la piste
- ✅ Zone de départ configurable
- ✅ Système de session
- ✅ Suppression automatique du véhicule à la fin
- ✅ Protection anti-vol du kart
- ✅ Compatible ESX / QBCore / Standalone
- ✅ Optimisé et léger

---

## 🎯 Fonctionnement

1. Le joueur se rend à la zone Karting
2. Il interagit le ped pour louer un kart
3. Le véhicule spawn automatiquement
4. Il peut rouler librement sur le circuit
5. À la fin :
  - Le kart est supprimé

---

 📦 Dépendances

- 🔹 **ox_lib**  
  👉 https://github.com/overextended/ox_lib  

- 🔹 **ox_target**  
  👉 https://github.com/overextended/ox_target

- 🔹 **ESX**  
  👉 https://github.com/mitlight/es_extended

- 🔹 FXServer (FiveM)

⚠️ Assurez-vous que `ox_lib` et `ox_target` et `es_extended` sont installés et démarrés avant le dossier.

---

## ⚙️ Compatibilité Framework

- ✔️ cerulean
- ✔️ Standalone  
- ✔️ Serveur RP  
- ✔️ ESX  
- ✔️ OneSync
- ✔️ ox_lib
- ✔️ ox_target

---

## 📍 Configuration du weboock notification

Ajouter votre weboock configurables dans le dossier karting coter :

```serveur.lua
local WEBHOOK_URL = "#Lien du webhooks#" <--Remplacer (#Lien du webhooks#) part votre Lien
```

---

## 📥 Installation

### 1️⃣ Télécharger le dossier

Placez le dossier dans votre `resources/`

---

### 2️⃣ Ajouter au server.cfg

Ajoutez les lignes suivantes dans votre `server.cfg` :

```cfg
ensure ox_lib
ensure ox_target
ensure [Karting]
```
