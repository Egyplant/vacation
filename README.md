# Общий план поездки

Статический сайт для GitHub Pages с общей синхронизацией через Supabase. Если облако недоступно, изменения продолжают сохраняться локально в браузере.

## 1. Создать Supabase

1. Создайте бесплатный проект на https://supabase.com/.
2. Откройте **SQL Editor**, вставьте содержимое `supabase-setup.sql`.
3. В конце файла замените `YOUR_EMAIL@example.com` и `GIRLFRIEND_EMAIL@example.com` на ваши email.
4. Запустите запрос.
5. Откройте **Authentication → URL Configuration**. После публикации добавьте адрес GitHub Pages в **Site URL** и **Redirect URLs**.
6. В **Project Settings → API Keys** скопируйте Project URL и **Publishable key**. Не используйте Secret или `service_role` key.

## 2. Заполнить конфигурацию

Откройте `config.js` и замените:

- `https://YOUR_PROJECT.supabase.co` на Project URL;
- `YOUR_PUBLISHABLE_KEY` на Publishable key.

Publishable key разрешено хранить в публичном сайте. Доступ к данным ограничен правилами RLS и списком email из SQL-файла.

## 3. Опубликовать на GitHub Pages

Загрузите в корень репозитория эти файлы:

- `index.html`
- `europe-trip-plan.html`
- `config.js`

В GitHub откройте **Settings → Pages → Build and deployment**:

- Source: **Deploy from a branch**
- Branch: **main**
- Folder: **/(root)**

После публикации откройте выданный адрес. Каждый участник вводит свой разрешённый email и переходит по одноразовой ссылке из письма.

## Как обновлять

Меняйте файлы локально и выполняйте обычный `git push`. GitHub Pages обновит сайт. Данные чеклиста находятся в Supabase и при обновлении HTML не пропадут.

## Безопасность

Не публикуйте паспортные данные, полные номера документов, банковские данные и секретные ключи. В `config.js` допустим только Publishable key. Доступ к общему состоянию имеют только email, добавленные в `trip_members`.
