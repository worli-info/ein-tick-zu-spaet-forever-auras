local _,A=...
A.L=GetLocale()=="deDE" and {
    title="EinTickZuSpaet Forever Auras",enabled="Anordnung aktiv",
    vertical="Senkrechte Spalten",buffX="Buffs: Abstand rechts",buffY="Buffs: Abstand oben",
    debuffX="Debuffs: Abstand rechts",debuffY="Debuffs: Abstand oben",
    scale="Skalierung (0.5–2)",stride="Symbole pro Spalte/Zeile (1–40)",gap="Symbolabstand (0–32)",
    apply="Übernehmen",reset="Standardwerte",close="Schließen",open="Einstellungen öffnen",
    description="Originale Blizzard-Anzeigen; Timer, Tooltips und Rechtsklick bleiben erhalten.\nDie Einstellungen gelten für alle Charaktere. Abstände in UI-Pixeln.",
    invalid="Ungültige Eingabe: %s",combat="Bitte außerhalb des Kampfes einstellen.",
    applied="Buff-Anordnung übernommen.",missing="Blizzards Buff-Anzeigen sind noch nicht verfügbar.",
} or {
    title="EinTickZuSpaet Forever Auras",enabled="Enable positioning",
    vertical="Vertical columns",buffX="Buffs: right margin",buffY="Buffs: top margin",
    debuffX="Debuffs: right margin",debuffY="Debuffs: top margin",
    scale="Scale (0.5–2)",stride="Icons per column/row (1–40)",gap="Icon spacing (0–32)",
    apply="Apply",reset="Defaults",close="Close",open="Open settings",
    description="Native Blizzard displays; timers, tooltips and right-click remain intact.\nSettings are account-wide. Margins use UI pixels.",
    invalid="Invalid input: %s",combat="Please configure outside combat.",
    applied="Aura layout applied.",missing="Blizzard's aura frames are not available yet.",
}
