// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;

// === localStorage (persists across sessions — for admin login) ===
void saveToStorage(String key, String value) {
  html.window.localStorage[key] = value;
}

String? getFromStorage(String key) {
  return html.window.localStorage[key];
}

void removeFromStorage(String key) {
  html.window.localStorage.remove(key);
}

// === sessionStorage (cleared when tab closes — for public room/item views) ===
void saveToSession(String key, String value) {
  html.window.sessionStorage[key] = value;
}

String? getFromSession(String key) {
  return html.window.sessionStorage[key];
}

void removeFromSession(String key) {
  html.window.sessionStorage.remove(key);
}
