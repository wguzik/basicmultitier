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
docker tag basicmultitier-frontend $ACR_NAME.azurecr.io/frontend:latest
docker tag basicmultitier-backend $ACR_NAME.azurecr.io/backend:latest

# Wypchnij obrazy do rejestru
docker push $ACR_NAME.azurecr.io/frontend:latest
docker push $ACR_NAME.azurecr.io/backend:latest
```

### Krok 5 - Utworzenie Container Apps

```bash
PROJECT=myProject # zmień tutaj na swój projekt, np. mrt-wg
ENVIRONMENT=dev
RANDOM_STRING=$(openssl rand -hex 4) # kawałek losowości
RESOURCE_GROUP_NAME=rg-${PROJECT}-${ENVIRONMENT}-${RANDOM_STRING}
CONTAINERAPP_NAME=ca-${PROJECT}-${ENVIRONMENT}-${RANDOM_STRING}
LOCATION=northeurope

ACR_NAME="myACR" # zmień tutaj na swoje repozytorium

# Utwórz grupę zasobów
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Utwórz środowisko Container Apps
az containerapp env create \
  --name $CONTAINERAPP_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --location $LOCATION

# Pobierz dane logowania do ACR
ACR_USERNAME=$(az acr credential show -n $ACR_NAME --query username -o tsv)
ACR_PASSWORD=$(az acr credential show -n $ACR_NAME --query "passwords[0].value" -o tsv)

# Utwórz aplikację przy użyciu Docker Compose
# Możesz tutaj nadać uprawnienia ACR do pobierania obrazów, ale celowo wykorzystujemy inną metodę.

az containerapp compose create \
  --name $CONTAINERAPP_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --environment $CONTAINERAPP_NAME \
  --registry-server "$ACR_NAME.azurecr.io" \
  --registry-username $ACR_USERNAME \
  --registry-password $ACR_PASSWORD \
  --file docker-compose.yml

echo "Aplikacja jest dostępna pod adresem:"
az containerapp show -n $CONTAINERAPP_NAME-frontend -g $RESOURCE_GROUP_NAME --query properties.configuration.ingress.fqdn -o tsv
```

## Sprzątanie

Usuń Container App i grupę zasobów:

```bash
az group delete --name $RESOURCE_GROUP_NAME --yes --no-wait
```

Pamiętaj o ACR w innym miejscu!
