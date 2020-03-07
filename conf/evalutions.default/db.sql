# --- !Ups
CREATE TABLE "Checkup_type"
(
    "id"           SERIAL  NOT NULL PRIMARY KEY,
    "checkup_type" VARCHAR NOT NULL
);

CREATE TABLE "Work_type"
(
    "id"        SERIAL  NOT NULL PRIMARY KEY,
    "work_type" VARCHAR NOT NULL
);

CREATE TABLE "Doctor_type"
(
    "id"          SERIAL  NOT NULL PRIMARY KEY,
    "doctor_type" VARCHAR NOT NULL
);

CREATE TABLE "Lab_type"
(
    "id"       SERIAL  NOT NULL PRIMARY KEY,
    "lab_type" VARCHAR NOT NULL
);

CREATE TABLE "Organization"
(
    "id"                SERIAL  NOT NULL PRIMARY KEY,
    "organization_name" VARCHAR NOT NULL,
    "address" VARCHAR NULL,
    "phone_number" VARCHAR NULL,
    "email" VARCHAR NULL,
    "workers_number" INTEGER NULL,
    "work_type" JSONB
);

CREATE TABLE "Tmp_table"
(
    "work_type_id" INT CONSTRAINT "Tmp_tableFkWork_typeId" REFERENCES "Work_type" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
    "checkup_period_id" INT CONSTRAINT "Tmp_tableFkCheckupId" REFERENCES "Checkup_period" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
    "doctor_type_id" INT CONSTRAINT "Tmp_tableFkDoctor_typeId" REFERENCES "Doctor_type" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
    "lab_type_id" INT CONSTRAINT "Tmp_tableFkLab_typeId" REFERENCES "Lab_type" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "Checkup_period"
(
    "id" SERIAL NOT NULL PRIMARY KEY,
    "number_per_year" INT NOT NULL
);

CREATE TABLE "Patient"
(
    "id"              SERIAL    NOT NULL PRIMARY KEY,
    "first_name"      VARCHAR   NOT NULL,
    "middle_name"     VARCHAR   NOT NULL,
    "last_name"       VARCHAR   NOT NULL,
    "passport_sn"     VARCHAR   NULL,
    "gender"          Int       NOT NULL,
    "birthday"        DATE      NOT NULL,
    "address"         VARCHAR   NOT NULL,
    "phone_number"    VARCHAR   NULL,
    "card_number"     VARCHAR   NOT NULL,
    "profession"      VARCHAR   NULL,
    "work_type_id"    INT
        CONSTRAINT "work_type_for_patient" REFERENCES "Work_type" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
    "last_checkup"    TIMESTAMP NULL,
    "photo"           VARCHAR   NULL,
    "organization_id" INT
        CONSTRAINT "organization_for_patient" REFERENCES "Organization" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO "Work_type" ("work_type")
VALUES ('Oqituvchi');
INSERT INTO "Work_type" ("work_type")
VALUES ('Elektrik');

INSERT INTO "Organization" ("organization_name")
VALUES ('TATU');
INSERT INTO "Organization" ("organization_name")
VALUES ('UZBEKENERGIYA');


# --- !Downs
DROP TABLE "Checkup_type";
DROP TABLE "Work_type";
DROP TABLE "Doctor_type";
DROP TABLE "Lab_type";
DROP TABLE "Organization";
DROP TABLE "Tmp_table";
DROP TABLE "Checkup_period";
DROP TABLE "Patient";
DELETE FROM "Work_type" WHERE work_type = 'Oqituvchi';
DELETE FROM "Work_type" WHERE work_type = 'Elektrik';
DELETE FROM "Organization" WHERE organization_name = 'TATU';
DELETE FROM "Organization" WHERE organization_name = 'UZBEKENERGIYA';
