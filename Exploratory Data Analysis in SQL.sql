-- Exploratory Data Analysis 

SELECT * FROM layoffs_stagging2;

-- MAXIMUM total_laid_off AND MAXIMUM percentage_laid_off 

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_stagging2;

-- Companies with 100% layoffs

SELECT *
FROM layoffs_stagging2
WHERE  percentage_laid_off = 1
ORDER  BY total_laid_off DESC;

-- Companies with 100% layoffs despite having maximum funds_raised_millions

SELECT *
FROM layoffs_stagging2
WHERE  percentage_laid_off = 1
ORDER  BY funds_raised_millions DESC;

-- Total layoffs over each company 

SELECT company, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company
ORDER BY 2 DESC ;

-- Total layoffs over each industry

SELECT industry, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY industry
ORDER BY 2 DESC ;

-- Layoff period

SELECT MIN(`date`),MAX(`date`)
FROM layoffs_stagging2;

-- Total layoffs over each country

SELECT country, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY country
ORDER BY 2 DESC ;

-- Total layoffs over year

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC ;

-- Total layoffs over stage

SELECT stage, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY stage
ORDER BY 2 DESC ;

SELECT COUNT(*)
FROM layoffs_stagging2;

-- Total percentage_laid_off over each  company

SELECT company, SUM(percentage_laid_off)
FROM layoffs_stagging2
GROUP BY company
ORDER BY 2 DESC ;

SELECT * FROM layoffs_stagging2;


SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_stagging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1 ASC;

-- Rolling sum of lay offs over each month
WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_stagging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1 ASC
)
SELECT  `MONTH`,total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS Rolling_sum
FROM Rolling_total;

-- Total laid offs per company over each year

SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

-- Top 5 companies laid off over each year

WITH Company_Year (company,years,total_laid_off)AS
(
SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company,YEAR(`date`)
), Company_year_rank AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_year_rank
WHERE Ranking <=5;

-------------------------------------------------------------

