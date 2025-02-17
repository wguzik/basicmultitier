# Lab - Prosta aplikacja microservice'owa

## Cel

Spojrzenie na model mikroserwisowy, metody uruchomienia aplikacji w kontenerach.

Czas trwania: 90 minut

## Wymagania

Aktywna subskrypcja w Azure i dostęp do portalu.

Zainstalowane:

- Azure CLI
- Docker
- Docker Compose
- Git

Możesz stworzyć maszynę wirtualną jak w ćwiczeniu: [Basictodo](https://github.com/wguzik/basic/tree/main/basictodo#instalacja-na-maszynie-wirtualnej-linux) i pracować na niej.

## Kroki

### Krok 1 - Sklonuj repozytorium

Upewnij się, że jesteś w katalogu domowym:

```bash
cd ~
```

```bash
git clone https://github.com/wguzik/basicmultitier.git
```

```bash
cd basicmultitier
```

### Krok 2 - Walidacja aplikacji lokalnie

- zbuduj i uruchom backend

```bash
cd backend
```

```bash
cp .env.example .env
```

```bash
docker build -t backend-app:latest .
```

```bash
docker run -d -p 3001:3001 --name backend-app backend-app:latest
```

Sprawdź logi aplikacji backend:

```bash
docker ps -a
docker logs <id>
```

Skąd wziąć brakującą zmienną?

```bash
# nie uruchamiaj tego teraz, ale tak :)
docker run -d -p 3001:3001 --name backend-app -e APPSETTING_DATABASE_URL="dburl" backend-app:latest
```

- zbuduj i uruchom frontend

```bash
cd ../frontend
```

```bash
docker build -t frontend-app:latest .
```

```bash
docker run -d -p 3000:3000 --name frontend-app frontend-app:latest
```

Sprawdź działanie aplikacji pod adresem http://localhost:3000.

```bash
curl http://localhost:3000
``` 

Dlateczego aplikacja frontend nie działa?

### Wariant maszyny linuksowej

> Jeżeli realizujesz to ćwiczenie na maszynie na której dział(o) ToDo, musisz najpierw zamknąć oryginalną aplikację.

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

```zainstaluj plugin compose
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
```

```bash
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
```

Sprawdź czy działa:

```
docker compose version
```

Uruchom aplikację: 

```bash
cd ~/basicmultitier
```

```bash
docker compose up --build
```
Ctrl+C aby wyjśc.

Aplikacja będzie dostępna pod adresem http://localhost:3000 jeżeli pracujesz lokalnie lub pod adresem <publiczne IP>.

Przenalizuj plik `docker-compose.yml`.

- udostępnij backend

```bash
sudo nano /etc/nginx/sites-available/basictodo
```

Dopisz w obiekcie `server` aby udostępnić usługę backend:

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

Zaktualizuj zmienną środowiskową w `docker-compose.yml` żeby wskazać adres publiczny adres IP:

```bash
- REACT_APP_API_URL=http://<PublicznyAdres>
```

```bash
sudo systemctl restart nginx
```

Uruchom aplikację:

```bash
docker compose up -d
```

Otwórz w przeglądarce adres IP maszyny linuksowej.

### Krok 4 - Wgranie obrazów do Azure Container Registry

Stwórz repozytorium w [Basic ACR](https://github.com/wguzik/basic/blob/main/basicacr), pod warunkiem, że nie tworzyłeś/aś wcześniej.

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
```

"Zaloguj się" do klastra:

```bash
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
echo $ACR_NAME
find deployments-k8s -type f -exec sed -i 's/acr/<nazwaAcr>/g' {} \;
```

kubectl apply -f deployments-k8s/namespace.yaml
```bash
kubectl apply -f deployments-k8s/namespace.yaml
kubectl apply -f deployments-k8s/backend-secrets.yaml
kubectl apply -f deployments-k8s/backend-configmap.yaml
kubectl apply -f deployments-k8s/frontend-configmap.yaml
kubectl apply -f deployments-k8s/postgres-deployment.yaml
kubectl apply -f deployments-k8s/backend-deployment.yaml
```

```bash
kubectl -n todo-app get pods

kubectl -n todo-app logs <backend-pod-id>
```

Zamień w pliku `backend-deployment.yaml`:
```yaml
        env:
        - name: APPSETTING_DATABASE_URL 
```

Zapisz i wdróż zmiany: 

```bash
kubectl apply -f deployments-k8s/backend-deployment.yaml
```

Wdróż frontend:

```bash
kubectl apply -f deployments-k8s/frontend-deployment.yaml
```

Wdróż prosty pod z curlem jeżeli chcesz zweryfikować kilka rzeczy "wewnątrz" klastra:

```
kubectl run -i --tty --rm network-debug --image=wbitt/network-multitool --restart=Never -- bash
```

### Krok 7 - Skonfiguruj Ingress

Wdróż ingresy:

```bash
kubectl apply -f deployments-k8s/backend-ingress.yaml
kubectl apply -f deployments-k8s/frontend-ingress.yaml
```

Podejrzyj podstawowe informacje o ingresach:

```bash
kubectl -n todo-app get ingress
```

Odwiedź adres IP w przeglądarce.

Sprawdź adres `/api/todos`.

### Krok 8 - Popraw konfigurację frontendu

Zaktualizuj konfigurację frontend tak, aby wskazywała na adres IP ingresu:

```bash
sed -i 's/localhost:3001/<adresip>/' deployments-k8s/frontend-configmap.yaml
# sed -i 's/localhost:3001/4.157.146.208/' deployments-k8s/frontend-configmap.yaml
```

Zaktualizuj config mapę:

```bash
kubectl apply -f deployments-k8s/frontend-configmap.yaml
```

Podejrzyj zawartość config mapy po wdrożeniu:

```bash
kubectl -n todo-app get configmap frontend-config -o yaml 
```

lub

```bash
kubectl -n todo-app describe configmap frontend-config
```

Żeby zmiana była efektywna, musisz zrestartować aplikację frontend:

```bash
kubectl delete pod <frontend-pod-id>
```

lub dużo bardziej elegancko:

```bash
kubectl --namespace todo-app rollout restart deployment frontend
```

alternatywnie:

```bash
kubectl -n todo-app scale deployment frontend --replicas=0
kubectl -n todo-app scale deployment frontend --replicas=1
```

### Krok 9 - Sprawdź ile zmieści się podów

```bash
kubectl get pods -A -o wide
```

```bash
kubectl -n todo-app scale deployment frontend --replicas=10
```

```bash
kubectl -n todo-app scale deployment frontend --replicas=100
```

### Krok 10 - Wymuś limit zasobów

Zeskaluj frontend do jednego podu:

```bash
kubectl -n todo-app scale deployment frontend --replicas=1
```

W `nano deployments-k8s/frontend-deployment.yaml` zmień limit zasobów odkomentowując linijki:

```yaml
        #resources:
        #  limits:
        #    cpu: "500m"
        #    memory: "512Mi"
        #  requests:
        #    cpu: "200m"
        #    memory: "256Mi"
```

```bash
kubectl -n todo-app apply -f deployments-k8s/frontend-deployment.yaml
```

```bash
kubectl -n todo-app scale deployment frontend --replicas=10
```

Ile podów zmieściło się w klastrze?

```bash
kubectl -n todo-app get pods
```

Sprawdź jakie zasoby są używane przez pody:

```bash
kubectl -n todo-app top pod
```

## Krok -1 - Usuń zasoby

Pamiętaj o usunięciu zasobów po skończonych zajęciach.

