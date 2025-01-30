# Lab - Prosta aplikacja microservice'owa

## Cel

Spojrzenie na model mikroserwisowy, metody uruchomienia aplikacji w kontenerach.

Czas trwania: 30 minut

## Wymagania

Aktywna subskrypcja w Azure i dostęp do portalu.

Zainstalowane:

- Azure CLI
- Docker
- Docker Compose
- Git

## Kroki

### Krok 1 - Sklonuj repozytorium

```bash
git clone https://github.com/wguzik/basicmultitier.git
```

```bash
cd basicmultitier
```

### Krok 2 - Walidacja aplikacji lokalnie

- zbuduj i uruchom backend

```bash
# Budowanie i uruchomienie backendu
cd backend
cp .env.example .env
docker build -t backend-app:latest .
docker run -d -p 3001:3001 --name backend-app backend-app:latest
```

- zbuduj i uruchom frontend

```bash
# W nowym terminalu - budowanie i uruchomienie frontendu
cd ../frontend
docker build -t frontend-app:latest .
docker run -d -p 3000:3000 --name frontend-app frontend-app:latest
```

Sprawdź działanie aplikacji pod adresem http://localhost:3000.

```bash
curl http://localhost:3000
``` 

Dlateczego aplikacja frontend nie działa?

### Wariant maszyny linuksowej
 Jeżeli realizujesz tu ćwiczenie ToDo, musiz najpierw zamknąć oryginalną aplikację.

```bash
pm2 list
pm2 stop <ID> #0?
```

Zmodyfikuj ustawienie Nginx:

```bash
sudo nano /etc/nginx/sites-available/basictodo
```

zmodyfikuj linijkę:

```bash
proxy_pass http://localhost:3000;
```

```bash
sudo systemctl restart nginx
```

W przeglądarce wpisz adres IP maszyny linuksowej.

### Krok 3 - Uruchomienie przez Docker Compose

```bash
# wyczyść instancje
docker ps
docker stop <ID>
docker rm <ID>
```

```bash
cd ~/basicmultitier
docker-compose up --build

# sudo apt install docker-compose, potwierdź instalację
```

Aplikacja będzie dostępna pod adresem http://localhost:3000

Przenalizuj plik docker-compose.yml.

### Wariant maszyny linuksowej

Zmodyfikuj ustawienie Nginx:

```bash
sudo nano /etc/nginx/sites-available/basictodo
```

Dopisz:

```bash
    location /api/todos {
        proxy_pass http://localhost:3001/api/todos;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
```

```bash
sudo systemctl restart nginx
```

Otwórz w przeglądarce adres IP maszyny linuksowej.


### Krok 4 - Wgranie obrazów do Azure Container Registry

Stwórz repozytorium w [Basic ACR](https://github.com/wguzik/basic/blob/main/basictodo/basicacr).

> Wykonaj ćwiczenie z katalogu basicacr za pomocą Cloud Shell lub na swoim komputerze. Możesz na maszynie wirtualnej, aczkolwiek musisz doinstalować Terraform i Azure CLI.

```bash
# Zaloguj się do Azure
az login

ACR_NAME="myACR" # zmień tutaj na swoje repozytorium

# Zaloguj się do rejestru
az acr login --name $ACR_NAME

# Oznacz obrazy
docker tag basicmultitier_frontend $ACR_NAME.azurecr.io/frontend:latest
docker tag basicmultitier_backend $ACR_NAME.azurecr.io/backend:latest

# Wypchnij obrazy do rejestru
docker push $ACR_NAME.azurecr.io/frontend:latest
docker push $ACR_NAME.azurecr.io/backend:latest
```

### Krok 5 - Skonfiguruj Kubernetes

Zainstaluj narzędzie do zarządzania Kubernetes:

```bash
sudo snap install kubectl --classic
```

Stwórz nowy klaster AKS w Azure:

```bash
RG_NAME="mrt-multitier"
AKS_NAME="mrtAks"
LOCATION="eastus"

az group create --name $RG_NAME --location $LOCATION
az aks create --resource-group $RG_NAME --name $AKS_NAME --location $LOCATION --enable-app-routing --generate-ssh-keys --node-count 2

az aks get-credentials --resource-group $RG_NAME --name $AKS_NAME
```

Podłącz repozytorium ACR do klastra AKS:

```bash
az aks update --name $AKS_NAME --resource-group $RG_NAME --attach-acr $ACR_NAME
```

Dokumentacja: [Integracja klastra AKS z repozytorium ACR](https://learn.microsoft.com/en-us/azure/aks/cluster-container-registry-integration)

### Krok 6 - Utwórz zasoby w Kubernetes


Zaktualizuj odniesienia do obrazów w plikach YAML.
```bash
find deployments-k8s -type f -exec sed -i 's/<nazwaAcr>/acr/g' {} \;
```

kubectl apply -f deployments-k8s/namespace.yaml
```bash
kubectl apply -f deployments-k8s/namespace.yaml
kubectl apply -f deployments-k8s/backend-secrets.yaml
kubectl apply -f deployments-k8s/backend-configmap.yaml
kubectl apply -f deployments-k8s/frontend-configmap.yaml
kubectl apply -f deployments-k8s/postgres-deployment.yaml
kubectl apply -f deployments-k8s/backend-deployment.yaml
kubectl apply -f deployments-k8s/frontend-deployment.yaml
```

### Krok 7 - Pobierz adres IP serwera

```bash
kubectl get svc
```

### Krok 8 - Skonfiguruj Ingress

```bash
kubectl apply -f ingress.yaml
```

