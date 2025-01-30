# Dokumentacja API Todo

Ten dokument zawiera przykłady interakcji z API Todo przy użyciu poleceń cURL.

## Zrozumienie metod REST API

REST API zazwyczaj wykorzystuje następujące metody HTTP:
- `GET` - Pobieranie danych
- `POST` - Tworzenie nowych danych
- `PUT` - Aktualizacja całego zasobu
- `PATCH` - Częściowa aktualizacja
- `DELETE` - Usuwanie danych

## Uwierzytelnianie

Większość publicznych API wymaga uwierzytelnienia. Popularne metody to:

### Token Bearer
```bash
curl -X GET http://localhost:3000/todos \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."
```

### Klucz API
```bash
curl -X GET http://localhost:3000/todos \
  -H "X-API-Key: twój-klucz-api"
```

### Basic Auth
```bash
curl -X GET http://localhost:3000/todos \
  -u "użytkownik:hasło"
```

## Podstawowa składnia cURL

Popularne opcje:
- `-X` lub `--request`: Określa metodę HTTP
- `-H` lub `--header`: Dodaje nagłówki
- `-d` lub `--data`: Wysyła dane
- `-i`: Dołącza nagłówki odpowiedzi

## Przykładowe zapytania

### Pobierz wszystkie zadania

```bash
curl -X GET http://localhost:3001/api/todos
```

### Pobierz zadania w stanie "DONE"

```bash
curl -X GET "http://localhost:3001/api/todos?state=DONE"
```

### Utwórz nowe zadanie

```bash
curl -X POST http://localhost:3001/api/todos \
-H "Content-Type: application/json" \
-d '{
"title": "Nauczyć się REST API",
"description": "Przestudiować metody HTTP i poćwiczyć z cURL"
}'
```

### Usuń zadanie

```bash
curl -X DELETE http://localhost:3001/api/todos/{id}
```

### Pobierz pojedyncze zadanie

```bash
curl -X GET http://localhost:3001/api/todos/{id}
``` 

### Przesuń zadanie do kategorii "IN_PROGRESS" i zaktualizuj treść

```bash
curl -X PUT http://localhost:3001/api/todos/{id} \
-H "Content-Type: application/json" \
-d '{
"title": "Nauczyć się REST API",
"description": "Nadal ćwiczyć cURL",
"state": "IN_PROGRESS"
}'
```

### Przesuń zadanie do kategorii "DONE"

```bash
curl -X PATCH http://localhost:3001/api/todos/{id} \
-H "Content-Type: application/json" \
-d '{
"state": "DONE"
}'
```

## Wskazówki
- Zawsze dodawaj nagłówek `Content-Type: application/json` podczas wysyłania danych JSON
- Używaj cudzysłowów wokół URL-i z parametrami zapytania
- W Windows CMD używaj podwójnych cudzysłowów zamiast pojedynczych
- Użyj flagi `-i` aby zobaczyć nagłówki odpowiedzi
- Przechowuj tokeny i klucze API w bezpiecznym miejscu
- Nigdy nie commituj tokenów do repozytorium kodu
- W środowisku produkcyjnym zawsze używaj HTTPS

