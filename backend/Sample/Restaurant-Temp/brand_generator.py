import json

# Define the brands and their descriptions in Flutter Quill Delta format
brands = [
    {
        "id": 1,
        "name": "Cộng",
        "description": [
            {"insert": "Phố Triệu Việt Vương tháng 10 năm 2007 chuyển động, chị chủ Linh Dung khoác cho quán cà phê số 152D màu áo mới. Kí ức về thời bao cấp của người con thủ đô ùa về trong từng bộ bàn ghế sần và đồ vật vật trang trí trong quán.\n\n"},
            {"insert": "Những ngày nhà nước bao thầu và cấp phát nhu yếu phẩm, miếng thịt cân đường xét tiêu chuẩn, con tem phiếu ố vàng gắn chặt anh cán bộ như nán lại trong không gian quán Cộng.\n\n"},
            {"insert": "Không chỉ là những vật dụng hay góc nhà ngày bao cấp, Cộng mang trong mình tinh thần tinh tươm hóm hỉnh. Vui tai những câu thơ Bút Tre, phấn khởi tranh cổ động, hay dí dỏm nhìn lại cuộc sống những năm 80.\n\n"},
            {"insert": "Chặng đường từ năm 2007, Cộng cà phê không ngừng nỗ lực đem đến trải nghiệm tinh thần ngày xưa qua không gian độc đáo, thức uống chất lượng, và dịch vụ tận tình. Cộng ấp ủ lan tiến xa để tỏa cảm hứng văn hóa cội nguồn Việt Nam đến bạn bè thế giới.\n"}
        ],
        "image_id": 1
    },
    {
        "id": 2,
        "name": "Gemini Coffee",
        "description": [
            {"insert": "Được hình thành từ 2013, Gemini Coffee với hơn 10 năm kinh nghiệm trong ngành Cà Phê. Là đơn vị sản xuất và kinh doanh cà phê tiên phong trong nghiên cứu và phát triển các dòng sản phẩm cà phê sức khỏe ở Việt Nam, định hình chuỗi cà phê tích hợp đa dạng tiện ích nhưng vẫn mang hơi hướng của phong cách kiến trúc truyền thống, tạo không gian cà phê độc đáo mà gần gũi thân thuộc, nơi mọi người kết nối và sẻ chia, nơi chúng tôi tôn vinh và lan tỏa văn hóa cà phê Việt.\n"}
        ],
        "image_id": 2
    },
    {
        "id": 3,
        "name": "Nhà hàng Golden Gate",
        "description": [
            {"insert": "Thành lập từ năm 2005, Golden Gate (CÔNG TY CỔ PHẦN TẬP ĐOÀN GOLDEN GATE) là đơn vị tiên phong áp dụng mô hình chuỗi nhà hàng tại Việt Nam, với 5 phong cách ẩm thực chính, bao gồm: Lẩu, Nướng, Á, Âu và quán cà phê. Golden Gate hiện sở hữu hơn 40 thương hiệu cùng hơn 500 nhà hàng đa phong cách trên 42 tỉnh thành, phục vụ 18 triệu lượt khách hàng mỗi năm và vẫn đang không ngừng nỗ lực phát triển hơn.\n"}
        ],
        "image_id": 3
    },
    {
        "id": 4,
        "name": "Highlands Coffee",
        "description": [
            {"insert": "Highlands Coffee được thành lập vào năm 1999, bắt nguồn từ tình yêu dành cho đất Việt cùng với cà phê và cộng đồng nơi đây. Khởi đầu với sản phẩm cà phê đóng gói tại Hà Nội, chúng tôi đã nhanh chóng phát triển trở thành chuỗi cà phê nổi tiếng với độ phủ hơn 500 cửa hàng trên khắp Việt Nam. Highlands Coffee hiện đang phục vụ các sản phẩm nổi bật cho hàng triệu người khởi đầu ngày mới hứng khởi như: Phin Sữa Đá, Freeze Trà Xanh, Trà Sen Vàng, Phindi Hạnh Nhân, các loại cà phê rang xay, đóng gói và uống liền tiện dụng khác.\n\n"},
            {"insert": "Tại Highlands Coffee, sự Tận Tâm là phương châm cho mọi hoạt động. Chúng tôi mong muốn mang đến một không gian không chỉ dừng lại ở việc phục vụ cà phê, mà còn là điểm tụ hội cộng đồng, nơi mọi người có thể kết nối và gắn bó bằng điểm chung về sự Đam mê - Tình thân - Quý trọng - và Tương trợ lẫn nhau. Highlands Coffee không ngừng cải tiến, để tốt hơn mỗi ngày, để kiên định với sứ mệnh vun đắp cộng đồng mà thương hiệu đã chọn.\n\n"},
            {"insert": "Năm 2022, Highlands Coffee tự hào khi là doanh nghiệp 5 năm liền nằm trong “Top 100 Nơi Làm Việc Tốt Nhất Việt Nam” và vừa được vinh danh Top 3 của Ngành Dịch vụ Khách hàng. Đến nay, chúng tôi cũng đã tuyển dụng và đào tạo hơn 10.000 nhân viên và xem đó như một phần sứ mệnh của mình.\n"}
        ],
        "image_id": 4
    },
    {
        "id": 5,
        "name": "Milano Coffee",
        "description": [
            {"insert": "Milano coffee là chuỗi cà phê nhượng quyền tại Việt Nam, do ông Lê Minh Cường thành lập từ năm 2011. Hiện có hơn 1900 cửa hàng tại 52 tỉnh thành cả nước. Theo Tạp chí điện tử Kinh Doanh, đây được xem là “chuỗi nhượng quyền cà phê lớn nhất Việt Nam hiện nay”.\n"}
        ],
        "image_id": 5
    },
    {
        "id": 6,
        "name": "Phúc Long",
        "description": [
            {"insert": "Một thương hiệu trà, trà sữa, cafe được yêu mến như Phúc Long thu hút hàng ngàn lượt khách mỗi ngày. Không ít người thắc mắc vậy Phúc Long nhượng quyền không, giá nhượng quyền Phúc Long là bao nhiêu.\n\n"},
            {"insert": "Trước khi về với Masan, rất nhiều người muốn mở cafe Phúc Long và nhiều lần liên hệ với công ty về chính sách nhượng quyền cafe. Tuy nhiên, theo chia sẻ của CEO Phúc Long, thương hiệu này chưa có chính sách nhượng quyền thương hiệu, thông tin đối tác sẽ được ghi nhận và sẽ được liên hệ sau khi có chính sách nhượng quyền.\n\n"},
            {"insert": "Đầu năm 2022, khi chính thức về với công ty mẹ Masan, thương hiệu Phúc Long được bao phủ mạnh mẽ khi xuất hiện dưới dạng kiot trong hệ thống siêu thị Winmart, Winmart+ với hàng ngàn chi nhánh. Phúc Long đã có hướng đi riêng để phát triển thương hiệu và lựa chọn của thương hiệu này là không đi theo hướng nhượng quyền. Nếu trong thời gian tới, Phúc Long có nhượng quyền, Blog Sapo sẽ cập nhật thêm thông tin cho bạn nhé.\n"}
        ],
        "image_id": 6
    },
    {
        "id": 7,
        "name": "QSR",
        "description": [
            {"insert": "QSR Việt Nam - Hành trình nâng tầm ẩm thực\n\n"},
            {"insert": "Được thành lập từ năm 2013, QSR Việt Nam đã vươn lên trở thành một trong những tên tuổi hàng đầu trong lĩnh vực dịch vụ chuỗi nhà hàng tại Việt Nam. Với hơn 130 nhà hàng trải dài khắp cả nước, chúng tôi tự hào mang đến những trải nghiệm ẩm thực đa dạng và đẳng cấp.\n\n"},
            {"insert": "Các thương hiệu nổi bật như Dairy Queen®, Swensen's, The Pizza Company, Aka House, và Chang - Modern Thai Cuisine, đều là minh chứng cho sự thành công và cam kết của QSR Việt Nam trong việc nâng tầm ẩm thực. Mỗi món ăn đều được chế biến từ nguyên liệu chọn lọc, đảm bảo mang đến sự hài lòng tuyệt đối cho khách hàng.\n\n"},
            {"insert": "QSR Việt Nam cam kết mang đến cho khách hàng những trải nghiệm ẩm thực tuyệt vời nhất, nhờ vào sự nhiệt huyết và nỗ lực của hơn 4000 nhân viên. Chúng tôi tự hào với những thành công và phát triển vượt bậc, không ngừng đổi mới và nâng cao chất lượng dịch vụ để khẳng định vị thế của mình trên thị trường ẩm thực Việt Nam.\n"}
        ],
        "image_id": 7
    },
    {
        "id": 8,
        "name": "Redwok",
        "description": [
            {"insert": "Công Ty Cổ Phần Ẩm Thực Chảo Đỏ (Red Wok) tiền thân là công ty Gói và Cuốn được thành lập từ năm 2006, và là công ty tiên phong kinh doanh về chuỗi nhà hàng món Việt. Tháng 6 năm 2017, công ty Gói và Cuốn chính thức đổi tên thành công ty Cổ phần Ẩm thực Chảo Đỏ (Red Wok). Hiện nay, Red Wok sở hữu các thương hiệu: Wrap&Roll, Lẩu Bò Sài Gòn, Quán Ụt Ụt, BiaCraft và là một trong những doanh nghiệp tiêu biểu đại diện cho nền Ẩm thực Việt Nam.\n"}
        ],
        "image_id": 8
    },
    {
        "id": 9,
        "name": "Starbucks",
        "description": [
            {"insert": "Nói rằng Starbucks mua và rang cà phê nguyên hạt chất lượng cao là hoàn toàn đúng. Đó là điều cốt lõi của công việc chúng tôi làm – nhưng thật khó để kể toàn bộ câu chuyện.\n\n"},
            {"insert": "Các quán cà phê của chúng tôi đã trở thành địa điểm dành cho những người yêu thích cà phê ở mọi nơi. Tại sao họ chỉ muốn dùng cà phê Starbucks? Vì họ biết họ có thể tin tưởng vào dịch vụ chân thật, một không gian hấp dẫn và một cốc cà phê tuyệt vời được rang một cách chuyên nghiệp và được pha đậm đặc mọi lúc.\n\n"},
            {"insert": "Mong đợi Hơn cả Cà phê\n\n"},
            {"insert": "Chúng tôi là những nhà cung cấp nhiệt tình về cà phê và mọi thứ khác đi kèm với trải nghiệm bổ ích tại quán cà phê. Chúng tôi cũng cung cấp cơ hội lựa chọn các loại chè Tazo® hảo hạng, bánh ngọt ngon và các món chiêu đãi thú vị khác nhằm làm hài lòng mọi vị giác. Và nhạc bạn nghe trong cửa hàng được chọn là vì nghệ thuật và sự hấp dẫn của bản nhạc.\n\n"},
            {"insert": "Mọi người đến Starbucks để trò chuyện, họp mặt hoặc làm việc. Chúng tôi là địa điểm tụ họp cho tình hàng xóm, một phần của công việc hàng ngày – và chúng tôi không thể hạnh phúc hơn về điều này. Truy cập để tìm hiểu về chúng tôi và bạn sẽ thấy: chúng tôi thú vị hơn nhiều những gì chúng tôi pha.\n"}
        ],
        "image_id": 9
    },
    {
        "id": 10,
        "name": "Trung Nguyên Legend",
        "description": [
            {"insert": "Tập đoàn Trung Nguyên Legend với tầm nhìn là Nhà lãnh đạo cà phê Toàn cầu. Chúng tôi tiên phong trong việc khơi nguồn sáng tạo, khởi xướng Lối Sống Tỉnh Thức hướng đến Hệ giá trị Chân – Thiện – Mỹ cho cộng đồng.\n\n"},
            {"insert": "Tinh thần phụng sự cộng đồng chính là kim chỉ nam cho mọi hoạt động của Trung Nguyên Legend trong suốt 25 năm qua. Chúng tôi phụng sự bằng những ly cà phê năng lượng tuyệt ngon, những không gian sáng tạo chuyên và đặc biệt cho cà phê: Trung Nguyên Legend, Trung Nguyên E-Coffee.\n\n"},
            {"insert": "Cà phê năng lượng Trung Nguyên Legend là món quà tặng ngoại giao dành cho Nguyên thủ, Đại sứ, Nhân vật ảnh hưởng, được phục vụ tại các Hội nghị thượng đỉnh APEC, ASEM..\n"}
        ],
        "image_id": 10
    }
]

# Generate the SQL statements without using json.dumps
sql_statements = []
for brand in brands:
    description_str = str(brand['description']).replace("'", "''")  # Use str() for direct formatting
    sql = f"INSERT INTO brand (id, name, description, image_id) VALUES ({brand['id']}, '{brand['name']}', '{description_str}', {brand['image_id']});"
    sql_statements.append(sql)

# Save to a file with utf-8 encoding
output_path = 'C:/laptrinh/hocki7/Restaurant-Review/backend/SQL/sample/brand_sql.sql'
with open(output_path, 'w', encoding='utf-8') as file:
    for statement in sql_statements:
        file.write(statement + '\n')

