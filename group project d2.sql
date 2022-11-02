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

-- insert values into menu_items table
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'burger', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'fries', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'pasta', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'salad', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'), 'salmon', 13);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'BBQ'), 'steak', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'BBQ'), 'pork loin', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'BBQ'), 'fillet mignon', 13);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'), 'dal soup', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'), 'rice', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'), 'tandoori chicken', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'), 'samosa', 13);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Italian'), 'lasagna', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Italian'), 'meatballs', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Italian'), 'spaghetti', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Italian'), 'pizza', 13);

INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Ethiopian'), 'meat chunks', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Ethiopian'), 'legume stew', 13);
INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Ethiopian'), 'flatbread', 13);


-- insert values into inventory table
INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL, (SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'burger'), 'burger', 1, 11);
INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL, (SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'steak'), 'steak', 2, 40);
INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL, (SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'samosa'), 'samosa', 3, 23);
INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL, (SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'pizza'), 'pizza', 4, 60);
INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL, (SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'legume stew'), 'legume stew', 5, 17);

-- insert sample customers into database
insert into customers values (customer_id_seq.nextval, 'John Smith', 'jsmith@gmail.com', '100 Light Street', 'Baltimore', 'MD', '21048', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Jane Smith', 'smithj@gmail.com', '200 Light Street', 'Baltimore', 'MD', '21049', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Bill W', 'wbill@gmail.com', '300 Light Street', 'Baltimore', 'MD', '21098', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Julia E', 'ejulia@gmail.com', '150 Light Street', 'Baltimore', 'MD', '21030', '1234567890123456');
insert into customers values (customer_id_seq.nextval, 'Chuck R', 'rchuck@gmail.com', '900 Light Street', 'Baltimore', 'MD', '21093', '1234567890123456');

--turn on server output
set serveroutput on;

-- MEMBER 1 

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

-- test newCuisine and newRestaurant procedures
BEGIN
    newCuisine('Chinese');
    newRestaurant('Rathskeller', '5782 Main St', 'Elkridge', 'MD', 21075, 'German');
END;

-- MEMBER 2
Insert into Waiters values (waiter_id_seq.nextval, 'Matthew Sach', 1);
Insert into Waiters values (waiter_id_seq.nextval, 'Zachary Livesay', 1);

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
end;
/


declare
 TestName varchar2(50) := 'Kenny Somaiya';
 TestRestaurant varchar2(50) := 'Buds Diner';
Begin
 
 Hire_Waiter(TestName, TestRestaurant);

 Show_Waiter_List(TestRestaurant);
end;

-- MEMBER 3

-- cuisine id helper function 
CREATE OR REPLACE FUNCTION FIND_CUISINE_TYPE (cuisineName IN VARCHAR2) RETURN NUMBER
IS
cuisineID cuisines.cuisine_id%type;

BEGIN
SELECT cuisine_id INTO cuisineID FROM cuisines WHERE cuisine_name = cuisineName;
RETURN cuisine_id;
EXCEPTION
WHEN NO_DATA_FOUND THEN
	dbms_output.put_line(‘There is no cuisine ID for ’ || cuisineName);
	RETURN -1;
END;

/

--procedure that creates a menu item and adds it to menu items table
CREATE OR REPLACE PROCEDURE CREATE_MENU_ITEM(itemName IN VARCHAR2, price IN NUMBER)
AS
BEGIN
	INSERT INTO menu_items(menu_item_id_seq.NEXTVAL, cuisine_id_seq.NEXTVAL,itemName, price);
END;

/
	
--create procedure that adds and menu item with its attributes and quantity to the inventory
CREATE OR REPLACE PROCEDURE ADD_MENU_ITEM_TO_INVENTORY (cuisineName IN VARCHAR2, quantity IN NUMBER)
IS
	name menu_items.menu_item_name%type;
	rest_id restaurants.restaurant_id%type;
BEGIN
	SELECT menu_item_name INTO name
	FROM menu_items;
	rest_id = FIND_RESTAURANT_ID();
	INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL, menu_item_id_seq.NEXTVAL, name rest_id, quantity);

END;
/

-- MEMBER 4

-- MEMBER 5

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

begin
    -- adding customer to database with add_customer procedure
    add_customer('Rob Shovan', 'rshovan1@umbc.edu', '10000 Hilltop Circle', 'Catonsville', 'MD', 21076, 1234567890123456);
    add_customer('Will Smith', 'wsmith@gmail.com', '10000 Hilltop Circle', 'Catonsville', 'MD', 21076, 1234567890123456);
    
    -- getting customer names with a specific zipcode, show that customers added with add_customer were entered into the db
    list_customer_in_zip(21076);
    list_customer_in_zip(21075);
    list_customer_in_zip(21048);
end;
