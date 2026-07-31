# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding database..."

# Ensure default user exists
user = User.first

# Clear existing transactions for this user to make seed clean and idempotent
user.transactions.destroy_all
puts "Cleared old transactions for user@example.com"

# Define realistic Vietnamese transaction categories, purposes, and price ranges
categories = [
  {
    purposes: [
      "Ăn sáng phở bò", "Ăn sáng bánh mì kẹp thịt", "Ăn sáng xôi xéo",
      "Ăn trưa cơm văn phòng", "Ăn trưa cơm tấm", "Ăn trưa bún chả",
      "Ăn tối hủ tiếu", "Ăn tối cơm gia đình", "Ăn tối phở gà",
      "Cà phê Highland", "Trà sữa Koi Thé", "Cà phê Trung Nguyên",
      "Trà đào túi lọc", "Ăn vặt bánh tráng trộn", "Sinh tố bơ",
      "Ăn lẩu Haidilao cuối tuần", "Đi nhậu bia hơi với bạn", "Buffet nướng K-Pub"
    ],
    range: 15_000..750_000
  },
  {
    purposes: [
      "Đổ xăng xe máy Honda", "Đổ xăng xe ô tô", "Đặt GrabBike đi làm",
      "Đặt GrabCar đi chơi", "Vé xe bus hằng tháng", "Phí gửi xe chung cư",
      "Bảo dưỡng thay dầu nhớt xe máy", "Rửa xe máy", "Sửa lốp xe máy"
    ],
    range: 5_000..500_000
  },
  {
    purposes: [
      "Mua áo thun Coolmate", "Mua quần jean lửng", "Mua giày chạy bộ Adidas",
      "Cắt tóc nam barber", "Sắm chảo chống dính nhà bếp", "Mua sách kỹ năng mềm",
      "Mua ổ cắm điện thông minh", "Mua sữa tắm xà phòng", "Kem đánh răng bàn chải"
    ],
    range: 30_000..1_500_000
  },
  {
    purposes: [
      "Vé xem phim CGV cuối tuần", "Mua bắp nước ngọt CGV", "Gia hạn tài khoản Netflix",
      "Gia hạn Spotify Premium", "Vé tham dự liveshow nhạc", "Vé khu vui chơi giải trí",
      "Mua boardgame về chơi", "Đi hát Karaoke gia đình"
    ],
    range: 50_000..600_000
  },
  {
    purposes: [
      "Thanh toán hóa đơn tiền điện", "Thanh toán tiền nước", "Cước Internet Wifi cáp quang",
      "Nạp tiền điện thoại Viettel", "Phí quản lý vận hành chung cư hằng tháng"
    ],
    range: 50_000..2_000_000
  },
  {
    purposes: [
      "Mừng đám cưới bạn thân", "Quà tặng sinh nhật đồng nghiệp", "Khám sức khỏe tại bệnh viện",
      "Mua thuốc tây hiệu thuốc", "Quyên góp từ thiện", "Săn deal mua sắm Shopee"
    ],
    range: 20_000..1_000_000
  }
]

transactions_to_create = []

# Generate 500 mock transactions scattered across the last 12 months (365 days)
500.times do
  category = categories.sample
  purpose = category[:purposes].sample
  total = rand(category[:range])

  # Round total to the nearest 1,000 for realistic Vietnamese Currency values
  total = (total / 1000.0).round * 1000
  total = 10_000 if total <= 0

  # Scatter timestamps randomly over the last 12 months (365 days)
  random_days_ago = rand(0..365)
  random_seconds = rand(0..86400)
  created_at = random_days_ago.days.ago - random_seconds.seconds

  transactions_to_create << {
    purpose: purpose,
    total: total,
    created_at: created_at,
    updated_at: created_at,
    user_id: user.id
  }
end

# Bulk insert for optimal performance (inserts 500 records in a single database transaction)
Transaction.insert_all!(transactions_to_create)

puts "Successfully seeded 500 realistic transactions for user@example.com scattered across the last 12 months!"
