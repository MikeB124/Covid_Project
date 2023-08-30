-- test tables populated succesfully

--select * 
--from ..covid
--order by 3,4;

--select * 
--from ..CovidDeaths
--order by 3,4;

-- Select data we will be using

select Location,date,total_cases,new_cases,total_deaths,population
From ..CovidDeaths
order by 1,2;

-- Looking at Total Cases VS Total Deaths
-- Shows probability of death from Covid in the U.S.

select Location,date,total_cases,total_deaths,(total_deaths/total_cases) * 100 as DeathPercentage
From ..CovidDeaths
where location like '%states%'
order by 1,2;

-- Looking at total cases vs population
-- what % of population got Covid
select Location,date,population,total_cases,(total_cases/population) * 100 as InfectedPopulation
From ..CovidDeaths
where location like '%states%'
order by 1,2;

-- Looking at Countries with highest infection tate compared to population
-- what country with highest infection rate VS population
-- ADD group by due to aggreagte function
select Location,population,max(total_cases) as highestinfectioncount,max((total_cases/population)) * 100 as PercentPopulationinfected
From ..CovidDeaths
-- where location like '%states%'
Group by location,population
order by PercentPopulationinfected desc;

-- Looking at Countries with highest death count per population
select Location,max(cast(total_deaths as int))  as TotalDeathCount
From ..CovidDeaths
-- where location like '%states%'
-- remove rows whose location is populated and the continent column isnt
Where continent is not null
Group by location
order by TotalDeathCount desc;


-- Segmenting by Continent
-- Looking at Countries with highest death count per population
select location,max(cast(total_deaths as int))  as TotalDeathCount
From ..CovidDeaths
-- where location like '%states%'
-- remove rows whose location is populated and the continent column isnt
Where continent is null
Group by location
order by TotalDeathCount desc;


-- Segmenting by Continent

-- Looking at Countries with highest death count per population
select continent,max(cast(total_deaths as int))  as TotalDeathCount
From ..CovidDeaths
-- where location like '%states%'
-- remove rows whose location is populated and the continent column isnt
Where continent is not null
Group by continent
order by TotalDeathCount desc;


-- start to consider visulization and drill down availability

-- Global numbers

--global death percentage by date

select date,sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as total_Deaths, sum(cast(new_Deaths as int))/sum(new_cases)*100 as DeathPercentage
From ..CovidDeaths
where continent is not null
group by date
order by 1,2;

-- global death percentage - total cases and total deaths 
select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as total_Deaths, sum(cast(new_Deaths as int))/sum(new_cases)*100 as DeathPercentage
From ..CovidDeaths
where continent is not null
order by 1,2;


-- JOINS!
-- looking at total populations VS vaccinations

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
from..CovidDeaths dea
join ..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
order by 1,2,3;

--Rolling count, add up 

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location)
from..CovidDeaths dea
join ..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
order by 1,2,3;