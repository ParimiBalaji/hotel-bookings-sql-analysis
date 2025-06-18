create database hotel_db;
use hotel_db;

SHOW TABLES;
SELECT * FROM hotel_bookings LIMIT 10;

-- Total number of reservations in the dataset
select count(*) as total_reservations from hotel_bookings;

-- Most Popular Mean plan among guests
select type_of_meal_Plan,count(*) as total from hotel_bookings
group by type_of_meal_plan 
order by total desc
limit 1;

--  Average price per room (All Bookings vs With Children)
select round(avg(avg_price_per_room),2) as avg_price_with_child from hotel_bookings where no_of_children > 0;

-- Reservations made in Specififc Year
select count(*) as reservations_2022
from hotel_bookings
where year(str_to_date(arrival_date, '%y-%m-%d')) = 2022; 

--  Most Common Room Type
select room_type_reserved,count(*) as total from hotel_bookings
group by room_type_reserved
order by total
limit 1;

--

-- 6. How many reservations fall on a weekend (no_of_weekend_nights > 0)?
select count(*) as weekend_reservations 
from hotel_bookings
where no_of_weekend_nights>0;
-- 7. What is the highest and lowest lead time for reservations?
select max(lead_time) as Highest_Leadtime,min(lead_time) as Lowest_leadtime  from hotel_bookings;
-- 8. What is the most common market segment type for reservations?
select market_segment_type,count(*) as total from hotel_bookings
group by market_segment_type
order by total desc
limit 1;

-- 9. How many reservations have a booking status of "Confirmed"?
select count(*) as confirmed_reservations
from hotel_bookings
where booking_status = 'Confirmed';
-- 10. What is the total number of adults and children across all reservations?
select sum(no_of_adults) as total_adults,sum(no_of_children) as total_children from hotel_bookings;
-- 11. Rank room types by average price within each market segment.
SELECT 
    market_segment_type, 
    room_type_reserved, 
    AVG(avg_price_per_room) AS avg_price
FROM hotel_bookings
GROUP BY market_segment_type, room_type_reserved
ORDER BY market_segment_type, avg_price DESC;

-- 12. Find the top 2 most frequently booked room types per market segment.
SELECT *
FROM (
    SELECT 
        market_segment_type,
        room_type_reserved,
        COUNT(*) AS count,
        RANK() OVER (PARTITION BY market_segment_type ORDER BY COUNT(*) DESC) AS rnk
    FROM hotel_bookings
    GROUP BY market_segment_type, room_type_reserved
) AS ranked_rooms
WHERE rnk <= 2;


-- 13. What is the average number of nights (both weekend and weekday) spent by
-- guests for each room type?
SELECT room_type_reserved,
       AVG(no_of_weekend_nights + no_of_week_nights) AS avg_total_nights
FROM hotel_bookings
GROUP BY room_type_reserved;

-- 14. For reservations involving children, what is the most common room type, and
-- what is the average price for that room type?
SELECT room_type_reserved, COUNT(*) AS count, AVG(avg_price_per_room) AS avg_price
FROM hotel_bookings
WHERE no_of_children > 0
GROUP BY room_type_reserved
ORDER BY count DESC
LIMIT 1;

-- 15. Find the market segment type that generates the highest average price per
-- room.
 SELECT market_segment_type, AVG(avg_price_per_room) AS avg_price
FROM hotel_bookings
GROUP BY market_segment_type
ORDER BY avg_price DESC
LIMIT 1;

