-- Insertion test data
BEGIN;

SELECT update_staff();

-- INSERT Warehouses
INSERT INTO Warehouses VALUES (1, 'Арбор',   '+79167130067', 'arbor@rental.com',   '125315, г. Москва, ул. Усиевича, дом 18');
INSERT INTO Warehouses VALUES (2, 'Флюмен',  '+79162103495', 'flumen@rental.com',  '980371, г. Москва, ул. Брянская, дом 8');
INSERT INTO Warehouses VALUES (3, 'Гелидус', '+79165499144', 'gelidus@rental.com', '980178, г. Москва, ул. Краснопрудная, дом 11');
INSERT INTO Warehouses VALUES (4, 'Монтис',  '+79168251546', 'montis@rental.com',  '983182, г. Санкт-Петербург, пр-кт Испытателей, дом 31');
INSERT INTO Warehouses VALUES (5, 'Сильва',  '+79165946514', 'silva@rental.com',   '420127, Респ. Татарстан, г. Казань, ул. Максимова, дом 2');
SELECT setval('warehouses_id_seq', (SELECT MAX(id) FROM Warehouses));

-- INSERT Items
INSERT INTO Items VALUES (1,  1, 'плиткорез',                            'Для точной резки плитки и керамики.',                    '{"Тип привода":"ручной","Глубина резания":"14 мм","Длина реза":"500 мм","Режущий элемент":"ролик","Наружный диаметр ролика":"15 мм","Внутренний диаметр ролика":"6 мм","Толщина ролика":"1.5 мм","Балеринка":"нет","Лазерный указатель":"нет","Класс товара":"Профессиональный","Вид упаковки":"коробка","Вес нетто":"2.6 кг","Габариты без упаковки":"105х160х676 мм","С подшипником":"нет"}', 91,  300,  400 );
INSERT INTO Items VALUES (2,  1, 'пневматический гайковерт',             'Для быстрого и эффективного закручивания гаек.',         '{"Тип привода":"пневматический","Максимальный крутящий момент":"1200 Н·м","Скорость вращения":"7000 об/мин","Вес нетто":"2.1 кг","Длина":"180 мм","Диаметр шланга":"10 мм","Рабочее давление":"6.2 бар","Потребление воздуха":"170 л/мин","Тип упаковки":"пластиковый кейс"}',                                                                                                                  62,  900,  1300);
INSERT INTO Items VALUES (3,  1, 'лазерный уровень',                     'Для точной установки и выравнивания объектов.',          '{"Количество линий":"2","Диапазон работы":"10 м","Точность":"±0.3 мм/м","Тип лазера":"красный","Класс защиты":"IP54","Питание":"3xAA батарейки","Время работы":"20 часов","Вес нетто":"0.5 кг","Крепление":"1/4 дюйма"}',                                                                                                                                                                       100, 400,  600 );
INSERT INTO Items VALUES (4,  2, 'тележка с ручным подъемником',         'Для легкого подъема и перемещения грузов.',              '{"Грузоподъемность":"1000 кг","Высота подъема":"1600 мм","Материал платформы":"сталь","Вес нетто":"120 кг","Тип колес":"полиуретан","Тип привода":"ручной","Габариты":"1200x800x1800 мм"}',                                                                                                                                                                                                     85,  1200, 1500);
INSERT INTO Items VALUES (5,  2, 'складской робот',                      'Автоматизированное устройство для перемещения товаров.', '{"Грузоподъемность":"50 кг","Скорость движения":"1.5 м/с","Время работы":"8 часов","Тип батареи":"Li-Ion","Класс защиты":"IP65","Вес нетто":"85 кг","Интеграция":"Wi-Fi, Bluetooth"}',                                                                                                                                                                                                          64,  4000, 5500);
INSERT INTO Items VALUES (6,  3, 'кран-балка',                           'Для перемещения тяжелых предметов в пределах склада.',   '{"Грузоподъемность":"5 тонн","Высота подъема":"12 м","Длина пролета":"10 м","Тип привода":"электрический","Мощность двигателя":"5 кВт","Скорость подъема":"4 м/мин","Класс защиты":"IP54"}',                                                                                                                                                                                                    54,  4000, 5500);
INSERT INTO Items VALUES (7,  2, 'конвейер',                             'Используется для перемещения товаров на складе.',        '{"Тип":"ленточный","Длина":"5 м","Ширина ленты":"600 мм","Скорость движения":"0.5-2 м/с","Мощность двигателя":"1.5 кВт","Грузоподъемность":"50 кг/м","Материал ленты":"резина"}',                                                                                                                                                                                                               80,  1500, 2000);
INSERT INTO Items VALUES (8,  1, 'электрический погрузчик',              'Используется для перемещения тяжелых грузов.',           '{"Грузоподъемность":"2.5 тонны","Высота подъема":"4 м","Тип батареи":"Li-Ion","Время работы":"6 часов","Скорость движения":"15 км/ч","Вес":"4500 кг","Класс защиты":"IP54"}',                                                                                                                                                                                                                   56,  2000, 2500);
INSERT INTO Items VALUES (9,  4, 'сварочный аппарат',                    'Для сварки металлов и других материалов.',               '{"Тип":"инверторный","Сварочный ток":"20-200 А","Потребляемая мощность":"6.5 кВт","Тип электродов":"3.2-5 мм","Класс защиты":"IP21","Вес нетто":"4.5 кг","Напряжение":"220 В"}',                                                                                                                                                                                                                0,   700,  1000);
INSERT INTO Items VALUES (10, 4, 'компрессор',                           'Для подачи сжатого воздуха.',                            '{"Тип":"поршневой","Объем ресивера":"50 л","Мощность":"2.2 кВт","Производительность":"250 л/мин","Рабочее давление":"8 бар","Вес нетто":"35 кг","Габариты":"800x300x700 мм"}',                                                                                                                                                                                                                  10,  700,  1000);
INSERT INTO Items VALUES (11, 5, 'фрезерный станок',                     'Для точной фрезеровки различных материалов.',            '{"Тип":"универсальный","Мощность двигателя":"5 кВт","Скорость вращения шпинделя":"50-2500 об/мин","Рабочая зона":"1000x500 мм","Вес нетто":"1200 кг","Класс точности":"H"}',                                                                                                                                                                                                                    77,  2500, 3000);
INSERT INTO Items VALUES (12, 1, 'газовый резак',                        'Для резки металлов и других твердых материалов.',        '{"Тип топлива":"ацетилен/пропан","Толщина реза":"3-100 мм","Длина резака":"500 мм","Класс безопасности":"EN ISO 5172","Вес нетто":"1.2 кг"}',                                                                                                                                                                                                                                                   95,  600,  800 , FALSE, TRUE);
INSERT INTO Items VALUES (13, 5, 'дрель-шуруповерт',                     'Для сверления и закручивания шурупов.',                  '{"Тип":"аккумуляторный","Мощность":"18 В","Крутящий момент":"45 Н·м","Вес нетто":"1.2 кг","Скорость вращения":"0-1500 об/мин","Емкость батареи":"2 А·ч"}',                                                                                                                                                                                                                                      68,  700,  900 );
INSERT INTO Items VALUES (14, 3, 'плоскогубцы с изолированными ручками', 'Для работы с электрическими проводами и кабелями.',      '{"Материал":"хромованадиевая сталь","Длина":"160 мм","Изоляция":"до 1000 В","Вес нетто":"0.2 кг"}',                                                                                                                                                                                                                                                                                             35,  200,  300 );
INSERT INTO Items VALUES (15, 3, 'бетононасос',                          'Для перекачивания бетона на строительных площадках.',    '{"Производительность":"60 м³/ч","Максимальная высота подачи":"30 м","Тип двигателя":"дизельный","Вес нетто":"2500 кг","Класс защиты":"IP23"}',                                                                                                                                                                                                                                                  84,  4000, 5500);
INSERT INTO Items VALUES (16, 3, 'вакуумный упаковщик',                  'Для упаковки продуктов в вакуумной упаковке.',           '{"Производительность насоса":"20 м³/ч","Тип упаковки":"вакуумная","Мощность":"1.2 кВт","Вес нетто":"50 кг","Габариты":"600x400x400 мм"}',                                                                                                                                                                                                                                                       90,  2000, 2400);
SELECT setval('items_id_seq', (SELECT MAX(id) FROM Items));

-- INSERT ItemsImages
-- TODO

-- INSERT Categories
INSERT INTO Categories VALUES (1, 'Инструменты');
INSERT INTO Categories VALUES (2, 'Обработка');
INSERT INTO Categories VALUES (3, 'Электрика');
INSERT INTO Categories VALUES (4, 'Строительная техника');
INSERT INTO Categories VALUES (5, 'Промышленная машина');
INSERT INTO Categories VALUES (6, 'Подъемное оборудование');
INSERT INTO Categories VALUES (7, 'Автоматизация');
INSERT INTO Categories VALUES (8, 'Пневматика');
INSERT INTO Categories VALUES (9, 'Упаковка');
SELECT setval('categories_id_seq', (SELECT MAX(id) FROM Categories));

-- INSERT ItemsCategories
INSERT INTO ItemsCategories VALUES (1, 1);
INSERT INTO ItemsCategories VALUES (1, 2);
INSERT INTO ItemsCategories VALUES (2, 1);
INSERT INTO ItemsCategories VALUES (2, 3);
INSERT INTO ItemsCategories VALUES (3, 1);
INSERT INTO ItemsCategories VALUES (3, 4);
INSERT INTO ItemsCategories VALUES (4, 5);
INSERT INTO ItemsCategories VALUES (4, 6);
INSERT INTO ItemsCategories VALUES (5, 5);
INSERT INTO ItemsCategories VALUES (5, 7);
INSERT INTO ItemsCategories VALUES (6, 5);
INSERT INTO ItemsCategories VALUES (6, 6);
INSERT INTO ItemsCategories VALUES (7, 5);
INSERT INTO ItemsCategories VALUES (7, 7);
INSERT INTO ItemsCategories VALUES (8, 5);
INSERT INTO ItemsCategories VALUES (8, 6);
INSERT INTO ItemsCategories VALUES (9, 1);
INSERT INTO ItemsCategories VALUES (10, 1);
INSERT INTO ItemsCategories VALUES (10, 8);
INSERT INTO ItemsCategories VALUES (11, 5);
INSERT INTO ItemsCategories VALUES (11, 2);
INSERT INTO ItemsCategories VALUES (12, 1);
INSERT INTO ItemsCategories VALUES (12, 2);
INSERT INTO ItemsCategories VALUES (13, 1);
INSERT INTO ItemsCategories VALUES (14, 1);
INSERT INTO ItemsCategories VALUES (15, 5);
INSERT INTO ItemsCategories VALUES (15, 4);
INSERT INTO ItemsCategories VALUES (16, 5);
INSERT INTO ItemsCategories VALUES (16, 9);

-- INSERT Discounts
INSERT INTO Discounts VALUES (1, 'Недельная господдержка промышленного производства', 'По указу №5 президента РФ на промышленное оборудование возлагается скидка 10%', 10, NOW(), NOW() + INTERVAL '7 days');
INSERT INTO Discounts VALUES (2, 'Пора накачать колеса!',                             'Давно проверяли давление в шинах? Скидка 5% на аренду компрессора',              5, NOW(), NOW() + INTERVAL '3 day');
SELECT setval('discounts_id_seq', (SELECT MAX(id) FROM Discounts));

-- INSERT ItemsDiscounts
INSERT INTO ItemsDiscounts
    SELECT i.id, 1
    FROM Items AS i 
    JOIN ItemsCategories AS ic  
        ON i.id = ic.item_id
    JOIN Categories AS c
        ON ic.category_id = c.id
    WHERE c.category_name = 'Промышленная машина';
INSERT INTO ItemsCategories VALUES (10, 2);

-- INSERT Customers
INSERT INTO Customers VALUES (1, 'Корнилов Арсений',  'arseniy6950@mail.ru',         FALSE, '+7(909)445-14-88', TRUE,  '980484 г. Москва, ш. Дмитровское, дом 131 к. 2',                                     '4128 355647');
INSERT INTO Customers VALUES (2, 'Горелова Лариса',    NULL,                         FALSE, '+7(924)855-68-37', TRUE,   NULL,                                                                                 NULL        );
INSERT INTO Customers VALUES (3, 'Аксаков Иван',       NULL,                         FALSE,  NULL,              FALSE,  NULL,                                                                                 NULL        );
INSERT INTO Customers VALUES (4, 'Исаев Павел',       'pavel62@yandex.ru',           TRUE,  '+7(909)189-17-81', TRUE,  '119021 г. Москва, пр-кт Комсомольский, дом 3',                                       '4338 106639');
INSERT INTO Customers VALUES (5, 'Ельченко Роман',    'roman4159@yandex.ru',         TRUE,  '+7(971)778-40-29', TRUE,  '141011 обл. Московская, г. Мытищи, ул. 4-я Парковая, дом 16',                        '4396 605504');
INSERT INTO Customers VALUES (6, 'Мишина Елизавета',  'elizaveta3412@yandex.ru',     TRUE,  '+7(936)970-45-53', TRUE,  '919216 обл Московская, г Долгопрудный, ш Старое Дмитровское, дом 15',                '4072 639447');
INSERT INTO Customers VALUES (7, 'Гребнев Максим',    'max47@rambler.ru',            TRUE,  '+7(925)930-73-21', FALSE,  NULL,              '4522 205106'                                                                  );
INSERT INTO Customers VALUES (8, 'Коршиков Дмитрий',  'dmitriy.korshikov@gmail.com', TRUE,  '+7(908)329-79-43', TRUE,  '980243 г. Москва, ул. Перовская, дом 8 к. 1',                                        '4041 379819');
INSERT INTO Customers VALUES (9, 'Кубланов Григорий', 'grigoriy_kub@gmail.com',      TRUE,   NULL,              FALSE, '919935 обл. Московская, г. Балашиха, мкр. Железнодорожный, ул. Маяковского, дом 25', '4396 255125');
SELECT setval('customers_id_seq', (SELECT MAX(id) FROM Customers));

-- INSERT CustomersAuth (all users have password '1234')
INSERT INTO CustomersAuth(id, username, password_hash) VALUES (1, 'arseniy6950',   '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');
INSERT INTO CustomersAuth(id, username, password_hash) VALUES (2, 'gorelovalar',   '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');
INSERT INTO CustomersAuth(id, username, password_hash) VALUES (3, 'aksakov123',    '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');
INSERT INTO CustomersAuth(id, username, password_hash) VALUES (4, 'pavel62',       '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');
INSERT INTO CustomersAuth(id, username, password_hash) VALUES (5, 'elizaveta3412', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');
INSERT INTO CustomersAuth(id, username, password_hash) VALUES (6, 'max47',         '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');
INSERT INTO CustomersAuth(id, username, password_hash) VALUES (7, 'korshikov43',   '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');
INSERT INTO CustomersAuth(id, username, password_hash) VALUES (8, 'grigoriy_kub',  '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');

-- INSERT ItemsServiceHistory
INSERT INTO ItemsServiceHistory(item_id, new_quality, change_reason) VALUES (2, 60, 'Треснул корпус');
SELECT setval('itemsservicehistory_id_seq', (SELECT MAX(id) FROM ItemsServiceHistory));

-- INSERT WarehouseTransferStatus
INSERT INTO WarehouseTransferStatus VALUES (1, 'created');
INSERT INTO WarehouseTransferStatus VALUES (2, 'cancelled');
INSERT INTO WarehouseTransferStatus VALUES (3, 'shipped');
INSERT INTO WarehouseTransferStatus VALUES (4, 'lost');
INSERT INTO WarehouseTransferStatus VALUES (5, 'received');
SELECT setval('warehousetransferstatus_id_seq', (SELECT MAX(id) FROM WarehouseTransferStatus));

-- INSERT WarehousesTransferHistory
ALTER SEQUENCE public.warehousetransferhistory_id_seq RESTART WITH 5;
INSERT INTO WarehouseTransferHistory VALUES (1, 5,  3, 2, NOW() - INTERVAL '7 days',  NOW() - INTERVAL '3 days',  5, NULL);
INSERT INTO WarehouseTransferHistory VALUES (2, 10, 1, 4, NOW() - INTERVAL '30 days', NOW() - INTERVAL '26 days', 5, NULL);
INSERT INTO WarehouseTransferHistory VALUES (3, 9,  1, 4, NOW() - INTERVAL '12 days', NOW() - INTERVAL '11 days', 5, NULL);
INSERT INTO WarehouseTransferHistory VALUES (4, 13, 3, 5, NOW() - INTERVAL '15 days', NOW() - INTERVAL '6 days',  5, NULL);
SELECT setval('warehousetransferhistory_id_seq', (SELECT MAX(id) FROM WarehouseTransferHistory));

-- INSERT WarehousesTransfer
ALTER SEQUENCE public.warehousetransfer_id_seq RESTART WITH 5;
INSERT INTO WarehouseTransfer(item_id, destination_warehouse_id) VALUES (7, 4);

-- INSERT Rent
-- TODO

-- INSERT RentHistory
-- TODO

-- INSERT Sessions
-- TODO

-- INSERT StaffPosition
-- TODO
INSERT INTO StaffPositions(name) VALUES ('director');
INSERT INTO StaffPositions(name) VALUES ('warehouse worker');
INSERT INTO StaffPositions(name) VALUES ('marketing manager');
INSERT INTO StaffPositions(name) VALUES ('database moderator');
INSERT INTO StaffPositions(name) VALUES ('database administrator');
INSERT INTO StaffPositions(name) VALUES ('inventory manager');
INSERT INTO StaffPositions(name) VALUES ('intern');

COMMIT;