/*
  Warnings:

  - You are about to alter the column `amount` on the `donations` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(6,2)`.
  - You are about to alter the column `price` on the `plans` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(6,2)`.

*/
-- AlterTable
ALTER TABLE "donations" ALTER COLUMN "amount" SET DATA TYPE DECIMAL(6,2);

-- AlterTable
ALTER TABLE "plans" ALTER COLUMN "price" SET DATA TYPE DECIMAL(6,2);
