 <h1 align="center">Hi 👋, I'm Mob</h1>
<h3 align="center">Join the Cryptocurrency Market, make money from Airdrop - Retroactive with me</h3>

- <p align="left"> <img src="https://komarev.com/ghpvc/?username=mobonchain&label=Profile%20views&color=0e75b6&style=flat" alt="mobonchain" /> <a href="https://github.com/mobonchain"> <img src="https://img.shields.io/github/followers/mobonchain?label=Follow&style=social" alt="Follow" /> </a> </p>

- [![TopAME | Bullish - Cheerful](https://img.shields.io/badge/TopAME%20|%20Bullish-Cheerful-blue?logo=telegram&style=flat)](https://t.me/xTopAME)

# Hướng dẫn cài đặt Node Validator Hyperlane

Hướng dẫn này sẽ giúp bạn cài đặt Node Validator cho dự án Hyperlane trên mạng Base, Arbitrum, Polygon, hoặc Optimism.

---

## Yêu cầu

1. **VPS**: Hệ điều hành Ubuntu, cấu hình khuyến nghị **4 vCPU** - **6 GB RAM**
2. **Ví EVM**:
   - **Private Key** của ví EVM (khuyến nghị dùng ví phụ).
   - Ví cần có ít nhất **0.0001 ETH** trên mạng bạn chọn (Arbitrum, Base, Optimism, Polygon).
3. **URL RPC**: Cùng mạng với mạng bạn chọn chạy node. Có thể đăng ký miễn phí URL RPC tại **[Alchemy](https://alchemy.com/)**.

### Hướng dẫn lấy URL RPC từ Alchemy

1. Truy cập vào trang web **[Alchemy](https://alchemy.com/)** và đăng ký tài khoản nếu bạn chưa có.
2. Đăng ký tài khoản Alchemy nếu bạn chưa có.
3. Tạo một dự án mới:
   - Nhấn vào **Create App**.
   - Điền thông tin như tên dự án và chọn mạng mà bạn muốn chạy (ví dụ: Arbitrum, Base, Optimism, hoặc Polygon).
   - Nhấn **Create App**
4. Sau khi tạo dự án thành công, nhấn vào dự án vừa tạo để lấy URL RPC.
   - URL RPC sẽ có định dạng tương tự như: `https://<network>.alchemyapi.io/v2/<api-key>`.

---

## Cài đặt Node trên mạng Base

1. Chạy các lệnh sau:

```bash
cd $HOME
wget -O hyperlane_base.sh https://raw.githubusercontent.com/mobonchain/Hyperlane/refs/heads/main/hyperlane_base.sh
chmod +x hyperlane_base.sh
./hyperlane_base.sh
```

---

## Cài đặt Node trên các mạng khác

Chạy node trên các mạng **Arbitrum**, **Polygon**, và **Optimism** như sau:

- **Arbitrum**:

```bash
cd $HOME
wget -O hyperlane_arbitrum.sh https://raw.githubusercontent.com/mobonchain/Hyperlane/refs/heads/main/hyperlane_arbitrum.sh
chmod +x hyperlane_arbitrum.sh
./hyperlane_arbitrum.sh
```

- **Polygon**:

```bash
cd $HOME
wget -O hyperlane_polygon.sh https://raw.githubusercontent.com/mobonchain/Hyperlane/refs/heads/main/hyperlane_polygon.sh
chmod +x hyperlane_polygon.sh
./hyperlane_polygon.sh
```

- **Optimism**:

```bash
cd $HOME
wget -O hyperlane_optimism.sh https://raw.githubusercontent.com/mobonchain/Hyperlane/refs/heads/main/hyperlane_optimism.sh
chmod +x hyperlane_optimism.sh
./hyperlane_optimism.sh
```

---

## Sau khi cài đặt

1. Đợi quá trình cài đặt hoàn tất. Nếu không có lỗi xảy ra, tiếp tục với các bước sau:
   - Nhập vào tên container (ví dụ: `hyperlane1`).
   - Nhập vào tên validator (ví dụ: `mobonchain`).
   - Nhập **Private Key** và **RPC URL** khi được yêu cầu.

2. Kiểm tra container đã chạy thành công hay chưa bằng lệnh:

```bash
docker ps
```

Nếu container xuất hiện trong danh sách, cài đặt đã hoàn tất thành công!

---

## Lưu ý quan trọng

- **Sử dụng ví phụ**: Để đảm bảo an toàn, chỉ sử dụng ví phụ khi chạy node.
- **Kiểm tra số dư ví**: Đảm bảo ví có đủ ETH để thực hiện giao dịch trên mạng mà bạn chọn.
- **RPC URL miễn phí**: URL RPC miễn phí từ Alchemy có thể có giới hạn sử dụng. Nếu bạn chạy nhiều node, hãy cân nhắc sử dụng gói trả phí.

Chúc bạn cài đặt thành công!
