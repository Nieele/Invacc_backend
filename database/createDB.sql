BEGIN;

CREATE TABLE IF NOT EXISTS Warehouses (
    id       serial        PRIMARY KEY,
    name     varchar(50)   NOT NULL  UNIQUE,
    phone    varchar(15)   NOT NULL  UNIQUE,
    email    varchar(50)   NOT NULL  UNIQUE,
    address  varchar(100)  NOT NULL  UNIQUE,
    active   boolean       NOT NULL  DEFAULT true
);

CREATE TABLE IF NOT EXISTS StaffPositions (
    id    serial       PRIMARY KEY,
    name  varchar(50)  NOT NULL  UNIQUE
);

CREATE TABLE IF NOT EXISTS Staff (
    id            serial       PRIMARY KEY,
    username      varchar(50)  NOT NULL  UNIQUE,
    full_name     varchar(50)  NOT NULL,
    email         varchar(50)  NOT NULL  UNIQUE,
    phone         varchar(50)  NULL,
    position      int          NOT NULL,
    warehouse_id  int          NULL,
    active        boolean      NOT NULL  DEFAULT TRUE,  
    FOREIGN KEY (position)     REFERENCES StaffPositions(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(id)     ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Items (
    id            serial         PRIMARY KEY,
    warehouse_id  int            NOT NULL,
    name          varchar(50)    NOT NULL,
    description   text           NULL,
    properties    jsonb          NULL,
    quality       int            NOT NULL  DEFAULT 100  CHECK (quality >= 0 AND quality <= 100),
    price         decimal(10,2)  NOT NULL               CHECK (price > 0),
    late_penalty  decimal(10,2)  NOT NULL               CHECK (late_penalty > 0),
    active        boolean        NOT NULL  DEFAULT TRUE,
    archived      boolean        NOT NULL  DEFAULT FALSE,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Items_metadata (
    item_id     serial     PRIMARY KEY,
    create_at   timestamp  NOT NULL  DEFAULT current_timestamp,
    create_by   int        NOT NULL,
    update_at   timestamp  NOT NULL  DEFAULT current_timestamp,
    update_by   int        NOT NULL,
    FOREIGN KEY (item_id)    REFERENCES Items(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (create_by)  REFERENCES Staff(id) ON DELETE CASCADE  ON UPDATE CASCADE,
    FOREIGN KEY (update_by)  REFERENCES Staff(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS ItemsServiceHistory (
    id             serial       PRIMARY KEY,
    item_id        int          NOT NULL,
    old_quality    int          NOT NULL  CHECK (old_quality >= 0 AND old_quality <= 100),
    new_quality    int          NOT NULL  CHECK (new_quality >= 0 AND new_quality <= 100),
    change_reason  text         NOT NULL,
    FOREIGN KEY (item_id) REFERENCES Items(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS ItemsServiceHistory_metadata (
    service_id  serial     PRIMARY KEY,
    changed_at  timestamp  NOT NULL  DEFAULT current_timestamp,
    changed_by  int        NOT NULL,
    FOREIGN KEY (service_id) REFERENCES ItemsServiceHistory(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Categories (
    id             serial       PRIMARY KEY,
    category_name  varchar(50)  NOT NULL  UNIQUE
);

CREATE TABLE IF NOT EXISTS ItemsCategories (
    item_id      int  NOT NULL,
    category_id  int  NOT NULL,
    FOREIGN KEY (item_id)     REFERENCES Items (id)      ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories (id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(item_id, category_id)
);

CREATE TABLE IF NOT EXISTS Discounts (
    id          serial       PRIMARY KEY,
    name        varchar(50)  NOT NULL,
    description text         NULL,
    percent     int          NOT NULL                        CHECK (percent > 0 AND percent < 100),
    start_date  date         NOT NULL  DEFAULT current_date  CHECK (start_date >= current_date),
    end_date    date         NOT NULL                        CHECK (end_date > current_date AND end_date > start_date)
);

CREATE TABLE IF NOT EXISTS Discounts_metadata (
    discount_id  serial     PRIMARY KEY,
    create_at   timestamp  NOT NULL  DEFAULT current_timestamp,
    create_by   int        NOT NULL,
    FOREIGN KEY (discount_id) REFERENCES Discounts(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (create_by)  REFERENCES Staff(id)     ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS ItemsDiscounts (
    item_id      int  NOT NULL,
    discount_id  int  NOT NULL,
    FOREIGN KEY (item_id)     REFERENCES Items (id)     ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (discount_id) REFERENCES Discounts (id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(item_id, discount_id)
);

CREATE TABLE IF NOT EXISTS ItemsImages (
    id       serial   PRIMARY KEY,
    item_id  int      NOT NULL,
    url      text     NOT NULL,
    is_main  boolean  NOT NULL  DEFAULT FALSE,
    FOREIGN KEY (item_id) REFERENCES Items(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS ItemsImages_metadata (
    id         serial     PRIMARY KEY,
    create_at  timestamp  NOT NULL,
    create_by  int        NOT NULL,
    FOREIGN KEY (id) REFERENCES ItemsImages(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Customers (
    id  serial  PRIMARY KEY,
    full_name     varchar(50)   NOT NULL,
    email         varchar(50)   NULL      UNIQUE,
    email_verify  boolean       NOT NULL  DEFAULT FALSE,
    phone         varchar(50)   NULL      UNIQUE,
    phone_verify  boolean       NOT NULL  DEFAULT FALSE,
    address       varchar(255)  NULL,
    passport      varchar(50)   NULL
);

CREATE TABLE IF NOT EXISTS CustomersAuth (
    id             serial        PRIMARY KEY,
    username       varchar(50)   NOT NULL  UNIQUE,
    password_hash  varchar(255)  NOT NULL,
    FOREIGN KEY (id) REFERENCES Customers(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Customers_metadata (
    id         serial PRIMARY KEY,
    create_at  timestamp  NOT NULL  DEFAULT current_timestamp,
    update_at  timestamp  NOT NULL  DEFAULT current_timestamp,
    FOREIGN KEY (id) REFERENCES Customers(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Sessions (
    id           serial        PRIMARY KEY,
    customer_id  int           NOT NULL,
    token        varchar(255)  NOT NULL,
    create_at    timestamp     NOT NULL  DEFAULT current_timestamp,
    expires_at   timestamp     NOT NULL  DEFAULT current_timestamp + INTERVAL '1 month',
    FOREIGN KEY (id) REFERENCES Customers(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (expires_at < create_at)
);

CREATE TABLE IF NOT EXISTS Rent (
    id               serial         PRIMARY KEY,
    item_id          int            NOT NULL  UNIQUE,
    customer_id      int            NOT NULL,
    start_rent_time  timestamp      NOT NULL  DEFAULT current_timestamp,
    end_rent_time    timestamp      NOT NULL,
    overdue          boolean        NOT NULL  DEFAULT FALSE,
    total_payments   decimal(10,2)  NOT NULL,
    FOREIGN KEY (item_id)      REFERENCES Items (id)      ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (customer_id)  REFERENCES Customers (id)  ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (start_rent_time < end_rent_time)
);

CREATE TABLE IF NOT EXISTS RentHistory (
    id                 serial         PRIMARY KEY,
    item_id            int            NOT NULL,
    warehouse_id       int            NOT NULL,
    customer_id        int            NOT NULL,
    start_rent_time    timestamp      NOT NULL,
    end_rent_time      timestamp      NOT NULL,
    overdue_rent_days  int            NOT NULL,
    total_payments     decimal(10,2)  NOT NULL,
    FOREIGN KEY (item_id)       REFERENCES Items (id)       ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (warehouse_id)  REFERENCES Warehouses (id)  ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (customer_id)   REFERENCES Customers (id)   ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (start_rent_time < end_rent_time)
);

CREATE TABLE IF NOT EXISTS WarehouseTransferStatus (
    id      serial       PRIMARY KEY,
    status  varchar(50)  NOT NULL  UNIQUE
);

CREATE TABLE IF NOT EXISTS WarehouseTransfer (
    id                        serial           PRIMARY KEY,
    item_id                   int              NOT NULL  UNIQUE,
    destination_warehouse_id  int              NOT NULL,
    status                    int              NOT NULL  DEFAULT 1,
    uuid_delivery             uuid             NOT NULL  DEFAULT gen_random_uuid()  UNIQUE,
    FOREIGN KEY (item_id)                  REFERENCES Items (id)                   ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (destination_warehouse_id) REFERENCES Warehouses (id)              ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (status)                   REFERENCES WarehouseTransferStatus(id)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS WarehouseTransfer_metadata (
    warehouse_transfer_id serial     PRIMARY KEY,
    create_at             timestamp  NOT NULL  DEFAULT current_timestamp,
    create_by             int        NOT NULL,
    update_at             timestamp  NOT NULL  DEFAULT current_timestamp,
    update_by             int        NOT NULL,
    FOREIGN KEY (create_by) REFERENCES Staff(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (update_by) REFERENCES Staff(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS WarehouseTransferHistory (
    id                        serial     PRIMARY KEY,
    item_id                   int        NOT NULL,
    source_warehouse_id       int        NOT NULL,
    destination_warehouse_id  int        NOT NULL,
    sending_time              timestamp  NULL       DEFAULT NULL,
    receiving_time            timestamp  NULL       DEFAULT NULL,
    status                    int        NOT NULL,
    uuid_delivery             uuid       NULL       UNIQUE,
    FOREIGN KEY (item_id)                  REFERENCES Items(id)                        ON DELETE CASCADE  ON UPDATE CASCADE,
    FOREIGN KEY (source_warehouse_id)      REFERENCES Warehouses(id)                   ON DELETE CASCADE  ON UPDATE CASCADE,
    FOREIGN KEY (destination_warehouse_id) REFERENCES Warehouses(id)                   ON DELETE CASCADE  ON UPDATE CASCADE,
    FOREIGN KEY (status)                   REFERENCES WarehouseTransferStatus(id)      ON DELETE CASCADE  ON UPDATE CASCADE,
    FOREIGN KEY (uuid_delivery)            REFERENCES WarehouseTransfer(uuid_delivery) ON DELETE SET NULL ON UPDATE CASCADE
);


-- TRIGGERS --

-- Automatic creation of a record in the table Items_metadata
CREATE OR REPLACE FUNCTION add_items_metadata()
RETURNS TRIGGER AS $$
DECLARE
    staff_id integer := (SELECT (id) FROM Staff WHERE username = current_user);
BEGIN
    INSERT INTO Items_metadata (item_id, create_by, update_by)
    VALUES (NEW.id, staff_id, staff_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_add_items_metadata
AFTER INSERT ON Items
FOR EACH ROW
EXECUTE FUNCTION add_items_metadata();


-- Automatic replace quality Items after adding an entry to the ItemsServiceHistory
CREATE OR REPLACE FUNCTION add_items_service_history()
RETURNS TRIGGER AS $$
BEGIN
-- set old quality from items
    NEW.old_quality = (SELECT quality 
                        FROM Items 
                        WHERE id = NEW.item_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_add_items_service_history
BEFORE INSERT ON ItemsServiceHistory
FOR EACH ROW
EXECUTE FUNCTION add_items_service_history();

-- TODO: check with non-existent user
-- Automatic creation of a record in the table ItemsServiceHistory_metadata and update Item quality
CREATE OR REPLACE FUNCTION add_items_service_history_metadata()
RETURNS TRIGGER AS $$
DECLARE
    staff_id integer := (SELECT (id) FROM Staff WHERE username = current_user);
BEGIN
    INSERT INTO ItemsServiceHistory_metadata(service_id, changed_by)
    VALUES (NEW.id, staff_id);

    UPDATE Items SET quality = NEW.new_quality WHERE Items.id = NEW.item_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_add_items_service_history_metadata
AFTER INSERT ON ItemsServiceHistory
FOR EACH ROW
EXECUTE FUNCTION add_items_service_history_metadata();


-- Check before transfer item to other warehouse. The item should not be rented
CREATE OR REPLACE FUNCTION prevent_add_transfer()
RETURNS TRIGGER AS $$
DECLARE
    warehouse_active_status boolean;
BEGIN
    SELECT active INTO warehouse_active_status
    FROM Warehouses
    WHERE id = NEW.destination_warehouse_id;

    IF warehouse_active_status = false THEN
        RAISE EXCEPTION 'Cannot transfer to warehouse_id %, it is non active.', NEW.destination_warehouse_id;
    END IF;

    IF EXISTS (SELECT * FROM Rent WHERE item_id = NEW.item_id) THEN
        RAISE EXCEPTION 'Cannot transfer item item_id %, it is currently rented.', NEW.item_id;
    END IF;

    IF EXISTS (SELECT * FROM WarehouseTransfer WHERE item_id = NEW.item_id) THEN
        RAISE EXCEPTION 'Cannot transfer item item_id %, it is already transfer to another warehouse.', NEW.item_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_add_transfer
BEFORE INSERT ON WarehouseTransfer
FOR EACH ROW
EXECUTE FUNCTION prevent_add_transfer();


-- Set status 'create' before insert record in the WarehouseTransfer
CREATE OR REPLACE FUNCTION setup_status_warehouse_transfer()
RETURNS TRIGGER AS $$
DECLARE
    create_status int := (SELECT id FROM WarehouseTransferStatus WHERE status = 'create'); 
BEGIN
    NEW.status = create_status;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_setup_status_warehouse_transfer
BEFORE INSERT ON WarehouseTransfer
FOR EACH ROW
EXECUTE FUNCTION setup_status_warehouse_transfer();


-- Creating of a record in the WarehousesOrdersHistory after insert to WarehousesOrders
CREATE OR REPLACE FUNCTION add_warehouse_transfer_history()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO WarehouseTransferHistory(item_id, source_warehouse_id, destination_warehouse_id, sending_time, receiving_time, uuid_delivery)
    VALUES (
                NEW.item_id,
                (SELECT warehouse_id FROM Items WHERE id = NEW.item_id),
                NEW.destination_warehouse_id,
                NULL,
                NULL,
                NEW.status,
                NEW.uuid_delivery
           );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_add_warehouse_transfer_history
AFTER INSERT ON WarehouseTransfer
FOR EACH ROW
EXECUTE FUNCTION add_warehouse_transfer_history();


-- only source warehouse user can send the item and only destination warehouse user can receive the item 
CREATE OR REPLACE FUNCTION prevent_update_status_warehouses_transfer()
RETURNS TRIGGER AS $$
DECLARE
    shipped_status  int := (SELECT id FROM WarehouseTransferStatus WHERE status = 'shipped');
    received_status int := (SELECT id FROM WarehouseTransferStatus WHERE status = 'received');
BEGIN
   -- prevent the status from changing to "shipped" for an employee not from the item's warehouse
    IF NEW.status = shipped_status THEN
        IF (SELECT source_warehouse_id
              FROM WarehousesOrdersHistory
             WHERE uuid_delivery = NEW.uuid_delivery) !=
           (SELECT warehouse_id
              FROM Staff
             WHERE username = current_user) THEN
                RAISE EXCEPTION 'It is not possible to confirm the shipment from another warehouse.';
        END IF;
    END IF;
    
    -- prevent the status from changing to "received" for an employee not from the item's warehouse
    IF NEW.status = received_status THEN
        IF (SELECT source_warehouse_id
              FROM WarehousesOrdersHistory
             WHERE uuid_delivery = NEW.uuid_delivery) !=
           (SELECT warehouse_id
              FROM Staff
             WHERE username = current_user) THEN
                RAISE EXCEPTION 'It is not possible to confirm receipt from another warehouse.';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_update_status_warehouses_transfer
BEFORE UPDATE OF status
ON WarehouseTransfer
FOR EACH ROW
WHEN (OLD.status != NEW.status)
EXECUTE FUNCTION prevent_update_status_warehouses_transfer();


-- Update status in WarehouseTransferHistory after update WarehouseTransfer.status
CREATE OR REPLACE FUNCTION update_status_warehouses_transfer_history()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE WarehouseTransferHistory
       SET status = NEW.status
     WHERE uuid_delivery = NEW.uuid_delivery;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_status_warehouses_transfer_history
AFTER UPDATE OF status
ON WarehouseTransfer
FOR EACH ROW
WHEN (OLD.status != NEW.status)
EXECUTE FUNCTION update_status_warehouses_transfer_history();


-- Check before archive items
CREATE OR REPLACE FUNCTION prevent_archive_items()
RETURNS TRIGGER AS $$
BEGIN
    -- The item cannot be rented
    IF EXISTS (SELECT * FROM WarehouseTransfer WHERE item_id = NEW.item_id) THEN
        RAISE EXCEPTION 'The item item_id % is being transfer.', NEW.item_id;
    END IF;

    -- The item cannot be in transfer
    IF EXISTS (SELECT item_id FROM Rent WHERE item_id = NEW.item_id) THEN
        RAISE EXCEPTION 'The item item_id % is being rented.', NEW.item_id;
    END IF; 

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_archive_items
BEFORE UPDATE OF archived
ON Items
FOR EACH ROW
WHEN (OLD.archived != NEW.archived)
EXECUTE FUNCTION prevent_archive_items();


-- Check before rent. The item should not be already rented, unactive, transferring or archived
CREATE OR REPLACE FUNCTION prevent_rent()
RETURNS TRIGGER AS $$
BEGIN
    -- check of the already rented items takes place when inserting

    -- the item has been unactive
    IF (SELECT active FROM Items WHERE item_id = NEW.item_id) = FALSE THEN
        RAISE EXCEPTION 'Cannot rent item_id %, it is currently unactive.', NEW.item_id;
    END IF;

    -- the item has been transfer
    IF EXISTS (SELECT * FROM WarehousesTransfer WHERE item_id = NEW.item_id) THEN
        RAISE EXCEPTION 'Cannot rent item_id %, it is currently transfer.', NEW.item_id;
    END IF;

    -- the item has been archived
    IF (SELECT archived FROM ItemsDecommissioning WHERE item_id = NEW.item_id) = TRUE THEN
        RAISE EXCEPTION 'Cannot decommissioning item_id %, it is currently order.', NEW.item_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_rent
BEFORE INSERT ON Rent
FOR EACH ROW
EXECUTE FUNCTION prevent_rent();

-- calculate total_payment
CREATE OR REPLACE FUNCTION calculate_total_interim_payment_rent()
RETURNS TRIGGER AS $$
DECLARE
    total_days int;
    item_price decimal(10,2);
    current_day date;
    total_discount_percent int;
    total_payments_tmp decimal(10,2) := 0;
BEGIN
    -- calculate date rent
    SELECT 
        CASE
            WHEN EXTRACT(DAY FROM NEW.end_rent_time - NEW.start_rent_time) = 0 THEN 1
            ELSE EXTRACT(DAY FROM NEW.end_rent_time - NEW.start_rent_time) + 
                CASE WHEN EXTRACT(HOUR FROM NEW.end_rent_time) >= 12 THEN 1 ELSE 0 END
        END
    INTO total_days;

    SELECT price 
    FROM Items 
    WHERE id = NEW.item_id
    INTO item_price;

    -- add discounts
    FOR i IN 0..total_days - 1 LOOP
        current_day := NEW.start_rent_time::date + (i * INTERVAL '1 day');
        total_discount_percent := 0;

        SELECT COALESCE(SUM(Discounts.percent), 0)
        FROM Discounts
        JOIN ItemsDiscounts ON ItemsDiscounts.discount_id = Discounts.id
        WHERE ItemsDiscounts.item_id = NEW.item_id AND
            current_day BETWEEN Discounts.start_date AND Discounts.end_date
        INTO total_discount_percent;

        IF total_discount_percent > 100 THEN
            total_discount_percent := 100;
        END IF;

        total_payments_tmp := total_payments_tmp + item_price * (1 - total_discount_percent::float/100);
    END LOOP;

    UPDATE Rent 
    SET total_payments = total_payments_tmp
    WHERE id = NEW.id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calculate_total_interim_payment_rent
AFTER INSERT ON Rent
FOR EACH ROW
EXECUTE FUNCTION calculate_total_interim_payment_rent();


-- create a history record based on a record from rent after delete from rent
CREATE OR REPLACE FUNCTION add_rent_history()
RETURNS TRIGGER AS $$
DECLARE
    warehouse_id_item int;
    start_overdue_time timestamp;
    overdue_rent_days_calc int := 0;
    late_penalty_item decimal(10, 2);
BEGIN
    SELECT warehouse_id 
    FROM Items 
    WHERE id = OLD.item_id
    INTO warehouse_id_item;

    IF OLD.overdue = true THEN
        start_overdue_time := CASE  
            WHEN (OLD.end_rent_time < DATE_TRUNC('day', OLD.start_rent_time) + INTERVAL '2 days') OR (EXTRACT(HOUR FROM OLD.end_rent_time) >= 12) THEN
                DATE_TRUNC('day', OLD.start_rent_time) + INTERVAL '2 days'
            ELSE
                DATE_TRUNC('day', OLD.end_rent_time) + INTERVAL '1 day'
        END;

        overdue_rent_days_calc := 1 + GREATEST(CEIL(EXTRACT(EPOCH FROM (NOW() - start_overdue_time)) / 86400));
    END IF;

    SELECT late_penalty 
    FROM Items WHERE 
    id = OLD.item_id
    INTO late_penalty_item;

    INSERT INTO RentHistory(item_id, warehouse_rent_id, customer_id, start_rent_time, end_rent_time, overdue_rent_days, total_payments)
    VALUES (
            OLD.item_id,
            warehouse_id_item,
            OLD.customer_id,
            OLD.start_rent_time,
            NOW(),
            overdue_rent_days_calc,
            OLD.total_payments + late_penalty_item * overdue_rent_days_calc
        );

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_add_rent_history
BEFORE DELETE ON Rent
FOR EACH ROW
EXECUTE FUNCTION add_rent_history();

-- add new users to the UserWarehouse from postgres tables
CREATE OR REPLACE FUNCTION update_user_warehouse()
RETURNS VOID AS $$
BEGIN
    INSERT INTO UserWarehouse (username, warehouse_id)
    SELECT usename, NULL
    FROM pg_user
    WHERE usename NOT IN (SELECT uw.username FROM UserWarehouse uw) AND usename NOT IN ('postgres', 'register');

    DELETE FROM UserWarehouse
    WHERE username NOT IN (SELECT usename FROM pg_user);
END;
$$ LANGUAGE plpgsql;

-- daily update overdue
CREATE OR REPLACE FUNCTION daily_update_overdue_rent()
RETURNS VOID AS $$
BEGIN
    UPDATE Rent
    SET overdue = true 
    WHERE overdue = false
    AND NOW() > (
        CASE 
            WHEN NOW() < DATE_TRUNC('day', start_rent_time) + INTERVAL '1 day 12 hours' THEN
                DATE_TRUNC('day', start_rent_time) + INTERVAL '1 day 12 hours'
            ELSE
                DATE_TRUNC('day', end_rent_time) + 
                    (CASE 
                        WHEN EXTRACT(HOUR FROM end_rent_time) >= 12 THEN 
                            INTERVAL '1 day 12 hours' 
                        ELSE 
                            INTERVAL '12 hours' 
                    END)
        END
    );
END;
$$ LANGUAGE plpgsql;


-- Create customer metadata
CREATE OR REPLACE FUNCTION create_customers_metadata()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Customers_metadata(id) VALUES (NEW.id);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_create_customers_metadata
AFTER INSERT ON Customers
FOR EACH ROW
EXECUTE FUNCTION create_customers_metadata();


-- Update metadata when the user's personal data or password changes
CREATE OR REPLACE FUNCTION update_customers_metadata()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Customers_metadata
    SET update_at = current_timestamp
    WHERE id = NEW.id;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_update_customers_metadata
AFTER INSERT ON Customers
FOR EACH ROW
EXECUTE FUNCTION update_customers_metadata();

CREATE TRIGGER trg_update_customers_metadata_auth
AFTER UPDATE ON CustomersAuth
FOR EACH ROW
EXECUTE FUNCTION update_customers_metadata();


-- Create discounts metadata
CREATE OR REPLACE FUNCTION create_discounts_metadata()
RETURNS TRIGGER AS $$
DECLARE
    staff_id int := (SELECT id FROM Staff WHERE username = current_user);
BEGIN
    INSERT INTO Customers_metadata(id, create_by)
    VALUES (NEW.id, staff_id);
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_create_discounts_metadata
AFTER INSERT ON Discounts
FOR EACH ROW
EXECUTE FUNCTION create_discounts_metadata();


-- Create ItemsImages metadata
CREATE OR REPLACE FUNCTION create_items_images_metadata()
RETURNS TRIGGER AS $$
DECLARE
    staff_id int := (SELECT id FROM Staff WHERE username = current_user);
BEGIN
    INSERT INTO ItemsImages_metadata(id, create_by)
    VALUES (NEW.id, staff_id);
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_create_items_images_metadata
AFTER INSERT ON Discounts
FOR EACH ROW
EXECUTE FUNCTION create_items_images_metadata();


-- Add schedule pgagent. execute update overdue in Rent everyday in 12:00
CREATE EXTENSION IF NOT EXISTS pgagent;

DO $$
DECLARE
    jid integer;
    scid integer;
BEGIN
-- Creating a new job
INSERT INTO pgagent.pga_job(
    jobjclid, jobname, jobdesc, jobhostagent, jobenabled
) VALUES (
    1::integer, 'DailyCheckOverdueRent'::text, ''::text, ''::text, true
) RETURNING jobid INTO jid;

-- Steps
-- Inserting a step (jobid: NULL)
INSERT INTO pgagent.pga_jobstep (
    jstjobid, jstname, jstenabled, jstkind,
    jstconnstr, jstdbname, jstonerror,
    jstcode, jstdesc
) VALUES (
    jid, 'CheckAndUpdate'::text, true, 's'::character(1),
    ''::text, 'RentalDB'::name, 'f'::character(1),
    'SELECT public.daily_update_overdue_rent();'::text, ''::text
) ;

-- Schedules
-- Inserting a schedule
INSERT INTO pgagent.pga_schedule(
    jscjobid, jscname, jscdesc, jscenabled,
    jscstart, jscend,    jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths
) VALUES (
    jid, 'Daily 12:00'::text, ''::text, true,
    NOW()::timestamp with time zone, (NOW() + INTERVAL '1 year')::timestamp with time zone,
    -- Minutes
    '{t,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f}'::bool[]::boolean[],
    -- Hours
    '{f,f,f,f,f,f,f,f,f,f,f,f,t,f,f,f,f,f,f,f,f,f,f,f}'::bool[]::boolean[],
    -- Week days
    '{f,f,f,f,f,f,f}'::bool[]::boolean[],
    -- Month days
    '{f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f}'::bool[]::boolean[],
    -- Months
    '{f,f,f,f,f,f,f,f,f,f,f,f}'::bool[]::boolean[]
) RETURNING jscid INTO scid;
END
$$;

END;