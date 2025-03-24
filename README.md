# Solguruz CLI for Flutter

## Usage

#### Currently supported commands (will be extended in future):

1. Create a new full structured page in flutter project:

```commandline
sg create page sign_in
```

2. Create a new event in existing page in flutter project:

```commandline
sg create event submit_form in sign_in
```

## Requirements

- Flutter SDK Version >= 3.5.0
- Structure like this:

```structure
lib
│
├── app_routes
│       ├── routes.dart
│       └── route_names.dart
│
├── pages
│   └── sign_in
│          ├── bloc
│          │     ├── sign_in_bloc.dart
│          │     ├── sign_in_event.dart
│          │     └── sign_in_state.dart
│          └── view
│                ├── sign_in_page.dart
│                └── components
│
├── logger
│       └── app_logging.dart
├── utils
│       └── analytics_helper.dart
├── analytics
│       └── main_event.dart
│
└── pubspec.yaml
```

## 🚀 About Us

Engineering Quality Solutions by employing technologies with Passion and Love | Web and Mobile App
Development Company in India and Canada.

## 🔗 Links

<div align="left">

<a href="https://solguruz.com/" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/solguruz.svg" alt="Solguruz" style="margin-bottom: 5px;" />
</a>

<a href="https://www.facebook.com/SolGuruzHQ" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/facebook.svg" alt="Solguruz on Facebook" style="margin-bottom: 5px;" />
</a>

<a href="https://www.linkedin.com/company/solguruz/" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/linkedin.svg" alt="Solguruz on Linkedin" style="margin-bottom: 5px;" />
</a>

<a href="https://www.instagram.com/solguruz/" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/instagram.svg" alt="Solguruz on Instagram" style="margin-bottom: 5px;" />
</a>

<a href="https://twitter.com/SolGuruz" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/twitter.svg" alt="Solguruz on Twitter" style="margin-bottom: 5px;" />
</a>

<a href="https://www.behance.net/solguruz" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/behance.svg" alt="Solguruz on Behance" style="margin-bottom: 5px;" />
</a>

<a href="https://dribbble.com/SolGuruz" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/dribbble.svg" alt="Solguruz on Dribble" style="margin-bottom: 5px;" />
</a>

<a href="https://solguruz.com/hire-flutter-developers/" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/hire_flutter_developer.svg" alt="Hire Flutter Developers" style="margin-bottom: 5px;" />
</a>

<a href="https://solguruz.com/services/flutter-app-development" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/explore_our_flutter_service.svg" alt="Flutter App Development" style="margin-bottom: 5px;" />
</a>

</div>

## License

```text
MIT License

Copyright (c) 2025 SolGuruz LLP

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```