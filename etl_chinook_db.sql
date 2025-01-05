CREATE DATABASE IF NOT EXISTS SWORDFISH_CHINOOK;
USE DATABASE SWORDFISH_CHINOOK;

CREATE WAREHOUSE IF NOT EXISTS SWORDFISH_CHINOOK_WAREHOUSE;
USE WAREHOUSE SWORDFISH_CHINOOK_WAREHOUSE;



CREATE SCHEMA IF NOT EXISTS SWORDFISH_CHINOOK.stages;
CREATE OR REPLACE STAGE temp_stage;


CREATE OR REPLACE TABLE employee_stage(
    EmployeeId INT,
    LastName VARCHAR(20),
    FirstName VARCHAR(20),
    Title VARCHAR(30),
    ReportsTo INT,
    BirthDate DATETIME,
    HireDate DATETIME,
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    Email VARCHAR(60)
);

COPY INTO employee_stage
FROM @stages.TEMP_STAGE/employee.csv
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);


SELECT * FROM employee_stage;

CREATE OR REPLACE TABLE customer_stage(
    CustomerId INT,
    FirstName VARCHAR(40),
    LastName VARCHAR(20),
    Company VARCHAR(80),
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    Email VARCHAR(60),
    SupportRepId INT
);

COPY INTO customer_stage
FROM @stages.TEMP_STAGE/customer.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT * FROM customer_stage;

CREATE OR REPLACE TABLE invoice_stage(
    InvoiceId INT,
    CustomerId INT,
    InvoiceDate DATETIME,
    BillingAddress VARCHAR(70),
    BillingCity VARCHAR(40),
    BillingState VARCHAR(40),
    BillingCountry VARCHAR(40),
    BillingPostalCode VARCHAR(10),
    Total DECIMAL(10,2)
);

COPY INTO invoice_stage
FROM @stages.TEMP_STAGE/invoice.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT * FROM invoice_stage;


CREATE OR REPLACE TABLE invoiceline_stage(
    InvoiceLineId INT,
    InvoiceId INT,
    TrackId INT,
    UnitPrice DECIMAL(10,2),
    Quantity INT
);



COPY INTO invoiceline_stage
FROM @stages.TEMP_STAGE/invoiceline.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT * FROM invoiceline_stage;



CREATE OR REPLACE TABLE track_stage(
    TrackId INT,
    Name VARCHAR(200),
    AlbumId INT,
    MediaTypeId INT,
    GenreId INT,
    Composer VARCHAR(220),
    Milliseconds INT,
    Bytes INT,
    UnitPrice DECIMAL(10,2)
);

COPY INTO track_stage
FROM @stages.TEMP_STAGE/track.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT * FROM track_stage;




CREATE OR REPLACE TABLE mediatype_stage(
    MediaTypeId INT,
    Name VARCHAR(120)
);

COPY INTO mediatype_stage
FROM @stages.TEMP_STAGE/mediatype.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT * FROM mediatype_stage;





CREATE OR REPLACE TABLE genre_stage(
    GenreId INT,
    Name VARCHAR(120)
);

COPY INTO genre_stage
FROM @stages.TEMP_STAGE/genre.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT * FROM genre_stage;




CREATE OR REPLACE TABLE playlist_stage(
    PlaylistId INT,
    Name VARCHAR(120)
);

COPY INTO playlist_stage
FROM @stages.TEMP_STAGE/playlist.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT * FROM playlist_stage;





CREATE OR REPLACE TABLE playlisttrack_stage(
    PlaylistId INT,
    TrackId INT
);

COPY INTO playlisttrack_stage
FROM @stages.TEMP_STAGE/playlisttrack.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT * FROM playlisttrack_stage;





CREATE OR REPLACE TABLE album_stage(
    AlbumId INT,
    Title VARCHAR(160),
    ArtistId INT
);

COPY INTO album_stage
FROM @stages.TEMP_STAGE/album.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT * FROM album_stage;




CREATE OR REPLACE TABLE artist_stage(
    ArtistId INT,
    Name VARCHAR(120)
);

COPY INTO artist_stage
FROM @stages.TEMP_STAGE/artist.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT * FROM artist_stage;








CREATE OR REPLACE TABLE dim_date AS
SELECT
    ROW_NUMBER() OVER (ORDER BY unique_dates.InvoiceDate) AS id_date,
    EXTRACT(YEAR FROM unique_dates.InvoiceDate) AS year,
    EXTRACT(MONTH FROM unique_dates.InvoiceDate) AS month,
    EXTRACT(DAY FROM unique_dates.InvoiceDate) AS day,
    EXTRACT(WEEK FROM unique_dates.InvoiceDate) AS week,
    EXTRACT(QUARTER FROM unique_dates.InvoiceDate) AS quarter,
    unique_dates.InvoiceDate AS timestamp
FROM (
    SELECT DISTINCT CAST(InvoiceDate AS DATE) AS InvoiceDate
    FROM invoice_stage
) unique_dates;

SELECT * FROM dim_date;



CREATE OR REPLACE TABLE dim_address AS
SELECT
    ROW_NUMBER() OVER (ORDER BY BillingAddress, BillingState, BillingCity) AS id_address,
    BillingAddress AS street,
    BillingState AS state,
    BillingCity AS city
FROM (
    SELECT DISTINCT
        BillingAddress,
        BillingState,
        BillingCity
    FROM invoice_stage
);

SELECT * from dim_address;


CREATE OR REPLACE TABLE dim_employee AS
SELECT
    EmployeeId AS id_employee,
    BirthDate AS birth_date,
    HireDate AS hire_date,
    State AS state,
    Country AS country
FROM employee_stage;

SELECT * FROM dim_employee;



CREATE OR REPLACE TABLE dim_customer AS
SELECT
    CustomerId AS id_customer,
    Company AS company,
    Country AS nationality,
FROM customer_stage;

SELECT * FROM dim_customer;


CREATE OR REPLACE TABLE dim_track AS
SELECT
    ts.TrackId AS id_track,
    ts.Name AS name,
    ts.Composer AS composer,
    ts.Milliseconds AS milliseconds,
    ts.Bytes AS bytes,
    al.Title AS album,
    ar.Name AS artist_name,
    mt.Name AS media_type,
    ge.Name AS genre_name,
FROM track_stage ts
 JOIN album_stage al ON ts.AlbumId = al.AlbumId
 JOIN artist_stage ar ON al.ArtistId = ar.ArtistId
 JOIN mediatype_stage mt ON ts.MediaTypeId = mt.MediaTypeId
 JOIN genre_stage ge ON ts.GenreId = ge.GenreId;

SELECT * from dim_track;



CREATE OR REPLACE TABLE fact_invoice AS
SELECT
    ROW_NUMBER() OVER (ORDER BY invoice_stage.InvoiceId) AS id_invoice, 
     invoiceline_stage.UnitPrice AS unit_price, 
    invoiceline_stage.Quantity AS Quantity, 
    invoice_stage.Total AS Total,  
    employee_stage.EmployeeId AS dim_employee_id,
    customer_stage.CustomerId AS dim_customer_id,
    track_stage.TrackId AS dim_track_id,
    dim_address.id_address AS dim_address_id, 
    dim_date.id_date AS dim_date_id,
FROM invoice_stage 
JOIN invoiceline_stage ON invoice_stage.InvoiceId = invoiceline_stage.InvoiceId 
JOIN customer_stage  ON invoice_stage.CustomerId = customer_stage.CustomerId 
JOIN employee_stage ON customer_stage.SupportRepId = employee_stage.EmployeeId 
JOIN track_stage  ON invoiceline_stage.TrackId = track_stage.TrackId 
JOIN dim_address  ON invoice_stage.BillingAddress = dim_address.street
JOIN dim_date ON CAST(invoice_stage.InvoiceDate AS DATE) = dim_date.timestamp;


SELECT * FROM fact_invoice;