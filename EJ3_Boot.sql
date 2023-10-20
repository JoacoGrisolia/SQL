-- AVG. 
-- 1. Obtener el promedio de precios por cada categoría de producto. La cláusula OVER(PARTITION BY CategoryID) específica que se debe calcular el promedio de precios por cada valor único de CategoryID en la tabla.
select c.category_name ,p.product_name,p.unit_price,avg(p.unit_price) over (partition by c.category_name) as avgpricebycategory 
from products p inner join categories c on p.category_id =c.category_id 
-- 2. Obtener el promedio de venta de cada cliente
select avg(od.quantity*od.unit_price) over (partition by o.customer_id) as avgorderamount,
	od.order_id,
	o.customer_id,
	o.employee_id,
	o.order_date,
	o.required_date,
	o.shipped_date 
from order_details od inner join orders o on od.order_id =o.order_id order by o.customer_id 
--3. Obtener el promedio de cantidad de productos vendidos por categoría (product_name, quantity_per_unit, unit_price, quantity, avgquantity) y ordenarlo por nombre de la categoría y nombre del producto.
select p.product_name, 
    c.category_name,
    p.quantity_per_unit,
    p.unit_price,
    od.quantity,
    avg(od.quantity) over (partition by p.product_name) as avgquantity
    from products p inner join categories c on p.category_id =c.category_id inner join order_details od on p.product_id =od.product_id order by  c.category_name, p.product_name
---- MIN
-- 4. Selecciona el ID del cliente, la fecha de la orden y la fecha más antigua de la orden para cada cliente de la tabla 'Orders'.
select customer_id ,order_date ,min(order_date) over (partition by customer_id) from orders o 
--MAX
-- 5. Seleccione el id de producto, el nombre de producto, el precio unitario, el id de categoría y el precio unitario máximo para cada categoría de la tabla Products.
select product_id ,product_name ,unit_price ,category_id, max(unit_price) over (partition by category_id) from products p 
-- Row_number
--6. Obtener el ranking de los productos más vendidos
with cantidades_totales_producto as(select p.product_name, sum(od.quantity) as totalquantity
from products p inner join order_details od on p.product_id =od.product_id group by p.product_name  order by totalquantity desc) 
select row_number() over (order by totalquantity desc),product_name ,totalquantity from cantidades_totales_producto 
--7. Asignar numeros de fila para cada cliente, ordenados por customer_id
select row_number() over (order by customer_id),* from customers c 
--8. Obtener el ranking de los empleados más jóvenes () ranking, nombre y apellido del empleado, fecha de nacimiento)
select row_number() over (order by birth_date desc),concat(first_name,' ',last_name) ,birth_date  from employees e 
--SUM
--9. Obtener la suma de venta de cada cliente
select sum(od.unit_price*od.quantity) over (partition by o.customer_id),* from orders o inner join order_details od on o.order_id =od.order_id 
--10.Obtener la suma total de ventas por categoría de producto
select c.category_name,
	p.product_name, 
    p.unit_price,
    od.quantity,
    sum(od.unit_price*od.quantity) over (partition by p.category_id) as totalsales
    from products p inner join categories c on p.category_id =c.category_id inner join order_details od on p.product_id =od.product_id order by  c.category_name, p.product_name
--11. Calcular la suma total de gastos de envío por país de destino, luego ordenarlo por país y por orden de manera ascendente
select ship_country ,order_id ,shipped_date ,freight ,sum(freight) over (partition by ship_country) as totalshippingcosts from orders o order by ship_country ,order_id 
--RANK
-- 12.Ranking de ventas por cliente
with ventas_totales as (select o.customer_id ,c.company_name, sum(od.unit_price*od.quantity) as total_sales from orders o inner join order_details od on o.order_id =od.order_id 
inner join customers c on o.customer_id =c.customer_id  group by o.customer_id ,c.company_name) 
select customer_id ,company_name ,total_sales, rank() over (order by total_sales desc) from ventas_totales
--13.Ranking de empleados por fecha de contratacion
select employee_id ,first_name, last_name  ,hire_date,rank() over(order by hire_date)  from employees e 
--14. Ranking de productos por precio unitario
select product_id ,product_name ,unit_price ,rank() over (order by unit_price desc) from products p 
--LAG
-- 15.Mostrar por cada producto de una orden, la cantidad vendida y la cantidad vendida del producto previo.
select order_id ,product_id ,quantity ,lag(quantity,1) over (order by order_id) as prevquantity from order_details od 
--16. Obtener un listado de ordenes mostrando el id de la orden, fecha de orden, id del cliente y última fecha de orden.
select order_id ,order_date ,customer_id, lag(order_date,1) over (partition by customer_id order by order_date asc) from orders
--17. Obtener un listado de productos que contengan: id de producto, nombre del producto, precio unitario, precio del producto anterior, diferencia entre el precio del producto y precio del producto anterior.
select product_id ,product_name, unit_price ,lag(unit_price,1) over (order by product_id) as lastunitprice,
unit_price-(lag(unit_price,1) over (order by product_id)) as pricedifference from products p 
--LEAD
-- 18.Obtener un listado que muestra el precio de un producto junto con el precio del producto siguiente
select product_name ,unit_price ,lead(unit_price,1) over (order by product_id) from products p 
-- 19.Obtener un listado que muestra el total de ventas por categoría de producto junto con el total de ventas de la categoría siguiente
select c.category_name, 
	sum(od.unit_price *od.quantity) as totalsales,
	lead(sum(od.unit_price *od.quantity),1) over (order by c.category_name)	
	from products p 
inner join categories c on p.category_id =c.category_id 
inner join order_details od on p.product_id =od.product_id 
group by c.category_name 


