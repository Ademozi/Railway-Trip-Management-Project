# 🚆 Railway Trip Management

> L3 – Decision Support Systems (DSS) | UMBB – Faculty of Sciences, CS Department | 2025/2026

A two-part project that manipulates an XML dataset of Algerian train lines, trips, schedules, classes, and prices:

- **Part 1** — XSLT transformation that renders the XML as a clean, styled HTML report.
- **Part 2** — Flask web application for searching, filtering, and analysing trip data.

---

## 📁 Project Structure

```
Railway Trip Management Project/
│
├── Part1-xsl-xml/
│   ├── transport.xml       ← Shared data source (train lines, trips, prices)
│   ├── trains.xsl          ← XSLT stylesheet (XML → HTML)
│   └── style.css           ← CSS styles for the generated HTML page
│
└── part2-python-flask/
    ├── app.py              ← Flask application (routes + XML parsing)
    ├── transport.xml       ← Copy of the data source used by the app
    └── templates/
        ├── base.html       ← Shared layout & navigation bar
        ├── index.html      ← Home / landing page
        ├── trips.html      ← Browse & filter all trips
        ├── search.html     ← Search a trip by code (DOM)
        └── stats.html      ← Statistics per line & train type (ElementTree)
```

---

## Part 1 — XSLT (XML → HTML)

### How it works

The file `trains.xsl` is an XSLT 1.0 stylesheet that reads `transport.xml` and generates a structured HTML page. Each train line is rendered as a section with a table listing every trip's schedule, train type, class, and price (DA).

### View in a browser (quickest way)

Open `Part1-xsl-xml/transport.xml` directly in **Firefox** or **Chrome** — the browser will automatically apply `trains.xsl` and render the styled HTML page.

> ⚠️ Chrome may block local XSL processing due to security restrictions. Firefox is recommended for local file viewing.

### Generate a standalone HTML file

If you have `xsltproc` installed (Linux / macOS):

```bash
cd Part1-xsl-xml
xsltproc trains.xsl transport.xml > output.html
```

Then open `output.html` in any browser.

---

## Part 2 — Flask Web Application

### Prerequisites

- Python 3.10+
- Flask

### Installation

```bash
cd part2-python-flask
pip install flask
```

### Run the app

```bash
python app.py
```

Then visit **http://127.0.0.1:5000** in your browser.

---

## 🌐 Application Routes

| Route | Page | Description | XML API |
|---|---|---|---|
| `/` | Home | Overview and navigation | — |
| `/trips` | Browse Trips | List all trips with live filters | `ElementTree` |
| `/search` | Search by Code | Fetch complete trip details by code (e.g. `T101`) | `DOM (minidom)` |
| `/stats` | Statistics | Cheapest/most expensive trip per line; trip count by train type | `ElementTree` |

---

## ✨ Features

### Browse & Filter Trips (`/trips`)
- Filter by **departure city**
- Filter by **arrival city**
- Filter by **train type** (Normal, Rapid, Coradia…)
- Filter by **maximum price** (DA)
- Filters are combinable and populated dynamically from the XML data

### Search by Trip Code (`/search`)
- Enter a trip code (e.g. `T102`, `T305`) to retrieve its full details
- Implemented with **DOM (`xml.dom.minidom`)** as required

### Statistics (`/stats`)
- **Cheapest and most expensive ticket** for each train line
- **Number of trips per train type** across the whole network
- Implemented with **ElementTree** as required

---

## 🧰 XML APIs Used

| API | Module | Used for |
|---|---|---|
| **DOM** | `xml.dom.minidom` | `/search` — complete trip lookup by code |
| **ElementTree** | `xml.etree.ElementTree` | `/trips` — filtering · `/stats` — statistics |

---

## 📊 Data Overview (`transport.xml`)

The XML file describes the Algerian rail network:

- **Stations** — 15 stations (Oran, Algiers, Blida, Constantine, Tizi Ouzou, Bejaia…)
- **Lines** — multiple lines identified by codes (L01, L02…)
- **Trips** — each line contains several trips with:
  - A unique code (T101, T201…)
  - A train type: `Normal`, `Rapid`, or `Coradia`
  - A schedule (departure & arrival times)
  - Operating days (e.g. `mon,wed,fri`)
  - One or more travel classes (`Economy`, `VIP`) with prices in DA

---

## 👥 Authors

| Name | Group |
|---|---|
| Teffah Adem lahlou | Group 04 |
| Hamadache Chemseddine | Group 04 |
| Bensalah Dhiae ddine | Group 04 |

---

