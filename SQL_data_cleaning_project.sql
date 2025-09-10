select count(*) from world_layoff.layoffs_new;

select * from world_layoff.layoffs_new limit 10;

drop table world_layoff.layoffs;

drop table world_layoff.layoffs_staging;

select * from world_layoff.layoffs;

use world_layoff;

RENAME table layoffs_new to layoffs;

CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT layoffs_staging
select * from layoffs;

select COUNT(*) from layoffs_staging;

-- Project Started 

CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT layoffs_staging
select * from layoffs;

select COUNT(*) from layoffs_staging;
-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

select COUNT(*) from layoffs_staging;
use world_layoff;

ALTER TABLE layoffs_staging ADD row_num INT;

select * from layoffs_staging limit 10;

-- 1.Remove Duplicates
create table layoffs_staging2 like layoffs_staging;

INSERT INTO `layoffs_staging2`
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
`row_num`)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
ROW_NUMBER() over(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging;

select * from layoffs_staging2 where row_num >=2;

select * from layoffs_staging2 where company = "Casper";
select * from layoffs_staging2 where company = "Hibob";

DELETE from layoffs_staging2 
where row_num >= 2;

select COUNT(*) from layoffs_staging2;

--  2.Standardize Data

-- if we look at industry it looks like we have some null and empty rows
select * from layoffs_staging2;

select DISTINCT company from layoffs_staging2;

select DISTINCT industry 
from layoffs_staging2
order by industry;

select * from layoffs_staging2
where industry is NULL;

select * from layoffs_staging2
where industry = '' 
OR industry ='NULL';

select * from layoffs_staging2
where total_laid_off is NULL;

select * from layoffs_staging2
where company like 'Ballys%';

select * from layoffs_staging2
where company like 'Airbn%';

-- we should set the blanks to nulls since those are typically easier to work with

UPDATE layoffs_staging2
set industry = NULL
where industry = '';

select * from layoffs_staging2
where industry is NULL
OR industry = '';

-- write a query that if there is another row with the same company name, it will update it to the non-null industry values
-- makes it easy so if there were thousands we wouldn't have to manually check them all

select * from layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
where t1.industry is NULL
and t2.industry is not NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is NULL
and t2.industry is not NULL;

select * from layoffs_staging2
where industry is NULL
OR industry = '';


select Distinct industry 
from layoffs_staging2
order by industry;

-- the Crypto has multiple different variations. We need to standardize that - let's say all to Crypto
 
 UPDATE layoffs_staging2
 set industry = 'Crypto'
 where industry IN ('Crypto Currency','CryptoCurrency');
 
select industry 
from layoffs_staging2
where industry like 'Crypto%';

select DISTINCT country 
from layoffs_staging2
order by country;

-- we have some country as "United States" and some "United States." with a period at the end. Let's standardize this.

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' from country);

-- change date format
UPDATE layoffs_staging2
set `date` = date_format(`date`,'%m/%d/%Y')
where `date` <> 'NULL'; 

select `date`,str_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2 limit 10;

UPDATE layoffs_staging2
set `date` = str_to_date(`date`,'%m/%d/%Y')
where `date` <> 'NULL'; 

select date from layoffs_staging2;


-- convert the data type properly( text to date)



ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Incorrect date value: 'NULL' for column 'date' at row 221

UPDATE layoffs_staging2
set `date` = NULL
where `date` = 'NULL';

-- convert date column to DATE data type

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

select date from layoffs_staging2;

-- 3. look at NULL values

-- the null values in total_laid_off, percentage_laid_off, and funds_raised_millions all look normal. 
-- looks ok null values because it makes it easier for calculations during the EDA phase

-- so there isn't anything to change with the null values


-- 4. remove any columns and rows that we need to

select * from layoffs_staging2 limit 50;

select * from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

-- delete useless data

DELETE from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

select * from layoffs_staging2 limit 50;

-- remove row_num extra column

ALTER TABLE layoffs_staging2
DROP column row_num;

DROP table layoffs_staging;

RENAME TABLE layoffs_staging2 to layoffs_staging;

select * from layoffs_staging;






