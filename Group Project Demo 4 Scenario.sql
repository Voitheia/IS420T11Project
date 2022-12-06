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

-- MEMBER 1 Gavin Phillips

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

--procedure that takes input of cuisine name and returns restaurants that serve it
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
    dbms_output.put_line(' ');
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

-- MEMBER 2 Zachary Livesay

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
 dbms_output.put_line('New Waiter ' || WName || ' added to ' || RNAME || '''s database.');
    dbms_output.put_line('');
exception
when others then
    dbms_output.put_line('Encountered an error adding a waiter.');
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
 || ', Waiter Restaurant ID: ' || waiters_rec.Waiter_Restaurant_ID);
 --exit when waiters_cursor%notfound;
 end if;
 end loop;
 exception
	when no_data_found then
	dbms_output.put_line('no such waiters exist');
end;
/

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
 dbms_output.put_line('Waiter ID: ' || orders_rec.Waiter_ID || ', Accumulated Tips: ' || orders_rec.SumOfTips);
 end loop;
end;
/

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
 dbms_output.put_line('State: ' || orders_rec.RESTAURANT_STATE || ', Accumulated Tips: ' || orders_rec.SumOfTips);
 end loop;
end;
/

-- Member 3 code Nalia

--find the type id of this particular menu_item's name
CREATE OR REPLACE FUNCTION FIND_CUISINE_TYPE_ID (p_name IN VARCHAR2) RETURN NUMBER
IS
    cuisineID cuisines.cuisine_id%type;
BEGIN
    SELECT cuisine_id INTO cuisineID FROM cuisines WHERE cuisine_name = p_name;
    RETURN cuisineID;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('There is no cuisine type ID for ' || p_name);
        RETURN -1;
    
END;
/

--procedure that creates a menu item and adds it to menu items table
-- CREATE_MENU_ITEM procedure
CREATE OR REPLACE PROCEDURE CREATE_MENU_ITEM (c_type_id IN NUMBER,itemName IN VARCHAR2, price IN NUMBER) 
IS
BEGIN
    INSERT INTO menu_items VALUES (menu_item_id_seq.NEXTVAL, c_type_id, itemName, price);
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Invalid cuisine type id, item name or price.');
END;
/

--helper function for FIND_MENU_ITEM_ID
CREATE OR REPLACE FUNCTION FIND_MENU_ITEM_ID (name IN VARCHAR2) RETURN NUMBER
IS
    item_id NUMBER;
BEGIN
    SELECT menu_item_id INTO item_id FROM menu_items WHERE menu_item_name = name;
    RETURN item_id;
    
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('There is no menu_item id for ' || name);
END;
/

--ADD MENU_ITEM TO INVENTORY PROCEDURE
CREATE OR REPLACE PROCEDURE ADD_MENU_ITEM_TO_INVENTORY (rest_name IN VARCHAR2, itemName IN VARCHAR2, quantity IN NUMBER)
IS
    item_name menu_items.menu_item_name%type;
    mi_id menu_items.menu_item_id%type;
    rest_id restaurants.restaurant_id%type;
BEGIN
    mi_id := FIND_MENU_ITEM_ID(itemName);
    rest_id := FIND_RESTAURANT_ID(rest_name);
    INSERT INTO inventory VALUES (inventory_id_seq.NEXTVAL,mi_id,itemName,rest_id,quantity);
EXCEPTION
WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('invalid restaurant name, menu item name or quantity');
    
END;
/

--UPDATE_MENU_ITEM_INVENTORY 
CREATE OR REPLACE PROCEDURE UPDATE_MENU_ITEM_INVENTORY (rest_id IN NUMBER, mitem_id NUMBER, p_quantity IN NUMBER)
IS 
BEGIN
    UPDATE inventory
    SET inventory_quantity = inventory_quantity - p_quantity
    WHERE inventory_restaurant_id = rest_id AND
    inventory_menu_item_id = mitem_id;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Either syntax or logic error');
END;
/

--REPORT_MENU_ITEMS procedure
CREATE OR REPLACE PROCEDURE REPORT_MENU_ITEMS
AS
    CURSOR report_info IS SELECT menu_item_cuisine_id, inventory_menu_item_name, inventory_quantity FROM menu_items, inventory
    WHERE menu_item_id = inventory_menu_item_id;
    c_id menu_items.menu_item_cuisine_id%type;
    item_name inventory.inventory_menu_item_name%type;
    amount inventory.inventory_quantity%type;
    
BEGIN
    OPEN report_info;
    LOOP
        FETCH report_info INTO c_id, item_name, amount;
        EXIT WHEN report_info%NOTFOUND;
        dbms_output.put_line('Cuisine id: ' || c_id || ' Item Name: ' || item_name || ' Amount: ' || amount);
    END LOOP;
    CLOSE report_info;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Incorrect execution of explicit cursor.');
END;
/

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
exception
when others then
    dbms_output.put_line('Encountered an error adding a customer.');
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
exception
when others then
    dbms_output.put_line('Encountered an error listing customers in zipcode.');
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
exception
when others then
    dbms_output.put_line('Encountered an error generating highest and lowest spenders report.');
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
exception
when others then
    dbms_output.put_line('Encountered an error generating tip report.');
end;
/

DECLARE
-- local variable
	
BEGIN

-- Member 1: Gavin Phillips

-- Demonstration of the newCuisineprocedure

	newCuisine('American');
    newCuisine('Italian');
    newCuisine('BBQ');
    newCuisine('Indian');
    newCuisine('Ethiopian');
	
	-- Demonstration of the newRestaurant procedure

    newRestaurant('Ribs_R_US', '5782 Main St', 'Baltimore', 'MD', 21250, 'American');
    newRestaurant('Bella Italia', '1601 N Main St', 'Tarboro', 'NC', 21043, 'Italian');
    newRestaurant('Roma', '502 Baltimore Pike', 'Bel Air', 'MD', 21043, 'Italian');
    newRestaurant('Bull Roast', '827 Nursery Rd', 'Linthicum Heights', 'NY', 10013, 'BBQ');
    newRestaurant('Taj Mahal', '729A Frederick Rd', 'Catonsville', 'NY', 10013, 'Indian');
    newRestaurant('Selasie', '10309 Grand Central Ave', 'Owings Mills', 'PA', 16822, 'Ethiopian');
    newRestaurant('Ethiop', '1345 First St', 'Tarboro', 'PA', 16822,  'Ethiopian');
	
	-- Demonstration of the findRestaurant procedure

    findRestaurant('Italian');
    findRestaurant('Ethiopian');

-- Member 2: Zachary Livesay

	Hire_Waiter ('Jack', 'Ribs_R_US');
	Hire_Waiter ('Jill', 'Ribs_R_US');
	Hire_Waiter ('Wendy', 'Ribs_R_US');
	Hire_Waiter ('Hailey', 'Ribs_R_US');
	Hire_Waiter ('Mary', 'Bella Italia');
	Hire_Waiter ('Pat', 'Bella Italia');
	Hire_Waiter ('Michael', 'Bella Italia');
	Hire_Waiter ('Rakesh', 'Bella Italia');
	Hire_Waiter ('Verma', 'Bella Italia');
	Hire_Waiter ('Mike', 'Roma');
	Hire_Waiter ('Judy', 'Roma');
	Hire_Waiter ('Trevor', 'Selasie');
	Hire_Waiter ('Trudy', 'Ethiop');
	Hire_Waiter ('Trisha', 'Ethiop');
	Hire_Waiter ('Tariq', 'Ethiop');
	Hire_Waiter ('Chap', 'Taj Mahal');
	Hire_Waiter ('Hannah', 'Bull Roast');

	show_waiter_list('Ethiop');

end;
/

DECLARE
-- local variable
    american_cuisine_type1 NUMBER;
    american_cuisine_type2 NUMBER;
    american_cuisine_type3 NUMBER;
    american_cuisine_type4 NUMBER;
    american_cuisine_type5 NUMBER;
    
    italian_cuisine_type1 NUMBER;
    italian_cuisine_type2 NUMBER;
    italian_cuisine_type3 NUMBER;
    italian_cuisine_type4 NUMBER;
    
    bbq_cuisine_type1 NUMBER;
    bbq_cuisine_type2 NUMBER;
    bbq_cuisine_type3 NUMBER;
    bbq_cuisine_type4 NUMBER;
    
    indian_cuisine_type1 NUMBER;
    indian_cuisine_type2 NUMBER;
    indian_cuisine_type3 NUMBER;
    indian_cuisine_type4 NUMBER;
    
    ethiopian_cuisine_type1 NUMBER;
    ethiopian_cuisine_type2 NUMBER;
    ethiopian_cuisine_type3 NUMBER;
    
    i_rest_id NUMBER;
    i_menu_item_num NUMBER;
    
    e_rest_id NUMBER;
    e_menu_item_num NUMBER;
    
    b_rest_id NUMBER;
    b_menu_item_num NUMBER;
    
    b2_rest_id NUMBER;
    b2_menu_item_num NUMBER;
BEGIN

    
    -- Member 3: Nalia Pope

    american_cuisine_type1 := FIND_CUISINE_TYPE_ID('American');
    CREATE_MENU_ITEM(american_cuisine_type1,'Burger', 10);
    american_cuisine_type2 := FIND_CUISINE_TYPE_ID('American');
    CREATE_MENU_ITEM(american_cuisine_type2,'fries', 5);
    american_cuisine_type3 := FIND_CUISINE_TYPE_ID('American');
    CREATE_MENU_ITEM(american_cuisine_type3,'pasta', 15);
    american_cuisine_type4 := FIND_CUISINE_TYPE_ID('American');
    CREATE_MENU_ITEM(american_cuisine_type4,'salad', 10);
    american_cuisine_type5 := FIND_CUISINE_TYPE_ID('American');
    CREATE_MENU_ITEM(american_cuisine_type5,'salmon', 20);
    

--add all menu items for the italian cuisine in the DB by calling the appropriate procedure/function
    
    italian_cuisine_type1 := FIND_CUISINE_TYPE_ID('Italian');
    CREATE_MENU_ITEM(italian_cuisine_type1,'lasagna', 15);
    italian_cuisine_type2 := FIND_CUISINE_TYPE_ID('Italian');
    CREATE_MENU_ITEM(italian_cuisine_type2,'meatballs', 10);
    italian_cuisine_type3 := FIND_CUISINE_TYPE_ID('Italian');
    CREATE_MENU_ITEM(italian_cuisine_type3,'spaghetti', 15);
    italian_cuisine_type4 := FIND_CUISINE_TYPE_ID('Italian');
    CREATE_MENU_ITEM(italian_cuisine_type4,'pizza', 20);
    
--add all menu items for the BBQ cuisine in the DB by calling the appropriate procedure/function
    
    bbq_cuisine_type1 := FIND_CUISINE_TYPE_ID('BBQ');
    CREATE_MENU_ITEM(bbq_cuisine_type1,'steak', 25);
    bbq_cuisine_type2 := FIND_CUISINE_TYPE_ID('BBQ');
    CREATE_MENU_ITEM(bbq_cuisine_type2,'burger', 10);
    bbq_cuisine_type3 := FIND_CUISINE_TYPE_ID('BBQ');
    CREATE_MENU_ITEM(bbq_cuisine_type3,'pork loin', 15);
    bbq_cuisine_type4 := FIND_CUISINE_TYPE_ID('BBQ');
    CREATE_MENU_ITEM(bbq_cuisine_type4,'filet mignon', 30);
    

--add all menu items for the Indian cuisine in the DB by calling the appropriate procedure/function
    
    indian_cuisine_type1 := FIND_CUISINE_TYPE_ID('Indian');
    CREATE_MENU_ITEM(indian_cuisine_type1,'dal soup', 10);
    indian_cuisine_type2 := FIND_CUISINE_TYPE_ID('Indian');
    CREATE_MENU_ITEM(indian_cuisine_type2,'rice', 5);
    indian_cuisine_type3 := FIND_CUISINE_TYPE_ID('Indian');
    CREATE_MENU_ITEM(indian_cuisine_type3,'tandoori chicken', 10);
    indian_cuisine_type4 := FIND_CUISINE_TYPE_ID('Indian');
    CREATE_MENU_ITEM(indian_cuisine_type4,'samosa', 8);
    
--add all menu items for the Ethiopian cuisine in the DB by calling the appropriate procedure/function

    ethiopian_cuisine_type1 := FIND_CUISINE_TYPE_ID('Ethiopian');
    CREATE_MENU_ITEM(ethiopian_cuisine_type1,'meat chunks', 12);
    ethiopian_cuisine_type2 := FIND_CUISINE_TYPE_ID('Ethiopian');
    CREATE_MENU_ITEM(ethiopian_cuisine_type2,'legume stew', 10);
    ethiopian_cuisine_type3 := FIND_CUISINE_TYPE_ID('Ethiopian');
    CREATE_MENU_ITEM(ethiopian_cuisine_type3,'flatbread', 3);
   
    


--add burger to the inventory of the Ribs_R_US restaurant: quntity: 50
 ADD_MENU_ITEM_TO_INVENTORY('Ribs_R_US','burger',50);

-- Add fries to the inventory of the Ribs_R_US restaurant: quantity: 150
 ADD_MENU_ITEM_TO_INVENTORY('Ribs_R_US','fries',150);
--the above line works correctly!

--Add lasagna to the inventory of the Bella Italia restaurant: quantity: 10
 ADD_MENU_ITEM_TO_INVENTORY('Bella Italia','lasagna',10);
--the above line works correctly!

--Add steak to the inventory of the Bull Roast restaurant: quantity: 15
 ADD_MENU_ITEM_TO_INVENTORY('Bull Roast','steak',15);

--Add pork loin to the inventory of the Bull Roast restaurant: quantity: 50
 ADD_MENU_ITEM_TO_INVENTORY('Bull Roast','pork loin',50);

--Add fillet mignon to the inventory of the Bull Roast restaurant: quantity: 5
 ADD_MENU_ITEM_TO_INVENTORY('Bull Roast','filet mignon',5);

--Add dal soup to the inventory of the Taj Mahal restaurant: quantity: 50
 ADD_MENU_ITEM_TO_INVENTORY('Taj Mahal','dal soup',50);

--Add rice to the inventory of the Taj Mahal restaurant: quantity: 500
 ADD_MENU_ITEM_TO_INVENTORY('Taj Mahal','rice',500);

--Add samosa to the inventory of the Taj Mahal restaurant: quantity: 150
 ADD_MENU_ITEM_TO_INVENTORY('Taj Mahal','samosa',150);

--Add meat chunks to the inventory of the Selasie restaurant: quantity: 150
 ADD_MENU_ITEM_TO_INVENTORY('Selasie','meat chunks',150);

--Add legume stew to the inventory of the Selasie restaurant: quantity: 150
 ADD_MENU_ITEM_TO_INVENTORY('Selasie','legume stew',150);

--Add flatbread to the inventory of the Selasie restaurant: quantity: 500
 ADD_MENU_ITEM_TO_INVENTORY('Selasie','flatbread',500);

--Add meat chunks to the inventory of the Ethiop restaurant: quantity: 150
 ADD_MENU_ITEM_TO_INVENTORY('Ethiop','meat chunks',150);

--Add legume stew to the inventory of the Ethiop restaurant: quantity: 150
 ADD_MENU_ITEM_TO_INVENTORY('Ethiop','legume stew',150);

--Add flatbread to the inventory of the Ethiop restaurant: quantity: 500
 ADD_MENU_ITEM_TO_INVENTORY('Ethiop','flatbread',500);


-- Member 5: Rob Shovan

	add_customer ('Cust1','cust1@gmail.com','123 Fake Rd','Baltimore','MD',21045,1234567890123456);
	add_customer ('Cust11','cust11@gmail.com','123 Fake Rd','Baltimore','MD',21045,1234567890123456);
	add_customer ('Cust3','cust3@gmail.com','123 Fake Rd','Baltimore','MD',21046,1234567890123456);
	add_customer ('Cust111','cust111@gmail.com','123 Fake Rd','Baltimore','MD',21045,1234567890123456);
	add_customer ('CustNY1','custNY1@gmail.com','123 Fake Rd','New York','NY',10045,1234567890123456);
	add_customer ('CustNY2','custNY2@gmail.com','123 Fake Rd','New York','NY',10045,1234567890123456);
	add_customer ('CustNY3','custNY3@gmail.com','123 Fake Rd','New York','NY',10045,1234567890123456);
	add_customer ('CustPA1','custPA1@gmail.com','123 Fake Rd','Pittsburg','PA',16822,1234567890123456);
	add_customer ('CustPA2','custPA2@gmail.com','123 Fake Rd','Pittsburg','PA',16822,1234567890123456);
	add_customer ('CustPA3','custPA3@gmail.com','123 Fake Rd','Pittsburg','PA',16822,1234567890123456);
	add_customer ('CustPA4','custPA4@gmail.com','123 Fake Rd','Pittsburg','PA',16822,1234567890123456);
	add_customer ('CustPA5','custPA5@gmail.com','123 Fake Rd','Pittsburg','PA',16822,1234567890123456);
	add_customer ('CustPA6','custPA6@gmail.com','123 Fake Rd','Pittsburg','PA',16822,1234567890123456);

end;
/

INSERT INTO orders VALUES 
	(order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants WHERE restaurant_name = 'Bella Italia'), 
	(Select customer_id FROM customers WHERE customer_name = 'Cust1'), 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'pizza'),  
	(SELECT waiter_id FROM waiters WHERE waiter_name = 'Mary'), 
	to_date('2022-OCT-10', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'pizza'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'pizza'));
	
INSERT INTO orders VALUES 
	(order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants WHERE restaurant_name = 'Bella Italia'), 
	(Select customer_id FROM customers WHERE customer_name = 'Cust11'), 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'spaghetti'),  
	(SELECT waiter_id FROM waiters WHERE waiter_name = 'Mary'), 
	to_date('2022-OCT-15', 'YYYY-MON-DD'), 
	((SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'spaghetti') * 2), 
	((SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'spaghetti') * 2));
	
INSERT INTO orders VALUES 
	(order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants WHERE restaurant_name = 'Bella Italia'), 
	(Select customer_id FROM customers WHERE customer_name = 'Cust11'), 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'pizza'),  
	(SELECT waiter_id FROM waiters WHERE waiter_name = 'Mary'), 
	to_date('2022-OCT-15', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'pizza'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'pizza'));
	
INSERT INTO orders VALUES 
	(order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants WHERE restaurant_name = 'Bull Roast'), 
	(Select customer_id FROM customers WHERE customer_name = 'CustNY1'), 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'filet mignon'),  
	(SELECT waiter_id FROM waiters WHERE waiter_name = 'Hannah'), 
	to_date('2022-NOV-01', 'YYYY-MON-DD'), 
	((SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'filet mignon') * 2), 
	((SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'filet mignon') * 2));
	
INSERT INTO orders VALUES 
	(order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants WHERE restaurant_name = 'Bull Roast'), 
	(Select customer_id FROM customers WHERE customer_name = 'CustNY1'), 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'filet mignon'),  
	(SELECT waiter_id FROM waiters WHERE waiter_name = 'Hannah'), 
	to_date('2022-NOV-02', 'YYYY-MON-DD'), 
	((SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'filet mignon') * 2), 
	((SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'filet mignon') * 2));
	
INSERT INTO orders VALUES 
	(order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants WHERE restaurant_name = 'Bull Roast'), 
	(Select customer_id FROM customers WHERE customer_name = 'CustNY2'), 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'pork loin'),  
	(SELECT waiter_id FROM waiters WHERE waiter_name = 'Hannah'), 
	to_date('2022-NOV-01', 'YYYY-MON-DD'), 
	(SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'pork loin'), 
	(SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'pork loin'));
	
INSERT INTO orders VALUES 
	(order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants WHERE restaurant_name = 'Ethiop'), 
	(Select customer_id FROM customers WHERE customer_name = 'CustPA1'), 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'meat chunks'),  
	(SELECT waiter_id FROM waiters WHERE waiter_name = 'Trisha'), 
	to_date('2022-DEC-01', 'YYYY-MON-DD'), 
	((SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'meat chunks') * 10), 
	((SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'meat chunks') * 10));
	
INSERT INTO orders VALUES 
	(order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants WHERE restaurant_name = 'Ethiop'), 
	(Select customer_id FROM customers WHERE customer_name = 'CustPA1'), 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'meat chunks'),  
	(SELECT waiter_id FROM waiters WHERE waiter_name = 'Trisha'), 
	to_date('2022-DEC-01', 'YYYY-MON-DD'), 
	((SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'meat chunks') * 10), 
	((SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'meat chunks') * 10));
	
INSERT INTO orders VALUES 
	(order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants WHERE restaurant_name = 'Ethiop'), 
	(Select customer_id FROM customers WHERE customer_name = 'CustPA1'), 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'meat chunks'),  
	(SELECT waiter_id FROM waiters WHERE waiter_name = 'Trisha'), 
	to_date('2022-DEC-05', 'YYYY-MON-DD'), 
	((SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'meat chunks') * 10), 
	((SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'meat chunks') * 10));
	
INSERT INTO orders VALUES 
	(order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants WHERE restaurant_name = 'Ethiop'), 
	(Select customer_id FROM customers WHERE customer_name = 'CustPA2'), 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'legume stew'),  
	(SELECT waiter_id FROM waiters WHERE waiter_name = 'Trevor'), 
	to_date('2022-DEC-01', 'YYYY-MON-DD'), 
	((SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'legume stew') * 10), 
	((SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'legume stew') * 10));
	
INSERT INTO orders VALUES 
	(order_id_seq.nextval, 
	(SELECT restaurant_ID FROM restaurants WHERE restaurant_name = 'Ethiop'), 
	(Select customer_id FROM customers WHERE customer_name = 'CustPA2'), 
	(SELECT menu_item_id FROM menu_items WHERE menu_item_name = 'legume stew'),  
	(SELECT waiter_id FROM waiters WHERE waiter_name = 'Trevor'), 
	to_date('2022-DEC-06', 'YYYY-MON-DD'), 
	((SELECT menu_item_price FROM menu_items WHERE menu_item_name = 'legume stew') * 10), 
	((SELECT ROUND(menu_item_price*.2, 1) FROM menu_items WHERE menu_item_name = 'legume stew') * 10));

Declare
    i_rest_id NUMBER;
    i_menu_item_num NUMBER;
    
    e_rest_id NUMBER;
    e_menu_item_num NUMBER;
    
    b_rest_id NUMBER;
    b_menu_item_num NUMBER;
    
    b2_rest_id NUMBER;
    b2_menu_item_num NUMBER;
Begin

--Update menu item inventory: Reduce the inventory of rice by 25 at the Taj Mahal
    i_rest_id := FIND_RESTAURANT_ID ('Taj Mahal');
    i_menu_item_num := FIND_MENU_ITEM_ID('rice');
    UPDATE_MENU_ITEM_INVENTORY(i_rest_id,i_menu_item_num,25);

--Update menu item inventory: Reduce the inventory of meat chunks by 50 at the Selasie
    e_rest_id := FIND_RESTAURANT_ID ('Selasie');
    e_menu_item_num := FIND_MENU_ITEM_ID('meat chunks');
    UPDATE_MENU_ITEM_INVENTORY(e_rest_id,e_menu_item_num,50);

--Update menu item inventory: Reduce the inventory of filet mignon by 2 at the  Bull Roast
    b_rest_id := FIND_RESTAURANT_ID ('Bull Roast');
    b_menu_item_num := FIND_MENU_ITEM_ID('filet mignon');
    UPDATE_MENU_ITEM_INVENTORY(b_rest_id,b_menu_item_num,2);

--Update menu item inventory: Reduce the inventory of filet mignon by 2 at the  Bull Roast
    b2_rest_id := FIND_RESTAURANT_ID ('Bull Roast');
    b2_menu_item_num := FIND_MENU_ITEM_ID('filet mignon');
    UPDATE_MENU_ITEM_INVENTORY(b2_rest_id,b2_menu_item_num,2);

end;
/
--write out the output: '------------- Initial Inventory for Ethiop restaurant ---------'
--run a query to show all information from restaurant_inventory for the Ethiop restaurant
DECLARE
    CURSOR restaurant_info IS SELECT restaurants.restaurant_name, inventory_id, inventory_menu_item_id, inventory_menu_item_name, inventory_restaurant_id, inventory_quantity 
    FROM restaurants, inventory WHERE restaurant_id = inventory_restaurant_id AND restaurant_name = 'Ethiop';
    rest_name VARCHAR2(50);
    in_id NUMBER;
    in_item_id NUMBER;
    in_item_name VARCHAR2(20);
    in_rest_id NUMBER;
    in_amt NUMBER;
BEGIN
    dbms_output.put_line('-------------------- Inital Inventory for Ethipo restaurant --------------------------'); 
    OPEN restaurant_info;
    LOOP
        FETCH restaurant_info INTO rest_name, in_id, in_item_id,in_item_name, in_rest_id,in_amt;
        EXIT WHEN restaurant_info%NOTFOUND;
        dbms_output.put_line('Restaurant Name: '|| rest_name ||
        ' Inventory ID:' || in_id || 
        ' Inventory Menu Item ID: ' || in_item_id || 
        ' Inventory Menu Item Name: ' || in_item_name || 
        ' Restaurant ID: ' || in_rest_id || 
        ' Item Quantity: ' || in_amt);
    END LOOP;
    CLOSE restaurant_info;
END;
/


--update menu item inventory: reduce the inventory of meat chunks by 30 at the Ethiop
DECLARE
    e_rest_id NUMBER;
    e_menu_item_num NUMBER;
BEGIN
    e_rest_id := FIND_RESTAURANT_ID ('Ethiop');
    e_menu_item_num := FIND_MENU_ITEM_ID('meat chunks');
    UPDATE_MENU_ITEM_INVENTORY(e_rest_id,e_menu_item_num,30);

END;
/


--Update menu item inventory: Reduce the inventory of meat chunks by 30 at the Ethiop
DECLARE
    e2_rest_id NUMBER;
    e2_menu_item_num NUMBER;
BEGIN
    e2_rest_id := FIND_RESTAURANT_ID ('Ethiop');
    e2_menu_item_num := FIND_MENU_ITEM_ID('meat chunks');
    UPDATE_MENU_ITEM_INVENTORY(e2_rest_id,e2_menu_item_num,30);

END;
/
--Update menu item inventory: Reduce the inventory of legume stew by 20 at the Ethiop
DECLARE
    e3_rest_id NUMBER;
    e3_menu_item_num NUMBER;
BEGIN
    e3_rest_id := FIND_RESTAURANT_ID ('Ethiop');
    e3_menu_item_num := FIND_MENU_ITEM_ID('legume stew');
    UPDATE_MENU_ITEM_INVENTORY(e3_rest_id,e3_menu_item_num,20);

END;
/

--Write on the output: ‘  ---------------  Final Inventory for Ethiop restaurant -------------------‘
--Run a query to show all information from restaurant_inventory for the Ethiop restaurant

DECLARE
    CURSOR restaurant_info2 IS SELECT restaurants.restaurant_name, inventory_id, inventory_menu_item_id, inventory_menu_item_name, inventory_restaurant_id, inventory_quantity 
    FROM restaurants, inventory WHERE restaurant_id = inventory_restaurant_id AND restaurant_name = 'Ethiop';
    rest_name VARCHAR2(50);
    in_id NUMBER;
    in_item_id NUMBER;
    in_item_name VARCHAR2(20);
    in_rest_id NUMBER;
    in_amt NUMBER;
BEGIN
    dbms_output.put_line('-------------------- Final Inventory for Ethipo restaurant --------------------------'); 
    OPEN restaurant_info2;
    LOOP
        FETCH restaurant_info2 INTO rest_name, in_id, in_item_id,in_item_name, in_rest_id,in_amt;
        EXIT WHEN restaurant_info2%NOTFOUND;
        dbms_output.put_line('Restaurant Name: '|| rest_name ||
        ' Inventory ID:' || in_id || 
        ' Inventory Menu Item ID: ' || in_item_id || 
        ' Inventory Menu Item Name: ' || in_item_name || 
        ' Restaurant ID: ' || in_rest_id || 
        ' Item Quantity: ' || in_amt);
    END LOOP;
    CLOSE restaurant_info2;
END;
/


-- Reports
Declare
Begin
dbms_output.put_line('========================================================================');
dbms_output.put_line('========================================================================');
dbms_output.put_line('                  ----    R E P O R T S   below ----');
dbms_output.put_line('========================================================================');
dbms_output.put_line('========================================================================');


 ----------- REPORT BY MEMBER 1: ’ || Gavin Phillips || ‘ -------------
dbms_output.put_line(' ----------- REPORT BY MEMBER 2: Gavin Phillips ------------- ' || chr(10));
restaurantIncomeReport;
dbms_output.put_line(chr(10));
 
 ----------- REPORT BY MEMBER 2: ’ || Zachary Livesay || ‘ -------------
dbms_output.put_line(' ----------- REPORT BY MEMBER 2: Zachary Livesay ------------- ' || chr(10));
Report_Tips;
Report_Tips_by_State;
dbms_output.put_line(chr(10));

 ----------- REPORT BY MEMBER 3: ’ || Nalia Pope || ‘ -------------

dbms_output.put_line('-------------- REPORT BY MEMBER 3: NALIA POPE --------------------');
REPORT_MENU_ITEMS();
dbms_output.put_line(chr(10));

 ----------- REPORT BY MEMBER 4: ’ || Paul Rajapandi || ‘ -------------


 ----------- REPORT BY MEMBER 5: ’ || Rob Shovan || ‘ -------------
dbms_output.put_line(' ----------- REPORT BY MEMBER 5: Robert Shovan ------------- ' || chr(10));
highest_lowest_spenders_report;
generous_tipper_state_report;
 
END;
