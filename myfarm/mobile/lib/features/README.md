# Features

Business features are implemented here, one subdirectory per feature:

```
features/
  authentication/   (Phase 02+)
  dashboard/        (Phase 02+)
  livestock/        (Phase 02+)
  financial/        (Phase 02+)
  inventory/        (Phase 02+)
  collaboration/    (Phase 02+)
  settings/         (Phase 02+)
```

Each feature follows Clean Architecture with feature-first layout:

```
features/<feature>/
  data/
    datasources/
    models/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    providers/
    screens/
    widgets/
```

Add route entries to `mobile/lib/app/app_routes.dart` as each feature is implemented.
