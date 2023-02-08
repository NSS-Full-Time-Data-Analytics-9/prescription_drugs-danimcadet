--1a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

SELECT npi,
	COUNT(drug_name) AS claims
FROM prescription
GROUP BY npi
ORDER BY claims DESC;

--1b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

SELECT prescription.npi,
	COUNT(prescription.drug_name) AS claims,
	prescriber.nppes_provider_first_name,
	prescriber.nppes_provider_last_org_name,
	prescriber.specialty_description
FROM prescription
LEFT JOIN prescriber
ON prescription.npi=prescriber.npi
GROUP BY prescription.npi,
	prescriber.nppes_provider_first_name,
	prescriber.nppes_provider_last_org_name,
	prescriber.specialty_description
ORDER BY  claims DESC;

--2a. Which specialty had the most total number of claims (totaled over all drugs)?
SELECT prescriber.specialty_description, 
	COUNT(prescription.drug_name) AS claims
FROM prescriber
LEFT JOIN prescription
ON prescriber.npi=prescription.npi
GROUP BY prescriber.specialty_description
ORDER BY claims DESC;

-- 2b. Which specialty had the most total number of claims for opioids?
SELECT prescriber.specialty_description,
	COUNT(drug.opioid_drug_flag='Y')
FROM prescriber
LEFT JOIN prescription
	ON prescriber.npi=prescription.npi
LEFT JOIN drug
	ON prescription.drug_name=drug.drug_name
GROUP BY prescriber.specialty_description
ORDER BY count DESC;

--2c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?
SELECT prescriber.specialty_description,
	prescription.drug_name
FROM prescriber
FULL JOIN prescription
	ON prescriber.npi=prescription.npi
WHERE prescription.drug_name IS null;

--3a. Which drug (generic_name) had the highest total drug cost?
SELECT drug.generic_name AS drug,
	SUM(prescription.total_drug_cost) AS cost
FROM drug
LEFT JOIN prescription 
	ON drug.generic_name=prescription.drug_name
WHERE prescription.total_drug_cost IS NOT null
GROUP BY drug.generic_name
ORDER BY cost DESC;

--3b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**
SELECT generic_name AS drug,  
	SUM(total_drug_cost)/SUM(total_day_supply) AS daily_cost
FROM drug
LEFT JOIN prescription AS p
USING(drug_name)
WHERE total_drug_cost IS NOT NULL
GROUP BY generic_name
ORDER BY daily_cost DESC;

--4a. a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.


