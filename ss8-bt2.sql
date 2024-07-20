create database student;
use student;
create table Class(
  ClassID int auto_increment primary KEY not null ,
  ClassName text not null,
  StartDate datetime not null,
  Status bit not null
  
);

create table Student(
StudentID INT auto_increment primary key not null,
StudentName nvarchar(30) not null,
Address nvarchar(50),
Phone varchar(20),
Status int not null,
ClassID int
 
);

create table Subjects(
  SubID int auto_increment primary key not null,
  SubName nvarchar(30) not null,
  Credit TINYINT NOT NULL CHECK (Credit >= 1) DEFAULT 1,
  Status bit default 1
);
create table Mark (
  MarkID int auto_increment primary key not null,
  SubID int not null,
  StudentID INT not null,
  Mark float default 0 check (Mark between 0 and 100) ,
  ExamTimes tinyint default 1
);

alter table student
add constraint FK_classID foreign key (ClassID) references  Class(ClassID);
-- Thêm ràng buộc cho cột StartDate của bảng Class là ngày hiện hành.
alter table Class
modify column StartDate datetime not null default current_timestamp;
-- Thêm ràng buộc mặc định cho cột Status của bảng Student là 1.
alter table student
modify column Status int default 1;

-- Thêm ràng buộc khóa ngoại cho bảng Mark trên cột:

alter table Mark
add constraint FK_subject foreign key (SubID) references  Subjects(SubID),
add constraint FK_sudent foreign key (StudentID) references  Student(StudentID);

-- Thêm dữ liệu vào các bảng.

select * from Class;
insert into Class(ClassName,StartDate,Status) values
('A1','2008-12-20',1),
('A2','2008-12-22',1),
('B3',current_date(),0);

select * from Student;
insert into Student(StudentName,Address,Phone,Status,ClassID) values
('Hung','Ha noi','0912113113',1,1),
('Hoa','Hai phong','',1,1),
('Manh','HCM','0123123123',0,2);

select * FROM Subjects;
insert into Subjects(SubName,Credit,Status) values
('CF',5,1),
('C',6,1),
('HDJ',5,1),
('RDBS',10,1);

select * from Mark;
insert into Mark(SubID,StudentID,Mark,ExamTimes) values
(1,1,8,1),
(1,2,10,2),
(2,1,12,1);

-- Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2.
update student
SET ClassID = 2
where StudentName = 'Hung';
select * from student;
-- Cập nhật cột phone trên bảng sinh viên là ‘No phone’ cho những sinh viên chưa có số điện thoại.
update student
set Phone = 'No phone'
where Phone = '';
select * from student;
-- Nếu trạng thái của lớp (Stutas) là 0 thì thêm từ ‘New’ vào trước tên lớp.
update Class
set ClassName = concat('New',ClassName)
where Status = 0;
 select * from class;
 update Class
set ClassName = replace(ClassName,'Newnew','New')
where Status = 0;
 select * from class;
 -- Nếu trạng thái của status trên bảng Class là 1 và tên lớp bắt đầu là 
 -- ‘New’ thì thay thế ‘New’ bằng ‘old’
 update Class
 set ClassName = replace(ClassName,'New','Old')
 where Status = 1 and ClassName like 'New%';
  select * from class;
  -- Nếu lớp học chưa có sinh viên thì thay thế trạng thái là 0 (status=0).
  update Class
  set Status = 0
  where ClassID not in(select distinct ClassID from student);
  -- Kiểm tra kết quả
SELECT * FROM Class;
-- Cập nhật trạng thái của môn học (bảng subject) là 0 nếu môn học đó chưa có sinh viên dự thi.
update Subjects 
SET Status = 0
where SubID not in(select distinct SubID from Mark);
SELECT * FROM Subjects;

-- Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’.
select StudentName from student
where StudentName like 'H%';

-- Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.
select * from Class
where month(StartDate) = 12;
-- Hiển thị giá trị lớn nhất của credit trong bảng subject.
select SubName, Credit as max_Credit  from Subjects 
where Credit = (select max(Credit) from Subjects);

-- Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
select SubID, SubName, Status,Credit as max_Credit  from Subjects 
where Credit = (select max(Credit) from Subjects);

-- Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.
select SubID, SubName, Status,Credit as max_Credit  from Subjects 
where Credit between 3 and 5;
-- Hiển thị các thông tin bao gồm: classid, className, studentname, Address từ hai bảng Class, student
select c.ClassID, c.ClassName, s.StudentName, s.Address from Class c
join student s on s.ClassID = c.ClassID;
-- Hiển thị các thông tin môn học chưa có sinh viên dự thi.
select * from Subjects
where SubID not in (select SubID from  Mark WHERE SubID IS NOT NULL);
-- Hiển thị các thông tin môn học có điểm thi lớn nhất.
select s.* , m.Mark from Subjects s
join Mark m on m.SubID = s.SubID
where m.Mark = (select max(m1.Mark) FROM Mark m1 );
-- Hiển thị các thông tin sinh viên và điểm trung bình tương ứng.
SELECT st.StudentID, st.StudentName, st.Address, st.Phone, st.Status, AVG(m.Mark) AS AverageMark
FROM Student st
JOIN Mark m ON st.StudentID = m.StudentID
GROUP BY st.StudentID, st.StudentName, st.Address, st.Phone, st.Status;

-- Tính điểm trung bình của sinh viên 'Hung'
SELECT st.StudentName, AVG(m.Mark) AS AverageMark
FROM Student st
JOIN Mark m ON st.StudentID = m.StudentID
WHERE st.StudentName = 'Hoa'
GROUP BY st.StudentID, st.StudentName;
-- Hiển thị các thông tin sinh viên và điểm trung bình, chỉ đưa ra các sinh viên có điểm trung bình lớn hơn 10.
  
SELECT st.StudentID, st.StudentName, st.Address, st.Phone, st.Status, AVG(m.Mark) AS AverageMark
FROM Student st
JOIN Mark m ON st.StudentID = m.StudentID
GROUP BY st.StudentID, st.StudentName, st.Address, st.Phone, st.Status
having  AVG(m.Mark)>10;
-- Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.
SELECT st.StudentName, sb.SubName, m.Mark FROM Mark m
join student st on m.StudentID = st.StudentID
join Subjects sb on sb.SubID = m.SubID
order by m.Mark desc, st.StudentName ASC; 
-- Xóa tất cả các lớp có trạng thái là 0.
delete from Class
where Status = 0;

select * from Class;
-- Xóa tất cả các môn học chưa có sinh viên dự thi.
delete from Subjects
where SubId not in (select SubId from  Mark );

select * from Subjects;
-- Xóa bỏ cột ExamTimes trên bảng Mark.

ALTER TABLE Mark
DROP COLUMN ExamTimes;
select * from Mark;

-- Sửa đổi cột status trên bảng class thành tên ClassStatus.
ALTER TABLE Class
CHANGE COLUMN Status ClassStatus INT;
select * from Class;
-- Đổi tên bảng Mark thành SubjectTest.
RENAME TABLE Mark TO SubjectTest;













