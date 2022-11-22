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

-- insert sample cuisines into database
INSERT INTO cuisines values(cuisine_id_seq.nextval, 'American');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'BBQ');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'Indian');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'Italian');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'Ethiopian');

-- insert sample restaurants into database
INSERT into restaurants values(restaurant_id_seq.nextval, 'Buds Diner', '1601 N Main St', 'Tarboro', 'NC', 27886, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'));
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'Chilis Bar and Grill', '502 Baltimore Pike', 'Bel Air', 'MD', 21014, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'BBQ'));
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'Kabob and Curry', '827 Nursery Rd', 'Linthicum Heights', 'MD', 21090, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'));
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'Mama Santas', '729A Frederick Rd', 'Catonsville', 'MD', 21228, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Italian'));
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'Suya Spot Ethiopian Grill', '10309 Grand Central Ave', 'Owings Mills', 'MD', 21117, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Ethiopian'));

-- insert sample waiters into database
INSERT INTO waiters VALUES (waiter_id_seq.nextval, 'Zachary Livesay', 1);
INSERT INTO waiters VALUES (waiter_id_seq.nextval, 'Kenny Somaiya', 2);
INSERT INTO waiters VALUES (waiter_id_seq.nextval, 'Matthew Sachs', 3);
INSERT INTO waiters VALUES (waiter_id_seq.nextval, 'Jalen Murray', 4);
INSERT INTO waiters VALUES (waiter_id_seq.nextval, 'Jacob Nagel', 5);

-- insert values into menu_items table
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'burger', 10);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'fries', 5);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'pasta', 10);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'salad', 8);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'salmon', 18);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'BBQ'), 'steak', 20);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'BBQ'), 'pork loin', 22);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'BBQ'), 'fillet mignon', 25);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'), 'dal soup', 10);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'), 'rice', 4);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'), 'tandoori chicken', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'), 'samosa', 5);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Italian'), 'lasagna', 14);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Italian'), 'meatballs', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Italian'), 'spaghetti', 11);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Italian'), 'pizza', 9);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Ethiopian'), 'meat chunks', 15);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Ethiopian'), 'legume stew', 12);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Ethiopian'), 'flatbread', 10);


-- insert values into inventory table
INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL, (SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'burger'), 'burger', 1, 11);
INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL, (SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'steak'), 'steak', 2, 40);
INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL, (SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'samosa'), 'samosa', 3, 23);
INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL, (SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'pizza'), 'pizza', 4, 60);
INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL, (SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'legume stew'), 'legume stew', 5, 17);

-- insert sample customers into database
insert into customers values (customer_id_seq.nextval, 'John Smith', 'jsmith@gmail.com', '100 Light Street', 'Baltimore', 'MD', '21048', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Jane Smith', 'smithj@gmail.com', '200 Light Street', 'Baltimore', 'CT', '21049', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Bill W', 'wbill@gmail.com', '300 Light Street', 'Baltimore', 'NY', '21098', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Julia E', 'ejulia@gmail.com', '150 Light Street', 'Baltimore', 'NJ', '21030', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Chuck R', 'rchuck@gmail.com', '900 Light Street', 'Baltimore', 'WV', '21093', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Jackie Q', 'qjackie@gmail.com', '900 Light Street', 'Baltimore', 'WV', '21093', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Jon P', 'pjon@gmail.com', '1100 Light Street', 'Baltimore', 'MD', '21226', '1234567890123456');

INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'burger' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	1, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'burger'),  
	1, to_date('2022-NOV-21', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'burger'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'burger'));

INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'fries' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	1, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'fries'),  
	1, to_date('2022-NOV-21', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'fries'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'fries'));

INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'salad' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	1, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'salad'), 
	1, to_date('2022-FEB-26', 'YYYY-MON-DD'),
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'salad'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'salad'));

INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'steak' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	2, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'steak'), 
	2, to_date('2022-MAY-21', 'YYYY-MON-DD'),
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'steak'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'steak'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'fillet mignon' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	2, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'fillet mignon'), 
	2, to_date('2022-MAY-21', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'fillet mignon'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'fillet mignon'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'dal soup' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	3, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'dal soup'), 
	3, to_date('2022-AUG-20', 'YYYY-MON-DD'),
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'dal soup'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'dal soup'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'tandoori chicken' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	3, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'tandoori chicken'),  
	3, to_date('2022-AUG-20', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'tandoori chicken'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'tandoori chicken'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'lasagna' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	4, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'lasagna'), 
	4, to_date('2022-FEB-26', 'YYYY-MON-DD'),
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'lasagna'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'lasagna'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'meatballs' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	4, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'meatballs'), 
	4, to_date('2022-OCT-31', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'meatballs'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'meatballs'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'pizza' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	4, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'pizza'), 
	4, to_date('2022-OCT-31', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'pizza'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'pizza'));

INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'legume stew' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	5, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'legume stew'),  
	5, to_date('2022-MAY-03', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'legume stew'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'legume stew'));
	
INSERT INTO orders VALUES (order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants, menu_items WHERE menu_item_name = 'flatbread' AND menu_item_cuisine_ID = restaurant_cuisine_id), 
	5, 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'flatbread'), 
	5, to_date('2022-MAY-03', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'flatbread'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'flatbread'));

-- Beginning of Deliverable 2
-- procedure that adds cuisine types
create or replace procedure newCuisine(cuisine_type IN varchar2)
    AS
    BEGIN
        INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, cuisine_type);
    END;
/

-- procedure that adds new restaurant
create or replace procedure newRestaurant(
    r_name varchar2,
    r_street_address varchar2,
    r_city varchar2,
    r_state varchar2,
    r_zipcode number,
    r_cuisine_type varchar2
    )
    AS
    BEGIN
        INSERT INTO restaurants VALUES(
        restaurant_id_seq.nextval,
        r_name,
        r_street_address,
        r_city,
        r_state,
        r_zipcode,
        (SELECT cuisine_id FROM cuisines WHERE cuisine_name = r_cuisine_type));
    END;
/

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

-- End of Member 1 code

-- MEMBER 2: Zachary Livesay

-- helper function that returns the restaurant id using the Restauarnt Name as a parameter
create or replace function FIND_RESTAURANT_ID
 (RestaurantName IN varchar2) RETURN number 
is
 RID restaurants.restaurant_id%type;
 
begin
 select restaurant_id
 into RID
 from restaurants
 where restaurant_name = RestaurantName;
 return RID;
end;
/

-- procedure that hires a waiter by taking in their name and the name of the restaurant the will be employed at
create or replace procedure Hire_Waiter
 (WaiterName IN varchar2, RestaurantName IN varchar2)
is
 WName varchar2(50);
 RName varchar2(50);
 RID number;
 
begin
 WName := WaiterName;
 RName := RestaurantName;
 RID := FIND_RESTAURANT_ID(RName);
 Insert into Waiters values (waiter_id_seq.nextval, WName, RID);
end;
/

-- procedure that shows a list of waiters at the restauarant that matches the one in the parameter
create or replace procedure Show_Waiter_List
 (RestaurantName IN varchar2)
is
cursor waiters_cursor is
    select Waiter_ID, Waiter_Name, Waiter_Restaurant_ID
    from Waiters;
  waiters_rec waiters_cursor%rowtype; 
  
  RName varchar(50);
  RID number;
 
begin
 RName := RestaurantName;
 RID := FIND_RESTAURANT_ID(RName);

 for waiters_rec in waiters_cursor
 loop
 if waiters_rec.waiter_restaurant_id = RID then dbms_output.put_line('Waiter ID: ' || waiters_rec.Waiter_ID || ', Waiter Name: ' || waiters_rec.Waiter_Name
 || ', Waiter Restaurant ID: ' || waiters_rec.Waiter_Restaurant_ID || chr(10));
 --exit when waiters_cursor%notfound;
 end if;
 end loop;
 exception
     when no_data_found then
     dbms_output.put_line('no such waiters exist');
end;
/

declare
 TestName varchar2(50) := 'Patrick Livesay';
 TestRestaurant varchar2(50) := 'Chilis Bar and Grill';
 
 TestName2 varchar2(50) := 'Ryan Dablo';
 TestRestaurant2 varchar2(50) := 'Kabob and Curry';
 
 TestName3 varchar2(50) := 'Jesse Parham';
 TestRestaurant3 varchar2(50) := 'Mama Santas';
 
 TestName4 varchar2(50) := 'Alex Cochrane';
 TestRestaurant4 varchar2(50) := 'Suya Spot Ethiopian Grill';
 
 TestRestaurant5 varchar2(50) := 'Buds Diner';
Begin
 Hire_Waiter(TestName, TestRestaurant);
 Hire_Waiter(TestName2, TestRestaurant2);
 Hire_Waiter(TestName3, TestRestaurant3);
 Hire_Waiter(TestName4, TestRestaurant4);
 Show_Waiter_List(TestRestaurant5);
end;
/

--procedure that displays a sum of tips accumulated by each waiter
create or replace procedure Report_Tips
is
 cursor orders_cursor is
	select w.WAITER_ID, SUM(o.ORDER_TIP) as SumOfTips
	from waiters w, orders o
	where w.waiter_ID = o.ORDER_WAITER_ID
    group by w.WAITER_ID;
 orders_rec orders_cursor%rowtype; 
 
begin
 for orders_rec in orders_cursor
 loop
 dbms_output.put_line('Waiter ID: ' || orders_rec.Waiter_ID || ' | Accumulated Tips: ' || orders_rec.SumOfTips || chr(10));
 end loop;
 exception
     when no_data_found then
     dbms_output.put_line('no such tips to report');
end;
/

exec Report_Tips;

--procedure that displays a sum of tips at restauarnts accumulated by state
create or replace procedure Report_Tips_By_State
is
 cursor orders_cursor is
	select r.RESTAURANT_STATE, SUM(o.ORDER_TIP) as SumOfTips
	from restaurants r, orders o
	where r.RESTAURANT_ID = o.ORDER_RESTAURANT_ID
    group by r.RESTAURANT_STATE;
 orders_rec orders_cursor%rowtype; 
 
begin
 for orders_rec in orders_cursor
 loop
 dbms_output.put_line('State: ' || orders_rec.RESTAURANT_STATE || ' | Accumulated Tips: ' || orders_rec.SumOfTips || chr(10));
 end loop;
 exception
     when no_data_found then
     dbms_output.put_line('no such tips to report');
end;
/

exec Report_Tips_By_State;

-- MEMBER 3 Nalia Pope

-- cuisine id helper function 
CREATE OR REPLACE FUNCTION FIND_CUISINE_TYPE (cuisineName IN VARCHAR2) RETURN NUMBER
IS
cuisineID cuisines.cuisine_id%type;

BEGIN
SELECT cuisine_id INTO cuisineID FROM cuisines WHERE cuisine_name = cuisineName;
RETURN cuisineID;
EXCEPTION
WHEN NO_DATA_FOUND THEN
	dbms_output.put_line('There is no cuisine ID for ' || cuisineName);
	RETURN -1;
END;

/

--procedure that creates a menu item and adds it to menu items table
CREATE OR REPLACE PROCEDURE CREATE_MENU_ITEM(itemName IN VARCHAR2, price IN NUMBER)
AS
BEGIN
	INSERT INTO menu_items VALUES(menu_item_id_seq.NEXTVAL, cuisine_id_seq.NEXTVAL,itemName, price);
END;

/
	
--create procedure that adds and menu item with its attributes and quantity to the inventory
CREATE OR REPLACE PROCEDURE ADD_MENU_ITEM_TO_INVENTORY (cuisineName IN VARCHAR2, quantity IN NUMBER)
IS
	item_name menu_items.menu_item_name%type;
	rest_id restaurants.restaurant_id%type;
BEGIN
	SELECT menu_item_name INTO item_name
	FROM menu_items;
	rest_id := FIND_RESTAURANT_ID();
	INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL, menu_item_id_seq.NEXTVAL, item_name, rest_id, quantity);

END;
/

-- MEMBER 4: Paul Rajapandi

-- MEMBER 5: Rob Shovan

-- find customer given name
create or replace function find_customer_id(customerName in varchar2) return number
is
    customerID customers.customer_id%type;
begin
    select customer_id into customerID from customers where customer_name = customerName;
    return customerID;
EXCEPTION
when NO_DATA_FOUND then
    dbms_output.put_line('There is no customer ID for ' || customerName);
    return -1;
end;
/

-- add a customer given necessary information
-- does not require c_id since that is handled by a sequence
create or replace procedure add_customer
    (
    c_name varchar2,
    c_email varchar2,
    c_street_address varchar2,
    c_city varchar2,
    c_state varchar2,
    c_zipcode number,
    c_credit_card number
    )
as
begin
    insert into customers
    values (customer_id_seq.nextval, c_name, c_email, c_street_address, c_city, c_state, c_zipcode, c_credit_card);
    dbms_output.put_line('New customer ' || c_name || ' added to the database.');
    dbms_output.put_line('');
end;
/

-- list names of customers who live in a given zipcode
create or replace procedure list_customer_in_zip
    (
    zipcode number
    )
as
    cursor c_customer is
        select customer_name
        from customers
        where customer_zipcode = zipcode;
    customer_rec c_customer%rowtype;
    i number; -- iterator to keep track of number of customers in each zipcode
begin
    i := 0;
    dbms_output.put_line('Customers in zipcode ' || zipcode || ':');
    for customer_rec in c_customer
    loop
        dbms_output.put_line(customer_rec.customer_name);
        i := i + 1;
    end loop;
    if i <= 0 then
        dbms_output.put_line('No customers found.');
    end if;
    dbms_output.put_line('');
end;
/

-- highest and lowest spenders report
create or replace procedure highest_lowest_spenders_report
as
    cursor c_customer_highest is
        select order_customer_id, sum(order_amount_paid) as total_spent
        from orders
        group by order_customer_id
        order by total_spent desc;
    customer_highest_rec c_customer_highest%rowtype;
    cursor c_customer_lowest is
        select order_customer_id, sum(order_amount_paid) as total_spent
        from orders
        group by order_customer_id
        order by total_spent asc;
    customer_lowest_rec c_customer_lowest%rowtype;
    customerName customers.customer_name%type;
    i number; -- iterator
begin
    i := 0;
    dbms_output.put_line('Highest spending customers:');
    for customer_highest_rec in c_customer_highest
    loop
        if i < 3 then
            select customer_name into customerName from customers where customer_id = customer_highest_rec.order_customer_id;
            dbms_output.put_line('Customer name: ' || customerName || ' | Amount spent: ' || customer_highest_rec.total_spent);
            i := i+1;
        end if;
    end loop;
    i := 0;
    dbms_output.put_line('');
    dbms_output.put_line('Lowest spending customers:');
    for customer_lowest_rec in c_customer_lowest
    loop
        if i < 3 then
            select customer_name into customerName from customers where customer_id = customer_lowest_rec.order_customer_id;
            dbms_output.put_line('Customer name: ' || customerName || ' | Amount spent: ' || customer_lowest_rec.total_spent);
            i := i+1;
        end if;
    end loop;
    dbms_output.put_line('');
end;
/

-- generous tippers report
create or replace procedure generous_tipper_state_report
as
    cursor c_state_tips is
        select c.customer_state, sum(o.order_tip) as total_tip
        from customers c, orders o
        where c.customer_id = o.order_customer_id
        group by c.customer_state
        order by total_tip desc;
    state_tips_rec c_state_tips%rowtype;
begin
    dbms_output.put_line('Amount tipped by state:');
    for state_tips_rec in c_state_tips
    loop
        dbms_output.put_line('State: ' || state_tips_rec.customer_state || ' | Amount tipped: ' || state_tips_rec.total_tip);
    end loop;
end;
/

-- execution of procedures
begin
    -- adding customer to database with add_customer procedure
    add_customer('Rob Shovan', 'rshovan1@umbc.edu', '10000 Hilltop Circle', 'Catonsville', 'MD', 21076, 1234567890123456);
    add_customer('Will Smith', 'wsmith@gmail.com', '10000 Hilltop Circle', 'Catonsville', 'MD', 21076, 1234567890123456);
    
    -- getting customer names with a specific zipcode, show that customers added with add_customer were entered into the db
    list_customer_in_zip(21076);
    list_customer_in_zip(21075);
    list_customer_in_zip(21048);

    highest_lowest_spenders_report;

    generous_tipper_state_report;
end;
