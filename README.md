# laravel-oauth2-provider-example
https://readouble.com/laravel/5.5/en/passport.html

## Requirements
- Docker
- npm

## Steps
### 1. Create project (It has already been done)
    make create-project
### 2. Run database container
    make db-up
### 3. Migrate
    make ARG="migrate" artisan
### 4. Install passport
    make ARG="passport:install" artisan
### 5. Setup front-end
    npm i
    npm run dev
### 6. Deploy passport
    make ARG="passport:keys" artisan
    
