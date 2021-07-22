-- 1. List all customers who live in Texas (use JOINs) 
SELECT c.customer_id, c.first_name, c.last_name
FROM customer as c
JOIN address as a
ON c.address_id = a.address_id
WHERE a.district = 'Texas'

-- 2. Get all payments above $6.99 with the Customer's Full Name
SELECT c.customer_id, p.payment_id, c.first_name, c.last_name
FROM payment as p
JOIN customer as c
ON p.customer_id = c.customer_id
WHERE p.amount > 6.99

-- 3. Show all customers names who have made payments over $175(use subqueries)
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 175
)

-- 4. List all customers that live in Nepal (use the city table)
SELECT *
FROM customer
WHERE address_id IN (
	SELECT address_id
	FROM address
	WHERE city_id IN (
		SELECT city_id
		FROM city
		WHERE country_id IN (
			SELECT country_id
			FROM country
			WHERE country = 'Nepal'
		)
	)
)

-- 5. Which staff member had the most transactions?
SELECT *
FROM staff
WHERE staff_id IN (
	SELECT staff_id
	FROM payment
	GROUP BY staff_id
	ORDER BY COUNT(staff_id) DESC
)
LIMIT 1

-- 6. How many movies of each rating are there? 
SELECT rating, COUNT(rating)
FROM film
GROUP BY rating

-- 7. Show all customers who have made a single payment
SELECT *
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM (
		SELECT customer_id, COUNT(customer_id) as amt
		FROM payment
		WHERE payment.amount > 6.99
		GROUP BY customer_id
		ORDER BY amt
	) as amts
	WHERE amt = 1
)

-- 8. Howmanyfreerentalsdidourstoresgive away?
SELECT COUNT(payment_id)
FROM payment
WHERE payment.amount = 0