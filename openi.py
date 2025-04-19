from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import random
from datetime import datetime
def login(username, password):
    # 使用无头浏览器配置
 with open(r'D:\Myproject\autologin\output.txt', 'a') as f:
    f.write(str(datetime.now()) + '  ' + username + '  ' + password + '\n')
    chrome_options = Options()
    chrome_options.add_argument("--headless")  # 无头模式
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("window-size=1920x1080")
    chrome_options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36")  # 设置用户代理
    chrome_options.binary_location = r'D:\Myproject\autologin\chrome-win64\chrome.exe'
    # 设置WebDriver路径
    service = Service(executable_path=r'D:\Myproject\autologin\chromedriver.exe')  # 替换为您的ChromeDriver路径
    driver = webdriver.Chrome(service=service, options=chrome_options)
    driver = webdriver.Chrome()

    # 修改webdriver属性，防止被检测
    driver.execute_cdp_cmd('Page.addScriptToEvaluateOnNewDocument', {
      'source': '''
        Object.defineProperty(navigator, 'webdriver', {
          get: () => undefined
        })
      '''
    })

    # 访问登录页面
    driver.get("https://openi.pcl.ac.cn/user/login")

    # 等待页面加载并输入用户名和密码
    WebDriverWait(driver, 5).until(
        EC.presence_of_element_located((By.ID, "user_name"))
    )
    driver.find_element(By.ID, "user_name").send_keys(username)
    driver.find_element(By.ID, "input_password").send_keys(password)
    print("输入用户名和密码成功！",file=f)
    # # 使用JavaScript点击记住我复选框
    # checkbox = driver.find_element(By.ID, "remember")
    # driver.execute_script("arguments[0].click();", checkbox)
    time.sleep(random.randint(3, 5))
    # 点击登录按钮
    login_button = driver.find_element(By.ID, "submitId")
    login_button.click()
    print("点击登录按钮成功！",file=f)
    # 随机延时
    # # 等待弹窗加载并处理它
    WebDriverWait(driver, 5).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, ".ui.checkbox input[type='checkbox']"))
    )
    time.sleep(6)  # 等待10秒，阅读条约
    # # 选择"不再提醒"复选框
    # label = driver.find_element(By.NAME, "notRemindAgain")  # 确保XPath正确指向标签
    # label.click()
    # time.sleep(7)  
    # # 点击"关闭"按钮
    # close_button = driver.find_element(By.CSS_SELECTOR, ".ui.positive.button")
    # close_button.click()
    # time.sleep(1)
    # print("处理弹窗成功！",file=f)
    # 登录成功后跳转到指定的页面
    driver.get("https://openi.pcl.ac.cn/cloudbrains")
    search_input = driver.find_element(By.CSS_SELECTOR, "input[placeholder='搜索任务名称...']")
    search_input.send_keys("image")
    search_button = driver.find_element(By.CSS_SELECTOR, "button.ui.green.button")
    search_button.click()
    print("搜索任务名称成功！",file=f)

    # 随机延时
    time.sleep(random.randint(5, 10))
    stop_button = driver.find_element(By.XPATH, "//a[text()='停止']")
    if 'disabled' in stop_button.get_attribute('class'):
        debug_link = driver.find_element(By.XPATH, "//a[text()='再次调试']")
        driver.execute_script("arguments[0].click();", debug_link)
        print("点击再次调试链接成功！",file=f)
        # time.sleep(random.randint(100, 180))
        time.sleep(random.randint(80, 120))
    else:
        # 如果停止按钮可点击，则执行正常操作
        print("停止按钮可点击，已经优先停止运行", file=f)
        # 点击停止按钮
        driver.execute_script("arguments[0].click();", stop_button)
        time.sleep(random.randint(80, 120))
        debug_link = driver.find_element(By.XPATH, "//a[text()='再次调试']")
        driver.execute_script("arguments[0].click();", debug_link)
        print("点击再次调试链接成功！",file=f)
        # time.sleep(random.randint(100, 180))
        time.sleep(random.randint(80, 120))     
    # 等待停止按钮可见并点击
    WebDriverWait(driver, 5).until(
        EC.presence_of_element_located((By.XPATH, "//a[text()='停止' and not(contains(@class, 'disabled'))]"))
    )
    stop_link = driver.find_element(By.XPATH, "//a[text()='停止' and not(contains(@class, 'disabled'))]")
    driver.execute_script("arguments[0].click();", stop_link)
    print("点击停止按钮成功！",file=f)
    print("用户", username, "登录成功！",file=f)
    driver.quit()

# 使用正确的用户名和密码替换以下调用参数
login("yls", "yls123123")
login("Vae", "yls253618")
login("xxy", "yls123123")
login("wsw123", "wsw123123")
login("wsw123", "wsw123123")
login("wow123", "wow123123")
login("yzjhylz", "Aa123456")
login("liu2300000", "w2300000")