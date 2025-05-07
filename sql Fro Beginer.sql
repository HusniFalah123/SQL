SELECT 
    *
FROM
    ds_salaries;
-- 1. Apakah ada data yang Null
SELECT 
    *
FROM
    ds_salaries
WHERE
    work_year IS NULL OR salary IS NULL
        OR salary_currency IS NULL
        OR experience_level IS NULL
        OR job_title IS NULL
        OR salary IS NULL
        OR salary_in_usd IS NULL
        OR employee_residence IS NULL
        OR company_location IS NULL
        OR company_size IS NULL
        OR remote_ratio IS NULL;
 
-- 2. Melihat ada job title apa saja
SELECT DISTINCT
    job_title
FROM
    ds_salaries
ORDER BY job_title;

-- 3. Melihat job title yg berkatian dengan data analyst 
SELECT DISTINCT
    job_title
FROM
    ds_salaries
WHERE
    job_title LIKE '%data analyst%'
ORDER BY job_title ;

-- 4. Berapa Rata-rata Gaji data analyst ?

SELECT 
    (AVG(salary_in_usd) * 15000) / 12 AS avg_sal_rp_monthly
FROM
    ds_salaries
WHERE
    LOWER(job_title) LIKE '%data analyst%';

-- 4.1 Berapa rata-rata gaji data analis berdasarkaan experience levelnya ?

SELECT 
    experience_level,
    (AVG(salary_in_usd) * 15000) / 12 AS avg_sal_rp_monthly
FROM
    ds_salaries
WHERE
    LOWER(job_title) LIKE '%data analyst%'
GROUP BY experience_level;

-- 4.2 Berapa rata-rata gaji data analis berdasarkaan experience levelnya dan jenis employementnya ?
SELECT 
    experience_level,
    employment_type,
    (AVG(salary_in_usd) * 15000) / 12 AS avg_sal_rp_monthly
FROM
    ds_salaries
WHERE
    LOWER(job_title) LIKE '%data analyst%'
GROUP BY experience_level , employment_type
ORDER BY experience_level , employment_type;	

-- 5. Negara dengan gaji yang timggi untuk data analyst, full time,experiencenya entery level dan midle ?

SELECT 
    company_location, AVG(salary_in_usd) salary_in_usd
FROM
    ds_salaries
WHERE
    job_title LIKE '%data analys%'
        AND employment_type = 'FT'
        AND experience_level IN ('MI' , 'EN')
GROUP BY company_location
HAVING salary_in_usd >= 20000
;

-- 6. Di tahun berapa kenaikan gaji dari mid ke senior itu memeiliki kenaikan yang tertinggi ?
-- untuk pekerjaan yg berkaitan dengan data analyst yang penuh waktu

WITH ds_1 as (
  SELECT work_year, AVG(salary_in_usd) sal_in_usd_ex
  FROM ds_salaries
  WHERE
    employment_type = "FT"
    AND experience_level = "EX"
    AND job_title LIKE'%data analyst%'
  GROUP BY work_year
), ds_2 as(
SELECT work_year, AVG(salary_in_usd) sal_in_usd_mi
  FROM ds_salaries
  WHERE
    employment_type = "FT"
    AND experience_level = "MI"
    AND job_title LIKE '%data analyst%'
  GROUP BY work_year
), t_year AS (
SELECT DISTINCT work_year FROM ds_salaries)
SELECT t_year.work_year,
      ds_1.sal_in_usd_ex, 
      ds_2.sal_in_usd_mi,
      ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi differences
FROM t_year
LEFT JOIN ds_1 ON ds_1.work_year = t_year.work_year
LEFT JOIN ds_2 ON ds_2.work_year = t_year.work_year;
