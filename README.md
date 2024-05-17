# js_code_test

Document scanner with cards, paper and any photos. It can upload with name to firestore and can see detections list.

## Getting Started

#### 1. Clone and Install

```bash
# Clone the repo
git clone https://github.com/zwe-mun-htun/js_code_test.git

# Navigate to clonned folder and Install dependencies
cd js_code_test && flutter packages get

#### 2. Run
```bash

# For Web
flutter run -d chrome

## Flutter Version
Flutter 3.19.2 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 7482962148 (7 weeks ago) • 2024-02-27 16:51:22 -0500
Engine • revision 04817c99c9
Tools • Dart 3.3.0 • DevTools 2.31.1


## Directory Structure
```
📂web
📂lib
 │───main.dart  
 └───📂src
     └────📂core
     |    │────📂utils
     └────📂data
     |    │────📂models
     └────📂domain
     |    │────📂repositories
     └────📂presentations
     |    │────📂cubit
     |    │────📂values
     |    │────📂views
     |    └────📂widgets
