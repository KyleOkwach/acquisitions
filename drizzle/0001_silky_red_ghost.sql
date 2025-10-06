ALTER TABLE "users" DROP CONSTRAINT "users_name_unique";--> statement-breakpoint
ALTER TABLE "users" ALTER COLUMN "name" SET DATA TYPE varchar(255);--> statement-breakpoint
ALTER TABLE "users" ALTER COLUMN "name" DROP DEFAULT;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "email" varchar(255) NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "password" varchar(255) NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "role" varchar(50) DEFAULT 'user' NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_email_unique" UNIQUE("email");