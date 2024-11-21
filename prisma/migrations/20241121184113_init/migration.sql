/*
  Warnings:

  - The `url` column on the `pet_photos` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `profile_picture` column on the `pets` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `avatar` column on the `users` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "pet_photos" DROP COLUMN "url",
ADD COLUMN     "url" JSONB;

-- AlterTable
ALTER TABLE "pets" DROP COLUMN "profile_picture",
ADD COLUMN     "profile_picture" JSONB;

-- AlterTable
ALTER TABLE "users" DROP COLUMN "avatar",
ADD COLUMN     "avatar" JSONB;
