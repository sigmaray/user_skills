# Реализация тестового задания

Сначала реализовал логику в модели. Затем повторно реализовал логику в interaction (service). Логику из модели можно удалять, чтобы сделать модель тонкой.

# Тесты модели
```
spec/models/user_spec.rb
```

# Тесты для interaction (service)
```
spec/interactions/users/create_spec.rb
```

# Как запустить тесты с помощью docker-compose
```
docker-compose run --rm web bundle exec rspec
```

# Как запустить проект с помощью docker-compose
```
docker-compose run --rm web bundle exec bash
# ...
rails db:migrate
rails console
# ...
user_creation_params = {
  name: "Bill",
  patronymic: "James",
  email: "Billhimself@yahoo.com",
  age: 74,
  nationality: "american",
  country: "US",
  gender: "male",
  surname: "Murray",
  skill_names: "acting, comedy",
  interest_names: "golf, baseball, music"
}
Users::Create.run(user_creation_params)
```
