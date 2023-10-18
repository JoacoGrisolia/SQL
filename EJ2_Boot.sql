1.select distinct category name from categories c 
2.select distinct region from customers c
3.select distinct contact title from customers c
4.select * from customers c order by country
5.select * from orders o order by order_date, customer_id
6.insert into customers (customer_id,company_name,contact_name,contact_title,address,city,region,postal_code,country,phone,fax)
values ('PEPSI','Pepsico','Liu Yang','Owner','Dorrego 100','Buenos Aires',null,7600, 'Argentina','(54) 333-5757','93.24.45.65')
7.insert into region(region_id,region_description)
values (5,'Southeast')
8.select * from customers c where region is null
9.select product_name ,case when unit_price is null then 10 else unit_price end as precio from products p
10.select c.company_name ,c.contact_name ,o.order_date from customers c inner join orders o on c.customer_id=o.customer_id
11.select od.order_id,p.product_name ,od.discount from order_details od inner join products p  on od.product_id  =p.product_id
12.select c.customer_id, c.company_name, o.order_id, o.order_date from customers c left join orders o on c.customer_id=o.customer_id
13.select e.employee_id,e.last_name,t.territory_id ,t.territory_description  from employee_territories et inner join employees e on et.employee_id =e.employee_id 
left join territories t on et.territory_id =t.territory_id
14.select o.order_id, c.company_name  from orders o left join customers c on o.customer_id=c.customer_id
15.select o.order_id, c.company_name from orders o right join customers c on o.customer_id=c.customer_id
16.select s.company_name, o.order_date  from orders o right join shippers s on o.ship_via =s.shipper_id where EXTRACT(YEAR FROM o.order_date)=1996
17.select e.first_name ,e.last_name ,et.territory_id  from employees e  full outer join employee_territories et on e.employee_id =et.employee_id
18.select order_id,unit_price ,quantity , unit_price*quantity as total from order_details od (PREGUNTAR CON QUE TABLA HAY Q HACER MATCH)
19.select s.company_name from suppliers s union select c.company_name from customers c order by company_name 
20.select first_name  from employees e union select...       (NO ENCUENTRO LA COLUMNA GERENTES DE DEPART.)
21.select distinct p.product_name ,p.product_id  from products p inner join order_details od on p.product_id =od.product_id order by p.product_id (pensar como hacer con SUBQUERY)
22.select c.company_name  from customers c where customer_id in (select o.customer_id  from orders o where ship_country ='Argentina')
23.select p.product_name  from products p where product_id not in (select product_id  from order_details od where order_id in (select o.order_id  from orders o where ship_country ='France' ))
24.select od.order_id , sum(od.quantity) from order_details od group by od.order_id 
25.select p.product_name, avg(units_in_stock) from products p group by p.product_name 
26.select p.product_name, avg(units_in_stock) from products p group by p.product_name having avg(units_in_stock)>100
27.select c.company_name, o.customer_id,avg(o.order_id) as average_orders from customers c inner join orders o on c.customer_id = o.customer_id group by c.company_name , o.customer_id 
(no habria q hacer un count(*) y agrupar por customer_id???)
28.select p.product_name,case when p.discontinued = 1 then 'Discontinued' else c.category_name end as product_category from products p inner join categories c on p.category_id  =c.category_id
29.select first_name ,last_name ,case when title ='Sales Manager' then 'Gerente de ventas' else title end as job_title from employees e  
