-- Tạo database và chọn database
CREATE DATABASE TicketFilm;
USE TicketFilm;

-- Tạo bảng tblPhim mà không định nghĩa khóa chính ban đầu
CREATE TABLE tblPhim (
  PhimID INT,
  Ten_phim NVARCHAR(25),
  Loai_phim NVARCHAR(25),
  Thoi_gian INT
);

-- Tạo bảng tblPhong mà không định nghĩa khóa chính ban đầu
CREATE TABLE tblPhong (
  PhongID INT ,
  Ten_phong NVARCHAR(20),
  Trang_thai TINYINT
);

-- Tạo bảng tblGhe mà không định nghĩa khóa chính và khóa ngoại ban đầu
CREATE TABLE tblGhe (
  GheID INT,
  PhongID INT,
  So_ghe NVARCHAR(10)
);

-- Tạo bảng tblVe mà không định nghĩa khóa chính và khóa ngoại ban đầu
CREATE TABLE tblVe (
  PhimID INT,
  GheID INT,
  Ngay_chieu DATETIME,
  Trang_thai NVARCHAR(20)
);

-- Sử dụng câu lệnh ALTER TABLE để thêm các ràng buộc

-- Thay đổi cột khóa chính trong bảng tblPhim
alter table tblPhim 
modify PhimID int auto_increment primary key;
-- Thay đổi cột khóa chính trong bảng tblPhim
alter table tblPhong 
modify PhongID int auto_increment primary key;
-- Thay đổi cột khóa chính trong bảng va add khoa ngoai tblGhe
alter table tblGhe
modify GheID int auto_increment primary KEY,
add constraint FK_tblGhe_tblPhong foreign key (PhongID) references tblPhong(PhongID);

-- Thay đổi cột khóa chính trong bảng va add khoa ngoai tblVe
alter table tblVe
add constraint PK_tblVe primary key (PhimID,GheID),
add constraint FK_tblVe_tblPhim foreign key (PhimID) references tblPhim (PhimID),
add constraint FK_tblVe_tblGhe foreign key (GheID) references tblGhe (GheID);

-- insert data in tables

select * from tblPhim;
insert into tblPhim(Ten_phim,Loai_phim,Thoi_gian) values
('Em Bé Hà Nội','Tâm Lý',90),
('Nhiệm Vụ Bất Khả Thi','Hành Động',100),
('Dị Nhân','Viễn Tưởng',90),
('Cuốn Theo Chiêu Gió','Tình cảm',120);

select * from tblPhong;
insert into tblPhong(Ten_phong,Trang_thai) values
('Phòng chiếu 1',1),
('Phòng chiếu 2',1),
('Phòng chiếu 3',0);

select * from tblGhe;
insert into tblGhe(PhongID,So_ghe)values
(1,'A3') ,
(1,'B5'),
(2, 'A7'),
(2, 'D1'),
(3, 'T2');

select * from tblVe;
insert into tblVe(PhimID,GheID,Ngay_chieu,Trang_thai)values
(1, 1, '2008-10-20', 'Đã đặt'),
(1, 3, '2008-11-20', 'Đã đặt'),
(1, 4, '2008-12-23', 'Đã đặt'),
(2, 1, '2009-02-14', 'Đã đặt'),
(3, 1, '2009-02-14', 'Đã đặt'),
(2, 5, '2009-08-03', 'Chưa đặt'),
(2, 3, '2009-08-03', 'Chưa đặt');
-- 2. Hiển thị danh sách các phim (chú ý: danh sách phải được sắp xếp theo trường Thoi_gian)
select * from  tblPhim
order by Thoi_gian desc;
-- 3. Hiển thị Ten_phim có thời gian chiếu dài nhất
select tp.Ten_phim, tp.Thoi_gian from tblPhim tp
where  tp.Thoi_gian = ( select max(thoi_gian) from tblPhim);

-- 4 Hiển thị Ten_Phim có thời gian chiếu ngắn nhất

select tp.Ten_phim, tp.Thoi_gian from tblPhim tp
where tp.Thoi_gian = (select min(Thoi_gian) from tblPhim);

-- 5 Hiển thị danh sách So_Ghe mà bắt đầu bằng chữ ‘A’

select g.So_ghe from tblGhe g
where g.So_ghe like 'A%';

-- 6. Sửa cột Trang_thai của bảng tblPhong sang kiểu nvarchar(25)

alter table tblPhong
modify column Trang_thai nvarchar(25);
DESCRIBE tblPhong;

-- 7. Cập nhật giá trị cột Trang_thai của bảng tblPhong theo các luật sau:
update tblPhong
set Trang_thai = case
   when Trang_thai = '0' then 'Đang sửa'
   when Trang_thai = '1' then 'Đang sử dụng'
   when Trang_thai  is null then 'Unknow'
else Trang_thai   
  end ;
-- Sau đó hiển thị bảng tblPhong (Yêu cầu dùng procedure để hiển thị đồng thời sau khi update)

delimiter //
create procedure UpdateAndShowTblPhong()
begin
update tblPhong
-- Cập nhật giá trị cột Trang_thai
set Trang_thai = case
   when Trang_thai = '0' then 'Đang sửa'
   when Trang_thai = '1' then 'Đang sử dụng'
   when Trang_thai  is null then 'Unknow'
else Trang_thai   
  end ;
    -- Hiển thị bảng tblPhong
    SELECT * FROM tblPhong;
end//

delimiter ;
CALL UpdateAndShowTblPhong();

-- **8. Hiển thị danh sách tên phim mà có độ dài >15 và < 25 ký tự **

select Ten_phim from tblPhim
where char_length(Ten_phim)>15 and char_length(Ten_phim)<25;

--  Hiển thị Ten_Phong và Trang_Thai trong bảng tblPhong trong 1 cột với tiêu đề ‘Trạng thái phòng chiếu’
SELECT concat(tp.Ten_phong, ' - ', tp.Trang_thai) AS `Trạng thái phòng chiếu`
FROM tblPhong tp;
-- 10. Tạo view có tên tblRank với các cột sau: STT(thứ hạng sắp xếp theo Ten_Phim), TenPhim, Thoi_gian
create view tblRank as 
select 
   row_number() over (order by Ten_phim) as STT,
   Ten_phim as TenPhim,
   Thoi_gian
   from tblPhim;
   -- Để xem dữ liệu trong view tblRank sau khi tạo:
   SELECT * FROM tblRank;
   
    -- 11. Trong bảng tblPhim :
    
    -- Thêm trường Mo_ta kiểu nvarchar(max)
    alter table tblPhim
    add column Mo_ta text;
    select * from tblPhim;
    -- Cập nhật trường Mo_ta: thêm chuỗi “Đây là bộ phim thể loại ” + nội dung trường LoaiPhim
    
    update tblPhim
    set Mo_ta = concat('Đây là bộ phim thể loại', Loai_phim);
    -- Hiển thị bảng tblPhim sau khi cập nhật
    select * from tblPhim;
    -- Cập nhật trường Mo_ta: thay chuỗi “bộ phim” thành chuỗi “film” (Dùng replace)
	 update tblPhim
     set Mo_ta = replace(Mo_ta, 'bộ phim', 'film');
      -- Hiển thị bảng tblPhim sau khi cập nhật
    select * from tblPhim;
    -- Xóa tất cả các khóa ngoại trong các bảng trên.
    alter table tblVe 
    drop foreign key FK_tblVe_tblPhim,
    drop foreign key FK_tblVe_tblGhe;
    describe tblVe ;
    alter table tblGhe
    drop foreign key FK_tblGhe_tblPhong;
	describe tblGhe ;

-- Xóa dữ liệu ở bảng tblGhe
delete from tblGhe;
select * from tblGhe;

-- Hiển thị ngày giờ hiện chiếu và ngày giờ chiếu cộng thêm 5000 phút trong bảng tblVe
SELECT 
    Ngay_chieu AS 'Ngày Chiếu',
    DATE_ADD(Ngay_chieu, INTERVAL 5000 MINUTE) AS 'Ngày Chiếu + 5000 Phút'
FROM 
    tblVe;











 
 