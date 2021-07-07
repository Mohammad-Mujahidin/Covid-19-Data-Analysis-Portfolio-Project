
-- Queries used to create Tableau vizualization Project for covid 19


-- Global Information

Select SUM(new_cases) as total_cases, SUM(convert(int, new_deaths)) as total_deaths, SUM(convert(int, new_deaths))/SUM(New_Cases)*100 as death_percentage
From Portfolio_Project..Covid_Deaths
order by total_cases, total_deaths

-- Total Deaths Per Continent

Select location, SUM(convert(int, new_deaths)) as Total_Death_Count
From Portfolio_Project..Covid_Deaths
Where continent is null 
and location not in ('International', 'World', 'European Union')
Group by location
order by Total_Death_Count desc

-- Percent Population Infected Per Country

Select Location, Population, MAX(total_cases) as Highest_Infection_Count,  Max((total_cases/population))*100 as Percent_Population_Infected
From Portfolio_Project..Covid_Deaths
Group by Location, Population
order by Percent_Population_Infected desc

-- Tableau table 4

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as Percent_Population_Infected
From Portfolio_Project..Covid_Deaths
Where continent is null 
and location not in ('International', 'World', 'European Union')
Group by Location, Population, date
order by Percent_Population_Infected desc