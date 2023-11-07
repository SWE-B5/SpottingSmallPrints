# SpottingSmallPrints

## Documentation

### Wie macht man sein eigenes Branch?
[GitHub Docs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-and-deleting-branches-within-your-repository#creating-a-branch)

### Wie lade ich mein Branch hoch/erstelle ein Pull Request?
[GitHub Docs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)

### Namensbennenung
- Datein werden immer kleingeschrieben
- Eine Szene kommt in den Ordner `scenes\x\y\scene.tscn` und die dazugehörige Script in `scripts\x\y\scene.gd`

### Commitnamensbenennung
Damit man Commits unterscheiden kann, soll man laut folgender Resource seine Commits nennen, damit es einheiterlicher ist

[conventionalcommits.org](https://www.conventionalcommits.org/en/v1.0.0)

### Wo tuhe ich welchen Code hin?
- Konstante Variablen die man einfach tauschen soll, kommen in `store/Constants.gd`
- Spieler Variablen die sich über die Szenen hinweg nicht ändern sollen kommen `store/PlayerVariables.gd`
- Spieler Variablen die sich über die Szene handeln, kommen in `scripts/scenes/SZENE.gd`
