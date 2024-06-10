--ex1--
with job_dupli AS (SELECT company_id,title, description,
count(*) as job_count
FROM job_listings
group by title, description, company_id)
select count(job_count)
from job_dupli
where job_count>1
--ex2--
with ranking_spending_cte as (SELECT category, product, sum(spend) as total_spend,
rank () over (partition by category order by sum(spend) desc)
FROM product_spend
where extract (year from transaction_date)=2022
group by category, product)
select category,product,total_spend	
from ranking_spending_cte
where rank in(1,2)
--ex3--
with policy_call_count as(SELECT policy_holder_id	, count(case_id) as policy_call_count
FROM callers
group by policy_holder_id	
having  count(case_id)>=3)
select count(policy_call_count) as policy_holder_count
from policy_call_count
--ex4--
with like_count as (select a.page_id, count(b.liked_date) as like_count from pages as a  
left join page_likes as b 
on a.page_id=b.page_id
group by a.page_id)
select page_id from like_count
where like_count=0
--ex5--
  with cte_curr_month as( 
select 
user_id from user_actions
where extract(month from event_date)=7
and extract (year from event_date)=2022),
cte_previous_month as(  
select user_id from user_actions
where extract (month from event_date)=6
and extract (year from event_date)=2022)
select 
7 as month,
count(distinct a.user_id) as monthly_active_users
from cte_curr_month as a 
inner join cte_previous_month as b
on a.user_id=b.user_id
--ex6--
select country, SUBSTR(trans_date, 1, 7) AS month, 
count(trans_date) as trans_count,
sum(case when state='approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state='approved' then amount else 0 end) as approved_total_amount
from transactions
group by country,month
--ex7--
select product_id, min(year) as first_year, 
quantity, price
from sales 
group by product_id
--ex8--
select customer_id
from customer 
group by customer_id
having count(distinct product_key)=(select count(product_key)  from product)
--ex9--
select employee_id 
from Employees 
where salary <30000
and manager_id not in (select employee_id  from Employees )
--ex11--
(select b.name as results
from MovieRating as c
left join users as b on b.user_id=c.user_id 
group by c.user_id
order by count(c.movie_id) desc, b.name
limit 1)
union all
(select a.title as results
from movies as a
left join MovieRating as c
on a.movie_id=c.movie_id
where substr(created_at,1,7)='2020-02'
group by c.movie_id
order by avg(rating) desc, a.title
limit 1)
--ex12--
with cte1 as (select requester_id as id , count(requester_id) as num
from RequestAccepted
group by requester_id),
cte2 as (select accepter_id as id, count(accepter_id) as num
from RequestAccepted
group by accepter_id),
cte3 as (select id,num from cte1
union all
select id, num from cte2)
select id, sum(num) as num 
from cte3
group by id
order by num desc
limit 1

