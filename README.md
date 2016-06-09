# JtlDbWrapper
JTL DB Wrapper Scripts<br/>
<br/>
#**************** DISCLAIMER ****************

Vorweg:
Bitte bis zum Ende lesen, um alle wichtigen Infos zu haben und notwendige
Anpassungen vorzunehmen.

Das hier richtet sich nicht an den Otto Normal Verbraucher. Man braucht schon
einiges an Know How und Verständnis, was hier passiert, wenn man es erweitern
möchte. Da es hier aber auch einige fähige Service Partner und Freelancer gibt,
wird es sicherlich einige User geben, die damit was anfangen können und ggf.
bei der Realisierung eigener Wünsche behilflich sein werden - mir inkl.

Ich stelle diesen JTL DB Wrapper mal der Allgemeinheit zur Verfügung, um etwas
Feedback dafür zu bekommen. Intern funktioniert das auch wunderbar, aber ich
kann keine Haftung etc. dafür übernehmen. Die Nutzung erfolgt also auf komplett
eigene Gefahr und man muss schon wissen, was man tut - sonst kann man sich sehr
viel kaputt machen, was dann evtl. auch nicht mehr repariert werden kann, nur
via eines **aktuellen** Backups!

Deshalb bitte mit der nötigen Sorgfalt verwenden und ganz ganz wichtig:<br/>
"Think before you type/click/run!"

Support gibt es dafür natürlich keinen!

Einzige Bedingung:
Bitte erfolgreiche Verwendung und Einsatzzweck mitteilen (gerne auch via PN),
um evtl. eine kleine Sammlung aufzubauen und Inspirationen zu erhalten.

#1. Was ist das überhaupt?

An verschiedenen Stellen sollten via Workflows die ein oder anderen Werte
festgelegt werden. Oftmals geht das ja bereits via eines Workflows, aber eben
leider nicht immer. So z. B. ein Standard Wert für das Zahlungsziel für neue
Kunden. Bei Kommentaren sollte noch ein Zeitstempel ergänzt werden usw.

Man kann hiermit jedoch (soweit ich das getestet habe) so ziemlich *alle* Werte
in der Datenbank ändern. Also einfache Werte wie das genannte Zahlungsziel,
aber man kann damit vermutlich auch neue Aufträge anlegen oder Daten löschen.

Da man hier PowerShell nutzen kann und somit Zugriff auf das komplette .Net
Framework hat, kann man sich auch sehr einfach eigene Scripte bauen. Es sind
einem hier quasi keine Grenzen gesetzt - nur das eigene Know How :-)

Ergo: Bitte wirklich mit größter Sorgfalt verwenden und nicht schreien, wenn
man sich damit wichtige Daten zerschossen hat.

Da man hier nach wie vor einen Workflow erstellt, kann man bereits sehr viele
Bedingungen wie gewohnt im Workflow festlegen und nur dann das Script hier
ausführen lassen.

Der große Vorteil aus meiner Sicht:
Man verwendet hier von JTL bereitgestellte Methoden, um auf die DB zuzugreifen
und muss sicht nicht jedes Mal erneut SQL Statements zusammenstricken.

Man kann ein Objekt via Primary Key (meist in JTL InterneXYNummer) laden, den
oder die Werte ändern und die Werte wieder in die DB schreiben lassen oder auch
das Objekt entfernen.

Außerdem hat man eine generelle Basis für alle (?) JTL DB Objekte.

#2. Anwendungs-Beispiele

- Standard Zahlungsziel für Neukunden hinterlegen
- Generell Standardwerte hinterlegen wie einen bestimmten Hersteller
- Kommentare/STATUS/whatever mit Zeitstempel versehen
- Eingaben validieren und ggf. korrigieren oder eine Mail rausschicken
- Werte mit einem Suffix/Präfix versehen
- Man kann damit vermutlich auch die Firma eines Auftrags ändern usw.
- Alles, was man mit .Net + PowerShell machen kann
- Imports ohne Ameise, weil die Ameise das nicht unterstüzt (z. B. Amazon
  Sonderpreise)

Das Script kann man beliebig starten:
- via Workflow bei Neuanlage oder Änderungen etc.
- direkt via PowerShell/Batch Datei/SQL Jobs/Zeitgesteuert usw.

Man kann sich auch Powershell Module daraus bauen usw.

Natürlich kann man das Script den eigenen Bedürfnissen nach anpassen und seiner
Fantasie freien Lauf lassen.

Ich bin sehr gespannt auf Feedback :-)

#3. Verwendung

Der JTL DB Wrapper besteht meist aus folgenden Teilen:
- einem Workflow mit beliebigen Bedingungen und der Aktion "Ausführen"
- dem JtlDbWrapper.ps1 PowerShell Script, z. B. unter C:\Data\Scripts\JtlDbWrapper.ps1

Folgende Werte sind in dem JtlDbWrapper.ps1 Script ggf. zu ändern:
- Zugangsdaten für die DB inkl. sa + Passwort und ggf. auch den gewünschten Mandanten
- der Pfad zu einer JTL DLL, falls die Wawi nicht in das Standardverzeichnis installiert wurde

Workflow Inhalt (Beispiel zum Setzen des Zahlungsziels, ist natürlich anzupassen):

Programm-Pfad (unbedingt 32-bit verwenden, da JTL eine 32-bit Applikation ist!!!):
```
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe
```

Parameter (siehe auch Screenshot):
```dotliquid
{% capture ParamList %}
    {% comment %}
        Untenstehende Variablen bitte anpassen
        
        WICHTIG:
        Sonderzeichen machen höchstwahrscheinlich Probleme, dazu gehören auch einfache und doppelte Anführungszeichen!
    {% endcomment %}
    
    {% assign ObjectName = 'jtlKunde' %}
    {% capture PkValue %}@({{ Vorgang.InterneKundennummer }}){% endcapture %}
    {% assign ColumnName = 'nZahlungsziel' %}
    {% assign NewValue = '10' %}
    
    {% comment %}
        Folgende Werte sind nur zum Testen hier hinterlegt:
        {% assign PkValue = '@(13622)' %}
    {% endcomment %}
    
    -NoProfile -ExecutionPolicy Bypass -Command "& 'C:\Data\Scripts\JtlDbWrapper.ps1' -ObjectName '{{ ObjectName }}' -PkValue {{ PkValue }} -ColumnName '{{ ColumnName }}' -NewValue '{{ NewValue }}'"
{% endcapture -%}
{{ ParamList | Trim }}
```

Sieht etwas viel aus, ist aber im Grunde sehr einfach und sorgt dafür, dass das Script wie folgt aufgerufen wird:

```
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& 'C:\Data\Scripts\JtlDbWrapper.ps1' -ObjectName 'jtlKunde' -PkValue 1234 -ColumnName 'nZahlungsziel' -NewValue '10'"
```

So, nun viel Spaß eim Experimentieren und nicht vergessen, kurze Nachricht mit Einsatzzweck oder auch Idee ins Forum und/oder an mich via PN wäre nett.
