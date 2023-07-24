# Запуск контейнера с postfix в ОС ALSE 1.7
## Подготовка

```bash
cp env-sample .env
```
Заполнить данные в файле `.env`

```bash
nano env-sample .env
```

При необходимости изменить файлы конфигурации в src/templates

## Сборка образа

```bash
docker build -t <image_tag> .
```

## Запуск контейнера

Для запуска контейнера необходимо передать переменные окружени.
Вольюмы прокидывать по собственному усмотрению

```bash
docker run --env-file .env --rm -it -p 25:25 <image_tag>
```