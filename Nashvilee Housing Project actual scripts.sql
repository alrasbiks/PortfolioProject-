/****** Script for Nashville Housing Clean Data Project by Khalid Al Rasbi ******/

--cleaning data by SQL Quries
--Cahnge Date Format

select SaleDateConverted, CONVERT (Date,SaleDate)
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT (Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Poulate Property Address data
-- In data there is some of null property adress so we should work on fixing it in this part
-- We know it should match so here is how to fix it 

select nh1.ParcelID, nh1.PropertyAddress, nh2.ParcelID, nh2.PropertyAddress, ISNULL(nh1.propertyAddress,nh2.propertyAddress)
from PortfolioProject..NashvilleHousing nh1
Join PortfolioProject..NashvilleHousing nh2
	ON nh1.ParcelID = nh2.ParcelID
	AND nh1.[UniqueID ] <> nh2.[UniqueID ]
Where nh1.PropertyAddress is null

Update nh1
SET PropertyAddress = ISNULL(nh1.propertyAddress,nh2.propertyAddress)
from PortfolioProject..NashvilleHousing nh1
Join PortfolioProject..NashvilleHousing nh2
	ON nh1.ParcelID = nh2.ParcelID
	AND nh1.[UniqueID ] <> nh2.[UniqueID ]
Where nh1.PropertyAddress is null

--Sprating the address Information 
--by using Propertyaddress I just created 
--Split to Address and City 

--first show as column 
Select PropertyAddress
From PortfolioProject..NashvilleHousing

Select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address 
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address 

From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAdress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAdress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) 

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

--Here to Splirt Owner Address
--First Show Owner Address
--using diffrent way

Select OwnerAddress 
From PortfolioProject..NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 
 ,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 
 ,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) 
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAdress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) 

Select *
From PortfolioProject..NashvilleHousing

--Change Y and N to Yes and No in Colums "Sold as Vacant" 

Select Distinct (SoldAsVacant), Count (SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
 , Case When SoldAsVacant = 'Y' THEN 'Yes'
		When SOldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
						When SOldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END

--Remove any Duplications 

WITH RowNumCTE AS(
Select *,
		ROW_NUMBER() OVER(
		PARTITION BY	ParcelID,
						PropertyAddress,
						SalePrice,
						SaleDate,
						LegalReference
						Order By
						UniqueID
						) row_num		
From PortfolioProject..NashvilleHousing
)
--Delete
--From RowNumCTE
--Where row_num >1

Select *
From RowNumCTE
Where row_num >1
Order by PropertyAddress



-- Delete Unused Colums

Select *
From PortfolioProject..NashvilleHousing

ALTER TABLE  PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate