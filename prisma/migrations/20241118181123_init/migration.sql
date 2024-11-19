/*
  Warnings:

  - Changed the type of `type` on the `donations` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `channel` on the `users` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "donations" DROP COLUMN "type",
ADD COLUMN     "type" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "users" DROP COLUMN "channel",
ADD COLUMN     "channel" TEXT NOT NULL;

-- DropEnum
DROP TYPE "ChannelType";

-- DropEnum
DROP TYPE "DonationType";
