-- Team: T11
-- Team Members:
-- Member 1: Gavin Phillips
-- Member 2: Zachary Livesay
-- Member 3: Nalia Pope
-- Member 4: Paul Rajapandi
-- Member 5: Rob Shovan

-- drop all the tables we are going to create
drop table orders;
drop table customers;
drop table inventory;
drop table menu_items;
drop table waiters;
drop table restaurants;
drop table cuisines;

-- drop all the sequences we are going to create
drop sequence cuisine_id_seq;
drop sequence restaurant_id_seq;
drop sequence waiter_id_seq;
drop sequence menu_item_id_seq;
drop sequence inventory_id_seq;
drop sequence customer_id_seq;
drop sequence order_id_seq;

-- create the cuisines table
create table cuisines (
    cuisine_id number not null,
    cuisine_name varchar2(20) not null,
    constraint cuisine_id_pk
        primary key (cuisine_id)
);

-- create the restaurants table
create table restaurants (
    restaurant_id number not null,
    restaurant_name varchar2(50) not null,
    restaurant_street_address varchar2(100) not null,
    restaurant_city varchar2(50) not null,
    restaurant_state varchar2(2) not null,
    restaurant_zipcode number not null,
    restaurant_cuisine_id number not null,
    constraint restaurant_id_pk
        primary key (restaurant_id),
    constraint restaurant_fk_cuisine_id
        foreign key (restaurant_cuisine_id)
        references cuisines (cuisine_id)
);

-- create the waiters table
create table waiters (
    waiter_id number not null,
    waiter_name varchar2(50) not null,
    waiter_restaurant_id number not null,
    constraint waiter_id_pk
        primary key (waiter_id),
    constraint waiter_fk_restaurant_id
        foreign key (waiter_restaurant_id)
        references restaurants (restaurant_id)
);

-- create the menu_items table
create table menu_items (
    menu_item_id number not null,
    menu_item_cuisine_id number not null,
    menu_item_name varchar2(20) not null,
    menu_item_price number not null,
    constraint menu_item_id_pk
        primary key (menu_item_id),
    constraint menu_fk_cuisine_id
        foreign key (menu_item_cuisine_id)
        references cuisines (cuisine_id)
);

-- create the inventory table
create table inventory (
    inventory_id number not null,
    inventory_menu_item_id number not null,
    inventory_menu_item_name varchar2(20) not null,
    inventory_restaurant_id number not null,
    inventory_quantity number not null,
    constraint inventory_id_pk
        primary key (inventory_id),
    constraint inventory_fk_menu_item_id
        foreign key (inventory_menu_item_id)
        references menu_items (menu_item_id),
    constraint inventory_fk_restaurant_id
        foreign key (inventory_restaurant_id)
        references restaurants (restaurant_id)
);

-- create the customers table
create table customers (
    customer_id number not null,
    customer_name varchar2(50) not null,
    customer_email varchar2(50) not null,
    customer_street_address varchar2(100) not null,
    customer_city varchar2(50) not null,
    customer_state varchar2(2) not null,
    customer_zipcode number not null,
    customer_credit_card number not null,
    constraint customer_id_pk
        primary key (customer_id)
);

-- create the orders table
create table orders (
    order_id number not null,
    order_restaurant_id number not null,
    order_customer_id number not null,
    order_menu_item_id number not null,
    order_waiter_id number not null,
    order_date DATE not null,
    order_amount_paid number not null,
    order_tip number not null,
    constraint order_id_pk
        primary key (order_id),
    constraint order_fk_restaurant_id
        foreign key (order_restaurant_id)
        references restaurants (restaurant_id),
    constraint order_fk_customer_id
        foreign key (order_customer_id)
        references customers (customer_id),
    constraint order_fk_menu_item_id
        foreign key (order_menu_item_id)
        references menu_items (menu_item_id),
    constraint order_fk_waiter_id
        foreign key (order_waiter_id)
        references waiters (waiter_id)
);

-- create sequences for primary keys
create sequence cuisine_id_seq start with 1;
create sequence restaurant_id_seq start with 1;
create sequence waiter_id_seq start with 1;
create sequence menu_item_id_seq start with 1;
create sequence inventory_id_seq start with 1;
create sequence customer_id_seq start with 1;
create sequence order_id_seq start with 1;

--turn on server output
set serveroutput on;

-- MEMBER 1 

-- Beginning of Deliverable 2
-- insert sample cuisines into database
INSERT INTO cuisines values(cuisine_id_seq.nextval, 'American');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'Indian');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'Nigerian');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'Mexican');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'Swedish');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'German');

-- insert sample restaurants into database
INSERT into restaurants values(restaurant_id_seq.nextval, 'Buds Diner', '1601 N Main St', 'Tarboro', 'NC', 27886, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'));
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'Kabob and Curry', '827 Nursery Rd', 'Linthicum Heights', 'MD', 21090, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'));
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'Suya Spot Nigerian Grill', '10309 Grand Central Ave', 'Owings Mills', 'MD', 21117, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Nigerian'));
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'El Guapo', '729A Frederick Rd', 'Catonsville', 'MD', 21228, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Mexican'));
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'Sweden Special', '502 Baltimore Pike', 'Bel Air', 'MD', 21014, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Swedish'));
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'Gutentag Diner', '1010 Linden Avenue', 'Arbutus', 'MD', 21227, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'German'));

-- insert sample customers into database
insert into customers values (customer_id_seq.nextval, 'John Smith', 'jsmith@gmail.com', '100 Light Street', 'Baltimore', 'MD', '21048', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Jane Smith', 'smithj@gmail.com', '200 Light Street', 'Baltimore', 'MD', '21049', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Bill W', 'wbill@gmail.com', '300 Light Street', 'Baltimore', 'MD', '21098', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Julia E', 'ejulia@gmail.com', '150 Light Street', 'Baltimore', 'MD', '21030', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Chuck R', 'rchuck@gmail.com', '900 Light Street', 'Baltimore', 'MD', '21093', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Jon P', 'pjon@gmail.com', '1100 Light Street', 'Baltimore', 'MD', '21226', '1234567890123456');


-- insert sample waiters into database
INSERT INTO waiters VALUES (waiter_id_seq.nextval, 'Zachary Livesay', 1);
INSERT INTO waiters VALUES (waiter_id_seq.nextval, 'Kenny Somaiya', 2);
INSERT INTO waiters VALUES (waiter_id_seq.nextval, 'Matthew Sachs', 3);
INSERT INTO waiters VALUES (waiter_id_seq.nextval, 'Jalen Murray', 4);
INSERT INTO waiters VALUES (waiter_id_seq.nextval, 'Jacob Nagel', 5);
INSERT INTO waiters VALUES (waiter_id_seq.nextval, 'Austin Phillips', 6);

-- insert values into menu_items table
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'Mac and Cheese', 11);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'Cheeseburger', 12);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'Steak', 20);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'French Fries', 6);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'Chicken Noodle Soup', 8);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'), 'Dal Soup', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'), 'Rice', 3);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'), 'Tandoori Chicken', 12);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'), 'Samosa', 6);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Nigerian'), 'Meat Chunks', 12);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Nigerian'), 'Legume Stew', 11);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Nigerian'), 'Flatbread', 2);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Mexican'), 'Elote', 4);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Mexican'), 'Tostadas', 5);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Mexican'), 'Tacos Al Pastor', 9);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'German'), 'Schnitzel', 15);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'German'), 'Eintopf', 15);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'German'), 'Brezel', 13);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Swedish'), 'Kalops', 9);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Swedish'), 'Kanelbullar', 8);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Swedish'), 'Pannkakor', 10);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Swedish'), 'Ostfrallor', 4);

-- insert sample orders into database
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'Mac and Cheese' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	1, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'Mac and Cheese'),  
	1, to_date('2022-NOV-21', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'Mac and Cheese'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'Mac and Cheese'));

INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'Cheeseburger' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	1, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'Cheeseburger'),  
	1, to_date('2022-NOV-21', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'Cheeseburger'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'Cheeseburger'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'Dal Soup' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	2, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'Dal Soup'), 
	2, to_date('2022-AUG-20', 'YYYY-MON-DD'),
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'Dal Soup'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'Dal Soup'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'Tandoori Chicken' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	2, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'Tandoori Chicken'),  
	2, to_date('2022-AUG-20', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'Tandoori Chicken'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'Tandoori Chicken'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'Legume Stew' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	3, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'Legume Stew'),  
	3, to_date('2022-MAY-03', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'Legume Stew'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'Legume Stew'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'Flatbread' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	3, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'Flatbread'), 
	3, to_date('2022-MAY-03', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'Flatbread'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'Flatbread'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'Elote' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	4, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'Elote'), 
	4, to_date('2022-MAY-21', 'YYYY-MON-DD'),
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'Elote'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'Elote'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'Tacos Al Pastor' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	4, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'Tacos Al Pastor'), 
	4, to_date('2022-MAY-21', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'Tacos Al Pastor'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'Tacos Al Pastor'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'Schnitzel' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	5, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'Schnitzel'), 
	5, to_date('2022-FEB-26', 'YYYY-MON-DD'),
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'Schnitzel'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'Schnitzel'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'Eintopf' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	5, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'Eintopf'), 
	5, to_date('2022-FEB-26', 'YYYY-MON-DD'),
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'Eintopf'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'Eintopf'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'Pannkakor' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	6, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'Pannkakor'), 
	6, to_date('2022-OCT-31', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'Pannkakor'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'Pannkakor'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'Kanelbullar' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	6, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'Kanelbullar'), 
	6, to_date('2022-OCT-31', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'Kanelbullar'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'Kanelbullar'));

-- Beginning of Deliverable 3
--procedure that takes input of cuisine name and returns restaurants that serve it, deliverable 3 procedure 1
create or replace procedure findRestaurant(cName in varchar2)
IS 
    cursor fR IS SELECT restaurant_name, restaurant_street_address, restaurant_city, restaurant_state, restaurant_zipcode
    FROM restaurants
    WHERE restaurant_cuisine_id = (SELECT cuisine_id FROM cuisines WHERE cuisine_name = cName);
BEGIN
    dbms_output.put_line(cName || ' is offered at these restaurants:');
    dbms_output.put_line(' ');
    for restaurant IN fR
    loop
        dbms_output.put_line('Name: ' || restaurant.restaurant_name);
        dbms_output.put_line('Address: ' || restaurant.restaurant_street_address || ' ' || restaurant.restaurant_city 
        || ', ' || restaurant.restaurant_state || ' ' || restaurant.restaurant_zipcode);
    end loop;
end;
/

--procedure that displays income for restaurants by state and cuisine type
CREATE OR REPlACE VIEW IncomeReport AS
    SELECT (SUM(ORDER_AMOUNT_PAID) + SUM(order_tip)) AS OrderTotal, restaurant_state, restaurant_cuisine_id
    FROM ORDERS, RESTAURANTS
    WHERE restaurant_id = order_restaurant_id 
    GROUP BY restaurant_state, restaurant_cuisine_id;

CREATE OR REPLACE PROCEDURE restaurantIncomeReport
IS
    cursor total IS SELECT ordertotal, restaurant_state, restaurant_cuisine_id FROM IncomeReport;
    cName cuisines.cuisine_name%type;
BEGIN
    for restaurant IN total
    loop
        SELECT cuisine_name INTO cName FROM CUISINES WHERE restaurant.restaurant_cuisine_id = cuisine_id;
        dbms_output.put_line('Restaurants in ' || restaurant.restaurant_state || ' that serve ' || cName || ' have an income of ' || restaurant.ordertotal);
    end loop;
end;
/

-- test findRestaurant and  procedures
BEGIN
    findRestaurant('Indian');
    restaurantIncomeReport;
END;

/
