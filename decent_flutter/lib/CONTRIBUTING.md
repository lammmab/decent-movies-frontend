# Good luck lol

## The structure:

  lib/
  ├── main.dart                        ← central overlay manager + search/settings bar
  ├── pages/
  │   ├── connect.dart                 ← backend selector
  │   ├── player.dart                  ← plays videos from plugin
  │   ├── results.dart                 ← search results (uses title widgets)
  │   ├── settingspage.dart           ← global settings / logout
  │   └── titlepage.dart              ← full info for a selected title (episodes, seasons, etc.)
  ├── widgets/
  │   ├── option.dart                 ← reusable UI: input, checkbox, dropdown, etc.
  │   ├── search.dart                 ← styled search bar widget
  │   ├── settings.dart               ← white cogwheel icon button
  │   └── title.dart                  ← mini title widget for showing selectable titles in results

## To work on:

* settings page
