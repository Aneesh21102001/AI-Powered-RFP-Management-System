/*
  Warnings:

  - You are about to drop the `RFP` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `RFPLineItem` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "RFP";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "RFPLineItem";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "Rfp" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "structured" TEXT NOT NULL,
    "totalBudget" REAL,
    "deliveryDays" INTEGER,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "RfpLineItem" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "qty" INTEGER NOT NULL,
    "specs" TEXT,
    "rfpId" INTEGER NOT NULL,
    CONSTRAINT "RfpLineItem_rfpId_fkey" FOREIGN KEY ("rfpId") REFERENCES "Rfp" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Proposal" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "vendorId" INTEGER NOT NULL,
    "rfpId" INTEGER NOT NULL,
    "price" REAL,
    "terms" TEXT,
    "structured" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Proposal_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Proposal_rfpId_fkey" FOREIGN KEY ("rfpId") REFERENCES "Rfp" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Proposal" ("createdAt", "id", "price", "rfpId", "structured", "terms", "vendorId") SELECT "createdAt", "id", "price", "rfpId", "structured", "terms", "vendorId" FROM "Proposal";
DROP TABLE "Proposal";
ALTER TABLE "new_Proposal" RENAME TO "Proposal";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
