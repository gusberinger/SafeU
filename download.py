import requests
from bs4 import BeautifulSoup
import re
import csv
from time import strptime, strftime

rows = [["Date", "Time", "NotificationType", "Description"]]
for pagenumber in range(0, 7):
    url = f"https://publicsafety.umn.edu/alerts?page={pagenumber}"
    page = requests.get(url).text
    soup = BeautifulSoup(page, "html.parser")
    content = soup.find("div", class_="view-content")
    updates = content.find_all("div", recursive=False)
    for update in updates:
        title = update.find("div", class_ = "views-field-title").text
        type = re.match(r"SAFE-U (ADVISORY|EMERGENCY|Notifications)", title).group(1)
        time_created_text = update.find("span", class_ = "full-blog-dateline").text
        time_created_match = re.match(r"(\w+ \d{1,2}, \d{4}) at (\d{1,2}:\d{1,2} (AM|PM))",
                                      time_created_text)
        date, time = time_created_match.group(1,2)
        time = strftime("%H:%M", strptime(time, "%I:%M %p"))
        date = strftime("%m-%d-%Y", strptime(date, "%B %d, %Y"))
        description = update.find("div", class_ = "full-blog-abstract").text
        rows.append([date, time, type, description])
        print(len(rows))

with open("SafeU.csv", "w", newline="") as f:
    writer = csv.writer(f)
    for row in rows:
        writer.writerow(row)
