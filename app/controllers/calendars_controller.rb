class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def getWeek
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = [] #プッシュしたときに入れる配列
    plans = Plan.where(date: @todays_date..@todays_date + 6)
    # プランのモデルから一致した条件（７日分のデータ）を取得
    7.times do |x|
      today_plans = []#後の作業からプッシュされた時に入れる配列を入れる
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
        #プランの数だけ実行
        #新しいプランをプッシュするときに、プランのデータがそれぞれの１週間分の日付に一致してれば当てはめる
      end

      wday_num = Date.today.wday + x# wdayメソッドを用いて取得した数値
      # Xは今日は０、明日分は１、明後日分は２・・・と増えていく
      # 一週間分のデータを出したいifではその数字が７を超えたときの配列の数字を出す式になっている
      if wday_num >= 7  #「wday_numが7以上の場合」という条件式
        wday_num = wday_num -7
      end

      days = { :month => (@todays_date + x).month, :date => @todays_date.day + x, :plans => today_plans, :wday => wdays[wday_num]}
      @week_days.push(days)
      # プッシュした時の配列を入れるところが２８行目
    end

  end
end
