import psycopg2
from geopy.geocoders import Nominatim

hostname = 'localhost'
database = 'dvdrental'
username = 'postgres'
pwd = 'z+8'
port_id = 5432
conn = None
cur = None
try:
    conn = psycopg2.connect(
        host=hostname,
        dbname=database,
        user=username,
        password=pwd,
        port=port_id
    )
    cur = conn.cursor()
    # cur.execute("ALTER TABLE address ADD latitude float")
    # cur.execute("ALTER TABLE address ADD longitude float")
    # conn.commit()
    cur.execute("SELECT * FROM get_address(); ")

    all = cur.fetchall()

    for row in all:
        geolocator = Nominatim(user_agent="main")
        address = row[1]
        try:
            location = geolocator.geocode(address)
            lat = location.latitude
            long = location.longitude
        except:
            lat = 0
            long = 0
        print(lat)
        cur.execute("UPDATE address SET latitude = " + str(lat) + " WHERE address.address_id = " + str(row[0]))
        cur.execute("UPDATE address SET longitude = " + str(long) + " WHERE address.address_id = " + str(row[0]))

    conn.commit()




except Exception as error:
    print(error)
finally:
    if cur is not None:
        cur.close()
    if conn is not None:
        conn.close()