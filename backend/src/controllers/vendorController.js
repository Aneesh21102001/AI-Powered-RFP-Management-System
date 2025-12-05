const { validateVendorInput } = require("../validators/vendorValidator");
const vendorService = require("../services/vendorService");

async function createVendor(req, res) {
  const { isValid, errors } = validateVendorInput(req.body);

  if (!isValid) {
    return res.status(400).json({ errors });
  }

  try {
    const vendor = await vendorService.createVendor(req.body);
    res.json(vendor);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getVendors(req, res) {
  try {
    const vendors = await vendorService.getVendors();
    res.json(vendors);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function updateVendor(req, res) {
  try {
    const vendor = await vendorService.updateVendor(req.params.id, req.body);
    res.json(vendor);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function deleteVendor(req, res) {
  try {
    await vendorService.deleteVendor(req.params.id);
    res.json({ message: "Vendor deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = {
  createVendor,
  getVendors,
  updateVendor,
  deleteVendor
};
