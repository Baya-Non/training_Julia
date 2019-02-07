#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# このプログラムは気象庁の震源リストにアクセスをして日別のHTMLデータを取得してくるものです
# 開始日と終了日を指定してその間の日付のデータを取得してきますが、気象庁のシステムに対応しているものが2017年5月1日からのものしか存在しません。ご注意ください
# これよりも過去のデータに関しては別プログラムを用意します 
# 
# 使用パッケージ
# 1. HTTTP  Webページアクセスのためのパッケージ
# 2. Dates  日付操作用のパッケージ
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------

using HTTP
using Dates

# 検索のベースURL
BaseURL = "http://www.data.jma.go.jp/svd/eqev/data/daily_map/"
# 検索用日付
SearchDate = ""
# 保存先パス
PATH = "./Crawling/"
# 開始日と終了日を指定
# 形式は yyyyMMdd（例：20170101＝2017年1月1日）
# StartDate（開始日）が20170501なのはWebサービス上で最も古いデータがこの日付のため
StartDate = "20170501"
EndDate = "20170505"

# Juliaで取り扱う日付のフォーマットに設定
df = DateFormat("yyyymmdd")
sd = Date(StartDate,df)
ed = Date(EndDate,df)

# 差分日数の取得
d = ed - sd
days = Dates.value(d)

# 差分日数の分だけループを回す
for day in 0:days
    try
        # DATE型のデータをyyyymmddの形式に戻す
        SearchDay = sd + Dates.Day(day)
        year      = Dates.year(SearchDay)
        month     = Dates.month(SearchDay)
        day       = Dates.day(SearchDay)   
        # 月と日の0付け（桁合わせのため）
        if month <= 9
            month = string("0",month)
        end
        if day <= 9
            day = string("0",day)
        end
        # 検索用日付を作成（例：20170101）
        SearchDate = year
        SearchDate = string(SearchDate,month)
        SearchDate = string(SearchDate,day)
        
        # 検索日付が開始日以降であり、終了日以前であること
        # 強制終了条件として前日までの日付であること（基本的に当日のデータは整備されていない）
        if StartDate <= SearchDate && SearchDate <= EndDate && today() > SearchDay
            # 検索用のHTMLファイル名を生成
            SearchHTML = string(SearchDate,".html")
            # URL生成
            URL = string(BaseURL, SearchHTML)
            # URLを使用してリクエストを投げる
            r = HTTP.request("GET", URL)
            # 取得情報を保存
            f = open(string(PATH,string(SearchDate,".html")), "w")
            redirect_stdout(f)
            println(String(r.body))
            close(f)
            
            # 高速接続をしないために待機１秒を置く
            sleep(1)
        end
    catch e
        nothing
    end
end
