DROP TABLE IF EXISTS "meals";
CREATE TABLE "meals" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "cooking_time" NUMERIC,
    "instructions" TEXT,
    "rating" NUMERIC
);

DROP TABLE IF EXISTS "ingredients";
CREATE TABLE "ingredients" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "price" NUMERIC
);

DROP TABLE IF EXISTS "recipes";
CREATE TABLE "recipes" (
    "link_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "meal_id" INTEGER NOT NULL CONSTRAINT "fk_meal_id" REFERENCES meals("id"),
    "ingredient_id" INTEGER NOT NULL CONSTRAINT "fk_ingredient_id" REFERENCES ingredients("id"),
    "qty" TEXT
);