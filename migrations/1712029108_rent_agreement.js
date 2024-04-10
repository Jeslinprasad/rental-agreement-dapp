const RentalAgreement = artifacts.require("RentalAgreement");

module.exports = function(deployer) {
  const tenantAddress = '0x5E0c3ce440466D93484BB8E0dE93f3Fa10328aB9';
  const rentAmount = 100; // Example rent amount
  const depositAmount = 500; // Example deposit amount
  const startDate = 1234567890; // Example start date
  const endDate = 1234567890; // Example end date
  const ownerAddress = '0xD3a32D06E722C08FE97A47f9e638e23BCa6F7569'; // Address of the owner

  deployer.deploy(RentalAgreement, ownerAddress, tenantAddress, rentAmount, depositAmount, startDate, endDate);
};
