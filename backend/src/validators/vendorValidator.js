function validateVendorInput(data) {
  const errors = {};

  if (!data.name || data.name.trim() === "") {
    errors.name = "Vendor name is required";
  }

  if (!data.email || !data.email.includes("@")) {
    errors.email = "Valid email is required";
  }

  if (Object.keys(errors).length > 0) {
    return { isValid: false, errors };
  }

  return { isValid: true };
}

module.exports = { validateVendorInput };
