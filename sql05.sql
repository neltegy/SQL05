/*
문제1.
가장 늦게 입사한 직원의 이름(first_name last_name)과 연봉(salary)과 근무하는 부서
이름(department_name)은?
*/
select first_name||last_name 이름
      ,salary
      ,department_name
      ,hire_date
from employees e 
    ,(select department_id,department_name
      from departments)s
where e.department_id = s.department_id
   and e.hire_date = (select max(hire_date)
                   from employees);

/*
문제2.
평균연봉(salary)이 가장 높은 부서 직원들의 직원번호(employee_id), 이름(firt_name),
성(last_name)과 업무(job_title), 연봉(salary)을 조회하시오.
*/
select employee_id
      ,first_name
      ,last_name
      ,job_title
      ,tt.salary
from (select max(salary) salary --평균급여가 가장높은 부서의 급여를구함
      from (select avg(salary) salary
            from employees
            group by department_id)
     )t
     ,(select department_id,avg(salary) salary
      from employees
      group by department_id)tt
     ,employees e
     ,jobs
where t.salary in tt.salary
  and e.department_id = tt.department_id
  and jobs.job_id = e.job_id;
/*
문제3.
평균 급여(salary)가 가장 높은 부서는?
*/
select tt.department_id
from (select max(salary) salary --평균급여가 가장높은 부서의 급여를구함
      from (select avg(salary) salary
            from employees
            group by department_id)
     )t
     ,(select department_id,avg(salary) salary
      from employees
      group by department_id)tt
where t.salary in tt.salary;
  
/*
문제4.
평균 급여(salary)가 가장 높은 지역은?
*/
select region_name
from
(select max(salary) salary
from
(select  region_name,avg(salary) salary
from regions re
    ,countries co
    ,locations lo
    ,departments de
    ,employees em
where re.region_id = co.region_id
  and co.country_id = lo.country_id
  and lo.location_id = de.location_id
  and de.department_id = em.department_id
group by region_name))t
,
(select  region_name,avg(salary) salary
from regions re
    ,countries co
    ,locations lo
    ,departments de
    ,employees em
where re.region_id = co.region_id
  and co.country_id = lo.country_id
  and lo.location_id = de.location_id
  and de.department_id = em.department_id
group by region_name)tt
where t.salary in tt.salary;

/*
문제5.
평균 급여(salary)가 가장 높은 업무는?
*/
select t.job_title
from
(select job_title,avg(salary) salary
from employees em
    ,jobs
where em.job_id = jobs.job_id
group by jobs.job_id, job_title)t

,
(select max(salary) salary
from (select avg(salary) salary
      from employees em
      ,jobs
      where em.job_id = jobs.job_id
      group by jobs.job_id))tt

where t.salary = tt.salary;