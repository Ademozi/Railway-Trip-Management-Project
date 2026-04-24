from flask import Flask, render_template, request
import xml.etree.ElementTree as ET
from xml.dom import minidom

app = Flask(__name__)
XML_FILE = "transport.xml"

# ─────────────────────────────────────────────
#  Helpers
# ─────────────────────────────────────────────

def get_station_map():
    """Return a dict {id: name} built with ElementTree."""
    tree = ET.parse(XML_FILE)
    root = tree.getroot()
    return {s.get("id"): s.get("name") for s in root.findall("stations/station")}


def parse_trips_et():
    """
    Parse ALL trips with ElementTree.
    Returns a list of dicts ready for Jinja templates.
    """
    tree = ET.parse(XML_FILE)
    root = tree.getroot()
    stations = get_station_map()
    trips = []

    for line in root.findall("lines/line"):
        line_code = line.get("code")
        dep_city  = stations.get(line.get("departure"), "?")
        arr_city  = stations.get(line.get("arrival"),   "?")

        for trip in line.findall("trips/trip"):
            sched   = trip.find("schedule")
            days_el = trip.find("days")
            classes = []
            for cls in trip.findall("class"):
                classes.append({
                    "type":  cls.get("type"),
                    "price": int(cls.get("price"))
                })

            trips.append({
                "line_code":  line_code,
                "dep_city":   dep_city,
                "arr_city":   arr_city,
                "code":       trip.get("code"),
                "type":       trip.get("type"),
                "dep_time":   sched.get("departure") if sched is not None else "",
                "arr_time":   sched.get("arrival")   if sched is not None else "",
                "days":       days_el.text            if days_el is not None else "",
                "classes":    classes,
                "min_price":  min(c["price"] for c in classes) if classes else 0,
                "max_price":  max(c["price"] for c in classes) if classes else 0,
            })
    return trips


def get_trip_by_code_dom(code):
    """
    Fetch complete information about ONE trip using DOM (minidom).
    Returns a dict or None.
    """
    dom  = minidom.parse(XML_FILE)
    stations = get_station_map()

    for line_el in dom.getElementsByTagName("line"):
        dep_city = stations.get(line_el.getAttribute("departure"), "?")
        arr_city = stations.get(line_el.getAttribute("arrival"),   "?")

        for trip_el in line_el.getElementsByTagName("trip"):
            if trip_el.getAttribute("code") == code:
                sched_list = trip_el.getElementsByTagName("schedule")
                sched = sched_list[0] if sched_list else None
                days_list = trip_el.getElementsByTagName("days")
                days_text = days_list[0].firstChild.data if days_list else ""

                classes = []
                for cls_el in trip_el.getElementsByTagName("class"):
                    classes.append({
                        "type":  cls_el.getAttribute("type"),
                        "price": int(cls_el.getAttribute("price"))
                    })

                return {
                    "line_code": line_el.getAttribute("code"),
                    "dep_city":  dep_city,
                    "arr_city":  arr_city,
                    "code":      trip_el.getAttribute("code"),
                    "type":      trip_el.getAttribute("type"),
                    "dep_time":  sched.getAttribute("departure") if sched else "",
                    "arr_time":  sched.getAttribute("arrival")   if sched else "",
                    "days":      days_text,
                    "classes":   classes,
                }
    return None


def get_stats_et():
    """
    Statistics using ElementTree:
    - Cheapest & most expensive trip per line
    - Number of trips per train type
    """
    tree  = ET.parse(XML_FILE)
    root  = tree.getroot()
    stations = get_station_map()

    line_stats   = []
    type_counts  = {}

    for line in root.findall("lines/line"):
        line_code = line.get("code")
        dep_city  = stations.get(line.get("departure"), "?")
        arr_city  = stations.get(line.get("arrival"),   "?")

        all_prices = []  # (price, trip_code, class_type)

        for trip in line.findall("trips/trip"):
            t_type = trip.get("type")
            type_counts[t_type] = type_counts.get(t_type, 0) + 1

            for cls in trip.findall("class"):
                p = int(cls.get("price"))
                all_prices.append({
                    "price":      p,
                    "trip_code":  trip.get("code"),
                    "class_type": cls.get("type"),
                    "trip_type":  trip.get("type"),
                })

        if all_prices:
            cheapest   = min(all_prices, key=lambda x: x["price"])
            expensive  = max(all_prices, key=lambda x: x["price"])
        else:
            cheapest = expensive = None

        line_stats.append({
            "line_code": line_code,
            "dep_city":  dep_city,
            "arr_city":  arr_city,
            "cheapest":  cheapest,
            "expensive": expensive,
            "trip_count": len(line.findall("trips/trip")),
        })

    return line_stats, type_counts


# ─────────────────────────────────────────────
#  Routes
# ─────────────────────────────────────────────

@app.route("/")
def index():
    return render_template("index.html")


@app.route("/trips")
def trips():
    """Display all trips with optional filters."""
    all_trips   = parse_trips_et()

    departure   = request.args.get("departure", "").strip()
    arrival     = request.args.get("arrival",   "").strip()
    train_type  = request.args.get("train_type","").strip()
    max_price   = request.args.get("max_price", "").strip()

    filtered = all_trips

    if departure:
        filtered = [t for t in filtered if t["dep_city"].lower() == departure.lower()]
    if arrival:
        filtered = [t for t in filtered if t["arr_city"].lower() == arrival.lower()]
    if train_type:
        filtered = [t for t in filtered if t["type"].lower() == train_type.lower()]
    if max_price:
        try:
            mp = int(max_price)
            filtered = [t for t in filtered if t["min_price"] <= mp]
        except ValueError:
            pass

    # Build dropdown options dynamically
    cities     = sorted(set(t["dep_city"] for t in all_trips) | set(t["arr_city"] for t in all_trips))
    train_types = sorted(set(t["type"] for t in all_trips))

    return render_template("trips.html",
                           trips=filtered,
                           cities=cities,
                           train_types=train_types,
                           departure=departure,
                           arrival=arrival,
                           train_type=train_type,
                           max_price=max_price)


@app.route("/search")
def search():
    """Search a trip by its code using DOM."""
    code   = request.args.get("code", "").strip().upper()#to ensure case-insensitive search
    result = None
    error  = None

    if code:
        result = get_trip_by_code_dom(code)
        if result is None:
            error = f"No trip found with code: {code}"

    return render_template("search.html", result=result, error=error, code=code)


@app.route("/stats")
def stats():
    """Statistics page using ElementTree."""
    line_stats, type_counts = get_stats_et()
    return render_template("stats.html",
                           line_stats=line_stats,
                           type_counts=type_counts)


if __name__ == "__main__":
    app.run(debug=True)
