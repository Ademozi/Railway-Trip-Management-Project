# Railway Trip Management – L3 DSS Project
## UMBB – Faculty of Sciences | 2025/2026

---

## Project Structure

```
railway_project/
├── app.py              ← Flask web application (Part 2)
├── trains.xsl          ← XSLT transformation (Part 1)
├── transport.xml       ← Data source (provided)
├── templates/
│   ├── base.html       ← Shared layout + navigation
│   ├── index.html      ← Home page
│   ├── trips.html      ← All trips + filters
│   ├── search.html     ← Search by code (DOM)
│   └── stats.html      ← Statistics (ElementTree)
└── README.md
```

---

## Part 1 – XSLT

Open `transport.xml` in a browser (Chrome/Firefox) → it auto-loads `trains.xsl`
and renders a styled HTML page with all trip details.

Or transform manually:
```bash
xsltproc trains.xsl transport.xml > output.html
```

---

## Part 2 – Flask Application

### Install dependencies
```bash
pip install flask
```

### Run
```bash
python app.py
```
Then open: **http://127.0.0.1:5000**

---

## Features

| Route      | Feature                        | XML API Used   |
|------------|--------------------------------|----------------|
| `/`        | Home / overview                | —              |
| `/trips`   | Browse & filter all trips      | ElementTree    |
| `/search`  | Search trip by code            | DOM (minidom)  |
| `/stats`   | Cheapest/expensive + type count| ElementTree    |

---

## XML APIs Used (as required)

- **DOM (`xml.dom.minidom`)** → `/search` – fetches complete trip info by code
- **ElementTree (`xml.etree.ElementTree`)** → `/trips` + `/stats`
  - Cheapest and most expensive trip per line
  - Number of trips per train type