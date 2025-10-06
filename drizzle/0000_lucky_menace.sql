CREATE TABLE "users" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar(50) DEFAULT 'user' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "users_name_unique" UNIQUE("name")
);
