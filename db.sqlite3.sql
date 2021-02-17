BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "orders_order" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"email"	varchar(254) NOT NULL,
	"address"	varchar(150) NOT NULL,
	"phone_number"	varchar(15) NOT NULL,
	"city"	varchar(100) NOT NULL,
	"date_updated"	datetime NOT NULL,
	"date_add"	datetime NOT NULL,
	"paid"	bool NOT NULL,
	"order_number"	varchar(500) NOT NULL,
	"name_id"	integer NOT NULL,
	FOREIGN KEY("name_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "ecommerce_sub_category" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"date_add"	datetime NOT NULL,
	"date_updated"	datetime NOT NULL,
	"category_id"	integer NOT NULL,
	"is_available"	bool NOT NULL,
	"name"	varchar(200) NOT NULL,
	FOREIGN KEY("category_id") REFERENCES "ecommerce_category"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "ecommerce_product" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar(100) NOT NULL,
	"image"	varchar(100) NOT NULL,
	"price"	decimal NOT NULL,
	"is_available"	bool NOT NULL,
	"category_id"	integer NOT NULL,
	"description"	text,
	"slug"	varchar(50) UNIQUE,
	"date_add"	datetime NOT NULL,
	"date_updated"	datetime NOT NULL,
	"image1"	varchar(100),
	"image2"	varchar(100),
	"image3"	varchar(100),
	"image4"	varchar(100),
	"image5"	varchar(100),
	FOREIGN KEY("category_id") REFERENCES "ecommerce_sub_category"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "ecommerce_category" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"date_add"	datetime NOT NULL,
	"date_updated"	datetime NOT NULL,
	"name"	varchar(200) NOT NULL UNIQUE,
	"is_available"	bool NOT NULL
);
CREATE TABLE IF NOT EXISTS "socialaccount_socialaccount" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"provider"	varchar(30) NOT NULL,
	"uid"	varchar(191) NOT NULL,
	"last_login"	datetime NOT NULL,
	"date_joined"	datetime NOT NULL,
	"user_id"	integer NOT NULL,
	"extra_data"	text NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "socialaccount_socialapp" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"provider"	varchar(30) NOT NULL,
	"name"	varchar(40) NOT NULL,
	"client_id"	varchar(191) NOT NULL,
	"key"	varchar(191) NOT NULL,
	"secret"	varchar(191) NOT NULL
);
CREATE TABLE IF NOT EXISTS "socialaccount_socialtoken" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"token"	text NOT NULL,
	"token_secret"	text NOT NULL,
	"expires_at"	datetime,
	"account_id"	integer NOT NULL,
	"app_id"	integer NOT NULL,
	FOREIGN KEY("app_id") REFERENCES "socialaccount_socialapp"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("account_id") REFERENCES "socialaccount_socialaccount"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "socialaccount_socialapp_sites" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"socialapp_id"	integer NOT NULL,
	"site_id"	integer NOT NULL,
	FOREIGN KEY("socialapp_id") REFERENCES "socialaccount_socialapp"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("site_id") REFERENCES "django_site"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_site" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar(50) NOT NULL,
	"domain"	varchar(100) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS "account_emailaddress" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"verified"	bool NOT NULL,
	"primary"	bool NOT NULL,
	"user_id"	integer NOT NULL,
	"email"	varchar(254) NOT NULL UNIQUE,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "account_emailconfirmation" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"created"	datetime NOT NULL,
	"sent"	datetime,
	"key"	varchar(64) NOT NULL UNIQUE,
	"email_address_id"	integer NOT NULL,
	FOREIGN KEY("email_address_id") REFERENCES "account_emailaddress"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "orders_orderitem" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"price"	decimal NOT NULL,
	"quantity"	integer unsigned NOT NULL CHECK("quantity">=0),
	"order_id"	integer NOT NULL,
	"product_id"	integer NOT NULL,
	"date_add"	datetime NOT NULL,
	"date_updated"	datetime NOT NULL,
	FOREIGN KEY("product_id") REFERENCES "ecommerce_product"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("order_id") REFERENCES "orders_order"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "easy_thumbnails_thumbnaildimensions" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"thumbnail_id"	integer NOT NULL UNIQUE,
	"width"	integer unsigned CHECK("width">=0),
	"height"	integer unsigned CHECK("height">=0),
	FOREIGN KEY("thumbnail_id") REFERENCES "easy_thumbnails_thumbnail"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "easy_thumbnails_thumbnail" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"storage_hash"	varchar(40) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"modified"	datetime NOT NULL,
	"source_id"	integer NOT NULL,
	FOREIGN KEY("source_id") REFERENCES "easy_thumbnails_source"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "easy_thumbnails_source" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"storage_hash"	varchar(40) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"modified"	datetime NOT NULL
);
CREATE TABLE IF NOT EXISTS "django_session" (
	"session_key"	varchar(40) NOT NULL,
	"session_data"	text NOT NULL,
	"expire_date"	datetime NOT NULL,
	PRIMARY KEY("session_key")
);
CREATE TABLE IF NOT EXISTS "auth_group" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar(150) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS "auth_user" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"password"	varchar(128) NOT NULL,
	"last_login"	datetime,
	"is_superuser"	bool NOT NULL,
	"username"	varchar(150) NOT NULL UNIQUE,
	"first_name"	varchar(30) NOT NULL,
	"email"	varchar(254) NOT NULL,
	"is_staff"	bool NOT NULL,
	"is_active"	bool NOT NULL,
	"date_joined"	datetime NOT NULL,
	"last_name"	varchar(150) NOT NULL
);
CREATE TABLE IF NOT EXISTS "auth_permission" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"content_type_id"	integer NOT NULL,
	"codename"	varchar(100) NOT NULL,
	"name"	varchar(255) NOT NULL,
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_content_type" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"app_label"	varchar(100) NOT NULL,
	"model"	varchar(100) NOT NULL
);
CREATE TABLE IF NOT EXISTS "django_admin_log" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"action_time"	datetime NOT NULL,
	"object_id"	text,
	"object_repr"	varchar(200) NOT NULL,
	"change_message"	text NOT NULL,
	"content_type_id"	integer,
	"user_id"	integer NOT NULL,
	"action_flag"	smallint unsigned NOT NULL CHECK("action_flag">=0),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"user_id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_group_permissions" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"group_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_migrations" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"app"	varchar(255) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"applied"	datetime NOT NULL
);
INSERT INTO "orders_order" VALUES (1,'teye.etn@gmail.com','Afienya Accra','00234432','Accra','2021-02-16 18:52:35.702134','2021-02-16 18:52:35.789599',0,'202102161852-yE',2);
INSERT INTO "ecommerce_sub_category" VALUES (1,'2020-12-02 13:40:30.715209','2020-09-20 19:52:58.186421',1,1,'Android TV');
INSERT INTO "ecommerce_sub_category" VALUES (2,'2020-12-02 13:40:30.405282','2020-09-20 19:53:18.408350',1,1,'Set Top Boxes');
INSERT INTO "ecommerce_sub_category" VALUES (3,'2021-02-10 01:37:26.716129','2020-09-20 19:53:29.650387',1,0,'Chrome Boxes');
INSERT INTO "ecommerce_sub_category" VALUES (4,'2021-02-10 01:37:26.539127','2020-09-20 19:53:39.267653',1,0,'Chrome Casts');
INSERT INTO "ecommerce_sub_category" VALUES (5,'2021-02-10 01:37:26.379531','2020-09-20 19:53:56.177426',1,0,'WiFi Dongles');
INSERT INTO "ecommerce_sub_category" VALUES (6,'2020-12-02 13:40:29.088085','2020-09-20 19:54:11.823411',2,1,'Centralized Security & Surveillance Systems');
INSERT INTO "ecommerce_sub_category" VALUES (10,'2020-12-02 13:40:28.908721','2020-09-20 19:55:47.799161',4,1,'XtayConnect Internet');
INSERT INTO "ecommerce_sub_category" VALUES (12,'2021-02-13 10:33:48.250735','2021-02-13 10:33:48.250780',3,1,'Sumsung Smart ');
INSERT INTO "ecommerce_product" VALUES (1,'TCL Android AI 4K','images/2020/09/20/PHOTO-2020-09-04-11-46-23-9.jpg',1244,1,1,'','tcl-android-ai-4k','2020-09-20 22:12:47.601566','2020-09-20 22:12:43.522162',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "ecommerce_product" VALUES (4,'Set Top Boxes  Star times','images/2020/09/20/PHOTO-2020-09-04-11-46-23-11.jpg',1244,1,2,'','set-top-boxes-star-times','2020-09-20 22:32:40.096214','2020-09-20 22:32:40.096252',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "ecommerce_product" VALUES (5,'TCL Android AI 4K  Touch','images/2020/09/20/PHOTO-2020-09-04-11-46-23-8.jpg',1244,1,1,'','tcl-android-ai-4k-touch-12','2021-02-10 17:06:33.559778','2020-09-20 22:33:20.421237','images/2021/02/10/zddimages.jpeg','images/2021/02/10/zdimages.jpeg','images/2021/02/10/zgdzaindex.jpeg','images/2021/02/10/zddimages_xY33NZh.jpeg','images/2021/02/10/dsindex.jpeg');
INSERT INTO "ecommerce_product" VALUES (6,'TCL Android AI Chrome','images/2020/09/20/PHOTO-2020-09-04-11-46-23-3_f6T9nfK.jpg',1244,1,4,'','tcl-android-ai-chrome','2020-09-20 22:33:55.248904','2020-09-20 22:33:55.248963',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "ecommerce_product" VALUES (7,'Chrom DHL','images/2020/09/20/PHOTO-2020-09-04-11-46-23-6.jpg',1244,1,4,'','chrom-dhl','2020-09-20 22:50:52.686865','2020-09-20 22:50:52.686890',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "ecommerce_product" VALUES (8,'TCL Android AI 4K  z','images/2020/09/20/PHOTO-2020-09-04-11-46-23-8_Dcv2y0k.jpg',1244,1,1,'','tcl-android-ai-4k-z-12','2021-02-10 17:05:06.832323','2020-09-20 23:49:13.214483','images/2021/02/10/V96MINI_4K_1_uxOdVYi.jpg','images/2021/02/10/V96MINI_4K_details_2.jpg','images/2021/02/10/V96MINI_4K_8.jpg','images/2021/02/10/V96MINI_4K_details_3.jpg','images/2021/02/10/V96MINI_4K_3_Huju5tJ.jpg');
INSERT INTO "ecommerce_product" VALUES (9,'TCL Android','images/2020/09/20/PHOTO-2020-09-04-11-46-23-3_jtvpafG.jpg',1244,1,1,'','tcl-android','2020-09-20 23:49:41.132083','2020-09-20 23:49:41.132131',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "ecommerce_product" VALUES (12,'TCL Android AI 4K ','images/2020/09/22/PHOTO-2020-09-04-11-46-23-8_3NTwuVk.jpg',1244,1,1,'',NULL,'2020-09-22 14:17:58.135747','2020-09-22 14:17:58.135788',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "ecommerce_product" VALUES (37,'TCL Android AI 4K','images/2020/09/29/PHOTO-2020-09-04-11-46-23-5_coXr9Az.jpg',1244,1,5,'','tcl-android-ai-4k-q2','2020-09-29 00:13:22.234036','2020-09-29 00:13:22.234064',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "ecommerce_product" VALUES (38,'TCL Android AI 4K','images/2020/09/29/PHOTO-2020-09-04-11-46-23-12.jpg',1244,1,2,'','tcl-android-ai-4k-12','2021-02-10 17:04:10.981368','2020-09-29 00:13:53.468218','images/2021/02/10/C01S-T2__14.jpg','images/2021/02/10/C01S-T2__15.jpg','images/2021/02/10/V96MINI_4K_2.jpg','images/2021/02/10/V96MINI_4K_details_4.jpg','images/2021/02/10/V96MINI_4K_details_1.JPG');
INSERT INTO "ecommerce_product" VALUES (39,'Emmanuel Aggrey Emman','images/2020/09/29/PHOTO-2020-09-04-11-46-23-5_g3Y3kV7.jpg',1244,1,5,'<p>Nothing mush</p>','emmanuel-aggrey-emman-12','2021-02-10 17:03:49.820428','2020-09-29 00:29:59.633204','images/2021/02/10/V96MINI_4K_1.jpg','images/2021/02/10/V96MINI_4K_7.jpg','images/2021/02/10/V96MINI_4K_7_5XB6crV.jpg','images/2021/02/10/V8Plus-T2_6.jpg','images/2021/02/10/V96MINI_4K_3.jpg');
INSERT INTO "ecommerce_product" VALUES (40,'Nano Station M5','images/2021/02/08/C01S-T2__2.jpg',1244,1,5,'<p>================ CSS CDN : ================ https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css ================ JS CDN : ================== https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js</p>

<p>================ CSS CDN : ================ https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css ================ JS CDN : ================== https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js</p>

<p>================ CSS CDN : ================ https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css ================ JS CDN : ================== https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js</p>','nano-station-m5-12','2021-02-09 07:13:32.583969','2020-09-29 00:34:31.971950','images/2021/02/08/V8Plus-T2_7.jpg','images/2021/02/08/C01S-T2__10.jpg','images/2021/02/08/V96MINI_4K_1_ZOte0le.jpg','images/2021/02/08/V8Plus-T2_7_FYZ3w7z.jpg','images/2021/02/08/V96MINI_4K_7.jpg');
INSERT INTO "ecommerce_category" VALUES (1,'2020-09-20 19:48:22.835671','2020-09-20 19:48:22.835706','DTH Products',1);
INSERT INTO "ecommerce_category" VALUES (2,'2020-12-02 23:21:50.410107','2020-09-20 19:48:32.976310','Smart Home Devices',0);
INSERT INTO "ecommerce_category" VALUES (3,'2020-12-02 12:39:35.881632','2020-09-20 19:48:40.211109','IPTV Services',0);
INSERT INTO "ecommerce_category" VALUES (4,'2020-09-20 19:48:48.323684','2020-09-20 19:48:48.323716','Internet Services',1);
INSERT INTO "socialaccount_socialaccount" VALUES (1,'google','112142976742729723601','2020-11-18 00:30:03.938787','2020-10-30 22:06:38.847304',4,'{"id": "112142976742729723601", "email": "aggrey.en@gmail.com", "verified_email": true, "name": "Emmanuel Nartey", "given_name": "Emmanuel", "family_name": "Nartey", "picture": "https://lh3.googleusercontent.com/a-/AOh14Gj8ol7Y10F5Kl3RFRg_tOQELlBQBbGsPojGPx8MfA=s96-c", "locale": "en"}');
INSERT INTO "socialaccount_socialapp" VALUES (2,'google','Google Api 2','233855850003-cqds4netvbkniculdlrfvvfhsuao7nt3.apps.googleusercontent.com','','l9AXc-p9c9KtkY363BlR_QRX');
INSERT INTO "socialaccount_socialapp" VALUES (3,'facebook','Facebook Api','436895274322583','','a9b77f6d797b1e1ab47ff1e7c66eaad0');
INSERT INTO "socialaccount_socialtoken" VALUES (2,'ya29.A0AfH6SMCXouY-HwmmlfEOTS7dmFqXkplfjfFfqWeTlNHGeiaFIfMASIJhmRhHYtT2NXpAnnbqtl0P6gD5SiqzQyJS_N61P-Cdbi-KHzzv0mzbOkCDrRHoFGBpY_qLBkH9fQsRkcSHHbL-vqIvKTXX45q0mTfSkmQ_Dsi0HpnZCWd0','','2020-11-18 01:30:00.948578',1,2);
INSERT INTO "socialaccount_socialapp_sites" VALUES (2,2,1);
INSERT INTO "socialaccount_socialapp_sites" VALUES (3,3,2);
INSERT INTO "socialaccount_socialapp_sites" VALUES (4,2,2);
INSERT INTO "socialaccount_socialapp_sites" VALUES (5,3,1);
INSERT INTO "django_site" VALUES (1,'XTAYCONNECT AFRICA TM','127.0.0.1:8000');
INSERT INTO "django_site" VALUES (2,'XTAYCONNECT AFRICA TM','xtayconnectafrica.com');
INSERT INTO "account_emailaddress" VALUES (1,0,1,2,'teye.etn@gmail.com');
INSERT INTO "account_emailaddress" VALUES (2,0,1,3,'me@ktu.com');
INSERT INTO "account_emailaddress" VALUES (3,1,1,4,'aggrey.en@gmail.com');
INSERT INTO "account_emailaddress" VALUES (4,0,1,6,'me@me.com');
INSERT INTO "easy_thumbnails_thumbnail" VALUES (1,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/20/PHOTO-2020-09-04-11-46-23-9.jpg.50x50_q85_crop.jpg','2020-09-22 00:19:04.083842',1);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (2,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/21/PHOTO-2020-09-04-11-46-23-8.jpg.50x50_q85_crop.jpg','2020-09-22 00:20:08.119846',2);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (3,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/20/PHOTO-2020-09-04-11-46-23-8_Dcv2y0k.jpg.50x50_q85_crop.jpg','2020-09-22 00:20:08.440938',3);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (4,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/20/PHOTO-2020-09-04-11-46-23-3_jtvpafG.jpg.50x50_q85_crop.jpg','2020-09-22 00:20:08.740009',4);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (5,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/20/PHOTO-2020-09-04-11-46-23-8.jpg.50x50_q85_crop.jpg','2020-09-22 00:20:24.322736',5);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (6,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/20/PHOTO-2020-09-04-11-46-23-11.jpg.50x50_q85_crop.jpg','2020-09-22 00:20:24.676876',6);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (7,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/21/PHOTO-2020-09-04-11-46-23-5.jpg.50x50_q85_crop.jpg','2020-09-22 00:20:24.876362',7);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (8,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/20/PHOTO-2020-09-04-11-46-23-3_f6T9nfK.jpg.50x50_q85_crop.jpg','2020-09-22 00:20:25.131200',8);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (9,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/20/PHOTO-2020-09-04-11-46-23-6.jpg.50x50_q85_crop.jpg','2020-09-22 00:20:25.341511',9);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (10,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/20/images.jpeg.50x50_q85_crop.jpg','2020-09-22 00:20:25.574117',10);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (11,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/20/PHOTO-2020-09-04-11-46-23-12.jpg.50x50_q85_crop.jpg','2020-09-22 00:20:25.828765',11);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (12,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/22/PHOTO-2020-09-04-11-46-23-8_3NTwuVk.jpg.50x50_q85_crop.jpg','2020-09-25 00:50:10.651781',12);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (13,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/29/PHOTO-2020-09-04-11-46-23-5_5Ym49Es.jpg.50x50_q85_crop.jpg','2021-02-05 20:58:48.246964',13);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (14,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/29/PHOTO-2020-09-04-11-46-23-12.jpg.50x50_q85_crop.jpg','2021-02-07 00:35:55.373049',14);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (15,'d26becbf46ac48eda79c7a39a13a02dd','images/2021/02/08/C01S-T2__2.jpg.50x50_q85_crop.jpg','2021-02-08 07:54:10.659466',15);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (16,'d26becbf46ac48eda79c7a39a13a02dd','images/2020/09/29/PHOTO-2020-09-04-11-46-23-5_coXr9Az.jpg.50x50_q85_crop.jpg','2021-02-09 07:08:17.764787',16);
INSERT INTO "easy_thumbnails_thumbnail" VALUES (17,'d26becbf46ac48eda79c7a39a13a02dd','images/2021/02/08/C01S-T2__2.jpg.50x50_q85_crop.jpg','2021-02-09 07:33:47.379917',17);
INSERT INTO "easy_thumbnails_source" VALUES (1,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/20/PHOTO-2020-09-04-11-46-23-9.jpg','2020-09-22 00:19:03.980082');
INSERT INTO "easy_thumbnails_source" VALUES (2,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/21/PHOTO-2020-09-04-11-46-23-8.jpg','2020-09-22 00:20:07.915434');
INSERT INTO "easy_thumbnails_source" VALUES (3,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/20/PHOTO-2020-09-04-11-46-23-8_Dcv2y0k.jpg','2020-09-22 00:20:08.334012');
INSERT INTO "easy_thumbnails_source" VALUES (4,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/20/PHOTO-2020-09-04-11-46-23-3_jtvpafG.jpg','2020-09-22 00:20:08.623341');
INSERT INTO "easy_thumbnails_source" VALUES (5,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/20/PHOTO-2020-09-04-11-46-23-8.jpg','2020-09-22 00:20:24.097854');
INSERT INTO "easy_thumbnails_source" VALUES (6,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/20/PHOTO-2020-09-04-11-46-23-11.jpg','2020-09-22 00:20:24.531772');
INSERT INTO "easy_thumbnails_source" VALUES (7,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/21/PHOTO-2020-09-04-11-46-23-5.jpg','2020-09-22 00:20:24.789138');
INSERT INTO "easy_thumbnails_source" VALUES (8,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/20/PHOTO-2020-09-04-11-46-23-3_f6T9nfK.jpg','2020-09-22 00:20:25.024282');
INSERT INTO "easy_thumbnails_source" VALUES (9,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/20/PHOTO-2020-09-04-11-46-23-6.jpg','2020-09-22 00:20:25.266292');
INSERT INTO "easy_thumbnails_source" VALUES (10,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/20/images.jpeg','2020-09-22 00:20:25.452744');
INSERT INTO "easy_thumbnails_source" VALUES (11,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/20/PHOTO-2020-09-04-11-46-23-12.jpg','2020-09-22 00:20:25.717129');
INSERT INTO "easy_thumbnails_source" VALUES (12,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/22/PHOTO-2020-09-04-11-46-23-8_3NTwuVk.jpg','2020-09-25 00:50:10.537647');
INSERT INTO "easy_thumbnails_source" VALUES (13,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/29/PHOTO-2020-09-04-11-46-23-5_5Ym49Es.jpg','2021-02-05 20:58:48.147534');
INSERT INTO "easy_thumbnails_source" VALUES (14,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/29/PHOTO-2020-09-04-11-46-23-12.jpg','2021-02-07 00:35:55.284891');
INSERT INTO "easy_thumbnails_source" VALUES (15,'f9bde26a1556cd667f742bd34ec7c55e','images/2021/02/08/C01S-T2__2.jpg','2021-02-08 07:54:10.590401');
INSERT INTO "easy_thumbnails_source" VALUES (16,'f9bde26a1556cd667f742bd34ec7c55e','images/2020/09/29/PHOTO-2020-09-04-11-46-23-5_coXr9Az.jpg','2021-02-09 07:08:17.660548');
INSERT INTO "easy_thumbnails_source" VALUES (17,'5e4fc44a8986f46175c0675df42cf544','images/2021/02/08/C01S-T2__2.jpg','2021-02-09 07:33:36.327744');
INSERT INTO "django_session" VALUES ('49vdp0atrdunrqs7dobst6mti3nwi9wu','Y2IxMmNkYzAwYWNmYzc1MmQyNTVjYmFlZGMwZGEzYmMzYzRkODIwZDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI4NWJjMjFiNWYxNGJkOGZmYzVhNGNmNmUyODRkNGQwZjc4MzNjNjVhIiwiY2FydCI6e319','2020-10-07 00:18:01.621683');
INSERT INTO "django_session" VALUES ('s9j5lwi7oqbw07fykzjoqu6w9q4ruoa8','YjFjOTFhYWNlY2U4MGViMGQ1YjE1YzUwNGE0YmFlMTFlYTU5OWMxYjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI4NWJjMjFiNWYxNGJkOGZmYzVhNGNmNmUyODRkNGQwZjc4MzNjNjVhIiwiY2FydCI6eyI1Ijp7InF1YW50aXR5Ijo0LCJwcmljZSI6IjEyNDQuMDAifSwiMSI6eyJxdWFudGl0eSI6OSwicHJpY2UiOiIxMjQ0LjAwIn19LCJzYXZlZCI6InRjbC1hbmRyb2lkLWFpLTRrLXRvdWNoIiwibWVudSI6WyJ0Y2wtYW5kcm9pZC1haS00ay10b3VjaCJdLCJpdGVtc190b19idXkiOlsidGNsLWFuZHJvaWQiXSwiaXRlbXMiOlsic2V0LXRvcHMiXSwibnVtX3Zpc2l0cyI6MTR9','2020-10-06 18:47:15.573240');
INSERT INTO "django_session" VALUES ('4c2mi1167anczgx83iaufw8dbju1w5x0','OGIyN2QyM2JjOGM5ZjBlNmU5OTAxMGJiMWMyZWU3MTFjOWQxN2ZhNzp7ImNhcnQiOnsiMSI6eyJxdWFudGl0eSI6MiwicHJpY2UiOiIxMjQ0LjAwIn0sIjQiOnsicXVhbnRpdHkiOjEsInByaWNlIjoiMTI0NC4wMCJ9fSwiaGlzdG9yeSI6WyJ0Y2wtYW5kcm9pZC1haS1jaHJvbWUiXX0=','2020-10-08 02:57:15.625447');
INSERT INTO "django_session" VALUES ('k6p6vsf50lskjuwcg87k1ownsna3ygwf','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-06 02:33:02.750371');
INSERT INTO "django_session" VALUES ('hicwbwa5gw38tj2m7cnvt7qix6yya3rr','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-07 00:27:36.254670');
INSERT INTO "django_session" VALUES ('r1g4mf8873w6q6tyexsap2vsr9fnjmh8','NDRhNDdmNDBmNDgyYmU2YzllM2M3MzdjZTY3NjdkOTA3ZWQ5ZmQ2NTp7ImNhcnQiOnsiOCI6eyJxdWFudGl0eSI6MiwicHJpY2UiOiIxMjQ0LjAwIn0sIjIiOnsicXVhbnRpdHkiOjIsInByaWNlIjoiMTI0NC4wMCJ9fX0=','2020-10-06 22:04:13.716312');
INSERT INTO "django_session" VALUES ('2pxm9pgf7dsdyckc4ex8fxtelo5zgly6','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-06 20:17:24.642710');
INSERT INTO "django_session" VALUES ('4gjylpew5qxzxzwf22nztbltylejrpta','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-06 22:58:34.634859');
INSERT INTO "django_session" VALUES ('qyrxmjnwxsfldz96k8f7xv1o9977ps3a','MTBiNGQ4ODBmY2VlZDczMjlhMWVhOWJjNWJmMjY1ZTM4MzMxMzk5Mzp7ImNhcnQiOnsiOCI6eyJxdWFudGl0eSI6NSwicHJpY2UiOiIxMjQ0LjAwIn19LCJfYXV0aF91c2VyX2lkIjoiMSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiODViYzIxYjVmMTRiZDhmZmM1YTRjZjZlMjg0ZDRkMGY3ODMzYzY1YSIsImhpc3RvcnkiOlsidGNsLWFuZHJvaWQtYWktNGstdG91Y2giLCJ0Y2wtYW5kcm9pZCIsImNocm9tLWRobCIsInRjbC1hbmRyb2lkLWFpLTRrLXoiLCJ0Y2wtYW5kcm9pZC1haS00ayJdfQ==','2020-10-10 01:49:58.532327');
INSERT INTO "django_session" VALUES ('yuc1yk9r3h6lwiu1ithjpezv23qn4q2c','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-08 00:33:29.188940');
INSERT INTO "django_session" VALUES ('sapcahjmcceo9p19xous25b3w0qqj77y','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-08 00:34:48.147831');
INSERT INTO "django_session" VALUES ('ool1w1tfbne57z6ntydtkfqe7ejre1ui','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-08 03:13:01.799980');
INSERT INTO "django_session" VALUES ('mz60wywjzojbdy1i8y6akmhxhb7wi88f','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-09 00:18:08.590301');
INSERT INTO "django_session" VALUES ('t1a08hbtkzwfua91y4ikjxyct1jheffy','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-09 00:20:30.882785');
INSERT INTO "django_session" VALUES ('nckia8au7p1o3a990h0g3wt49xtr53dy','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-09 00:26:09.029249');
INSERT INTO "django_session" VALUES ('hljleiu80wu7ncv3gj897tapd22476j8','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-09 00:21:12.402338');
INSERT INTO "django_session" VALUES ('izyh8o945vuvwqmtrbdcg6nfvtx8d75f','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-09 00:27:43.579280');
INSERT INTO "django_session" VALUES ('ub6ejxhqlfjy9afb3wck28cazvien5cw','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-09 00:28:00.441012');
INSERT INTO "django_session" VALUES ('bxu8ep7y0e2drrsmeuwpq1xpfz782bhz','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-09 00:38:39.623579');
INSERT INTO "django_session" VALUES ('a3vst9kjbgp2r0uj9wz0f0wsabv10kvn','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-09 00:41:58.578879');
INSERT INTO "django_session" VALUES ('pmma7mzsd5dt6pk0t8ohntuprt9zr6je','M2JmMzE4NGViODU5ZDIzMDRkYzVkZjAxMTI4YTBiYTZhMWViMGNjOTp7ImNhcnQiOnt9LCJfYXV0aF91c2VyX2lkIjoiMSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiODViYzIxYjVmMTRiZDhmZmM1YTRjZjZlMjg0ZDRkMGY3ODMzYzY1YSJ9','2020-10-13 01:14:10.281020');
INSERT INTO "django_session" VALUES ('zur1ojb504qfxktpu7fzwfw8mus5j1vk','NGYzZDY1MTJkYWNkNzBiNjllMjM1N2QxM2FlMWVjNzU3ZGI1YzE2Mzp7ImNhcnQiOnsiMSI6eyJxdWFudGl0eSI6MSwicHJpY2UiOiIxMjQ0LjAwIn19LCJfYXV0aF91c2VyX2lkIjoiMSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiODViYzIxYjVmMTRiZDhmZmM1YTRjZjZlMjg0ZDRkMGY3ODMzYzY1YSJ9','2020-10-14 22:27:12.563201');
INSERT INTO "django_session" VALUES ('iv6ub97wjq1i4a0rxfurapag406ntf6s','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-14 22:28:38.299659');
INSERT INTO "django_session" VALUES ('rpgkuhogcmms9z3r1bxzpvzjo71nj2hc','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-23 00:21:29.402677');
INSERT INTO "django_session" VALUES ('cgnju2sbddh30rkovz48aqo75et6u7yq','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-23 01:35:48.576389');
INSERT INTO "django_session" VALUES ('zdnshglzgth909hpy3mzsi99grf6etzt','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-10-23 01:01:37.937310');
INSERT INTO "django_session" VALUES ('uwi6mo6linnrwlgwdvgkm1ky4dk3lyiu','NjI5YjAxZjUxMDgyMjFmNjA1NGEzYzkyMWY5ZWFhMjFiZGIyZDQ4ZDp7ImNhcnQiOnsiOCI6eyJxdWFudGl0eSI6MSwicHJpY2UiOiIxMjQ0LjAwIn19LCJoaXN0b3J5IjpbImVtbWFudWVsLWFnZ3JleS1lbW1hbiIsInRjbC1hbmRyb2lkLWFpLTRrLXoiXX0=','2020-11-13 00:00:16.611720');
INSERT INTO "django_session" VALUES ('6a402nhqfk9t8wgjywbonbyt82olup8m','MjE0NTAwOTJmZDY0NjhiNTQ1NjAzNWQ3ZGM1ZTI3NjgyYzZhZGVhYjp7ImNhcnQiOnt9LCJoaXN0b3J5IjpbImFnZ3JleS10ZXllLWplc3NpLXdSIl0sImFjY291bnRfdmVyaWZpZWRfZW1haWwiOm51bGx9','2020-11-13 21:21:14.113426');
INSERT INTO "django_session" VALUES ('5cac81gn6zwbrh61it3shta0woq22myc','YTFhZWE0MjJjNjQ3OGZiMDE4YWY2NmNjZTA3NzNlOWUxYmYzNTE0ZDp7ImNhcnQiOnsiOSI6eyJxdWFudGl0eSI6MSwicHJpY2UiOiIxMjQ0LjAwIn19LCJoaXN0b3J5IjpbInRjbC1hbmRyb2lkIl19','2020-11-13 21:24:33.447163');
INSERT INTO "django_session" VALUES ('gmw61pahjr6cm3el137csb0he3s83zyc','M2JmMzE4NGViODU5ZDIzMDRkYzVkZjAxMTI4YTBiYTZhMWViMGNjOTp7ImNhcnQiOnt9LCJfYXV0aF91c2VyX2lkIjoiMSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiODViYzIxYjVmMTRiZDhmZmM1YTRjZjZlMjg0ZDRkMGY3ODMzYzY1YSJ9','2020-11-13 21:28:36.183458');
INSERT INTO "django_session" VALUES ('1v7j4ns8qkyqsvcj56ex047axlnq3aup','OTZiN2M5NzJkOTQxZmQxMTM1NzJiOGFhNThkYzJhZmIyMjVjZTQyMzp7ImNhcnQiOnt9LCJzb2NpYWxhY2NvdW50X3N0YXRlIjpbeyJwcm9jZXNzIjoibG9naW4iLCJzY29wZSI6IiIsImF1dGhfcGFyYW1zIjoiIn0sIm9VQWFjMHJhWGJZUCJdfQ==','2020-11-13 22:18:48.483751');
INSERT INTO "django_session" VALUES ('7pzouwl7mx5h7yvfxho5ab6s2z9mu111','Y2IxMmNkYzAwYWNmYzc1MmQyNTVjYmFlZGMwZGEzYmMzYzRkODIwZDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI4NWJjMjFiNWYxNGJkOGZmYzVhNGNmNmUyODRkNGQwZjc4MzNjNjVhIiwiY2FydCI6e319','2020-11-13 23:49:36.921902');
INSERT INTO "django_session" VALUES ('gl3tvud6a4tg5mv7um8yu7zk4q5yqtik','Mjk4NjdmZjQ4NjJlZGU3YThjOTUyNDcyNGE1ZGYzNmY3NzRlYjJmZTp7ImNhcnQiOnsiNiI6eyJxdWFudGl0eSI6MSwicHJpY2UiOiIxMjQ0LjAwIn19LCJfYXV0aF91c2VyX2lkIjoiNCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6ImQ2ODI2MzgzOGY2OGZhYmRiNzRlNTM4YmNmNzUyZTkzYTE3NmY3NzMiLCJoaXN0b3J5IjpbInRjbC1hbmRyb2lkLWFpLWNocm9tZSJdfQ==','2020-12-02 00:30:12.979208');
INSERT INTO "django_session" VALUES ('h2ila73tq0uv4af141cvgxhxvwmpielk','MmFiOTI2NjY0N2Q4MjVkNDQwZTU0YTg3N2JkNzY5NzllNWE5MTBhYTp7ImNhcnQiOnsiNyI6eyJxdWFudGl0eSI6MSwicHJpY2UiOiIxMjQ0LjAwIn19LCJoaXN0b3J5IjpbImNocm9tLWRobCJdLCJfYXV0aF91c2VyX2lkIjoiMSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiODViYzIxYjVmMTRiZDhmZmM1YTRjZjZlMjg0ZDRkMGY3ODMzYzY1YSJ9','2020-12-16 11:40:00.289878');
INSERT INTO "django_session" VALUES ('afe0oi6lnvvd7xmc9cekycp5201525wg','NGEyN2YwOWRmMGMwZDJkNGVhOGVhZDU3OTY2Yzk0YmU5Y2RjOTRhZjp7ImNhcnQiOnt9LCJoaXN0b3J5IjpbInRjbC1hbmRyb2lkLWFpLTRrLXoiLCJ0Y2wtYW5kcm9pZC1haS00ay10b3VjaCIsInRjbC1hbmRyb2lkLWFpLWNocm9tZSJdLCJfYXV0aF91c2VyX2lkIjoiMSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiODViYzIxYjVmMTRiZDhmZmM1YTRjZjZlMjg0ZDRkMGY3ODMzYzY1YSJ9','2020-12-16 23:29:06.180199');
INSERT INTO "django_session" VALUES ('wfomjuwk8hxvypt2yoz74cxqc7mnux3u','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-12-19 12:33:11.192175');
INSERT INTO "django_session" VALUES ('g8jwh9pcpmop2ns9a2f9w3phv6q97zep','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-12-18 10:57:57.213887');
INSERT INTO "django_session" VALUES ('qsrwlvlm4dfvrabrhyw6sj2nkepq6mae','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-12-18 15:58:26.237876');
INSERT INTO "django_session" VALUES ('1ozyzv1bpqi93i41k7xdevgxmhu7su9j','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-12-18 16:30:03.403330');
INSERT INTO "django_session" VALUES ('on5d9daxe93qnji3jyq9qngaa269uchi','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2020-12-19 07:10:06.303213');
INSERT INTO "django_session" VALUES ('h0ogd5hdtwxdqqimukrd7czv4ld20jvk','MmNiOWQ4YTI2YjhiOWFlMTczZGZjMzM3ZWRkNmE1MTk2YTE4YmE5MTp7Imhpc3RvcnkiOlsidGNsLWFuZHJvaWQtYWktY2hyb21lIiwidGNsLWFuZHJvaWQtYWktNGstdG91Y2giLCJzZXQtdG9wLWJveGVzLXN0YXItdGltZXMiXSwiY2FydCI6e319','2021-01-04 04:46:05.451100');
INSERT INTO "django_session" VALUES ('j4nclpxh5a4m8sgfadn68iwdh4fx1ljn','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-01-05 01:52:22.908737');
INSERT INTO "django_session" VALUES ('jjs9squm328hssgr0kmmhm41ya73cdrm','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-01-05 01:50:28.173608');
INSERT INTO "django_session" VALUES ('5wzka51i04360hbft38480k340hfphpj','Mjk0NzdkYTcwMzk0MDM4ZDllOGZhNGU0ZWFkZmJmMGU5Y2NmYjhkYzp7ImNhcnQiOnsiMSI6eyJxdWFudGl0eSI6NzAsInByaWNlIjoiMTI0NC4wMCJ9LCI0Ijp7InF1YW50aXR5Ijo2LCJwcmljZSI6IjEyNDQuMDAifX0sImhpc3RvcnkiOlsic2V0LXRvcC1ib3hlcy1zdGFyLXRpbWVzIiwibmFuby1zdGF0aW9uLW01LTEyIiwidGNsLWFuZHJvaWQtYWktNGstdG91Y2giLCJ0Y2wtYW5kcm9pZCIsInRjbC1hbmRyb2lkLWFpLTRrIl0sIl9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI4NWJjMjFiNWYxNGJkOGZmYzVhNGNmNmUyODRkNGQwZjc4MzNjNjVhIiwiY2FydHNpemUiOjU4fQ==','2021-02-21 16:32:18.952479');
INSERT INTO "django_session" VALUES ('cfarc231rbbxd4v2xjmfhjtu4k2pfyqz','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-19 17:04:55.514685');
INSERT INTO "django_session" VALUES ('1a5vto90eanb4rgcrd2ni4ztlbil5hl4','ZjJlMDkxZGIzZGE3MmNlNGExN2Y2M2FkOWYzNjcyODcwOWFlZmFlODp7ImNhcnQiOnsiNDAiOnsicXVhbnRpdHkiOjEsInByaWNlIjoiMTI0NC4wMCJ9fSwiaGlzdG9yeSI6WyJzZXQtdG9wLWJveGVzLXN0YXItdGltZXMiLCJuYW5vLXN0YXRpb24tbTUtMTIiXSwiX2F1dGhfdXNlcl9pZCI6IjEiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6Ijg1YmMyMWI1ZjE0YmQ4ZmZjNWE0Y2Y2ZTI4NGQ0ZDBmNzgzM2M2NWEifQ==','2021-02-19 20:58:47.878573');
INSERT INTO "django_session" VALUES ('stba8ivgw49ax1hk2u1byf9opqfv8c7o','NThkMDUwYzk5MmExN2Y1Y2RjYWY3ODVkYjU2NmYzOWVhZGUyNzEzODp7Imhpc3RvcnkiOlsibmFuby1zdGF0aW9uLW01LTEyIl0sImNhcnQiOnt9fQ==','2021-02-19 20:58:32.753108');
INSERT INTO "django_session" VALUES ('l7w2uvkvewoco0wptcacjt0licgcxkx5','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-20 00:17:51.746420');
INSERT INTO "django_session" VALUES ('5x8pg8o8mlfwcj4oa9tc50a2565uc04i','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-20 00:18:45.725080');
INSERT INTO "django_session" VALUES ('ud7mkgwwawowbecm3razgrgmiui7wg9a','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-20 15:31:50.526710');
INSERT INTO "django_session" VALUES ('dxjbkirbx3989z6vbnmfav7d0xekjq0b','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-20 21:12:03.913713');
INSERT INTO "django_session" VALUES ('gvl6i9sxbouxw63twdle8wwejylmxxjm','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-20 21:47:27.939690');
INSERT INTO "django_session" VALUES ('1bfotkikbpvbkxv2cqg5ngxy5l1gmbxx','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-20 21:47:57.610786');
INSERT INTO "django_session" VALUES ('dgnvdeae9pk5r6z2u9o3cmr0yrukp5wx','ZmM5M2NiOGIyZTFhMzU2M2YzZjgyMmE2NDhkMjlmMzcwM2EzZTJhOTp7ImNhcnQiOnsiMzgiOnsicXVhbnRpdHkiOjUsInByaWNlIjoiMTI0NC4wMCJ9fSwiaGlzdG9yeSI6WyJ0Y2wtYW5kcm9pZC1haS1jaHJvbWUiLCJzZXQtdG9wLWJveGVzLXN0YXItdGltZXMiLCJ0Y2wtYW5kcm9pZC1haS00ayIsInRjbC1hbmRyb2lkLWFpLTRrLTEyIiwiY2hyb20tZGhsIiwidGNsLWFuZHJvaWQtYWktNGstdG91Y2giLCJ0Y2wtYW5kcm9pZC1haS00ay16IiwidGNsLWFuZHJvaWQtYWktNGstcTIiLCJ0Y2wtYW5kcm9pZCJdfQ==','2021-02-21 01:02:21.127749');
INSERT INTO "django_session" VALUES ('k20nq0p53hlwdsyd5ams3gbw88lrvvav','MzFmZmMyMDg0MmE3NzIyYWRjMDdlNDYxZTI4ZTVmYzE2MmZhMjcwNjp7Imhpc3RvcnkiOlsidGNsLWFuZHJvaWQtYWktNGstMTIiXSwiY2FydCI6e319','2021-02-21 00:35:18.552217');
INSERT INTO "django_session" VALUES ('q3nprljqvysat03kiotgx07162bl4or3','MzMxMjBmNWNlNjFkOGNhMjhmOWE1YjJiYTVjNTdiMWRlZjYwMGEzYzp7ImNhcnQiOnt9LCJoaXN0b3J5IjpbInRjbC1hbmRyb2lkLWFpLTRrLXRvdWNoIiwidGNsLWFuZHJvaWQtYWktNGsiLCJ0Y2wtYW5kcm9pZC1haS00ay0xMiJdfQ==','2021-02-21 01:19:00.646074');
INSERT INTO "django_session" VALUES ('r2p05r1rubsfeviqfijr9fbrxnhkym6y','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-21 01:03:46.814380');
INSERT INTO "django_session" VALUES ('g8i6ahkxy5lfqpwf4kp1raraquc2367u','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-21 01:09:43.591991');
INSERT INTO "django_session" VALUES ('zqq0polqe0kmsp7bkycu1xe410wku5vy','NDQxZjVlYzFhOTBiNjdkYTI1ZGJhYmUyZDdhZjFhN2M2YjRkOTRhNTp7ImNhcnQiOnt9LCJoaXN0b3J5IjpbInRjbC1hbmRyb2lkLWFpLTRrLTEyIl19','2021-02-24 04:17:09.648286');
INSERT INTO "django_session" VALUES ('akjbvw6f3isunc7vzqx1xyo6v2s1ddn9','MjUwOTU0YmNkYjI4Njc2ZjIwNWNhYjAxM2Q3Y2YxMGMyNmE5NDZmYTp7ImNhcnQiOnt9LCJoaXN0b3J5IjpbInRjbC1hbmRyb2lkLWFpLTRrLXoiLCJuYW5vLXN0YXRpb24tbTUtMTIiXX0=','2021-02-24 01:17:18.117680');
INSERT INTO "django_session" VALUES ('c4mewxwedqcu5mrqj5us12a6jizm27an','NWY1ZmQ4YTA5NGJiOGRlNTRlY2Q5YzY4YWE4NTBkOTUyZWNiZGUyNDp7ImNhcnQiOnsiNDAiOnsicXVhbnRpdHkiOjIsInByaWNlIjoiMTI0NC4wMCJ9fSwiaGlzdG9yeSI6WyJ0Y2wtYW5kcm9pZC1haS00ay10b3VjaCIsIm5hbm8tc3RhdGlvbi1tNS0xMiJdfQ==','2021-02-22 07:54:10.406989');
INSERT INTO "django_session" VALUES ('2iumd0tmozfs1nuk2yqexfu72bvngg93','Yjk1NzkxZmY2ZDhjOTAzMjdlNTAyYzg1NjMxNzI4MjBlZDU2YWRjMTp7ImNhcnQiOnt9LCJoaXN0b3J5IjpbInNldC10b3AtYm94ZXMtc3Rhci10aW1lcyIsIm5hbm8tc3RhdGlvbi1tNS0xMiJdfQ==','2021-02-22 07:50:42.936329');
INSERT INTO "django_session" VALUES ('o7l9kwe8l78a3d9woseq7ma0oxn022p7','OGY4NjBhMGIxZmEyNWNlZjNkN2RlY2I5ZTViY2I4ZmFkNzQzNTUwMTp7ImNhcnQiOnt9LCJoaXN0b3J5IjpbInNldC10b3AtYm94ZXMtc3Rhci10aW1lcyIsIm5hbm8tc3RhdGlvbi1tNS0xMiIsInRjbC1hbmRyb2lkLWFpLTRrLTEyIiwidGNsLWFuZHJvaWQtYWktNGstcTIiLCJjaHJvbS1kaGwiLCJ0Y2wtYW5kcm9pZCIsInRjbC1hbmRyb2lkLWFpLTRrLXoiXSwiX2F1dGhfdXNlcl9pZCI6IjEiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6Ijg1YmMyMWI1ZjE0YmQ4ZmZjNWE0Y2Y2ZTI4NGQ0ZDBmNzgzM2M2NWEifQ==','2021-02-22 07:50:38.837200');
INSERT INTO "django_session" VALUES ('up0jlb3ge1gleuduh59geyk9nlb59jy8','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-22 06:03:48.786370');
INSERT INTO "django_session" VALUES ('udqt40verd003q3t2ewmxm5hwaakx86f','NThkMDUwYzk5MmExN2Y1Y2RjYWY3ODVkYjU2NmYzOWVhZGUyNzEzODp7Imhpc3RvcnkiOlsibmFuby1zdGF0aW9uLW01LTEyIl0sImNhcnQiOnt9fQ==','2021-02-22 06:23:02.642736');
INSERT INTO "django_session" VALUES ('z4271pmguvch5e9mbgle987j9yeov5o8','NThkMDUwYzk5MmExN2Y1Y2RjYWY3ODVkYjU2NmYzOWVhZGUyNzEzODp7Imhpc3RvcnkiOlsibmFuby1zdGF0aW9uLW01LTEyIl0sImNhcnQiOnt9fQ==','2021-02-22 07:13:56.766974');
INSERT INTO "django_session" VALUES ('4igldtvjv7g9xmz1cmicnr8jf6g2g1fe','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-23 00:46:15.133412');
INSERT INTO "django_session" VALUES ('lag2phg2c6r27don8jcogmvw2cdz0mg1','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-23 03:34:10.645610');
INSERT INTO "django_session" VALUES ('0h6innqb83tjrqsbx1cmbbbx2l3tq7wt','OGYzMTEwMDY5ZWM1ZDAxYjAxYWM3MzNhMTllODY2NjQ0MWRiNDU0ZTp7Imhpc3RvcnkiOlsic2V0LXRvcC1ib3hlcy1zdGFyLXRpbWVzIl0sImNhcnQiOnt9fQ==','2021-02-23 06:41:30.918627');
INSERT INTO "django_session" VALUES ('uf67epk7vxxmel2x2rrztgz1mlb7pto3','OGYzMTEwMDY5ZWM1ZDAxYjAxYWM3MzNhMTllODY2NjQ0MWRiNDU0ZTp7Imhpc3RvcnkiOlsic2V0LXRvcC1ib3hlcy1zdGFyLXRpbWVzIl0sImNhcnQiOnt9fQ==','2021-02-23 06:55:56.746869');
INSERT INTO "django_session" VALUES ('finmibbb72qypyo47ixvbyiddawzftna','MjYzZjAyZjQ1ZGZlOTkwMjg0MDk5ZTRjZTQ1ZTIyMWZmNmE5MTM0OTp7ImNhcnQiOnt9LCJoaXN0b3J5IjpbInRjbC1hbmRyb2lkLWFpLTRrLXRvdWNoIl19','2021-02-23 23:59:56.648109');
INSERT INTO "django_session" VALUES ('1ys3hooik2pwiwj8heomyjmzo1rw2jj7','MDA3Mzc5NDBkOWZlOTAwZjJiYzJiMjcyY2VkYjYxNWIxYTAyMWRlNjp7ImNhcnQiOnsiNSI6eyJxdWFudGl0eSI6MiwicHJpY2UiOiIxMjQ0LjAwIn19LCJoaXN0b3J5IjpbInRjbC1hbmRyb2lkLWFpLTRrLXRvdWNoIl19','2021-02-24 00:18:21.956859');
INSERT INTO "django_session" VALUES ('j553kw2nnxxjcvnxjfmpbfxhaa2y5xtp','NmZiNWMwZWVkMTZiMDdjOTQxZWM1OWU2YWY3NzQzODMyNzlkNzg4MDp7ImNhcnQiOnsiMzgiOnsicXVhbnRpdHkiOjEsInByaWNlIjoiMTI0NC4wMCJ9LCI0MCI6eyJxdWFudGl0eSI6NCwicHJpY2UiOiIxMjQ0LjAwIn19LCJoaXN0b3J5IjpbInRjbC1hbmRyb2lkLWFpLTRrLXRvdWNoIiwibmFuby1zdGF0aW9uLW01LTEyIiwic2V0LXRvcC1ib3hlcy1zdGFyLXRpbWVzIiwidGNsLWFuZHJvaWQtYWktNGsiLCJ0Y2wtYW5kcm9pZC1haS1jaHJvbWUiLCJlbW1hbnVlbC1hZ2dyZXktZW1tYW4iLCJ0Y2wtYW5kcm9pZC1haS00ay1xMiJdLCJfYXV0aF91c2VyX2lkIjoiMSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiODViYzIxYjVmMTRiZDhmZmM1YTRjZjZlMjg0ZDRkMGY3ODMzYzY1YSJ9','2021-02-24 01:36:56.264119');
INSERT INTO "django_session" VALUES ('vfkgergkgget322weue9mk57q61opbqv','ODdiMjdhNTdiYTNmNWY0NTgwZDc2YTI1YzEyNWIzZTE4NWE2MGI4ODp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI4NWJjMjFiNWYxNGJkOGZmYzVhNGNmNmUyODRkNGQwZjc4MzNjNjVhIiwiaGlzdG9yeSI6WyJzZXQtdG9wLWJveGVzLXN0YXItdGltZXMiLCJ0Y2wtYW5kcm9pZC1haS00ay16IiwibmFuby1zdGF0aW9uLW01LTEyIiwidGNsLWFuZHJvaWQtYWktNGsiLCJjaHJvbS1kaGwiLCJ0Y2wtYW5kcm9pZC1haS00ay10b3VjaCIsInRjbC1hbmRyb2lkLWFpLTRrLTEyIiwidGNsLWFuZHJvaWQiLCJ0Y2wtYW5kcm9pZC1haS00ay16LTEyIiwidGNsLWFuZHJvaWQtYWktNGstdG91Y2gtMTIiLCJlbW1hbnVlbC1hZ2dyZXktZW1tYW4tMTIiXSwiY2FydCI6e319','2021-02-26 05:12:02.515977');
INSERT INTO "django_session" VALUES ('5moustbbxxdvpyy5wsidczroig418ct4','ZDIzMWI2MWQ2ZjczZDg3MjE2ODE5NDQ5MTEyNDA4NzY0YzMzOTMzOTp7ImNhcnQiOnsiMSI6eyJxdWFudGl0eSI6MSwicHJpY2UiOiIxMjQ0LjAwIn0sIjUiOnsicXVhbnRpdHkiOjEsInByaWNlIjoiMTI0NC4wMCJ9fX0=','2021-02-24 15:51:24.264294');
INSERT INTO "django_session" VALUES ('grytu3g3iwdda8xganzz0ecd5di2bcnk','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-24 04:53:18.823816');
INSERT INTO "django_session" VALUES ('da1cv539q9bvqyiza0031vp894ffrn5n','ODVhODY5YzJlNDYyYzRiMGI3MDk1YTY0YTMyYjhlMmE5MWZlMjMyYzp7ImNhcnQiOnsiNSI6eyJxdWFudGl0eSI6OSwicHJpY2UiOiIxMjQ0LjAwIn0sIjEiOnsicXVhbnRpdHkiOjMsInByaWNlIjoiMTI0NC4wMCJ9LCIzOCI6eyJxdWFudGl0eSI6MSwicHJpY2UiOiIxMjQ0LjAwIn19LCJoaXN0b3J5IjpbInRjbC1hbmRyb2lkLWFpLTRrLXRvdWNoIiwibmFuby1zdGF0aW9uLW01LTEyIiwidGNsLWFuZHJvaWQtYWktNGstMTIiLCJlbW1hbnVlbC1hZ2dyZXktZW1tYW4tMTIiLCJjaHJvbS1kaGwiXX0=','2021-02-24 20:52:10.072257');
INSERT INTO "django_session" VALUES ('mh3d1atdssy7zfd24jra4w8ewget9rhq','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-24 19:18:13.367743');
INSERT INTO "django_session" VALUES ('nz5f1er0em55c926p2wwffivwsxh5vpt','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-02-26 03:08:14.391716');
INSERT INTO "django_session" VALUES ('dwygge3kyp400k50pris8bkt6g4qvv1i','NDc1NWQ2ZjZjYjQwN2Y4M2Q3NjFjMWJjN2FkZjBjMDc1MDRlMzE5ZTp7ImNhcnQiOnt9LCJfYXV0aF91c2VyX2lkIjoiNSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMzhkZTcyOTgzMjQyYjQ3ODJlNGFkNTAxNmRiYTI5YzkyZTAwYmNlZCJ9','2021-02-26 15:35:21.612182');
INSERT INTO "django_session" VALUES ('g7210sym95rc8gaolwlmiax295kv1nk9','NDc1NWQ2ZjZjYjQwN2Y4M2Q3NjFjMWJjN2FkZjBjMDc1MDRlMzE5ZTp7ImNhcnQiOnt9LCJfYXV0aF91c2VyX2lkIjoiNSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMzhkZTcyOTgzMjQyYjQ3ODJlNGFkNTAxNmRiYTI5YzkyZTAwYmNlZCJ9','2021-02-26 15:41:10.318912');
INSERT INTO "django_session" VALUES ('nwgmvzb2oyjpa61p8tde24zq7efice64','ODRhNDRhY2M1ZjViYTZkN2QxMDg2YmFhNGJlZjc4OThjYzFhZjNhNTp7InNvY2lhbGFjY291bnRfc3RhdGUiOlt7InByb2Nlc3MiOiJsb2dpbiIsInNjb3BlIjoiIiwiYXV0aF9wYXJhbXMiOiIifSwiSEtvdDB0cEwyVVJhIl0sIl9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI4NWJjMjFiNWYxNGJkOGZmYzVhNGNmNmUyODRkNGQwZjc4MzNjNjVhIiwiY2FydCI6eyIxIjp7InF1YW50aXR5IjoxLCJwcmljZSI6IjEyNDQuMDAifSwiOSI6eyJxdWFudGl0eSI6MSwicHJpY2UiOiIxMjQ0LjAwIn19LCJoaXN0b3J5IjpbInRjbC1hbmRyb2lkLWFpLTRrIiwidGNsLWFuZHJvaWQtYWktNGstei0xMiIsInRjbC1hbmRyb2lkLWFpLTRrLTEyIiwic2V0LXRvcC1ib3hlcy1zdGFyLXRpbWVzIiwibmFuby1zdGF0aW9uLW01LTEyIl19','2021-02-27 12:55:43.434266');
INSERT INTO "django_session" VALUES ('vsq28sqdhs0djlcjhvdhlhqdiclajhym','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-03-01 02:20:03.517305');
INSERT INTO "django_session" VALUES ('7k5spamtlkdtkplnyj91xvmpt6jfzqdf','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-03-01 02:53:57.306013');
INSERT INTO "django_session" VALUES ('8yu39m6aobw3ckkffpvloik5c3gqniiu','YWQyNDJkMWI5OGFiMjAyNzk2NTYxMWVlZGFiYzRlNjNlYjE1ZmNiZTp7ImNhcnQiOnsiOCI6eyJxdWFudGl0eSI6MSwicHJpY2UiOiIxMjQ0LjAwIn0sIjkiOnsicXVhbnRpdHkiOjEsInByaWNlIjoiMTI0NC4wMCJ9LCIxMiI6eyJxdWFudGl0eSI6MSwicHJpY2UiOiIxMjQ0LjAwIn19LCJzb2NpYWxhY2NvdW50X3N0YXRlIjpbeyJuZXh0IjoiL2NoZWNrb3V0LyIsInByb2Nlc3MiOiJsb2dpbiIsInNjb3BlIjoiIiwiYXV0aF9wYXJhbXMiOiIifSwiQzNrQ3A2bWVsR3ZtIl19','2021-03-01 06:50:43.115400');
INSERT INTO "django_session" VALUES ('gfpp1i6ujnq1qkv5qsli36cuy8nxc2az','NjhhOWE2M2FkYzc4YTQ2NmFkNWVmOTEzODM5YTI4ZWQ4Mzk1YWZhZTp7ImNhcnQiOnsiOCI6eyJxdWFudGl0eSI6MSwicHJpY2UiOiIxMjQ0LjAwIn0sIjkiOnsicXVhbnRpdHkiOjEsInByaWNlIjoiMTI0NC4wMCJ9fSwic29jaWFsYWNjb3VudF9zdGF0ZSI6W3sibmV4dCI6Ii9jaGVja291dC8iLCJwcm9jZXNzIjoibG9naW4iLCJzY29wZSI6IiIsImF1dGhfcGFyYW1zIjoiIn0sInJkYTVQRE9kNms1NSJdfQ==','2021-03-01 07:07:55.511281');
INSERT INTO "django_session" VALUES ('86xjrseca2y95qgggxiwh5cm6iguj4ji','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-03-01 19:00:07.524438');
INSERT INTO "django_session" VALUES ('k5zjly4710a41almicouuvqjg41pfs74','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-03-01 17:55:02.128820');
INSERT INTO "django_session" VALUES ('hjnkgzr3xuatwaamqi3jif3dfg9lj9cn','OTdhYzJkZjQ0MWRmNWU3ZmQyNDRlMjIwMTI5YzRkYzUwZTgwNTk1ODp7ImNhcnQiOnt9LCJzb2NpYWxhY2NvdW50X3N0YXRlIjpbeyJwcm9jZXNzIjoibG9naW4iLCJzY29wZSI6IiIsImF1dGhfcGFyYW1zIjoiIn0sIkV0ejAxQTU4Z3hDNCJdfQ==','2021-03-02 05:25:44.815496');
INSERT INTO "django_session" VALUES ('i1tggkux4k6ufgbhq0kwljcytuiond7k','MjI0ZWJlNzk5NDQxOWE3OWVhZmJiYzJlMmJiMDAyNWFmZWViZGNlOTp7ImNhcnQiOnt9LCJzb2NpYWxhY2NvdW50X3N0YXRlIjpbeyJwcm9jZXNzIjoicmVnaXN0ZXIiLCJzY29wZSI6IiIsImF1dGhfcGFyYW1zIjoiIn0sIk9oS1JlTldJemlaQyJdfQ==','2021-03-02 05:30:27.151109');
INSERT INTO "django_session" VALUES ('8voz1p1t8ug5srx1xum6rgkw0me1fasf','Nzk2ODA1ZTQyOTM4NjFkODViNTBjZjE1YjIxMDgxMDc0MzIyYjE3NDp7ImNhcnQiOnsiNSI6eyJxdWFudGl0eSI6MTcsInByaWNlIjoiMTI0NC4wMCJ9LCI2Ijp7InF1YW50aXR5IjoxMSwicHJpY2UiOiIxMjQ0LjAwIn0sIjciOnsicXVhbnRpdHkiOjE0LCJwcmljZSI6IjEyNDQuMDAifSwiMSI6eyJxdWFudGl0eSI6MiwicHJpY2UiOiIxMjQ0LjAwIn0sIjkiOnsicXVhbnRpdHkiOjQsInByaWNlIjoiMTI0NC4wMCJ9LCI4Ijp7InF1YW50aXR5IjoxLCJwcmljZSI6IjEyNDQuMDAifX0sImhpc3RvcnkiOlsic2V0LXRvcC1ib3hlcy1zdGFyLXRpbWVzIiwibmFuby1zdGF0aW9uLW01LTEyIiwidGNsLWFuZHJvaWQtYWktNGstMTIiLCJ0Y2wtYW5kcm9pZC1haS00ay10b3VjaCIsImNocm9tLWRobCIsInRjbC1hbmRyb2lkLWFpLWNocm9tZSIsInRjbC1hbmRyb2lkLWFpLTRrLXEyIiwiZW1tYW51ZWwtYWdncmV5LWVtbWFuIiwidGNsLWFuZHJvaWQiLCJ0Y2wtYW5kcm9pZC1haS00ay16Il0sIl9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI4NWJjMjFiNWYxNGJkOGZmYzVhNGNmNmUyODRkNGQwZjc4MzNjNjVhIn0=','2021-03-02 18:33:46.847118');
INSERT INTO "django_session" VALUES ('365w310ov4insj9loi3zjsy1cbb6etww','YTRkY2FjYjUzMGNiYjcyODFkZjE3ODJlYzQwMTY0ZjhkNzk3NzFhOTp7Il9hdXRoX3VzZXJfaWQiOiIyIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiYWxsYXV0aC5hY2NvdW50LmF1dGhfYmFja2VuZHMuQXV0aGVudGljYXRpb25CYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiOWNkMWUwMDA1MjZjZmM4NmQ1YzNkMjIyMjBkZTM0YzRjODU3ZmI5NyIsIl9zZXNzaW9uX2V4cGlyeSI6MTIwOTYwMCwiY2FydCI6e319','2021-03-02 18:52:36.214840');
INSERT INTO "django_session" VALUES ('qob7im5bqvd22aghliji2libddnbgti5','MTNlYWZhN2JlM2NmNjA5MjJmMGE1ZjY2OTdmOTk5NThjNDk5MzQ3Yjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI4NWJjMjFiNWYxNGJkOGZmYzVhNGNmNmUyODRkNGQwZjc4MzNjNjVhIn0=','2021-03-02 19:06:09.084009');
INSERT INTO "django_session" VALUES ('5q0zjgjsd51tokicjrpuzsj79ija44cd','NTVlN2VhMDAwNTQ2ZDdlMjI4MmM0OTFiYTYzYjdlZmQwZGZkM2E2Njp7ImNhcnQiOnt9fQ==','2021-03-03 00:54:11.861257');
INSERT INTO "django_session" VALUES ('p5gudtjpngb0dvl97kba5of1l0hi2wpt','YThlMDhkN2UwYzRlZGQ2N2IxZjIxYmVhOGI5NTFjZjgxZjIxZjFiMTp7ImNhcnQiOnsiOSI6eyJxdWFudGl0eSI6MSwicHJpY2UiOiIxMjQ0LjAwIn0sIjgiOnsicXVhbnRpdHkiOjEsInByaWNlIjoiMTI0NC4wMCJ9fSwiX2F1dGhfdXNlcl9pZCI6IjEiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6Ijg1YmMyMWI1ZjE0YmQ4ZmZjNWE0Y2Y2ZTI4NGQ0ZDBmNzgzM2M2NWEifQ==','2021-03-03 00:59:45.693520');
INSERT INTO "auth_group" VALUES (1,'Administrator');
INSERT INTO "auth_group" VALUES (2,'STAFF USERS');
INSERT INTO "auth_user" VALUES (1,'pbkdf2_sha256$150000$oPRTQQA1dSqF$tbwRXyZoY9Q7CGRVCA/U24KT4cTClG1c4qDM/6GBZVw=','2021-02-17 00:55:02.081826',1,'emman','','',1,1,'2020-09-20 19:42:29.223979','');
INSERT INTO "auth_user" VALUES (2,'pbkdf2_sha256$150000$JqnBgoJu1fv5$C+vUWdHs/kaBaGrIYSAoY+2IVT2FuTMdINNTiYuq4Ec=','2021-02-16 18:44:07.973185',0,'teye.etn','','teye.etn@gmail.com',0,1,'2020-10-30 21:21:13.829380','');
INSERT INTO "auth_user" VALUES (3,'pbkdf2_sha256$150000$NVCH7MpfVR6b$8eD3O1He+bJWKkASROa+Kmrn2DxcfHM5E+BhmP2wXFE=','2021-02-15 16:39:56.363330',0,'me','','me@ktu.com',0,1,'2020-10-30 21:22:16.306178','');
INSERT INTO "auth_user" VALUES (4,'!iBQnRREJ9KLrFwEkc7E82Boq1UshJQm0h6jcupXp','2020-11-18 00:30:04.433718',0,'emmanuel','Emmanuel','aggrey.en@gmail.com',0,1,'2020-10-30 22:06:38.753462','Nartey');
INSERT INTO "auth_user" VALUES (5,'pbkdf2_sha256$150000$S9dFOCvEeIEq$vi6pkPNr4OEPU40oHJkrovQFd2HVMNM5xaM8F8rHmUM=','2021-02-12 15:40:51.689446',0,'xtayconnect','','',1,1,'2021-02-12 15:27:05','');
INSERT INTO "auth_user" VALUES (6,'pbkdf2_sha256$150000$dTp4G24FSFIE$wRxfcDF+nnpXPJ9kHBKQgtDcZP07Iues+o3A+A1AwC4=','2021-02-15 15:35:27.540730',0,'me2','','me@me.com',0,1,'2021-02-15 15:34:54.076456','');
INSERT INTO "auth_permission" VALUES (1,1,'add_logentry','Can add log entry');
INSERT INTO "auth_permission" VALUES (2,1,'change_logentry','Can change log entry');
INSERT INTO "auth_permission" VALUES (3,1,'delete_logentry','Can delete log entry');
INSERT INTO "auth_permission" VALUES (4,1,'view_logentry','Can view log entry');
INSERT INTO "auth_permission" VALUES (5,2,'add_permission','Can add permission');
INSERT INTO "auth_permission" VALUES (6,2,'change_permission','Can change permission');
INSERT INTO "auth_permission" VALUES (7,2,'delete_permission','Can delete permission');
INSERT INTO "auth_permission" VALUES (8,2,'view_permission','Can view permission');
INSERT INTO "auth_permission" VALUES (9,3,'add_group','Can add group');
INSERT INTO "auth_permission" VALUES (10,3,'change_group','Can change group');
INSERT INTO "auth_permission" VALUES (11,3,'delete_group','Can delete group');
INSERT INTO "auth_permission" VALUES (12,3,'view_group','Can view group');
INSERT INTO "auth_permission" VALUES (13,4,'add_user','Can add user');
INSERT INTO "auth_permission" VALUES (14,4,'change_user','Can change user');
INSERT INTO "auth_permission" VALUES (15,4,'delete_user','Can delete user');
INSERT INTO "auth_permission" VALUES (16,4,'view_user','Can view user');
INSERT INTO "auth_permission" VALUES (17,5,'add_contenttype','Can add content type');
INSERT INTO "auth_permission" VALUES (18,5,'change_contenttype','Can change content type');
INSERT INTO "auth_permission" VALUES (19,5,'delete_contenttype','Can delete content type');
INSERT INTO "auth_permission" VALUES (20,5,'view_contenttype','Can view content type');
INSERT INTO "auth_permission" VALUES (21,6,'add_session','Can add session');
INSERT INTO "auth_permission" VALUES (22,6,'change_session','Can change session');
INSERT INTO "auth_permission" VALUES (23,6,'delete_session','Can delete session');
INSERT INTO "auth_permission" VALUES (24,6,'view_session','Can view session');
INSERT INTO "auth_permission" VALUES (25,7,'add_category','Can add category');
INSERT INTO "auth_permission" VALUES (26,7,'change_category','Can change category');
INSERT INTO "auth_permission" VALUES (27,7,'delete_category','Can delete category');
INSERT INTO "auth_permission" VALUES (28,7,'view_category','Can view category');
INSERT INTO "auth_permission" VALUES (29,8,'add_sub_category','Can add sub_ category');
INSERT INTO "auth_permission" VALUES (30,8,'change_sub_category','Can change sub_ category');
INSERT INTO "auth_permission" VALUES (31,8,'delete_sub_category','Can delete sub_ category');
INSERT INTO "auth_permission" VALUES (32,8,'view_sub_category','Can view sub_ category');
INSERT INTO "auth_permission" VALUES (33,9,'add_product','Can add product');
INSERT INTO "auth_permission" VALUES (34,9,'change_product','Can change product');
INSERT INTO "auth_permission" VALUES (35,9,'delete_product','Can delete product');
INSERT INTO "auth_permission" VALUES (36,9,'view_product','Can view product');
INSERT INTO "auth_permission" VALUES (37,10,'add_order','Can add order');
INSERT INTO "auth_permission" VALUES (38,10,'change_order','Can change order');
INSERT INTO "auth_permission" VALUES (39,10,'delete_order','Can delete order');
INSERT INTO "auth_permission" VALUES (40,10,'view_order','Can view order');
INSERT INTO "auth_permission" VALUES (41,11,'add_orderitem','Can add order item');
INSERT INTO "auth_permission" VALUES (42,11,'change_orderitem','Can change order item');
INSERT INTO "auth_permission" VALUES (43,11,'delete_orderitem','Can delete order item');
INSERT INTO "auth_permission" VALUES (44,11,'view_orderitem','Can view order item');
INSERT INTO "auth_permission" VALUES (45,12,'add_source','Can add source');
INSERT INTO "auth_permission" VALUES (46,12,'change_source','Can change source');
INSERT INTO "auth_permission" VALUES (47,12,'delete_source','Can delete source');
INSERT INTO "auth_permission" VALUES (48,12,'view_source','Can view source');
INSERT INTO "auth_permission" VALUES (49,13,'add_thumbnail','Can add thumbnail');
INSERT INTO "auth_permission" VALUES (50,13,'change_thumbnail','Can change thumbnail');
INSERT INTO "auth_permission" VALUES (51,13,'delete_thumbnail','Can delete thumbnail');
INSERT INTO "auth_permission" VALUES (52,13,'view_thumbnail','Can view thumbnail');
INSERT INTO "auth_permission" VALUES (53,14,'add_thumbnaildimensions','Can add thumbnail dimensions');
INSERT INTO "auth_permission" VALUES (54,14,'change_thumbnaildimensions','Can change thumbnail dimensions');
INSERT INTO "auth_permission" VALUES (55,14,'delete_thumbnaildimensions','Can delete thumbnail dimensions');
INSERT INTO "auth_permission" VALUES (56,14,'view_thumbnaildimensions','Can view thumbnail dimensions');
INSERT INTO "auth_permission" VALUES (57,15,'add_site','Can add site');
INSERT INTO "auth_permission" VALUES (58,15,'change_site','Can change site');
INSERT INTO "auth_permission" VALUES (59,15,'delete_site','Can delete site');
INSERT INTO "auth_permission" VALUES (60,15,'view_site','Can view site');
INSERT INTO "auth_permission" VALUES (61,16,'add_emailaddress','Can add email address');
INSERT INTO "auth_permission" VALUES (62,16,'change_emailaddress','Can change email address');
INSERT INTO "auth_permission" VALUES (63,16,'delete_emailaddress','Can delete email address');
INSERT INTO "auth_permission" VALUES (64,16,'view_emailaddress','Can view email address');
INSERT INTO "auth_permission" VALUES (65,17,'add_emailconfirmation','Can add email confirmation');
INSERT INTO "auth_permission" VALUES (66,17,'change_emailconfirmation','Can change email confirmation');
INSERT INTO "auth_permission" VALUES (67,17,'delete_emailconfirmation','Can delete email confirmation');
INSERT INTO "auth_permission" VALUES (68,17,'view_emailconfirmation','Can view email confirmation');
INSERT INTO "auth_permission" VALUES (69,18,'add_socialaccount','Can add social account');
INSERT INTO "auth_permission" VALUES (70,18,'change_socialaccount','Can change social account');
INSERT INTO "auth_permission" VALUES (71,18,'delete_socialaccount','Can delete social account');
INSERT INTO "auth_permission" VALUES (72,18,'view_socialaccount','Can view social account');
INSERT INTO "auth_permission" VALUES (73,19,'add_socialapp','Can add social application');
INSERT INTO "auth_permission" VALUES (74,19,'change_socialapp','Can change social application');
INSERT INTO "auth_permission" VALUES (75,19,'delete_socialapp','Can delete social application');
INSERT INTO "auth_permission" VALUES (76,19,'view_socialapp','Can view social application');
INSERT INTO "auth_permission" VALUES (77,20,'add_socialtoken','Can add social application token');
INSERT INTO "auth_permission" VALUES (78,20,'change_socialtoken','Can change social application token');
INSERT INTO "auth_permission" VALUES (79,20,'delete_socialtoken','Can delete social application token');
INSERT INTO "auth_permission" VALUES (80,20,'view_socialtoken','Can view social application token');
INSERT INTO "django_content_type" VALUES (1,'admin','logentry');
INSERT INTO "django_content_type" VALUES (2,'auth','permission');
INSERT INTO "django_content_type" VALUES (3,'auth','group');
INSERT INTO "django_content_type" VALUES (4,'auth','user');
INSERT INTO "django_content_type" VALUES (5,'contenttypes','contenttype');
INSERT INTO "django_content_type" VALUES (6,'sessions','session');
INSERT INTO "django_content_type" VALUES (7,'ecommerce','category');
INSERT INTO "django_content_type" VALUES (8,'ecommerce','sub_category');
INSERT INTO "django_content_type" VALUES (9,'ecommerce','product');
INSERT INTO "django_content_type" VALUES (10,'orders','order');
INSERT INTO "django_content_type" VALUES (11,'orders','orderitem');
INSERT INTO "django_content_type" VALUES (12,'easy_thumbnails','source');
INSERT INTO "django_content_type" VALUES (13,'easy_thumbnails','thumbnail');
INSERT INTO "django_content_type" VALUES (14,'easy_thumbnails','thumbnaildimensions');
INSERT INTO "django_content_type" VALUES (15,'sites','site');
INSERT INTO "django_content_type" VALUES (16,'account','emailaddress');
INSERT INTO "django_content_type" VALUES (17,'account','emailconfirmation');
INSERT INTO "django_content_type" VALUES (18,'socialaccount','socialaccount');
INSERT INTO "django_content_type" VALUES (19,'socialaccount','socialapp');
INSERT INTO "django_content_type" VALUES (20,'socialaccount','socialtoken');
INSERT INTO "django_admin_log" VALUES (1,'2020-09-20 19:48:22.836227','1','Category object (1)','[{"added": {}}]',7,1,1);
INSERT INTO "django_admin_log" VALUES (2,'2020-09-20 19:48:32.976832','2','Category object (2)','[{"added": {}}]',7,1,1);
INSERT INTO "django_admin_log" VALUES (3,'2020-09-20 19:48:40.211627','3','Category object (3)','[{"added": {}}]',7,1,1);
INSERT INTO "django_admin_log" VALUES (4,'2020-09-20 19:48:48.324191','4','Category object (4)','[{"added": {}}]',7,1,1);
INSERT INTO "django_admin_log" VALUES (5,'2020-09-20 19:52:58.187067','1','Android TV: DTH Products','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (6,'2020-09-20 19:53:18.408931','2','Set Top Boxes: DTH Products','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (7,'2020-09-20 19:53:29.650881','3','Chrome Boxes: DTH Products','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (8,'2020-09-20 19:53:39.268221','4','Chrome Casts: DTH Products','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (9,'2020-09-20 19:53:56.178088','5','WiFi Dongles: DTH Products','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (10,'2020-09-20 19:54:11.823966','6','Smart Home Devices: Smart Home Devices','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (11,'2020-09-20 19:54:30.998447','6','Centralized Security & Surveillance Systems: Smart Home Devices','[{"changed": {"fields": ["name"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (12,'2020-09-20 19:54:46.132635','7','Bulbs: Smart Home Devices','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (13,'2020-09-20 19:54:56.193273','8','Fans: Smart Home Devices','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (14,'2020-09-20 19:55:05.900096','9','Fridges: Smart Home Devices','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (15,'2020-09-20 19:55:47.799693','10','XtayConnect Internet: Internet Services','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (16,'2020-09-20 19:56:04.572026','11','Public Outdoor Hotspots: Internet Services','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (17,'2020-09-20 19:56:19.385767','12','4G LTE Routers: Internet Services','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (18,'2020-09-20 20:15:53.198282','1','TCL Android AI 4K: DTH Products : Android TV','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (19,'2020-09-20 20:35:09.825343','2','Akai 32": Smart Home Devices : Fridges','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (20,'2020-09-20 20:35:27.314599','2','Akai 32": Smart Home Devices : Fridges','[{"changed": {"fields": ["images"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (21,'2020-09-20 21:42:21.416156','2','Akai 32": Smart Home Devices : Fridges','[{"changed": {"fields": ["slug"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (22,'2020-09-20 21:42:25.579271','1','TCL Android AI 4K: DTH Products : Android TV','[{"changed": {"fields": ["slug"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (23,'2020-09-20 22:06:27.609478','1','TCL Android AI 4K: DTH Products : Android TV','[{"changed": {"fields": ["images"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (24,'2020-09-20 22:06:35.749659','1','TCL Android AI 4K: DTH Products : Android TV','[{"changed": {"fields": ["images"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (25,'2020-09-20 22:31:06.833060','3','WiFi 2.4 & 5.0GHz Band: Internet Services : 4G LTE Routers','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (26,'2020-09-20 22:31:38.314431','3','WiFi 2.4 & 5.0GHz Band: Internet Services : 4G LTE Routers','[]',9,1,2);
INSERT INTO "django_admin_log" VALUES (27,'2020-09-20 22:31:41.763664','3','WiFi 2.4 & 5.0GHz Band: Internet Services : 4G LTE Routers','[]',9,1,2);
INSERT INTO "django_admin_log" VALUES (28,'2020-09-20 22:32:40.098914','4','Set Top Boxes  Star times: DTH Products : Set Top Boxes','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (29,'2020-09-20 22:33:20.424373','5','TCL Android AI 4K  Touch: DTH Products : Android TV','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (30,'2020-09-20 22:33:55.251465','6','TCL Android AI Chrome: DTH Products : Chrome Casts','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (31,'2020-09-20 22:50:52.689604','7','Chrom DHL: DTH Products : Chrome Casts','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (32,'2020-09-20 23:49:13.216881','8','TCL Android AI 4K  z: DTH Products : Android TV','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (33,'2020-09-20 23:49:41.134627','9','TCL Android: DTH Products : Android TV','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (34,'2020-09-21 00:01:55.368640','10','set tops: DTH Products : Set Top Boxes','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (35,'2020-09-21 00:02:13.690381','11','boxes: DTH Products : Set Top Boxes','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (36,'2020-09-22 00:27:53.695358','2','Akai 32": Smart Home Devices : Fridges','[{"changed": {"fields": ["description"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (37,'2020-09-22 13:00:12.204345','8','Aggrey Teye','',7,1,3);
INSERT INTO "django_admin_log" VALUES (38,'2020-09-22 13:00:12.315349','7','TCL Android AI 4K','',7,1,3);
INSERT INTO "django_admin_log" VALUES (39,'2020-09-22 13:00:12.436101','6','Aggrey','',7,1,3);
INSERT INTO "django_admin_log" VALUES (40,'2020-09-22 13:00:12.557922','5','Aggrey category','',7,1,3);
INSERT INTO "django_admin_log" VALUES (41,'2020-09-23 00:31:43.393797','23','Internet Services : TCL Android AI 4K ','',8,1,3);
INSERT INTO "django_admin_log" VALUES (42,'2020-09-23 00:31:43.505905','22','Smart Home Devices : Work lets see','',8,1,3);
INSERT INTO "django_admin_log" VALUES (43,'2020-09-23 00:31:43.672060','21','Smart Home Devices : TCL Android AI 4K ','',8,1,3);
INSERT INTO "django_admin_log" VALUES (44,'2020-09-23 00:31:43.793827','20','Internet Services : HEALTH','',8,1,3);
INSERT INTO "django_admin_log" VALUES (45,'2020-09-23 00:31:43.937819','19','Emmanuel Aggrey : Emmanuel Aggrey','',8,1,3);
INSERT INTO "django_admin_log" VALUES (46,'2020-09-23 00:31:44.050311','18','Emmanuel Aggrey : Aggrey','',8,1,3);
INSERT INTO "django_admin_log" VALUES (47,'2020-09-23 00:31:44.447264','17','IPTV Services : Aggrey ss','',8,1,3);
INSERT INTO "django_admin_log" VALUES (48,'2020-09-23 00:31:44.558273','16','DTH Products : zadfasr','',8,1,3);
INSERT INTO "django_admin_log" VALUES (49,'2020-09-23 00:31:44.669475','15','DTH Products : TCL Android AI 4K dd','',8,1,3);
INSERT INTO "django_admin_log" VALUES (50,'2020-09-23 00:31:44.779596','14','IPTV Services : TCL Android AI 4K ','',8,1,3);
INSERT INTO "django_admin_log" VALUES (51,'2020-09-23 00:31:44.890331','13','DTH Products : Aggrey','',8,1,3);
INSERT INTO "django_admin_log" VALUES (52,'2020-09-23 00:32:40.074852','12','Internet Services : 4G LTE Routers','',8,1,3);
INSERT INTO "django_admin_log" VALUES (53,'2020-09-23 00:32:40.176942','11','Internet Services : Public Outdoor Hotspots','',8,1,3);
INSERT INTO "django_admin_log" VALUES (54,'2020-09-23 00:33:23.247582','9','Smart Home Devices : Fridges','',8,1,3);
INSERT INTO "django_admin_log" VALUES (55,'2020-09-23 00:33:23.369872','8','Smart Home Devices : Fans','',8,1,3);
INSERT INTO "django_admin_log" VALUES (56,'2020-09-23 00:33:23.491637','7','Smart Home Devices : Bulbs','',8,1,3);
INSERT INTO "django_admin_log" VALUES (57,'2020-09-23 00:34:36.452686','17','TCL Android AI 4K : DTH Products : Android TV','',9,1,3);
INSERT INTO "django_admin_log" VALUES (58,'2020-09-23 00:34:36.542788','16','Aggrey dddddddddddd: DTH Products : Android TV','',9,1,3);
INSERT INTO "django_admin_log" VALUES (59,'2020-09-23 00:34:36.664555','15','Teye is a boy: DTH Products : Android TV','',9,1,3);
INSERT INTO "django_admin_log" VALUES (60,'2020-09-23 00:34:36.786635','14','Teye is a boy: DTH Products : Android TV','',9,1,3);
INSERT INTO "django_admin_log" VALUES (61,'2020-09-23 00:34:36.908177','13','Aggrey: DTH Products : Android TV','',9,1,3);
INSERT INTO "django_admin_log" VALUES (62,'2020-09-23 00:34:37.030275','11','boxes: DTH Products : Set Top Boxes','',9,1,3);
INSERT INTO "django_admin_log" VALUES (63,'2020-09-23 00:34:37.140811','10','set tops: DTH Products : Set Top Boxes','',9,1,3);
INSERT INTO "django_admin_log" VALUES (64,'2020-09-26 01:59:06.009534','13','Emmanuel Aggrey: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (65,'2020-09-26 02:01:57.717068','13','Emmanuel Aggrey: DTH Products : WiFi Dongles','[]',9,1,2);
INSERT INTO "django_admin_log" VALUES (66,'2020-09-26 02:02:35.926610','13','Emmanuel Aggrey: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (67,'2020-09-26 02:02:54.847363','14','TCL Android AI 4K n: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (68,'2020-09-26 02:05:23.790306','14','TCL Android AI 4K n: DTH Products : WiFi Dongles','[]',9,1,2);
INSERT INTO "django_admin_log" VALUES (69,'2020-09-26 02:05:40.643493','14','TCL Android AI 4K n: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (70,'2020-09-26 02:06:00.293747','15','TCL Android AI 4K nn: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (71,'2020-09-26 02:06:25.343711','15','TCL Android AI 4K nn: DTH Products : WiFi Dongles','[]',9,1,2);
INSERT INTO "django_admin_log" VALUES (72,'2020-09-26 02:07:17.353728','15','TCL Android AI 4K nn: DTH Products : WiFi Dongles','[]',9,1,2);
INSERT INTO "django_admin_log" VALUES (73,'2020-09-26 02:07:29.662399','15','TCL Android AI 4K nn: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (74,'2020-09-26 02:09:59.388144','16','TCL Android AI 4K  s: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (75,'2020-09-26 02:11:35.177620','16','TCL Android AI 4K  s: DTH Products : WiFi Dongles','[]',9,1,2);
INSERT INTO "django_admin_log" VALUES (76,'2020-09-26 02:11:50.978003','16','TCL Android AI 4K: DTH Products : WiFi Dongles','[{"changed": {"fields": ["name"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (77,'2020-09-26 02:12:06.518446','16','TCL Android AI 4K: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (78,'2020-09-26 02:16:42.714769','17','TCL Android AI 4K: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (79,'2020-09-26 02:16:54.827813','17','TCL Android AI 4K: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (80,'2020-09-26 02:17:08.813029','18','Aggrey: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (81,'2020-09-26 02:20:35.108502','18','Aggrey: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (82,'2020-09-26 02:24:47.065918','19','TCL Android AI 4K sas: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (83,'2020-09-27 20:17:00.885003','19','Product object (19)','',9,1,3);
INSERT INTO "django_admin_log" VALUES (84,'2020-09-27 20:17:24.378985','20','Product object (20)','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (85,'2020-09-27 20:19:31.909889','20','TCL Android AI 4K  z bbb: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (86,'2020-09-27 20:19:46.311749','21','TCL Android AI 4K  ff: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (87,'2020-09-27 20:23:34.035704','21','TCL Android AI 4K  ff: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (88,'2020-09-27 20:26:17.289225','22','TCL Android AI 4K vv: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (89,'2020-09-27 20:26:51.483583','22','TCL Android AI 4K vv: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (90,'2020-09-27 20:27:05.635184','23','TCL Android AI 4K rr: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (91,'2020-09-27 20:27:16.896989','23','TCL Android AI 4K rr: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (92,'2020-09-27 20:38:03.564482','24','Emmanuel Aggrey Teye: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (93,'2020-09-28 23:56:04.023374','24','Emmanuel Aggrey Teye: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (94,'2020-09-29 00:00:35.364164','25','TCL Android AI 4K DD: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (95,'2020-09-29 00:01:27.803987','25','TCL Android AI 4K DD: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (96,'2020-09-29 00:01:41.580829','26','Aggreysasde: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (97,'2020-09-29 00:02:52.244975','26','Aggreysasde: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (98,'2020-09-29 00:03:05.139837','27','Aggreysfl: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (99,'2020-09-29 00:03:33.136999','27','Aggreysfl: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (100,'2020-09-29 00:03:48.424922','28','TCL Android AI 4K ds: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (101,'2020-09-29 00:05:11.087556','28','TCL Android AI 4K ds: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (102,'2020-09-29 00:05:22.140467','29','TCL Android AI 4K z: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (103,'2020-09-29 00:05:56.709437','29','TCL Android AI 4K z: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (104,'2020-09-29 00:06:08.705992','30','TCL Android AI 4K s: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (105,'2020-09-29 00:06:30.407053','30','TCL Android AI 4K s: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (106,'2020-09-29 00:06:41.772364','31','TCL Android AI 4K xs: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (107,'2020-09-29 00:07:00.822423','31','TCL Android AI 4K xs: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (108,'2020-09-29 00:07:13.258579','32','TCL Android AI 4K zd: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (109,'2020-09-29 00:09:35.163023','32','TCL Android AI 4K zd: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (110,'2020-09-29 00:09:46.799256','33','TCL Android AI 4K: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (111,'2020-09-29 00:10:09.326217','33','TCL Android AI 4K: DTH Products : WiFi Dongles','[]',9,1,2);
INSERT INTO "django_admin_log" VALUES (112,'2020-09-29 00:11:32.897263','34','TCL Android AI 4K: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (113,'2020-09-29 00:11:45.485614','35','TCL Android AI 4K: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (114,'2020-09-29 00:12:09.402328','36','TCL Android AI 4K: DTH Products : Chrome Boxes','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (115,'2020-09-29 00:13:11.236829','36','TCL Android AI 4K: DTH Products : Chrome Boxes','',9,1,3);
INSERT INTO "django_admin_log" VALUES (116,'2020-09-29 00:13:11.331336','35','TCL Android AI 4K: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (117,'2020-09-29 00:13:11.441887','34','TCL Android AI 4K: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (118,'2020-09-29 00:13:11.530570','33','TCL Android AI 4K: DTH Products : WiFi Dongles','',9,1,3);
INSERT INTO "django_admin_log" VALUES (119,'2020-09-29 00:13:22.235836','37','TCL Android AI 4K: DTH Products : WiFi Dongles','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (120,'2020-09-29 00:13:53.470114','38','TCL Android AI 4K: DTH Products : Set Top Boxes','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (121,'2020-10-30 21:28:35.918588','1','Google Api','[{"added": {}}]',19,1,1);
INSERT INTO "django_admin_log" VALUES (122,'2020-10-30 21:41:30.952761','1','127.0.0.1:8000','[{"changed": {"fields": ["domain", "name"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (123,'2020-10-30 22:34:50.115104','2','Google Api 2','[{"added": {}}]',19,1,1);
INSERT INTO "django_admin_log" VALUES (124,'2020-10-30 22:37:47.140339','1','Google Api','',19,1,3);
INSERT INTO "django_admin_log" VALUES (125,'2020-12-02 12:35:48.109809','9','Emmanuel Aggrey','',7,1,3);
INSERT INTO "django_admin_log" VALUES (126,'2020-12-02 12:39:35.998874','3','IPTV Services','[{"changed": {"fields": ["is_available"]}}]',7,1,2);
INSERT INTO "django_admin_log" VALUES (127,'2020-12-02 13:40:29.000598','10','Internet Services : XtayConnect Internet','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (128,'2020-12-02 13:40:29.199286','6','Smart Home Devices : Centralized Security & Surveillance Systems','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (129,'2020-12-02 13:40:29.401687','5','DTH Products : WiFi Dongles','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (130,'2020-12-02 13:40:29.620660','4','DTH Products : Chrome Casts','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (131,'2020-12-02 13:40:30.066883','3','DTH Products : Chrome Boxes','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (132,'2020-12-02 13:40:30.607134','2','DTH Products : Set Top Boxes','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (133,'2020-12-02 13:40:30.839349','1','DTH Products : Android TV','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (134,'2020-12-02 13:41:38.068656','5','DTH Products : WiFi Dongles','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (135,'2020-12-02 13:41:38.301158','4','DTH Products : Chrome Casts','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (136,'2020-12-02 13:41:38.532332','3','DTH Products : Chrome Boxes','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (137,'2020-12-02 23:21:50.545358','2','Smart Home Devices','[{"changed": {"fields": ["is_available"]}}]',7,1,2);
INSERT INTO "django_admin_log" VALUES (138,'2021-02-05 17:11:00.083411','40','Nano Station M5: DTH Products : WiFi Dongles','[{"changed": {"fields": ["name"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (139,'2021-02-05 17:14:06.573398','40','Nano Station M5: DTH Products : WiFi Dongles','[]',9,1,2);
INSERT INTO "django_admin_log" VALUES (140,'2021-02-05 17:15:05.530967','40','Nano Station M5: DTH Products : WiFi Dongles','[{"changed": {"fields": ["image1"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (141,'2021-02-05 17:17:09.455861','40','Nano Station M5: DTH Products : WiFi Dongles','[{"changed": {"fields": ["image2", "image3", "image4", "image5"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (142,'2021-02-05 17:18:26.665934','38','TCL Android AI 4K: DTH Products : Set Top Boxes','[{"changed": {"fields": ["image1"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (143,'2021-02-08 06:04:31.735561','40','Nano Station M5: DTH Products : WiFi Dongles','[{"changed": {"fields": ["image"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (144,'2021-02-08 06:07:36.589412','40','Nano Station M5: DTH Products : WiFi Dongles','[{"changed": {"fields": ["image1", "image2", "image3", "image5"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (145,'2021-02-08 06:47:38.717887','40','Nano Station M5: DTH Products : WiFi Dongles','[{"changed": {"fields": ["image", "image1", "image2", "image3", "image4", "image5"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (146,'2021-02-08 06:49:44.609709','40','Nano Station M5: DTH Products : WiFi Dongles','[{"changed": {"fields": ["image", "image1", "image2", "image3", "image4", "image5"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (147,'2021-02-09 07:13:32.587139','40','Nano Station M5: DTH Products : WiFi Dongles','[{"changed": {"fields": ["description"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (148,'2021-02-10 01:37:11.091863','5','DTH Products : WiFi Dongles','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (149,'2021-02-10 01:37:11.277471','4','DTH Products : Chrome Casts','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (150,'2021-02-10 01:37:11.453587','3','DTH Products : Chrome Boxes','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (151,'2021-02-10 01:37:26.453689','5','DTH Products : WiFi Dongles','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (152,'2021-02-10 01:37:26.630036','4','DTH Products : Chrome Casts','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (153,'2021-02-10 01:37:26.806940','3','DTH Products : Chrome Boxes','[{"changed": {"fields": ["is_available"]}}]',8,1,2);
INSERT INTO "django_admin_log" VALUES (154,'2021-02-10 17:03:49.827891','39','Emmanuel Aggrey Emman: DTH Products : WiFi Dongles','[{"changed": {"fields": ["description", "image1", "image2", "image3", "image4", "image5"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (155,'2021-02-10 17:04:10.988711','38','TCL Android AI 4K: DTH Products : Set Top Boxes','[{"changed": {"fields": ["image1", "image2", "image3", "image4", "image5"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (156,'2021-02-10 17:05:06.846940','8','TCL Android AI 4K  z: DTH Products : Android TV','[{"changed": {"fields": ["image1", "image2", "image3", "image4", "image5"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (157,'2021-02-10 17:06:33.565648','5','TCL Android AI 4K  Touch: DTH Products : Android TV','[{"changed": {"fields": ["image1", "image2", "image3", "image4", "image5"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (158,'2021-02-10 18:34:52.890561','19','Order 19','',10,1,3);
INSERT INTO "django_admin_log" VALUES (159,'2021-02-10 19:07:00.909095','18','Order 18','',10,1,3);
INSERT INTO "django_admin_log" VALUES (160,'2021-02-10 19:07:01.084767','17','Order 17','',10,1,3);
INSERT INTO "django_admin_log" VALUES (161,'2021-02-10 19:07:01.290888','16','Order 16','',10,1,3);
INSERT INTO "django_admin_log" VALUES (162,'2021-02-10 19:07:01.476601','15','Order 15','',10,1,3);
INSERT INTO "django_admin_log" VALUES (163,'2021-02-10 19:07:01.652695','14','Order 14','',10,1,3);
INSERT INTO "django_admin_log" VALUES (164,'2021-02-10 19:07:01.866485','13','Order 13','',10,1,3);
INSERT INTO "django_admin_log" VALUES (165,'2021-02-10 19:07:02.043328','12','Order 12','',10,1,3);
INSERT INTO "django_admin_log" VALUES (166,'2021-02-10 19:07:02.209603','11','Order 11','',10,1,3);
INSERT INTO "django_admin_log" VALUES (167,'2021-02-10 19:07:02.375605','10','Order 10','',10,1,3);
INSERT INTO "django_admin_log" VALUES (168,'2021-02-10 19:07:02.577234','9','Order 9','',10,1,3);
INSERT INTO "django_admin_log" VALUES (169,'2021-02-10 19:07:02.718887','8','Order 8','',10,1,3);
INSERT INTO "django_admin_log" VALUES (170,'2021-02-10 19:07:02.884993','7','Order 7','',10,1,3);
INSERT INTO "django_admin_log" VALUES (171,'2021-02-10 19:07:03.050941','6','Order 6','',10,1,3);
INSERT INTO "django_admin_log" VALUES (172,'2021-02-10 19:07:03.217030','5','Order 5','',10,1,3);
INSERT INTO "django_admin_log" VALUES (173,'2021-02-10 19:07:03.416531','4','Order 4','',10,1,3);
INSERT INTO "django_admin_log" VALUES (174,'2021-02-10 19:07:03.645503','3','Order 3','',10,1,3);
INSERT INTO "django_admin_log" VALUES (175,'2021-02-10 19:07:03.902453','2','Order 2','',10,1,3);
INSERT INTO "django_admin_log" VALUES (176,'2021-02-10 19:07:04.102592','1','Order 1','',10,1,3);
INSERT INTO "django_admin_log" VALUES (177,'2021-02-10 19:07:13.203194','34','Order 34','',10,1,3);
INSERT INTO "django_admin_log" VALUES (178,'2021-02-10 19:07:13.459341','33','Order 33','',10,1,3);
INSERT INTO "django_admin_log" VALUES (179,'2021-02-10 19:07:13.666311','32','Order 32','',10,1,3);
INSERT INTO "django_admin_log" VALUES (180,'2021-02-10 19:07:13.943620','31','Order 31','',10,1,3);
INSERT INTO "django_admin_log" VALUES (181,'2021-02-10 19:07:14.266084','30','Order 30','',10,1,3);
INSERT INTO "django_admin_log" VALUES (182,'2021-02-10 19:07:14.442882','29','Order 29','',10,1,3);
INSERT INTO "django_admin_log" VALUES (183,'2021-02-10 19:07:14.653266','28','Order 28','',10,1,3);
INSERT INTO "django_admin_log" VALUES (184,'2021-02-10 19:07:14.873068','27','Order 27','',10,1,3);
INSERT INTO "django_admin_log" VALUES (185,'2021-02-10 19:07:15.105504','26','Order 26','',10,1,3);
INSERT INTO "django_admin_log" VALUES (186,'2021-02-10 19:07:15.291337','25','Order 25','',10,1,3);
INSERT INTO "django_admin_log" VALUES (187,'2021-02-10 19:07:15.459920','24','Order 24','',10,1,3);
INSERT INTO "django_admin_log" VALUES (188,'2021-02-10 19:07:15.636888','23','Order 23','',10,1,3);
INSERT INTO "django_admin_log" VALUES (189,'2021-02-10 19:07:15.837690','22','Order 22','',10,1,3);
INSERT INTO "django_admin_log" VALUES (190,'2021-02-10 19:07:16.026140','21','Order 21','',10,1,3);
INSERT INTO "django_admin_log" VALUES (191,'2021-02-10 19:07:16.203010','20','Order 20','',10,1,3);
INSERT INTO "django_admin_log" VALUES (192,'2021-02-10 19:15:13.305207','38','Order 38','',10,1,3);
INSERT INTO "django_admin_log" VALUES (193,'2021-02-10 19:15:13.523394','37','Order 37','',10,1,3);
INSERT INTO "django_admin_log" VALUES (194,'2021-02-10 19:15:13.796070','36','Order 36','',10,1,3);
INSERT INTO "django_admin_log" VALUES (195,'2021-02-10 19:15:14.032381','35','Order 35','',10,1,3);
INSERT INTO "django_admin_log" VALUES (196,'2021-02-12 15:02:46.498230','11','DTH Products : Fridges','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (197,'2021-02-12 15:03:18.652756','11','DTH Products : Fridges','',8,1,3);
INSERT INTO "django_admin_log" VALUES (198,'2021-02-12 15:22:55.129837','1','Administrator','[{"added": {}}]',3,1,1);
INSERT INTO "django_admin_log" VALUES (199,'2021-02-12 15:25:37.543419','2','STAFF USERS','[{"added": {}}]',3,1,1);
INSERT INTO "django_admin_log" VALUES (200,'2021-02-12 15:27:05.296020','5','xtayconnect','[{"added": {}}]',4,1,1);
INSERT INTO "django_admin_log" VALUES (201,'2021-02-12 15:27:18.046852','5','xtayconnect','[{"changed": {"fields": ["groups"]}}]',4,1,2);
INSERT INTO "django_admin_log" VALUES (202,'2021-02-12 15:27:18.253365','5','xtayconnect','[]',4,1,2);
INSERT INTO "django_admin_log" VALUES (203,'2021-02-12 15:31:50.520699','5','xtayconnect','[{"changed": {"fields": ["is_staff"]}}]',4,1,2);
INSERT INTO "django_admin_log" VALUES (204,'2021-02-12 15:32:19.602795','5','xtayconnect','[{"changed": {"fields": ["is_superuser"]}}]',4,1,2);
INSERT INTO "django_admin_log" VALUES (205,'2021-02-12 15:32:36.276863','5','xtayconnect','[{"changed": {"fields": ["is_superuser"]}}]',4,1,2);
INSERT INTO "django_admin_log" VALUES (206,'2021-02-15 07:03:27.335540','3','XTAYCONNECT AFRICA TM','[{"added": {}}]',19,1,1);
INSERT INTO "django_admin_log" VALUES (207,'2021-02-15 07:03:59.035066','3','Facebook Api','[{"changed": {"fields": ["name"]}}]',19,1,2);
INSERT INTO "django_admin_log" VALUES (208,'2021-02-15 07:04:12.817639','1','127.0.0.1:8000','[]',15,1,2);
INSERT INTO "django_admin_log" VALUES (209,'2021-02-15 07:06:37.196998','2','xtayconnectafrica.com','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (210,'2021-02-15 07:06:55.062776','3','Facebook Api','[{"changed": {"fields": ["sites"]}}]',19,1,2);
INSERT INTO "django_admin_log" VALUES (211,'2021-02-15 07:07:01.698880','2','Google Api 2','[{"changed": {"fields": ["sites"]}}]',19,1,2);
INSERT INTO "django_admin_log" VALUES (212,'2021-02-15 07:07:12.896307','3','Facebook Api','[{"changed": {"fields": ["sites"]}}]',19,1,2);
INSERT INTO "django_admin_log" VALUES (213,'2021-02-15 07:07:27.998463','3','Facebook Api','[{"changed": {"fields": ["key"]}}]',19,1,2);
INSERT INTO "django_admin_log" VALUES (214,'2021-02-16 18:28:50.080123','41','Order 41','',10,1,3);
INSERT INTO "django_admin_log" VALUES (215,'2021-02-16 18:28:50.185582','40','Order 40','',10,1,3);
INSERT INTO "django_admin_log" VALUES (216,'2021-02-16 18:28:50.288431','39','Order 39','',10,1,3);
INSERT INTO "auth_user_groups" VALUES (1,5,1);
INSERT INTO "auth_group_permissions" VALUES (1,1,5);
INSERT INTO "auth_group_permissions" VALUES (2,1,6);
INSERT INTO "auth_group_permissions" VALUES (3,1,7);
INSERT INTO "auth_group_permissions" VALUES (4,1,8);
INSERT INTO "auth_group_permissions" VALUES (5,1,9);
INSERT INTO "auth_group_permissions" VALUES (6,1,10);
INSERT INTO "auth_group_permissions" VALUES (7,1,11);
INSERT INTO "auth_group_permissions" VALUES (8,1,12);
INSERT INTO "auth_group_permissions" VALUES (9,1,13);
INSERT INTO "auth_group_permissions" VALUES (10,1,14);
INSERT INTO "auth_group_permissions" VALUES (11,1,15);
INSERT INTO "auth_group_permissions" VALUES (12,1,16);
INSERT INTO "auth_group_permissions" VALUES (13,1,25);
INSERT INTO "auth_group_permissions" VALUES (14,1,26);
INSERT INTO "auth_group_permissions" VALUES (15,1,27);
INSERT INTO "auth_group_permissions" VALUES (16,1,28);
INSERT INTO "auth_group_permissions" VALUES (17,1,29);
INSERT INTO "auth_group_permissions" VALUES (18,1,30);
INSERT INTO "auth_group_permissions" VALUES (19,1,31);
INSERT INTO "auth_group_permissions" VALUES (20,1,32);
INSERT INTO "auth_group_permissions" VALUES (21,1,33);
INSERT INTO "auth_group_permissions" VALUES (22,1,34);
INSERT INTO "auth_group_permissions" VALUES (23,1,35);
INSERT INTO "auth_group_permissions" VALUES (24,1,36);
INSERT INTO "auth_group_permissions" VALUES (25,1,37);
INSERT INTO "auth_group_permissions" VALUES (26,1,38);
INSERT INTO "auth_group_permissions" VALUES (27,1,39);
INSERT INTO "auth_group_permissions" VALUES (28,1,40);
INSERT INTO "auth_group_permissions" VALUES (29,1,41);
INSERT INTO "auth_group_permissions" VALUES (30,1,42);
INSERT INTO "auth_group_permissions" VALUES (31,1,43);
INSERT INTO "auth_group_permissions" VALUES (32,1,44);
INSERT INTO "auth_group_permissions" VALUES (33,1,49);
INSERT INTO "auth_group_permissions" VALUES (34,1,50);
INSERT INTO "auth_group_permissions" VALUES (35,1,51);
INSERT INTO "auth_group_permissions" VALUES (36,1,52);
INSERT INTO "auth_group_permissions" VALUES (37,1,53);
INSERT INTO "auth_group_permissions" VALUES (38,1,54);
INSERT INTO "auth_group_permissions" VALUES (39,1,55);
INSERT INTO "auth_group_permissions" VALUES (40,1,56);
INSERT INTO "auth_group_permissions" VALUES (41,1,61);
INSERT INTO "auth_group_permissions" VALUES (42,1,62);
INSERT INTO "auth_group_permissions" VALUES (43,1,63);
INSERT INTO "auth_group_permissions" VALUES (44,1,64);
INSERT INTO "auth_group_permissions" VALUES (45,1,65);
INSERT INTO "auth_group_permissions" VALUES (46,1,66);
INSERT INTO "auth_group_permissions" VALUES (47,1,67);
INSERT INTO "auth_group_permissions" VALUES (48,1,68);
INSERT INTO "auth_group_permissions" VALUES (49,2,16);
INSERT INTO "auth_group_permissions" VALUES (50,2,28);
INSERT INTO "auth_group_permissions" VALUES (51,2,32);
INSERT INTO "auth_group_permissions" VALUES (52,2,33);
INSERT INTO "auth_group_permissions" VALUES (53,2,34);
INSERT INTO "auth_group_permissions" VALUES (54,2,35);
INSERT INTO "auth_group_permissions" VALUES (55,2,36);
INSERT INTO "auth_group_permissions" VALUES (56,2,37);
INSERT INTO "auth_group_permissions" VALUES (57,2,38);
INSERT INTO "auth_group_permissions" VALUES (58,2,39);
INSERT INTO "auth_group_permissions" VALUES (59,2,40);
INSERT INTO "auth_group_permissions" VALUES (60,2,41);
INSERT INTO "auth_group_permissions" VALUES (61,2,42);
INSERT INTO "auth_group_permissions" VALUES (62,2,43);
INSERT INTO "auth_group_permissions" VALUES (63,2,44);
INSERT INTO "auth_group_permissions" VALUES (64,2,49);
INSERT INTO "auth_group_permissions" VALUES (65,2,50);
INSERT INTO "auth_group_permissions" VALUES (66,2,51);
INSERT INTO "auth_group_permissions" VALUES (67,2,52);
INSERT INTO "auth_group_permissions" VALUES (68,2,53);
INSERT INTO "auth_group_permissions" VALUES (69,2,54);
INSERT INTO "auth_group_permissions" VALUES (70,2,55);
INSERT INTO "auth_group_permissions" VALUES (71,2,56);
INSERT INTO "django_migrations" VALUES (1,'contenttypes','0001_initial','2020-09-20 19:39:21.344398');
INSERT INTO "django_migrations" VALUES (2,'auth','0001_initial','2020-09-20 19:39:21.490112');
INSERT INTO "django_migrations" VALUES (3,'admin','0001_initial','2020-09-20 19:39:21.630499');
INSERT INTO "django_migrations" VALUES (4,'admin','0002_logentry_remove_auto_add','2020-09-20 19:39:21.758754');
INSERT INTO "django_migrations" VALUES (5,'admin','0003_logentry_add_action_flag_choices','2020-09-20 19:39:21.893280');
INSERT INTO "django_migrations" VALUES (6,'contenttypes','0002_remove_content_type_name','2020-09-20 19:39:22.007319');
INSERT INTO "django_migrations" VALUES (7,'auth','0002_alter_permission_name_max_length','2020-09-20 19:39:22.139414');
INSERT INTO "django_migrations" VALUES (8,'auth','0003_alter_user_email_max_length','2020-09-20 19:39:22.248165');
INSERT INTO "django_migrations" VALUES (9,'auth','0004_alter_user_username_opts','2020-09-20 19:39:22.389708');
INSERT INTO "django_migrations" VALUES (10,'auth','0005_alter_user_last_login_null','2020-09-20 19:39:22.515022');
INSERT INTO "django_migrations" VALUES (11,'auth','0006_require_contenttypes_0002','2020-09-20 19:39:22.631714');
INSERT INTO "django_migrations" VALUES (12,'auth','0007_alter_validators_add_error_messages','2020-09-20 19:39:22.787145');
INSERT INTO "django_migrations" VALUES (13,'auth','0008_alter_user_username_max_length','2020-09-20 19:39:22.891048');
INSERT INTO "django_migrations" VALUES (14,'auth','0009_alter_user_last_name_max_length','2020-09-20 19:39:23.024926');
INSERT INTO "django_migrations" VALUES (15,'auth','0010_alter_group_name_max_length','2020-09-20 19:39:23.120671');
INSERT INTO "django_migrations" VALUES (16,'auth','0011_update_proxy_permissions','2020-09-20 19:39:23.219643');
INSERT INTO "django_migrations" VALUES (17,'sessions','0001_initial','2020-09-20 19:39:23.297218');
INSERT INTO "django_migrations" VALUES (18,'ecommerce','0001_initial','2020-09-20 19:39:51.726141');
INSERT INTO "django_migrations" VALUES (19,'ecommerce','0002_auto_20200920_2030','2020-09-20 20:30:35.693252');
INSERT INTO "django_migrations" VALUES (20,'ecommerce','0003_product_slug','2020-09-20 21:35:09.794206');
INSERT INTO "django_migrations" VALUES (21,'ecommerce','0004_auto_20200920_2212','2020-09-20 22:12:47.620650');
INSERT INTO "django_migrations" VALUES (22,'ecommerce','0005_auto_20200920_2244','2020-09-20 22:44:31.169600');
INSERT INTO "django_migrations" VALUES (23,'orders','0001_initial','2020-09-21 00:57:48.450299');
INSERT INTO "django_migrations" VALUES (24,'easy_thumbnails','0001_initial','2020-09-22 00:12:40.549670');
INSERT INTO "django_migrations" VALUES (25,'easy_thumbnails','0002_thumbnaildimensions','2020-09-22 00:12:40.673515');
INSERT INTO "django_migrations" VALUES (26,'ecommerce','0006_auto_20200922_1433','2020-09-22 14:33:55.235956');
INSERT INTO "django_migrations" VALUES (27,'orders','0002_auto_20200922_2220','2020-09-22 22:20:15.388363');
INSERT INTO "django_migrations" VALUES (28,'ecommerce','0007_auto_20200925_0056','2020-09-25 00:57:00.487304');
INSERT INTO "django_migrations" VALUES (29,'ecommerce','0008_auto_20200929_0055','2020-09-29 00:55:45.855283');
INSERT INTO "django_migrations" VALUES (30,'account','0001_initial','2020-10-30 20:46:01.353055');
INSERT INTO "django_migrations" VALUES (31,'account','0002_email_max_length','2020-10-30 20:46:01.560128');
INSERT INTO "django_migrations" VALUES (32,'sites','0001_initial','2020-10-30 20:46:01.682533');
INSERT INTO "django_migrations" VALUES (33,'sites','0002_alter_domain_unique','2020-10-30 20:46:01.782749');
INSERT INTO "django_migrations" VALUES (34,'socialaccount','0001_initial','2020-10-30 20:46:01.999937');
INSERT INTO "django_migrations" VALUES (35,'socialaccount','0002_token_max_lengths','2020-10-30 20:46:02.163345');
INSERT INTO "django_migrations" VALUES (36,'socialaccount','0003_extra_data_default_dict','2020-10-30 20:46:02.299365');
INSERT INTO "django_migrations" VALUES (37,'ecommerce','0009_auto_20201117_0616','2020-11-17 06:16:48.632687');
INSERT INTO "django_migrations" VALUES (38,'orders','0003_auto_20201202_1139','2020-12-02 11:39:08.381985');
INSERT INTO "django_migrations" VALUES (39,'ecommerce','0010_sub_category_is_available','2020-12-02 11:39:42.414257');
INSERT INTO "django_migrations" VALUES (40,'ecommerce','0011_auto_20201202_1149','2020-12-02 11:49:43.605189');
INSERT INTO "django_migrations" VALUES (41,'ecommerce','0012_category_is_available','2020-12-02 12:39:17.258855');
INSERT INTO "django_migrations" VALUES (42,'ecommerce','0013_product_image1','2021-02-05 16:58:23.764713');
INSERT INTO "django_migrations" VALUES (43,'ecommerce','0014_auto_20210205_1705','2021-02-05 17:05:23.628549');
INSERT INTO "django_migrations" VALUES (44,'ecommerce','0015_auto_20210215_0833','2021-02-15 08:33:31.150835');
INSERT INTO "django_migrations" VALUES (45,'orders','0004_auto_20210215_0833','2021-02-15 08:33:31.322184');
INSERT INTO "django_migrations" VALUES (46,'orders','0005_auto_20210216_1833','2021-02-16 18:33:04.849505');
CREATE INDEX IF NOT EXISTS "orders_order_name_id_3ff6d682" ON "orders_order" (
	"name_id"
);
CREATE INDEX IF NOT EXISTS "ecommerce_sub_category_category_id_c97ae54f" ON "ecommerce_sub_category" (
	"category_id"
);
CREATE INDEX IF NOT EXISTS "ecommerce_product_category_id_53003707" ON "ecommerce_product" (
	"category_id"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialaccount_user_id_8146e70c" ON "socialaccount_socialaccount" (
	"user_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "socialaccount_socialaccount_provider_uid_fc810c6e_uniq" ON "socialaccount_socialaccount" (
	"provider",
	"uid"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialtoken_app_id_636a42d7" ON "socialaccount_socialtoken" (
	"app_id"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialtoken_account_id_951f210e" ON "socialaccount_socialtoken" (
	"account_id"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialapp_sites_site_id_2579dee5" ON "socialaccount_socialapp_sites" (
	"site_id"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialapp_sites_socialapp_id_97fb6e7d" ON "socialaccount_socialapp_sites" (
	"socialapp_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "socialaccount_socialapp_sites_socialapp_id_site_id_71a9a768_uniq" ON "socialaccount_socialapp_sites" (
	"socialapp_id",
	"site_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq" ON "socialaccount_socialtoken" (
	"app_id",
	"account_id"
);
CREATE INDEX IF NOT EXISTS "account_emailaddress_user_id_2c513194" ON "account_emailaddress" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "account_emailconfirmation_email_address_id_5b7f8c58" ON "account_emailconfirmation" (
	"email_address_id"
);
CREATE INDEX IF NOT EXISTS "orders_orderitem_product_id_afe4254a" ON "orders_orderitem" (
	"product_id"
);
CREATE INDEX IF NOT EXISTS "orders_orderitem_order_id_fe61a34d" ON "orders_orderitem" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "easy_thumbnails_thumbnail_source_id_5b57bc77" ON "easy_thumbnails_thumbnail" (
	"source_id"
);
CREATE INDEX IF NOT EXISTS "easy_thumbnails_thumbnail_name_b5882c31" ON "easy_thumbnails_thumbnail" (
	"name"
);
CREATE INDEX IF NOT EXISTS "easy_thumbnails_thumbnail_storage_hash_f1435f49" ON "easy_thumbnails_thumbnail" (
	"storage_hash"
);
CREATE INDEX IF NOT EXISTS "easy_thumbnails_source_name_5fe0edc6" ON "easy_thumbnails_source" (
	"name"
);
CREATE INDEX IF NOT EXISTS "easy_thumbnails_source_storage_hash_946cbcc9" ON "easy_thumbnails_source" (
	"storage_hash"
);
CREATE UNIQUE INDEX IF NOT EXISTS "easy_thumbnails_source_storage_hash_name_481ce32d_uniq" ON "easy_thumbnails_source" (
	"storage_hash",
	"name"
);
CREATE UNIQUE INDEX IF NOT EXISTS "easy_thumbnails_thumbnail_storage_hash_name_source_id_fb375270_uniq" ON "easy_thumbnails_thumbnail" (
	"storage_hash",
	"name",
	"source_id"
);
CREATE INDEX IF NOT EXISTS "django_session_expire_date_a5c62663" ON "django_session" (
	"expire_date"
);
CREATE INDEX IF NOT EXISTS "auth_permission_content_type_id_2f476e4b" ON "auth_permission" (
	"content_type_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" (
	"content_type_id",
	"codename"
);
CREATE UNIQUE INDEX IF NOT EXISTS "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" (
	"app_label",
	"model"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_user_id_c564eba6" ON "django_admin_log" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" (
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" (
	"user_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" (
	"user_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_group_id_97559544" ON "auth_user_groups" (
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" (
	"user_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" (
	"user_id",
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" (
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" (
	"group_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" (
	"group_id",
	"permission_id"
);
COMMIT;
