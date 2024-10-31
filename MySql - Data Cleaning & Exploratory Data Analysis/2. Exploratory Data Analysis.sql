-- Exploratory Data Analysis

-- Preview the full data
SELECT * 
FROM layoffs_staging2;

-- Find the maximum number of layoffs and the maximum percentage of layoffs
SELECT MAX(total_laid_off) AS max_total_laid_off, 
       MAX(percentage_laid_off) AS max_percentage_laid_off
FROM layoffs_staging2;

-- Find companies where the percentage of employees laid off is 100%, ordered by funds raised in millions (highest first)
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Sum of total layoffs by company, ordered by the total layoffs in descending order
SELECT company, 
       SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

-- Find the minimum and maximum layoff dates
SELECT MIN(`date`) AS min_date, 
       MAX(`date`) AS max_date
FROM layoffs_staging2;

-- Sum of total layoffs by industry, ordered by the total layoffs in descending order
SELECT industry, 
       SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

-- Monthly summary of layoffs for the year 2022, ordered by the highest layoffs in descending order
SELECT YEAR(`date`) AS year, 
       MONTH(`date`) AS month, 
       SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`), MONTH(`date`)
HAVING year = 2022
ORDER BY sum_laid_off DESC;

-- Average percentage of layoffs by industry, ordered by average percentage in descending order
SELECT industry, 
       ROUND(AVG(percentage_laid_off), 2) AS average_percentage_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY average_percentage_laid_off DESC;

-- Top 5 industries by number of layoffs for each year, focusing on the year 2022
SELECT year, 
       industry, 
       sum_laid_off, 
       Ranking
FROM (
    SELECT YEAR(`date`) AS year,
           industry,
           SUM(total_laid_off) AS sum_laid_off,
           DENSE_RANK() OVER(PARTITION BY YEAR(`date`) ORDER BY SUM(total_laid_off) DESC) AS Ranking
    FROM layoffs_staging2
    GROUP BY year, industry
) ranking
WHERE Ranking <= 5 AND year = 2022;  -- Get top 5 industries in terms of number of layoffs for the year 2022

-- Rolling total of layoffs by month
WITH rolling_total AS (
    SELECT DATE_FORMAT(`date`, "%Y-%m") AS `month`, 
           SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE DATE_FORMAT(`date`, "%Y-%m") IS NOT NULL
    GROUP BY `month`
    ORDER BY `month` ASC
)
SELECT `month`, 
       total_off AS layoffs, 
       SUM(total_off) OVER(ORDER BY `month`) AS rolling_total_layoffs
FROM rolling_total;

-- Top 5 companies by total layoffs per year
WITH company_year AS (
    SELECT company, 
           YEAR(`date`) AS `year`, 
           SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
), company_year_rank AS (
    SELECT *, 
           DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_laid_off DESC) AS Ranking
    FROM company_year
    WHERE `year` IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE Ranking <= 5;  -- Get top 5 companies by number of layoffs for each year
