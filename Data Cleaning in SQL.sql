-- Data Cleaning in Sql

-- 1.REMOVING DUPLICATES
-- 2.STANDARDIZING THE DATA
-- 3.DEALING WITH NULL OR EMPTY VALUES
-- 4.REMOVE COLUMNS

SELECT * FROM layoffs;

CREATE TABLE layoffs_stagging
LIKE layoffs;

INSERT layoffs_stagging
SELECT *
FROM layoffs;

SELECT * FROM layoffs_stagging;
SELECT * FROM layoffs_stagging
WHERE company = "Better.com";

-- 1.REMOVING DUPLICATES
-- A.IDENTIFYING DUPLICATES
WITH duplicate_cte as 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off,
percentage_laid_off,`date`, stage, country,funds_raised_millions) AS row_num
FROM layoffs_stagging
)
SELECT *
FROM duplicate_cte 
WHERE row_num>1;

CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_stagging2;

INSERT INTO layoffs_stagging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country,funds_raised_millions) AS row_num
FROM layoffs_stagging;


SELECT * FROM layoffs_stagging2
WHERE row_num > 1;

DELETE 
FROM layoffs_stagging2
WHERE row_num > 1;

SELECT * FROM layoffs_stagging2;

-- 2.STANDARDIZING THE DATA

SELECT company, TRIM(company)
FROM layoffs_stagging2;

UPDATE  layoffs_stagging2
SET company=TRIM(company);

SELECT * FROM  layoffs_stagging2;

SELECT *
FROM layoffs_stagging2
WHERE industry LIKE 'Crypto%';

UPDATE  layoffs_stagging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT distinct industry
FROM layoffs_stagging2;

SELECT DISTINCT country, TRIM(TRAILING  '.' FROM country)
FROM layoffs_stagging2
ORDER BY 1;

UPDATE  layoffs_stagging2
SET country = TRIM(TRAILING  '.' FROM country)
WHERE country LIKE 'United States%';

-- CHANGING DATA TYPE
SELECT `date`
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET `date` = str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE  layoffs_stagging2
MODIFY  date  DATE;

-- 3.DEALING WITH NULL OR EMPTY VALUES

SELECT *
FROM layoffs_stagging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_stagging2
WHERE industry IS NULL OR industry='';

SELECT *
FROM layoffs_stagging2
WHERE  company LIKE "Bally's Interactive";

UPDATE layoffs_stagging2
SET industry = NULL
WHERE industry='';

SELECT stg1.industry , stg2.industry
FROM layoffs_stagging2 stg1
JOIN layoffs_stagging2 stg2
	ON  stg1.company = stg2.company AND stg1.location = stg2.location
WHERE stg1.industry IS NULL OR stg1.industry='' AND stg2.industry IS NOT NULL;

UPDATE layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL) AND t2.industry IS NOT NULL;

SELECT * FROM layoffs_stagging2;

-- 4.REMOVE COLUMNS

SELECT *
FROM layoffs_stagging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_stagging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_stagging2;

ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;

SELECT * FROM layoffs_stagging2 ; 

-----------------------------------------
