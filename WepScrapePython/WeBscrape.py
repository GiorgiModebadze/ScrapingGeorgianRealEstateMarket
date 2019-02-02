import bs4
from urllib.request import urlopen as uReq
from bs4 import BeautifulSoup as soup

items = []
# this is a test command for git 
# scrape myhome.ge
for i in range (1, 5227):
    print(i)
    my_url_Page = "https://www.myhome.ge/en/search?Page="+ str(i)
    uClient = uReq(my_url_Page)
    page_html = uClient.read()
    page_soup = soup(page_html, "html.parser")
    
    containers = page_soup.findAll("div",{"class":"wrapper full-width"})
    
    for container in containers:
        dealType = container.h5.text
        price = container.find("b",{"class":"item-price"}).text
        area = container.find("div",{"class":"item-size"}).text
        try:
            floor = container.find("div",{"data-tooltip":"Floor"}).text
        except:
            floor = "NA"
        try:   
            rooms = container.find("div",{"data-tooltip":"Number of rooms"}).text
        except:
            rooms = "NA"
        try:
            bedRooms = container.find("div",{"data-tooltip":"Bedroom"}).text
        except:
            bedRooms = "NA"
        address = container.find("div",{"class":"address"}).text
        date =  container.find("div",{"class":"statement-date"}).text
        item = dealType + "~" + price + "~" + area + "~" + floor  + "~" + rooms + "~" + bedRooms + "~" + address + "~" + date

        items.append(item)
        
    uClient.close()

with open('myHome.txt', 'w') as f:
    for item in items:
        f.write("%s\n" % item)


#scrape sityva da saqme

items = []

for i in range (1, 1723):
    print(i)
    my_url_Page = "https://ss.ge/en/real-estate/l?Page="+ str(i)
    uClient = uReq(my_url_Page)
    page_html = uClient.read()
    page_soup = soup(page_html, "html.parser")
    
    containers = page_soup.findAll("div",{"class":"latest_article_each_in"})
    
    for container in containers:
        dealType = container.find("span",{"class":"TiTleSpanList"}).text.strip()
        
        try:
            itemType = container.find("div",{"class":"latest_flat_type"}).text.strip()
        except:
            itemType = "NA"
        try:
            price = container.find("div",{"class":"latest_price"}).text.strip()
        except:
            price = "NA"
        try:
            area = container.find("div",{"class":"latest_flat_km"}).text.strip().partition(' ')[0]
            if area.endswith('\r\n'):
                area = area[:-2]
        except:
            area = "NA"
        try:
            address = container.find("div",{"class":"StreeTaddressList"}).a.text.strip()
        except:
            address = "NA"
        date =  container.find("div",{"class":"add_time"}).text.strip().partition(' ')[0]
        
        item = dealType +"~" + itemType + "~" + price + "~" + area + "~" +  address + "~" + date
        items.append(item)
        
    uClient.close()



with open('ssge.txt', 'w') as f:
    for item in items:
        f.write("%s\n" % item)

