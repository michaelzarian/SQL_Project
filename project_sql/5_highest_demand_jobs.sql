
/* ATTEMPT 1 

WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id),
    
    average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg),0) as avg_salary

    FROM job_postings_fact INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    GROUP BY skills_job_dim.skill_id)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary

FROM skills_demand INNER JOIN average_salary
ON skills_demand.skill_id = average_salary.skill_id


LIMIT 25
*/


WITH skill_stats AS (
    SELECT 
        sd.skill_id,
        sd.skills,
        COUNT(sjd.job_id) AS demand_count,
        ROUND(AVG(jp.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact jp
    INNER JOIN skills_job_dim sjd ON jp.job_id = sjd.job_id
    INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
    WHERE jp.job_title_short = 'Data Analyst' 
      AND jp.salary_year_avg IS NOT NULL
    GROUP BY sd.skill_id, sd.skills
)

SELECT 
    skill_id,
    skills,
    demand_count,
    avg_salary
FROM skill_stats
LIMIT 25;