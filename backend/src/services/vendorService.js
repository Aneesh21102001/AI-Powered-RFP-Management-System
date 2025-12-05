const prisma = require("../prismaClient");

async function createVendor(data) {
  return prisma.vendor.create({ data });
}

async function getVendors() {
  return prisma.vendor.findMany({
    orderBy: { createdAt: "desc" }
  });
}

async function updateVendor(id, data) {
  return prisma.vendor.update({
    where: { id: Number(id) },
    data
  });
}

async function deleteVendor(id) {
  return prisma.vendor.delete({
    where: { id: Number(id) }
  });
}

module.exports = {
  createVendor,
  getVendors,
  updateVendor,
  deleteVendor
};
