Select * from PortfolioProject.dbo.NashvilleHousing

Select SaleDateConverted, Convert(date, SaleDate) from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing 
Set SaleDate = convert(date, SaleDate)

Alter Table NashvilleHousing
add SaleDateConverted date

Update NashvilleHousing 
Set SaleDateConverted = convert(date, SaleDate)

--Populate property address data

select * 
from PortfolioProject.dbo.NashvilleHousing 
where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out Address into Individual Columns(Address, City, State)


Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing 
--where PropertyAddress is null
--order by ParcelID

Select
Substring(PropertyAddress, 1, CHARINDEX(',', Propertyaddress) -1) as Address,
Substring(propertyAddress, CHARINDEX(',', Propertyaddress) +1, LEN(propertyaddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing 
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', Propertyaddress) -1)

Alter table Nashvillehousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = Substring(propertyAddress, CHARINDEX(',', Propertyaddress) +1, LEN(propertyaddress))

Select * from portfolioproject.dbo.NashvilleHousing


Select Owneraddress from portfolioproject.dbo.NashvilleHousing

Select
PARSENAME(replace(Owneraddress, ',', '.') ,3),
PARSENAME(replace(Owneraddress, ',', '.') ,2),
PARSENAME(replace(Owneraddress, ',', '.') ,1)
from PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing 
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(replace(Owneraddress, ',', '.') ,3)

Alter table Nashvillehousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(replace(Owneraddress, ',', '.') ,2)

Alter table NashvilleHousing 
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(replace(Owneraddress, ',', '.') ,1)


Select * from portfolioproject.dbo.NashvilleHousing


Select distinct(SoldAsVacant), Count(SoldAsVacant)
From portfolioproject.dbo.nashvillehousing
group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End
From portfolioproject.dbo.NashvilleHousing

update PortfolioProject.dbo.NashvilleHousing
set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End



With RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	Partition By ParcelId,
				 PropertyAddress,
				 Saleprice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num


From portfolioproject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
where row_num > 1
order by PropertyAddress



--Delete unused columns

Select *
from PortfolioProject.dbo.NashvilleHousing

alter table portfolioproject.dbo.nashvillehousing
Drop column owneraddress, TaxDistrict, PropertyAddress

alter table portfolioproject.dbo.nashvillehousing
Drop column SaleDate
