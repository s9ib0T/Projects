-- ### Data Cleaning Pipeline for Layoffs Dataset

-- Initial Data Check
SELECT * FROM layoffs; 

-- Steps:
-- 1. Create a Staging Table
-- 2. Remove Duplicates
-- 3. Standardize Data (e.g., remove whitespaces, fix inconsistent values)
-- 4. Handle Null or Blank Values
-- 5. Drop Unnecessary Columns


-- ### Step 1: Initial Setup - Create Staging Table
-- Create a temporary staging table with the same schema as the original data
CREATE TABLE layoffs_staging
LIKE layoffs;

-- Insert data into the staging table for cleaning
INSERT INTO layoffs_staging
SELECT * FROM layoffs;


-- ### Step 2: Remove Duplicates
-- Identify and label duplicate rows using row numbers partitioned by key columns
WITH duplicate_cte AS (
    SELECT *,
           row_number() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
    FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1; -- View potential duplicates with row number greater than 1

-- Create a new staging table with row numbers to facilitate duplicate removal
CREATE TABLE layoffs_staging2 (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT DEFAULT NULL,
    `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert data into the new staging table, including the row numbers
INSERT INTO layoffs_staging2
SELECT *,
       row_number() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Remove duplicate entries based on the row_num > 1 condition
DELETE FROM layoffs_staging2 WHERE row_num > 1;


-- ### Step 3: Standardize Data

-- Trim whitespace from company names
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize industry and country values for consistency
-- Consolidate "Crypto", "CryptoCurrency", and "Crypto Currency" under a single label "Crypto"
UPDATE layoffs_staging2
SET industry = "Crypto"
WHERE industry LIKE "%Crypto%";

-- Standardize "United States" references to "US" and remove trailing periods
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE "United States%";

-- Convert date column from text to date format for easier analysis
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, "%m/%d/%Y");

-- Change the column type of `date` to a DATE type for better data integrity
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- ### Step 4: Handle Null or Blank Values

-- Replace empty industry values with NULL to standardize the handling of missing data
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Backfill industry values by matching records with the same company and location where possible
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
    AND t2.industry IS NOT NULL;

-- Remove rows where both `total_laid_off` and `percentage_laid_off` are NULL
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
    AND percentage_laid_off IS NULL;


-- ### Step 5: Remove Temporary Columns
-- Drop `row_num` as it was only needed for duplicate identification
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Final check on cleaned data
SELECT * FROM layoffs_staging2;
