/*

Covid 19 Data Exploration 

Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


select * 
from Portfolio_Project..Covid_Deaths
where continent is not null
order by location, date

-- Selecting Database to explore

select location, date, total_cases, new_cases, total_deaths, population
from Portfolio_Project..Covid_Deaths
where continent is not null
order by location, date

-- Total Cases vs Total Deaths in Saudin Arabia
-- Shows the precentage of dying if you are infected by covid 19 in Saudi Arabia

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Precentage
from Portfolio_Project..Covid_Deaths
where location='Saudi Arabia'
and continent is not null
order by location, date

-- Total Cases vs Total Deaths globaly
-- Shows the precentage of dying if you are infected by covid 19 globaly

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Precentage
from Portfolio_Project..Covid_Deaths
--where location='Saudi Arabia'
where continent is not null
order by location, date

-- Total Cases vs Population in Saudin Arabia
-- Shows what percentage of population infected with Covid 19 in Saudi Arabia

select location, date, population, total_cases, (total_cases/population)*100 as Popualtion_infected_precentage
from Portfolio_Project..Covid_Deaths
where location='Saudi Arabia'
order by location, date

-- Total Cases vs Population globaly
-- Shows what percentage of population infected with Covid 19 globaly

select location, date, population, total_cases, (total_cases/population)*100 as Popualtion_infected_precentage
from Portfolio_Project..Covid_Deaths
--where location='Saudi Arabia'
order by location, date

-- Countries with Highest Death Count per Population

select location, MAX(cast(total_deaths as int)) as Total_Death_count
from Portfolio_Project..Covid_Deaths
where continent is not null
group by location
order by Total_Death_count desc

-- Breaking things into continent

-- Showing contintents from highest death count per population to the lowest

Select continent, MAX(cast(Total_deaths as int)) as Total_Death_Count
From Portfolio_Project..Covid_Deaths
Where continent is not null 
Group by continent
order by Total_Death_Count desc

-- Global total cases and deaths with death precentage

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Death_Percentage
From Portfolio_Project..Covid_Deaths
where continent is not null

-- Total Population vs Vaccinations in Saudin Arabia
-- Shows Percentage of Population that has recieved at least one Covid Vaccine in Saudi Arabia

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Total_People_Vaccinated
From Portfolio_Project..Covid_Deaths dea
Join Portfolio_Project..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.location='Saudi Arabia' 
and dea.continent is not null 
order by dea.location, dea.date

-- Total Population vs Vaccinations globaly
-- Shows Percentage of Population that has recieved at least one Covid Vaccine globaly

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Total_People_Vaccinated
From Portfolio_Project..Covid_Deaths dea
Join Portfolio_Project..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.location='Saudi Arabia' 
where dea.continent is not null 
order by dea.location, dea.date

-- Using CTE to perform calculation on partition By in previous query

With Pop_vs_Vac (Continent, Location, Date, Population, New_Vaccinations, Total_People_Vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Total_People_Vaccinated
From Portfolio_Project..Covid_Deaths dea
Join Portfolio_Project..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (Total_People_Vaccinated/Population)*100 as #Percent_Population_Vaccinated
From Pop_vs_Vac

-- Creating View to store data for later visualizations

Create View Percent_Population_Vaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Total_People_Vaccinated
From Portfolio_Project..Covid_Deaths dea
Join Portfolio_Project..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

-- Checking the data

select *
from Percent_Population_Vaccinated