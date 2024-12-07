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

CREATE TABLE IF NOT EXISTS Customer_metadata (
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

END;