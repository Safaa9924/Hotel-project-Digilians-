CREATE Database HotelDatabase
use HotelDatabase

--Tables Creation

-- 1.(Guests)
CREATE TABLE Guests (
    GuestID INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(255) NOT NULL,
    NationalID_Passport VARCHAR(50) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    City VARCHAR(100),
	CreatedAt DATETIME DEFAULT GETDATE()
);

-- 2.(Staff)
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    StaffName VARCHAR(255) NOT NULL,
    Role VARCHAR(100), -- (Reception, Billing, Housekeeping)
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 3.(Rooms)
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomNumber VARCHAR(10) UNIQUE NOT NULL,
    RoomType VARCHAR(50),
    NightlyRate DECIMAL(10, 2),
	IsActive BIT DEFAULT 1 --1 = true / 0 = false
);

-- 4.(Reservations)
CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY IDENTITY(1,1),
    GuestID INT FOREIGN KEY REFERENCES Guests(GuestID),
    RoomID INT FOREIGN KEY REFERENCES Rooms(RoomID),
  
	Created_StaffID INT FOREIGN KEY REFERENCES Staff(StaffID),
    CheckIn_StaffID INT FOREIGN KEY REFERENCES Staff(StaffID),
    CheckOut_StaffID INT FOREIGN KEY REFERENCES Staff(StaffID),

    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
	ReservationStatus VARCHAR(30) NOT NULL 
        CHECK (ReservationStatus IN ('Booked', 'Checked-in', 'Checked-out', 'Cancelled', 'No-Show')),
    CancellationReason VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT CHK_CheckOut_After_CheckIn CHECK (CheckOutDate > CheckInDate) --قيد يضمن إن تاريخ الخروج يكون بعد تاريخ الدخول
  
);

-- 5.(Services)
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    ServiceName VARCHAR(100) UNIQUE NOT NULL,
    Price DECIMAL(10, 2)NOT NULL
);

-- 6.(Service_Usage)
CREATE TABLE Service_Usage (
    UsageID INT PRIMARY KEY IDENTITY(1,1),
    ReservationID INT FOREIGN KEY REFERENCES Reservations(ReservationID) NOT NULL,
    ServiceID INT FOREIGN KEY REFERENCES Services(ServiceID) NOT NULL,
    UsageDate DATE NOT NULL,
	Quantity INT DEFAULT 1 CHECK (Quantity > 0) NOT NULL,
    PriceAtTime DECIMAL(10,2) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 7.(Invoices)
CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY IDENTITY(1,1),
    ReservationID INT FOREIGN KEY REFERENCES Reservations(ReservationID)NOT NULL,
	StaffID INT FOREIGN KEY REFERENCES Staff(StaffID),
    InvoiceDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2)NOT NULL,
    PaidAmount DECIMAL(10, 2)NOT NULL,
	CreatedAt DATETIME DEFAULT GETDATE(),
   
    CONSTRAINT CHK_Paid_Less_Than_Total CHECK (PaidAmount <= TotalAmount)
    );

-- 8.(Payments)
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    InvoiceID INT FOREIGN KEY REFERENCES Invoices(InvoiceID)NOT NULL,
    PaymentDate DATE NOT NULL,
	Amount DECIMAL(12,2) NOT NULL,
    PaymentMethod VARCHAR(30) NOT NULL 
        CHECK (PaymentMethod IN ('Cash', 'Card', 'Online', 'Company', 'BankTransfer')),
    PaymentStatus VARCHAR(20) NOT NULL 
        CHECK (PaymentStatus IN ('Successful', 'Failed', 'Refunded', 'Pending')),
    CreatedAt DATETIME DEFAULT GETDATE()
    --PaymentMethod VARCHAR(50), -- (Cash, Card, Online, Company)
    --PaymentStatus VARCHAR(50)  -- (Successful, Failed, Refunded)
);

-- 9.(Housekeeping_Logs)
CREATE TABLE Housekeeping_Logs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    RoomID INT FOREIGN KEY REFERENCES Rooms(RoomID)NOT NULL,
    StaffID INT FOREIGN KEY REFERENCES Staff(StaffID)NOT NULL,
    CleanDate DATE NOT NULL,
    StartTime TIME,
    EndTime TIME,
	IsLate BIT NOT NULL DEFAULT 0,
    Notes VARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE()
    --IsLate BIT -- (1 for Late, 0 for On-time)
);



-- the Bulk insertion 

-- ============================================================
-- 1. GUESTS TABLE (50 ROWS)
-- ============================================================
INSERT INTO Guests (FullName, NationalID_Passport, Phone, Email, City) VALUES
('Liam Smith', 'PASS-1001', '+1-202-555-0101', 'liam.smith@gmail.com', 'New York'),
('Emma Johnson', 'PASS-1002', '+1-202-555-0102', 'emma.j@yahoo.com', 'Los Angeles'),
('Noah Williams', 'PASS-1003', '+44-7911-123456', 'noah.w@hotmail.com', 'London'),
('Olivia Brown', 'PASS-1004', '+61-411-000-111', 'olivia.b@gmail.com', 'Sydney'),
('William Jones', 'PASS-1005', '+1-416-555-0122', 'william.j@outlook.com', 'Toronto'),
('Sophia Garcia', 'PASS-1006', '+33-1-4266-1010', 'sophia.g@gmail.com', 'Paris'),
('James Miller', 'PASS-1007', '+49-30-123456', 'james.m@web.de', 'Berlin'),
('Ava Davis', 'PASS-1008', '+971-4-1234567', 'ava.d@dubaimail.com', 'Dubai'),
('Isabella Martinez', 'PASS-1009', '+34-91-1234567', 'isabella.m@gmail.com', 'Madrid'),
('Benjamin Rodriguez', 'PASS-1010', '+39-06-1234567', 'ben.r@libero.it', 'Rome'),
('Mia Wilson', 'PASS-1011', '+1-312-555-0144', 'mia.w@gmail.com', 'Chicago'),
('Lucas Anderson', 'PASS-1012', '+1-713-555-0155', 'lucas.a@yahoo.com', 'Houston'),
('Charlotte Taylor', 'PASS-1013', '+44-20-7946-0123', 'charlotte.t@gmail.com', 'Manchester'),
('Henry Thomas', 'PASS-1014', '+61-3-9876-5432', 'henry.t@melbourne.com', 'Melbourne'),
('Amelia Moore', 'PASS-1015', '+1-602-555-0166', 'amelia.m@gmail.com', 'Phoenix'),
('Alexander Jackson', 'PASS-1016', '+1-215-555-0177', 'alex.j@outlook.com', 'Philadelphia'),
('Evelyn Martin', 'PASS-1017', '+1-210-555-0188', 'evelyn.m@gmail.com', 'San Antonio'),
('Sebastian Lee', 'PASS-1018', '+82-2-123-4567', 'sebastian.l@seoul.kr', 'Seoul'),
('Harper Perez', 'PASS-1019', '+81-3-1234-5678', 'harper.p@tokyo.jp', 'Tokyo'),
('Jack Thompson', 'PASS-1020', '+1-619-555-0199', 'jack.t@gmail.com', 'San Diego'),
('Aria White', 'PASS-1021', '+1-214-555-0211', 'aria.w@yahoo.com', 'Dallas'),
('Owen Harris', 'PASS-1022', '+1-408-555-0222', 'owen.h@gmail.com', 'San Jose'),
('Ella Sanchez', 'PASS-1023', '+1-512-555-0233', 'ella.s@gmail.com', 'Austin'),
('Daniel Clark', 'PASS-1024', '+1-904-555-0244', 'daniel.c@outlook.com', 'Jacksonville'),
('Scarlett Ramirez', 'PASS-1025', '+1-415-555-0255', 'scarlett.r@gmail.com', 'San Francisco'),
('Jackson Lewis', 'PASS-1026', '+1-614-555-0266', 'jackson.l@yahoo.com', 'Columbus'),
('Victoria Robinson', 'PASS-1027', '+1-704-555-0277', 'victoria.r@gmail.com', 'Charlotte'),
('David Walker', 'PASS-1028', '+1-317-555-0288', 'david.w@outlook.com', 'Indianapolis'),
('Luna Young', 'PASS-1029', '+1-206-555-0299', 'luna.y@gmail.com', 'Seattle'),
('Matthew Allen', 'PASS-1030', '+1-303-555-0300', 'matthew.a@gmail.com', 'Denver'),
('Grace King', 'PASS-1031', '+1-202-555-0311', 'grace.k@yahoo.com', 'Washington'),
('Joseph Wright', 'PASS-1032', '+1-617-555-0322', 'joseph.w@gmail.com', 'Boston'),
('Chloe Scott', 'PASS-1033', '+1-615-555-0333', 'chloe.s@outlook.com', 'Nashville'),
('Samuel Nguyen', 'PASS-1034', '+1-404-555-0344', 'samuel.n@gmail.com', 'Atlanta'),
('Layla Hill', 'PASS-1035', '+1-405-555-0355', 'layla.h@yahoo.com', 'Oklahoma City'),
('Christopher Green', 'PASS-1036', '+1-702-555-0366', 'chris.g@gmail.com', 'Las Vegas'),
('Zoey Adams', 'PASS-1037', '+1-503-555-0377', 'zoey.a@outlook.com', 'Portland'),
('Isaac Baker', 'PASS-1038', '+1-901-555-0388', 'isaac.b@gmail.com', 'Memphis'),
('Lily Gonzalez', 'PASS-1039', '+1-502-555-0399', 'lily.g@gmail.com', 'Louisville'),
('Gabriel Nelson', 'PASS-1040', '+1-414-555-0400', 'gabriel.n@yahoo.com', 'Milwaukee'),
('Hannah Carter', 'PASS-1041', '+1-505-555-0411', 'hannah.c@gmail.com', 'Albuquerque'),
('Anthony Mitchell', 'PASS-1042', '+1-520-555-0422', 'anthony.m@outlook.com', 'Tucson'),
('Lila Perez', 'PASS-1043', '+1-559-555-0433', 'lila.p@gmail.com', 'Fresno'),
('Dylan Roberts', 'PASS-1044', '+1-916-555-0444', 'dylan.r@yahoo.com', 'Sacramento'),
('Addison Turner', 'PASS-1045', '+1-816-555-0455', 'addison.t@gmail.com', 'Kansas City'),
('Nathan Phillips', 'PASS-1046', '+1-480-555-0466', 'nathan.p@outlook.com', 'Mesa'),
('Nora Campbell', 'PASS-1047', '+1-757-555-0477', 'nora.c@gmail.com', 'Virginia Beach'),
('Caleb Parker', 'PASS-1048', '+1-404-555-0488', 'caleb.p@gmail.com', 'Atlanta'),
('Zoe Evans', 'PASS-1049', '+1-919-555-0499', 'zoe.e@yahoo.com', 'Raleigh'),
('Ryan Edwards', 'PASS-1050', '+1-402-555-0500', 'ryan.e@gmail.com', 'Omaha');

-- ============================================================
-- 2. STAFF TABLE (10 ROWS - ENOUGH FOR DISTRIBUTION)
-- ============================================================
INSERT INTO Staff (StaffName, Role) VALUES
('James Taylor', 'Reception'), ('Mary Anderson', 'Reception'),
('Robert Wilson', 'Billing'), ('Patricia Garcia', 'Billing'),
('Linda Thomas', 'Housekeeping'), ('William Moore', 'Housekeeping'),
('Barbara Martin', 'Housekeeping'), ('Richard Jackson', 'Housekeeping'),
('Susan Lee', 'Housekeeping'), ('Joseph White', 'Manager');
INSERT INTO Staff (StaffName, Role) VALUES
('Ahmed Hassan', 'Reception'),
('Fatma Ali', 'Housekeeping'),
('Mohamed Khaled', 'Billing'),
('Sara Mostafa', 'Manager'),
('Youssef Ibrahim', 'Reception');
-- ============================================================
-- 3. ROOMS TABLE (50 ROWS)
-- ============================================================
INSERT INTO Rooms (RoomNumber, RoomType, NightlyRate) VALUES
('101', 'Single', 100), ('102', 'Single', 100), ('103', 'Single', 100), ('104', 'Single', 100), ('105', 'Single', 100),
('201', 'Double', 180), ('202', 'Double', 180), ('203', 'Double', 180), ('204', 'Double', 180), ('205', 'Double', 180),
('206', 'Double', 180), ('207', 'Double', 180), ('208', 'Double', 180), ('209', 'Double', 180), ('210', 'Double', 180),
('301', 'Triple', 250), ('302', 'Triple', 250), ('303', 'Triple', 250), ('304', 'Triple', 250), ('305', 'Triple', 250),
('401', 'Suite', 500), ('402', 'Suite', 500), ('403', 'Suite', 500), ('404', 'Suite', 500), ('405', 'Suite', 500),
('501', 'Penthouse', 1200), ('502', 'Penthouse', 1200),
('106', 'Single', 105), ('107', 'Single', 105), ('108', 'Single', 105), ('109', 'Single', 105), ('110', 'Single', 105),
('211', 'Double', 190), ('212', 'Double', 190), ('213', 'Double', 190), ('214', 'Double', 190), ('215', 'Double', 190),
('306', 'Triple', 260), ('307', 'Triple', 260), ('308', 'Triple', 260), ('309', 'Triple', 260), ('310', 'Triple', 260),
('406', 'Suite', 550), ('407', 'Suite', 550), ('408', 'Suite', 550), ('409', 'Suite', 550), ('410', 'Suite', 550),
('503', 'Suite Deluxe', 700), ('504', 'Suite Deluxe', 700), ('111', 'Economy', 80);

-- ============================================================
-- 4. SERVICES TABLE (5 ROWS)
-- ============================================================
INSERT INTO Services (ServiceName, Price) VALUES
('Room Service', 25.00), ('Laundry', 15.00), ('Spa & Massage', 80.00),
('Airport Transfer', 45.00), ('Mini Bar', 30.00);

-- ============================================================
-- 5. RESERVATIONS TABLE (50 ROWS)
-- ============================================================
INSERT INTO Reservations 
    (GuestID, RoomID, 
     Created_StaffID, CheckIn_StaffID, CheckOut_StaffID, 
     CheckInDate, CheckOutDate, ReservationStatus, CancellationReason)
VALUES
    (1, 1, 1, 1, 1, '2026-01-01', '2026-01-05', 'Checked-out', NULL),
    (2, 6, 2, 2, 2, '2026-01-10', '2026-01-15', 'Checked-out', NULL),
    (3, 16, 1, 1, 1, '2026-02-01', '2026-02-03', 'Cancelled', 'Flight cancelled'),
    (4, 21, 2, 2, 2, '2026-01-20', '2026-01-25', 'Checked-out', NULL),
    (5, 26, 1, 1, NULL, '2026-03-01', '2026-03-10', 'Checked-in', NULL),
    (6, 2, 2, 2, 2, '2026-02-10', '2026-02-12', 'Checked-out', NULL),
    (7, 7, 1, 1, 1, '2025-12-01', '2025-12-05', 'Checked-out', NULL),
    (8, 17, 2, 2, NULL, '2026-03-05', '2026-03-08', 'Booked', NULL),
    (9, 22, 1, 1, 1, '2026-02-15', '2026-02-20', 'Checked-out', NULL),
    (10, 27, 2, 2, 2, '2026-01-05', '2026-01-08', 'Checked-out', NULL),
    (11, 3, 1, 1, 1, '2026-02-22', '2026-02-25', 'Cancelled', 'Personal emergency'),
    (12, 8, 2, 2, 2, '2026-01-12', '2026-01-14', 'Checked-out', NULL),
    (13, 18, 1, 1, NULL, '2026-03-12', '2026-03-15', 'Booked', NULL),
    (14, 23, 2, 2, 2, '2026-01-18', '2026-01-22', 'Checked-out', NULL),
    (15, 28, 1, 1, 1, '2025-11-20', '2025-11-25', 'Checked-out', NULL),
    (16, 4, 2, 2, NULL, '2026-04-01', '2026-04-05', 'Booked', NULL),
    (17, 9, 1, 1, 1, '2026-02-05', '2026-02-10', 'Checked-out', NULL),
    (18, 19, 2, 2, 2, '2026-01-25', '2026-01-30', 'Checked-out', NULL),
    (19, 24, 1, 1, NULL, '2026-03-15', '2026-03-20', 'Booked', NULL),
    (20, 29, 2, 2, 2, '2026-01-10', '2026-01-12', 'Checked-out', NULL),
    (21, 5, 1, 1, 1, '2026-02-01', '2026-02-05', 'Checked-out', NULL),
    (22, 10, 2, 2, 2, '2025-10-10', '2025-10-15', 'Checked-out', NULL),
    (23, 20, 1, 1, NULL, '2026-03-20', '2026-03-25', 'Booked', NULL),
    (24, 25, 2, 2, 2, '2026-01-05', '2026-01-10', 'Checked-out', NULL),
    (25, 30, 1, 1, 1, '2026-02-10', '2026-02-15', 'Checked-out', NULL),
    (26, 31, 2, 2, NULL, '2026-04-10', '2026-04-15', 'Booked', NULL),
    (27, 32, 1, 1, 1, '2026-01-15', '2026-01-20', 'Checked-out', NULL),
    (28, 33, 2, 2, NULL, '2026-03-01', '2026-03-05', 'Checked-in', NULL),
    (29, 34, 1, 1, 1, '2026-02-25', '2026-02-28', 'Checked-out', NULL),
    (30, 35, 2, 2, 2, '2026-01-20', '2026-01-22', 'Checked-out', NULL),
    (31, 36, 1, 1, NULL, '2026-05-01', '2026-05-05', 'Booked', NULL),
    (32, 37, 2, 2, 2, '2026-02-05', '2026-02-10', 'Checked-out', NULL),
    (33, 38, 1, 1, 1, '2026-01-25', '2026-01-30', 'Checked-out', NULL),
    (34, 39, 2, 2, NULL, '2026-03-10', '2026-03-15', 'Booked', NULL),
    (35, 40, 1, 1, 1, '2026-01-05', '2026-01-08', 'Checked-out', NULL),
    (36, 41, 2, 2, 2, '2026-02-15', '2026-02-20', 'Checked-out', NULL),
    (37, 42, 1, 1, 1, '2025-11-10', '2025-11-15', 'Checked-out', NULL),
    (38, 43, 2, 2, NULL, '2026-04-20', '2026-04-25', 'Booked', NULL),
    (39, 44, 1, 1, 1, '2026-01-15', '2026-01-20', 'Checked-out', NULL),
    (40, 45, 2, 2, NULL, '2026-03-05', '2026-03-08', 'Checked-in', NULL),
    (41, 46, 1, 1, 1, '2026-02-10', '2026-02-15', 'Checked-out', NULL),
    (42, 47, 2, 2, 2, '2026-01-01', '2026-01-05', 'Checked-out', NULL),
    (43, 48, 1, 1, NULL, '2026-06-01', '2026-06-05', 'Booked', NULL),
    (44, 49, 2, 2, 2, '2026-02-20', '2026-02-25', 'Checked-out', NULL),
    (45, 50, 1, 1, 1, '2026-01-10', '2026-01-15', 'Checked-out', NULL),
    (46, 11, 2, 2, NULL, '2026-03-25', '2026-03-30', 'Booked', NULL),
    (47, 12, 1, 1, 1, '2026-01-20', '2026-01-25', 'Checked-out', NULL),
    (48, 13, 2, 2, 2, '2026-02-15', '2026-02-20', 'Checked-out', NULL),
    (49, 14, 1, 1, 1, '2026-01-05', '2026-01-10', 'Checked-out', NULL),
    (50, 15, 2, 2, NULL, '2026-03-01', '2026-03-05', 'Checked-in', NULL);
	
INSERT INTO Reservations 
   (GuestID, RoomID, 
     Created_StaffID, CheckIn_StaffID, CheckOut_StaffID, 
     CheckInDate, CheckOutDate, ReservationStatus, CancellationReason)
VALUES
    (1, 1, 1, NULL, NULL, '2026-02-01', '2026-02-05', 'Cancelled', 'Change of plans'),
    (2, 2, 2, NULL, NULL, '2026-03-01', '2026-03-10', 'Cancelled', 'Illness'),
    (3, 3, 1, NULL, NULL, '2026-04-01', '2026-04-05', 'Cancelled', 'Family reasons'),
    (4, 4, 2, NULL, NULL, '2026-05-01', '2026-05-05', 'Cancelled', 'Work reasons'),
    (5, 5, 1, NULL, NULL, '2026-06-01', '2026-06-05', 'Cancelled', 'No show')
    ;
-- ============================================================
-- 6. SERVICE USAGE (50 ROWS)
-- ============================================================
INSERT INTO Service_Usage 
    (ReservationID, ServiceID, UsageDate, Quantity, PriceAtTime)
VALUES
    (1, 1, '2026-01-02', 1, 150.00),
    (1, 2, '2026-01-03', 1, 200.00),
    (2, 3, '2026-01-11', 1, 800.00),
    (2, 5, '2026-01-12', 1, 300.00),
    (4, 1, '2026-01-21', 1, 150.00),
    (6, 4, '2026-02-11', 1, 250.00),
    (7, 2, '2025-12-02', 1, 200.00),
    (9, 3, '2026-02-16', 1, 800.00),
    (10, 1, '2026-01-06', 1, 150.00),
    (12, 5, '2026-01-13', 1, 300.00),
    (14, 2, '2026-01-19', 1, 200.00),
    (15, 1, '2025-11-21', 1, 150.00),
    (17, 3, '2026-02-06', 1, 800.00),
    (18, 4, '2026-01-26', 1, 250.00),
    (20, 1, '2026-01-11', 1, 150.00),
    (21, 5, '2026-02-02', 1, 300.00),
    (22, 2, '2025-10-11', 1, 200.00),
    (24, 1, '2026-01-06', 1, 150.00),
    (25, 3, '2026-02-11', 1, 800.00),
    (27, 4, '2026-01-16', 1, 250.00),
    (29, 1, '2026-02-26', 1, 150.00),
    (30, 5, '2026-01-21', 1, 300.00),
    (32, 2, '2026-02-06', 1, 200.00),
    (33, 1, '2026-01-26', 1, 150.00),
    (35, 3, '2026-01-06', 1, 800.00),
    (36, 4, '2026-02-16', 1, 250.00),
    (37, 1, '2025-11-11', 1, 150.00),
    (39, 5, '2026-01-16', 1, 300.00),
    (41, 2, '2026-02-11', 1, 200.00),
    (42, 1, '2026-01-02', 1, 150.00),
    (44, 3, '2026-02-21', 1, 800.00),
    (45, 4, '2026-01-11', 1, 250.00),
    (47, 1, '2026-01-21', 1, 150.00),
    (48, 5, '2026-02-16', 1, 300.00),
    (49, 2, '2026-01-06', 1, 200.00),
    (1, 4, '2026-01-04', 1, 250.00),
    (2, 1, '2026-01-14', 1, 150.00),
    (4, 3, '2026-01-24', 1, 800.00),
    (6, 5, '2026-02-12', 1, 300.00),
    (7, 4, '2025-12-04', 1, 250.00),
    (9, 2, '2026-02-19', 1, 200.00),
    (10, 5, '2026-01-07', 1, 300.00),
    (12, 3, '2026-01-13', 1, 800.00),
    (14, 1, '2026-01-21', 1, 150.00),
    (15, 4, '2025-11-24', 1, 250.00),
    (17, 5, '2026-02-09', 1, 300.00),
    (18, 2, '2026-01-29', 1, 200.00),
    (20, 3, '2026-01-11', 1, 800.00),
    (21, 4, '2026-02-04', 1, 250.00),
    (22, 1, '2025-10-14', 1, 150.00);
-- ============================================================
-- 7. HOUSEKEEPING LOGS (50 ROWS)
-- ============================================================
INSERT INTO Housekeeping_Logs (RoomID, StaffID, CleanDate, StartTime, EndTime, IsLate) VALUES
(1, 5, '2026-01-06', '08:00', '08:45', 0), (2, 6, '2026-01-06', '09:00', '09:30', 0), (3, 7, '2026-01-06', '10:00', '10:45', 1),
(4, 8, '2026-01-06', '11:00', '11:30', 0), (5, 9, '2026-01-06', '12:00', '12:45', 0), (6, 5, '2026-01-16', '08:00', '08:30', 0),
(7, 6, '2025-12-06', '09:00', '09:45', 1), (8, 7, '2026-01-15', '10:00', '10:30', 0), (9, 8, '2026-02-11', '11:00', '11:45', 0),
(10, 9, '2025-10-16', '12:00', '12:30', 0), (11, 5, '2026-02-26', '08:00', '08:45', 0), (12, 6, '2026-01-15', '09:00', '09:30', 1),
(13, 7, '2026-02-21', '10:00', '10:45', 0), (14, 8, '2026-01-11', '11:00', '11:30', 0), (15, 9, '2026-03-06', '12:00', '12:45', 0),
(16, 5, '2026-02-04', '08:00', '08:30', 0), (17, 6, '2026-02-11', '09:00', '09:45', 1), (18, 7, '2026-01-31', '10:00', '10:30', 0),
(19, 8, '2026-03-21', '11:00', '11:45', 0), (20, 9, '2026-03-26', '12:00', '12:30', 0), (21, 5, '2026-01-26', '08:00', '08:45', 0),
(22, 6, '2025-10-16', '09:00', '09:30', 1), (23, 7, '2026-03-26', '10:00', '10:45', 0), (24, 8, '2026-01-11', '11:00', '11:30', 0),
(25, 9, '2026-02-16', '12:00', '12:45', 0), (26, 5, '2026-03-11', '08:00', '08:30', 0), (27, 6, '2026-01-09', '09:00', '09:45', 1),
(28, 7, '2025-11-26', '10:00', '10:30', 0), (29, 8, '2026-01-13', '11:00', '11:45', 0), (30, 9, '2026-02-16', '12:00', '12:30', 0),
(31, 5, '2026-04-16', '08:00', '08:45', 0), (32, 6, '2026-01-21', '09:00', '09:30', 1), (33, 7, '2026-03-06', '10:00', '10:45', 0),
(34, 8, '2026-03-16', '11:00', '11:30', 0), (35, 9, '2026-01-09', '12:00', '12:45', 0), (36, 5, '2026-02-21', '08:00', '08:30', 0),
(37, 6, '2025-11-16', '09:00', '09:45', 1), (38, 7, '2026-04-26', '10:00', '10:30', 0), (39, 8, '2026-01-21', '11:00', '11:45', 0),
(40, 9, '2026-03-09', '12:00', '12:30', 0), (41, 5, '2026-02-16', '08:00', '08:45', 0), (42, 6, '2026-01-06', '09:00', '09:30', 1),
(43, 7, '2026-06-06', '10:00', '10:45', 0), (44, 8, '2026-02-26', '11:00', '11:30', 0), (45, 9, '2026-01-16', '12:00', '12:45', 0),
(46, 5, '2026-03-31', '08:00', '08:30', 0), (47, 6, '2026-01-26', '09:00', '09:45', 1), (48, 7, '2026-02-21', '10:00', '10:30', 0),
(49, 8, '2026-01-11', '11:00', '11:45', 0), (50, 9, '2026-03-06', '12:00', '12:30', 0);
INSERT INTO Housekeeping_Logs (RoomID, StaffID, CleanDate, StartTime, EndTime, IsLate)
VALUES
    (17, 3, '2026-03-05', '10:00', '10:30', 0),  -- تنظيف في الميعاد
    (17, 4, '2026-03-10', '09:30', '10:00', 0),   -- تاني في الميعاد
    (17, 5, '2026-03-15', '11:30', '12:15', 1),   -- تأخير

    -- غرفة 9 (Double)
    (9, 2, '2026-02-20', '09:00', '09:45', 0),
    (9, 1, '2026-03-01', '10:00', '10:30', 0);
-- ============================================================
-- 8. INVOICES TABLE (50 ROWS)
-- ============================================================
INSERT INTO Invoices (ReservationID, InvoiceDate, TotalAmount, PaidAmount) VALUES
(1, '2026-01-05', 500, 500), (2, '2026-01-15', 360, 360), (3, '2026-02-03', 300, 300),
(4, '2026-01-25', 900, 900), (5, '2026-03-03', 1000, 0), (6, '2026-02-12', 450, 450),
(7, '2025-12-05', 700, 700), (8, '2026-03-03', 1200, 600), (9, '2026-02-20', 1200, 1200),
(10, '2026-01-08', 550, 550), (11, '2026-02-25', 400, 400), (12, '2026-01-14', 300, 300),
(13, '2026-03-03', 500, 0), (14, '2026-01-22', 800, 800), (15, '2025-11-25', 650, 650),
(16, '2026-03-03', 800, 800), (17, '2026-02-10', 400, 400), (18, '2026-01-30', 950, 950),
(19, '2026-03-03', 300, 0), (20, '2026-01-12', 320, 320), (21, '2026-02-05', 600, 600),
(22, '2025-10-15', 750, 750), (23, '2026-03-03', 450, 450), (24, '2026-01-10', 850, 850),
(25, '2026-02-15', 500, 500), (26, '2026-03-03', 1500, 0), (27, '2026-01-20', 650, 650),
(28, '2026-03-03', 200, 200), (29, '2026-02-28', 400, 400), (30, '2026-01-22', 350, 350),
(31, '2026-03-03', 950, 950), (32, '2026-02-10', 900, 900), (33, '2026-01-30', 800, 800),
(34, '2026-03-03', 1100, 0), (35, '2026-01-08', 450, 450), (36, '2026-02-20', 1100, 1100),
(37, '2025-11-15', 700, 700), (38, '2026-03-03', 600, 600), (39, '2026-01-20', 850, 850),
(40, '2026-03-03', 350, 350), (41, '2026-02-15', 600, 600), (42, '2026-01-05', 550, 550),
(43, '2026-03-03', 1250, 1250), (44, '2026-02-25', 900, 900), (45, '2026-01-15', 750, 750),
(46, '2026-03-03', 400, 400), (47, '2026-01-25', 800, 800), (48, '2026-02-20', 650, 650),
(49, '2026-01-10', 500, 500), (50, '2026-03-03', 700, 700);
INSERT INTO Invoices (ReservationID, InvoiceDate, TotalAmount, PaidAmount)
VALUES 
    (1, '2025-01-01', 5000.00, 1000.00);  -- متأخرة أكتر من 60 يوم
-- ============================================================
-- 9. Payments TABLE (50 ROWS)
-- ============================================================
INSERT INTO Payments 
    (InvoiceID, PaymentDate, PaymentMethod, PaymentStatus, Amount)
VALUES
    (1, '2026-01-05', 'Card', 'Successful', 1800.00),
    (2, '2026-01-15', 'Cash', 'Successful', 4200.00),
    (3, '2026-02-03', 'Online', 'Successful', 950.00),
    (4, '2026-01-25', 'Card', 'Successful', 6500.00),
    (5, '2026-03-10', 'Cash', 'Successful', 1200.00),
    (6, '2026-02-12', 'Online', 'Failed', 3200.00),
    (7, '2025-12-05', 'Card', 'Successful', 2800.00),
    (8, '2026-03-08', 'Cash', 'Successful', 1500.00),
    (9, '2026-02-20', 'Online', 'Successful', 5100.00),
    (10, '2026-01-08', 'Card', 'Successful', 900.00),
    (11, '2026-02-25', 'Cash', 'Failed', 3800.00),
    (12, '2026-01-14', 'Online', 'Successful', 2100.00),
    (13, '2026-03-15', 'Card', 'Successful', 4600.00),
    (14, '2026-01-22', 'Cash', 'Successful', 1400.00),
    (15, '2025-11-25', 'Online', 'Successful', 2700.00),
    (16, '2026-04-05', 'Card', 'Successful', 5900.00),
    (17, '2026-02-10', 'Cash', 'Successful', 1100.00),
    (18, '2026-01-30', 'Online', 'Successful', 3400.00),
    (19, '2026-03-20', 'Card', 'Failed', 4800.00),
    (20, '2026-01-12', 'Cash', 'Successful', 1600.00),
    (21, '2026-02-05', 'Online', 'Successful', 2300.00),
    (22, '2025-10-15', 'Card', 'Successful', 3700.00),
    (23, '2026-03-25', 'Cash', 'Successful', 5200.00),
    (24, '2026-01-10', 'Online', 'Successful', 1900.00),
    (25, '2026-02-15', 'Card', 'Successful', 4100.00),
    (26, '2026-04-15', 'Cash', 'Successful', 3000.00),
    (27, '2026-01-20', 'Online', 'Successful', 2500.00),
    (28, '2026-03-05', 'Card', 'Failed', 4400.00),
    (29, '2026-02-28', 'Cash', 'Successful', 1300.00),
    (30, '2026-01-22', 'Online', 'Successful', 3600.00),
    (31, '2026-05-05', 'Card', 'Successful', 5700.00),
    (32, '2026-02-10', 'Cash', 'Successful', 2000.00),
    (33, '2026-01-30', 'Online', 'Successful', 3100.00),
    (34, '2026-03-15', 'Card', 'Successful', 4700.00),
    (35, '2026-01-08', 'Cash', 'Successful', 1700.00),
    (36, '2026-02-20', 'Online', 'Successful', 3900.00),
    (37, '2025-11-15', 'Card', 'Failed', 5400.00),
    (38, '2026-04-25', 'Cash', 'Successful', 2200.00),
    (39, '2026-01-20', 'Online', 'Successful', 3300.00),
    (40, '2026-03-08', 'Card', 'Successful', 5000.00),
    (41, '2026-02-15', 'Cash', 'Successful', 2400.00),
    (42, '2026-01-05', 'Online', 'Successful', 2800.00),
    (43, '2026-06-05', 'Card', 'Successful', 6100.00),
    (44, '2026-02-25', 'Cash', 'Successful', 1800.00),
    (45, '2026-01-15', 'Online', 'Successful', 4200.00),
    (46, '2026-03-30', 'Card', 'Successful', 2900.00),
    (47, '2026-01-25', 'Cash', 'Successful', 3500.00),
    (48, '2026-02-20', 'Online', 'Successful', 4600.00),
    (49, '2026-01-10', 'Card', 'Successful', 2600.00),
    (50, '2026-03-05', 'Cash', 'Successful', 3700.00);

	SELECT COUNT(*) AS Payments_Count FROM Payments; 
--==================================================================================================================

--Q1) Guest Master View
SELECT TOP 20
    G.GuestID,
    G.FullName,
    G.NationalID_Passport,
    G.Phone,
    G.Email,
    G.City,
    COUNT(DISTINCT R.ReservationID) AS TotalStays,
    ISNULL(SUM(I.TotalAmount), 0) AS LifetimeSpend
FROM Guests G
LEFT JOIN Reservations R 
    ON G.GuestID = R.GuestID
    AND R.ReservationStatus = 'Checked-out'
LEFT JOIN Invoices I ON R.ReservationID = I.ReservationID 
GROUP BY
    G.GuestID,
    G.FullName,
    G.NationalID_Passport,
    G.Phone,
    G.Email,
    G.City
ORDER BY LifetimeSpend DESC;
 



--Q2) Room Availability View (By Date)
SELECT Rm.RoomID, Rm.RoomNumber, Rm.RoomType, Rm.NightlyRate,
       R.CheckInDate, R.CheckOutDate, R.ReservationStatus
FROM Rooms Rm
LEFT JOIN Reservations R ON Rm.RoomID = R.RoomID
AND R.ReservationStatus IN ('Booked', 'Checked-in')
WHERE ReservationStatus IN ('Booked', 'Checked-in')

-- DisAvailabilityStatus for a given date range (Available / Booked)
SELECT DISTINCT RM.RoomID , RoomNumber, RoomType, NightlyRate
FROM Rooms Rm
LEFT JOIN Reservations R 
ON Rm.RoomID = R.RoomID  
AND R.ReservationStatus IN ('Booked', 'Checked-in')
WHERE [CheckInDate] = '2026-04-01'
OR [CheckOutDate]='2026-04-05';

/
-- Q3: Daily Occupancy Rate - 
SELECT 
    d.TheDate AS [Date],
    (SELECT COUNT(*) FROM Rooms) AS TotalRooms,
    COUNT(DISTINCT r.RoomID) AS OccupiedRooms,
    ROUND(
        COUNT(DISTINCT r.RoomID) * 100 / (SELECT COUNT(*) FROM Rooms), 2) AS [Occupancy Rate %]
FROM 
    (VALUES 
        ('2026-01-01'), ('2026-01-02'), ('2026-01-03'), ('2026-01-04'), 
        ('2026-01-05'), ('2026-01-06'), ('2026-01-07'), ('2026-01-08')
        -- أضيفي الأيام اللي عايزاها
    ) d (TheDate)
LEFT JOIN Reservations r 
    ON d.TheDate >= r.CheckInDate          -- اليوم ده بعد أو يساوي دخول النزيل
    AND d.TheDate < r.CheckOutDate         -- واليوم ده قبل خروج النزيل
    AND r.ReservationStatus IN ('Checked-in', 'Checked-out')  -- الحجز نشط (النزيل موجود)
GROUP BY d.TheDate
ORDER BY d.TheDate;

-- Q4: Reservation Details View
CREATE VIEW vw_ReservationDetails AS
SELECT 
    r.ReservationID,
    g.FullName AS GuestName,
    rm.RoomNumber,
    rm.RoomType,
    r.CheckInDate,
    r.CheckOutDate,
    DATEDIFF(DAY, r.CheckInDate, r.CheckOutDate) AS Nights,
    r.ReservationStatus,
    DATEDIFF(DAY, r.CheckInDate, r.CheckOutDate) * rm.NightlyRate AS TotalRoomCharge
FROM Reservations r
INNER JOIN Guests g ON r.GuestID = g.GuestID
INNER JOIN Rooms rm ON r.RoomID = rm.RoomID;

SELECT * FROM vw_ReservationDetails
ORDER BY ReservationID;

-- Q5: Cancellation Analysis by Month

SELECT 
    FORMAT(r.CheckInDate, 'yyyy-MM') AS YearMonth,   
    COUNT(*) AS TotalReservations,
    SUM(CASE WHEN r.ReservationStatus = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledReservations,
    ROUND(
        SUM(CASE WHEN r.ReservationStatus = 'Cancelled' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS CancellationRatePercentage
FROM Reservations r
GROUP BY FORMAT(r.CheckInDate, 'yyyy-MM')
ORDER BY YearMonth;
-- Top 5 Cancellation Reasons 
SELECT TOP 5
    CancellationReason,
    COUNT(*) AS NumberOfCancellations
FROM Reservations
WHERE ReservationStatus = 'Cancelled'
  AND CancellationReason IS NOT NULL
GROUP BY CancellationReason
ORDER BY NumberOfCancellations DESC;

-- Q6: Services Revenue View
CREATE VIEW vw_ServiceRevenue AS
SELECT 
    s.ServiceName,
    FORMAT(su.UsageDate, 'yyyy-MM') AS YearMonth,
    COUNT(*) AS TotalUsageCount,
    SUM(su.Quantity * su.PriceAtTime) AS TotalServiceRevenue
FROM Service_Usage su
INNER JOIN Services s ON su.ServiceID = s.ServiceID
GROUP BY 
    s.ServiceName,
    FORMAT(su.UsageDate, 'yyyy-MM');

	SELECT * FROM vw_ServiceRevenue

	-- Top 5 services by revenue in the last 3 months
SELECT TOP 5
    ServiceName,
    YearMonth,
    TotalUsageCount,
    TotalServiceRevenue
FROM vw_ServiceRevenue
WHERE YearMonth >= FORMAT(DATEADD(MONTH, -3, GETDATE()), 'yyyy-MM')
ORDER BY TotalServiceRevenue DESC;

-- Q7: Invoice Aging & Outstanding Balances View
CREATE VIEW vw_InvoiceAging AS
SELECT 
    i.InvoiceID,
    g.FullName AS GuestName,
    i.InvoiceDate,
    i.TotalAmount,
    i.PaidAmount,
    i.TotalAmount - i.PaidAmount AS OutstandingAmount,
    CASE 
        WHEN DATEDIFF(DAY, i.InvoiceDate, GETDATE()) <= 7 THEN '0–7 days'
        WHEN DATEDIFF(DAY, i.InvoiceDate, GETDATE()) <= 30 THEN '8–30 days'
        WHEN DATEDIFF(DAY, i.InvoiceDate, GETDATE()) <= 60 THEN '31–60 days'
        ELSE '60+ days'
    END AS AgingBucket
FROM Invoices i
INNER JOIN Reservations r ON i.ReservationID = r.ReservationID
INNER JOIN Guests g ON r.GuestID = g.GuestID
WHERE i.TotalAmount > i.PaidAmount;  -- فقط الفواتير اللي لسه عليها مستحقات
SELECT * FROM vw_InvoiceAging

-- استعلام: كل الفواتير في الـ 60+ days bucket
SELECT *
FROM vw_InvoiceAging
WHERE AgingBucket = '60+ days'
ORDER BY OutstandingAmount DESC;

-- Q8: Payment Method Breakdown (monthly)

SELECT 
    FORMAT(p.PaymentDate, 'yyyy-MM') AS YearMonth,
    SUM(p.Amount) AS TotalPaid,
    
    SUM(CASE WHEN p.PaymentMethod = 'Cash' THEN p.Amount ELSE 0 END) AS PaidByCash,
    SUM(CASE WHEN p.PaymentMethod = 'Card' THEN p.Amount ELSE 0 END) AS PaidByCard,
    SUM(CASE WHEN p.PaymentMethod = 'Online' THEN p.Amount ELSE 0 END) AS PaidByOnline,
    SUM(CASE WHEN p.PaymentMethod = 'Company' THEN p.Amount ELSE 0 END) AS PaidByCompany,  -- لو موجود
    
    COUNT(CASE WHEN p.PaymentStatus = 'Failed' THEN 1 END) AS FailedCount,
    COUNT(CASE WHEN p.PaymentStatus = 'Refunded' THEN 1 END) AS RefundedCount

FROM Payments p
WHERE p.PaymentStatus = 'Successful'  -- لو عايزة بس الدفعات الناجحة
   OR p.PaymentStatus IN ('Failed', 'Refunded')  -- أو كل الحالات

GROUP BY FORMAT(p.PaymentDate, 'yyyy-MM')
ORDER BY YearMonth DESC;

-- Q9: Housekeeping & Room Turnover Report (آخر 30 يوم)

DECLARE @Last30Days DATE = DATEADD(DAY, -30, GETDATE());

SELECT 
    hl.RoomID,
    rm.RoomNumber,
    rm.RoomType,
    COUNT(*) AS CleaningCount_Last30Days,
    
    -- متوسط وقت التنظيف (بالدقايق)
    AVG(DATEDIFF(MINUTE, hl.StartTime, hl.EndTime)) AS AvgCleanTimeMinutes,
    
    -- عدد المرات اللي اتأخرت فيها التنظيف
    SUM(CASE WHEN hl.IsLate = 1 THEN 1 ELSE 0 END) AS LateCleanings,
    
    -- نسبة التأخير
    ROUND(
        SUM(CASE WHEN hl.IsLate = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*), 
        2
    ) AS LatePercentage

FROM Housekeeping_Logs hl
INNER JOIN Rooms rm ON hl.RoomID = rm.RoomID
WHERE hl.CleanDate >= @Last30Days
GROUP BY hl.RoomID, rm.RoomNumber, rm.RoomType
ORDER BY CleaningCount_Last30Days DESC;

-- Bonus: Housekeeping Performance View
CREATE VIEW vw_HousekeepingPerformance AS
SELECT 
    hl.RoomID,
    rm.RoomNumber,
    rm.RoomType,
    COUNT(*) AS TotalCleanings,
    AVG(DATEDIFF(MINUTE, hl.StartTime, hl.EndTime)) AS AvgCleanTimeMinutes,
    SUM(CASE WHEN hl.IsLate = 1 THEN 1 ELSE 0 END) AS TotalLateCleanings,
    ROUND(
        SUM(CASE WHEN hl.IsLate = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*), 
        2
    ) AS LatePercentage,
    MIN(hl.CleanDate) AS FirstCleaning,
    MAX(hl.CleanDate) AS LastCleaning
FROM Housekeeping_Logs hl
INNER JOIN Rooms rm ON hl.RoomID = rm.RoomID
GROUP BY hl.RoomID, rm.RoomNumber, rm.RoomType;

SELECT * 
FROM vw_HousekeepingPerformance
ORDER BY LatePercentage DESC;

-- Q10) Staff Performance View (Reception / Billing)
-- الهدف: عرض أداء الموظفين في آخر 30 يوم بناءً على الحجوزات والدخول/الخروج والإيرادات
CREATE VIEW vw_StaffPerformance AS
SELECT 
    s.StaffID,
    s.StaffName,
    s.Role,
        -- عدد الحجوزات اللي أنشأها
    COUNT(DISTINCT CASE WHEN r.Created_StaffID = s.StaffID THEN r.ReservationID END) AS ReservationsHandled,
        -- عدد الـ Check-ins اللي عملهم
    COUNT(DISTINCT CASE WHEN r.CheckIn_StaffID = s.StaffID THEN r.ReservationID END) AS CheckInsProcessed,
        -- عدد الـ Check-outs اللي عملهم
    COUNT(DISTINCT CASE WHEN r.CheckOut_StaffID = s.StaffID THEN r.ReservationID END) AS CheckOutsProcessed,
        -- عدد الدفعات الناجحة اللي سجلها (لو فيه عمود StaffID في Payments، أضيفيه)
    COUNT(DISTINCT p.PaymentID) AS TotalPaymentsProcessed,
        -- مجموع المبالغ المدفوعة الناجحة
    ISNULL(SUM(p.Amount), 0) AS TotalRevenueProcessed
	FROM Staff s
LEFT JOIN Reservations r 
    ON s.StaffID IN (r.Created_StaffID, r.CheckIn_StaffID, r.CheckOut_StaffID)
LEFT JOIN Invoices i ON r.ReservationID = i.ReservationID
LEFT JOIN Payments p 
    ON i.InvoiceID = p.InvoiceID
    AND p.PaymentStatus = 'Successful'
    AND p.PaymentDate >= DATEADD(DAY, -30, GETDATE())  -- آخر 30 يوم

GROUP BY 
    s.StaffID,
    s.StaffName,
    s.Role;
	SELECT *
FROM vw_StaffPerformance
	-- Top 10 staff by TotalRevenueProcessed (last 30 days)
SELECT TOP 10
    StaffName,
    Role,
    ReservationsHandled,
    CheckInsProcessed,
    CheckOutsProcessed,
    TotalPaymentsProcessed,
    TotalRevenueProcessed
FROM vw_StaffPerformance
ORDER BY TotalRevenueProcessed DESC;