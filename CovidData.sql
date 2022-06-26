SELECT* 
FROM PPP_Project1.dbo.CovidDeaths$
WHERE continent is not null
order by 4,3

SELECT* FROM PPP_Project1.dbo.CovidVaccinations$
order by 3,4

--Death Percentage In Nigeria
SELECT location,date,total_cases,total_deaths,population,(total_deaths/total_cases)*100 AS Death_Percentage
FROM PPP_Project1.dbo.CovidDeaths$
Where location= 'Nigeria'
order by 1,2

--Percentage of Population that got infected
SELECT location,date,total_cases,population,(total_cases/population)*100 AS Infection_Percentage
FROM PPP_Project1.dbo.CovidDeaths$
Where location= 'Nigeria'
order by 1,2

--Countries with highest infection rate compared to population
SELECT location,MAX(total_cases)as highest_infection_per_country,population,MAX((total_cases/population))*100 AS Infection_Percentage
FROM PPP_Project1.dbo.CovidDeaths$
group by location,population
order by Infection_Percentage DESC

--Country with highest amount of total cases
SELECT location,MAX(total_cases)as highest_infection_per_country,population,MAX((total_cases/population))*100 AS Infection_Percentage
FROM PPP_Project1.dbo.CovidDeaths$
WHERE continent is not null
group by location,population
order by highest_infection_per_country DESC

-- Average age with highest with highest infection
SELECT location,AVG( median_age)as Average_age
FROM PPP_Project1.dbo.CovidDeaths$
group by location
order by Average_age DESC

 --Countries with highest death count per country
 SELECT location,MAX(cast(total_deaths as bigint)) as Total_Death_Count
 FROM PPP_Project1.dbo.CovidDeaths$
 WHERE continent is not null
 group by location
 order by Total_Death_Count desc

 --Grouping into continents
 SELECT continent,MAX(cast(total_deaths as bigint)) as Total_Death_Count
 FROM PPP_Project1.dbo.CovidDeaths$
 WHERE continent is not null
 group by continent
 order by Total_Death_Count desc

 ---global numbers
 SELECT SUM(new_cases) total_new_cases ,SUM (cast(new_deaths as int))total_deaths,(SUM(cast(new_deaths as int))/SUM(new_cases)*100) AS Death_Percentage
FROM PPP_Project1.dbo.CovidDeaths$
Where continent is not null 
--group by date
order by 1,2

--Joining the two tables
SELECT* FROM PPP_Project1.dbo.CovidDeaths$ dea
join PPP_Project1.dbo.CovidVaccinations$ vac
on dea.location=vac.location
and dea.date= vac.date

--Total Population vs Vaccinations
With PopvsVac(Continent,location,date, population,new_vaccinations,rolling_vaccines)
as
(
SELECT dea.continent,dea.location ,dea.date,dea.population,vac.new_vaccinations,SUM(CAST(vac.new_vaccinations as int)) OVER(PARTITION BY dea.location Order by dea.location,dea.date) as rolling_vaccines
FROM PPP_Project1.dbo.CovidDeaths$ dea
join PPP_Project1.dbo.CovidVaccinations$ vac
on dea.location=vac.location
and dea.date= vac.date
where dea.continent is not null
)
Select *,(rolling_vaccines/population)*100
FROM PopvsVac

--Create View For Visualization

CREATE View PopvsVac as
SELECT dea.continent,dea.location ,dea.date,dea.population,vac.new_vaccinations,SUM(CAST(vac.new_vaccinations as int)) OVER(PARTITION BY dea.location Order by dea.location,dea.date) as rolling_vaccines
FROM PPP_Project1.dbo.CovidDeaths$ dea
join PPP_Project1.dbo.CovidVaccinations$ vac
on dea.location=vac.location
and dea.date= vac.date
where dea.continent is not null

Create view Infectionpercentage as
SELECT location,MAX(total_cases)as highest_infection_per_country,population,MAX((total_cases/population))*100 AS Infection_Percentage
FROM PPP_Project1.dbo.CovidDeaths$
group by location,population

