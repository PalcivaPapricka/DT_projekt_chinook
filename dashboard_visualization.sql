CREATE OR REPLACE VIEW quarterly_revenue AS
SELECT 
    CONCAT(d.year, '-Q', d.quarter) AS year_quarter,
    SUM(f.total) AS total_revenue
FROM 
    fact_invoice f
JOIN 
    dim_date d ON f.dim_date_id = d.id_date
GROUP BY 
    d.year, d.quarter
ORDER BY 
    d.year, d.quarter;


    
CREATE OR REPLACE VIEW media_type AS
SELECT 
    t.media_type, 
    AVG(f.total) AS avg_sale_value
FROM 
    fact_invoice f
JOIN 
    dim_track t ON f.dim_track_id= t.id_track
GROUP BY 
    t.media_type
ORDER BY 
    avg_sale_value DESC;



CREATE OR REPLACE VIEW nat_distr AS
SELECT dc.nationality, COUNT(fi.id_invoice) AS total_purchases
FROM fact_invoice fi
JOIN dim_customer dc ON fi.dim_customer_id = dc.id_customer
GROUP BY dc.nationality
ORDER BY total_purchases DESC; 

    

CREATE OR REPLACE VIEW average_order AS
SELECT dd.year, AVG(fi.total) AS avg_order_value
FROM fact_invoice fi
JOIN dim_date dd ON fi.dim_date_id = dd.id_date
GROUP BY dd.year
ORDER BY dd.year;



CREATE OR REPLACE VIEW genre_distr AS
SELECT dt.genre_name, dd.year, SUM(fi.total) AS total_revenue
FROM fact_invoice fi
JOIN dim_track dt ON fi.dim_track_id = dt.id_track
JOIN dim_date dd ON fi.dim_date_id = dd.id_date
GROUP BY dt.genre_name, dd.year
ORDER BY dd.year, total_revenue DESC;




SELECT * FROM quarterly_revenue;
SELECT * FROM media_type;
SELECT * FROM nat_distr;
SELECT * FROM average_order;
SELECT * FROM genre_distr;