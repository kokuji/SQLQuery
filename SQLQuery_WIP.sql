use sakila;

-- 1a
select  first_name, last_name from actor;

-- 1b Use nested function with concat to combine columns and create uppercase title
select upper(concat(first_name, " ", last_name)) as 'Actor Name'
from actor; 

-- 2a
select actor_id, first_name, last_name from actor
where first_name = "Joe";

-- 2b
select actor_id, first_name, last_name from actor
where last_name like "%gen%";

-- 2c
select actor_id, first_name, last_name
from actor
where last_name like "%li%"
order by last_name, first_name;

-- 2d Using "In" clause
select country_id, country
from country
where country in ("Afghanistan", "Bangladesh", "China");

-- 3a
alter table actor
add column description blob; 

-- 3b
alter table actor
drop column description;

-- 4a
select last_name, count(last_name) as "Name count"
from actor
group by last_name;

-- 4b
select last_name, count(last_name) as 'Name_count'
from actor
group by last_name
having `Name_count` > 1;

-- 4c 
select*
from actor
where last_name = "Williams";
update actor
set first_name = "Harpo"
where actor_id = 172; 

-- 4d 
update actor
set first_name = "Groucho"
where actor_id = 172;

-- 5a
show create table address;

-- 6a
SELECT staff.first_name, staff.last_name, address.address
FROM address
JOIN staff ON address.address_id=staff.address_id;
-- 6b
DROP VIEW revenue;
CREATE VIEW revenue as
SELECT staff.first_name, staff.last_name, payment.payment_date, payment.amount
FROM payment
JOIN staff ON payment.staff_id=staff.staff_id;
SELECT first_name, last_name, sum(amount) as "Total revenue per employee"
FROM revenue
WHERE payment_date LIKE "2005-08%"
GROUP BY last_name;

-- 6c
CREATE VIEW actor_list AS
SELECT film.film_id, film.title, film_actor.actor_id
from film_actor
INNER JOIN film ON film.film_id=film_actor.film_id;
SELECT actor_list.film_id, actor_list.title, COUNT(actor_list.actor_id) AS "Total actors in film"
FROM actor_list
GROUP BY actor_list.film_id;

-- 6d
SELECT COUNT(inventory_id) AS "Hunchback Impossible copies"
FROM inventory
WHERE film_id
IN
(
select film_id
from film
where title = "Hunchback Impossible"
);

DROP VIEW film_list;
CREATE VIEW film_list as
SELECT inventory.film_id, inventory.inventory_id, film.title
from inventory
JOIN film on inventory.film_id=film.film_id;
 
-- 6e
-- Create a view to join the two tables
CREATE VIEW customer_pay as
SELECT customer.first_name, customer.last_name, customer.customer_id, payment.amount
FROM customer
JOIN payment ON payment.customer_id=customer.customer_id;
-- Create a new view showoing total amount paid by customer name
DROP VIEW customer_total_pay;
CREATE VIEW customer_total_pay AS
SELECT customer_id, first_name, last_name, SUM(amount) AS "Total amount paid"
FROM customer_pay
GROUP BY customer_id
ORDER BY last_name ASC;

-- Show view of customer_total_pay view in ascending order by last name (A to Z)
SELECT*
FROM customer_total_pay;

-- 7a
SELECT title
FROM film
WHERE (title LIKE "K%" AND language_id)
OR (title LIKE "Q%" AND language_id) IN
(SELECT language_id
from language
WHERE name = "English"
);

-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(SELECT actor_id
FROM film_actor
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title = "Alone Trip"
)
);

-- 7c
SELECT cust.first_name, cust.last_name, cust.email, ctry.country
FROM customer cust
JOIN address a ON cust.address_id = a.address_id
JOIN city cty ON a.city_id = cty.city_id
JOIN country ctry ON cty.country_id = ctry.country_id
WHERE country = "Canada";
-- 7d
SELECT f.title, c.name
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
WHERE c.name = "Family";

-- 7e
SELECT f.title, count(f.title) AS "Number of times rented"
FROM film f
LEFT JOIN inventory i ON i.film_id = f.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY `Number of times rented` desc;

-- 7f
SELECT st.store_id, SUM(p.amount) AS "Total revenue (by store)"
FROM payment p
LEFT JOIN staff s ON p.staff_id = s.staff_id
LEFT JOIN store st ON st.store_id = s.store_id
GROUP BY st.store_id;

-- 7g
SELECT st.store_id, cty.city, ctry.country
FROM store st
LEFT JOIN address a ON st.address_id = a.address_id
LEFT JOIN city cty ON a.city_id = cty.city_id
LEFT JOIN country ctry ON cty.country_id = ctry.country_id;

-- 7h
SELECT c.name, sum(amount) AS "Total gross revenue (by genre)"
FROM payment p
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film_category fc ON i.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY `Total gross revenue (by genre)` DESC
limit 5;

-- 8a
CREATE VIEW  top_five_revenue AS
SELECT c.name, sum(p.amount) AS "Total gross revenue (by genre)"
FROM payment p
LEFT JOIN rental r ON p.rental_id = r.rental_id
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN film_category fc ON i.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY `Total gross revenue (by genre)` DESC
limit 5;

-- 8b
SELECT *
FROM top_five_revenue;

-- 8c
DROP VIEW top_five_revenue;