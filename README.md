# App_recipes

ใบงานที่ 8 : ดึงตำรับอาหารจาก API

# flutter_recipes

A Flutter application that displays a list of recipes from API with a lovely pink-themed UI.

แอปพลิเคชั่น Flutter สำหรับแสดงรายการเมนูอาหารจาก API ด้วย UI สีชมพูน่ารัก

## ✨ ฟีเจอร์หลัก

- แสดงรายการเมนูอาหารจาก DummyJSON API
- UI สีชมพูสวยงาม พร้อมไอคอนหัวใจ
- รองรับการแสดงรูปภาพเมนูอาหาร
- มีการจัดการ Error และ Loading State
- รองรับภาษาไทย

## 🏗️ โครงสร้าง Classes

### 1. `MyApp`
- StatelessWidget หลักของแอป
- กำหนด Theme สีชมพู และการตั้งค่าพื้นฐาน

### 2. `Recipe`
- Model class สำหรับข้อมูลเมนูอาหาร
- Properties: `id`, `name`, `image`
- มี factory constructor `fromJson()` สำหรับแปลงจาก JSON

### 3. `RecipesService`
- Service class สำหรับเรียก API
- เมธอด `fetchRecipes()` ดึงข้อมูลจาก https://dummyjson.com/recipes

### 4. `RecipesScreen`
- StatefulWidget หน้าจอหลัก
- แสดงรายการเมนูอาหารใน ListView
- จัดการ FutureBuilder สำหรับ async data

## 🔌 การดึงข้อมูลจาก API

```dart
// API Endpoint
https://dummyjson.com/recipes

// Response Structure
{
  "recipes": [
    {
      "id": 1,
      "name": "ชื่อเมนู",
      "image": "URL รูปภาพ"
    }
  ]
}
```

### ขั้นตอนการดึงข้อมูล:
1. ใช้ `http.get()` เรียก API
2. ตรวจสอบ status code 200
3. แปลง JSON response ด้วย `json.decode()`
4. แปลงเป็น List<Recipe> ด้วย `Recipe.fromJson()`

## 🎨 UI Features

- **สีหลัก**: โทนสีชมพู (#FFB6C1, #D72660, #B23A48)
- **Layout**: Card-based design with rounded corners
- **รูปภาพ**: Network images พร้อม fallback icon
- **Loading**: CircularProgressIndicator สีชมพู
- **Error**: แสดงข้อความภาษาไทยพร้อมไอคอน

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.0.0  # for API calls
```

To add these dependencies to your project, run:
```bash
flutter pub add http
```

## Getting Started

This project is a Flutter application that fetches and displays recipes from the DummyJSON API.

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio / VS Code
- Internet connection for API calls

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd flutter_recipes
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the application
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart              # Main application entry point
├── models/
│   └── recipe.dart       # Recipe model (included in main.dart)
├── services/
│   └── recipes_service.dart  # API service (included in main.dart)
└── screens/
    └── recipes_screen.dart   # Main recipes screen (included in main.dart)
```

*Note: In this project, all classes are defined in a single `main.dart` file for simplicity.*