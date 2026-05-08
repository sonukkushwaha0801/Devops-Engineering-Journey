from selenium import webdriver
import time

driver = webdriver.Chrome()

driver.get("http://localhost:8000")

print("\nPAGE TITLE:")
print(driver.title)

print("\nPAGE SOURCE:")
print(driver.page_source)

time.sleep(5)

driver.quit()
