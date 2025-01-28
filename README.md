# Lab - Infrastruktura dla aplikacji multitier

## Wymagania

Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp

### Cel

Przykładowa infrastruktura dla aplikacji multitier z wykorzystaniem Azure App Service, Azure SQL Database, Azure Private Endpoint, Azure Load Balancer.

Czas trwania: 30 minut

### Krok 1 - Sklonuj repozytorium w Cloud Shell

Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

> Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```bash
git clone https://github.com/wguzik/basicmultitier.git

cd basicmultitier/infra
```

> Poniższe kroki realizuje się za pomocą Cloud Shell.

### Krok 1 - Zainicjalizuj Terraform

- skopiuj plik `terraform.tfvars.example` do `terraform.tfvars` i wypełnij odpowiednimi wartościami

  ```bash
  cp terraform.tfvars.example terraform.tfvars

  code terraform.tfvars
  ```

- zainicjalizuj Terraform
  ```bash
  terraform init
  ```

### Krok 2 - Upewnij się, że kod jest poprawny

```bash
terraform fmt
terraform validate
terraform plan
```

### Krok 3 - Dodawaj po kolei zasoby

### Krok -1 - Usuń zasoby

```bash
terraform destroy
```

lub 

```bash
az group delete --name $RESOURCE_GROUP --yes --no-wait
```