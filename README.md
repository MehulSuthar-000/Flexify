# 🎬 Flexify

Flexify is a Flutter-based mobile application that lets users browse movies, view trailers, and explore trending content — a YouTube-style app, but focused entirely on movies. It uses the [TMDB API](https://www.themoviedb.org/documentation/api) for movie data and integrates YouTube trailers seamlessly.

---

## 📱 Features

- 🔍 Browse popular and trending movies
- 🎞️ Watch trailers fetched directly via TMDB → YouTube
- 🖼️ Rich movie posters and artwork with `cached_network_image`
- 🎠 Carousel sliders for UI presentation
- 🎬 Embedded video playback via `chewie` and `video_player`
- 🎨 Modern UI with `Google Fonts` and Lottie animations
- 🔒 Trusted certificates support for API calls

---

## 🧰 Built With

| Package                | Purpose                                 |
|------------------------|------------------------------------------|
| `cached_network_image` | Caching movie images                    |
| `carousel_slider`      | Sliding banners for featured content    |
| `lottie`               | Animated splash screen and effects      |
| `chewie`, `video_player` | Embedded video trailer playback       |
| `youtube_explode_dart` | Extracting YouTube trailers via TMDB   |
| `google_fonts`         | Stylish, readable typography            |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.2.2)
- Android Studio / VS Code / Xcode (for iOS)
- TMDB API key (sign up at [themoviedb.org](https://www.themoviedb.org/))

### Clone the Repo

```bash
git clone https://github.com/yourusername/flexify.git
cd flexify
