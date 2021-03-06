USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceOVERBUDGETITEM]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserPreferenceOVERBUDGETITEM]

	@UserKey int,
	@Value int,
	@Value2 int

AS --Encrypt

/*
|| When     Who Rel		   What
|| 10/19/12 KMC 10.5.6.1   Added the amount of the outstanding purchase orders
|| 12/10/12 GWG 10.5.6.3   Added an all projects option
*/

-- Value or Mode
-- 1 = My Assigned Projects
-- 2 = Where I am the account manager
-- 3 = In my office

-- Value2
-- 0 all projects over budget
-- 5 5% over budget
-- 10 10% over budget
-- etc...
-- 90 90% over budget
-- 100 100% and up over budget


Declare @CompanyKey int
Declare @OfficeKey int

Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey), @OfficeKey = OfficeKey from tUser (NOLOCK) Where UserKey = @UserKey

DECLARE @PercentOver AS DECIMAL(9, 3)
SELECT  @PercentOver = CAST(@Value2 AS DECIMAL(9, 3)) / 100.0

-- For items, just consider expenses, not labor
if @Value = 1
select * from
	(
	Select 
		 p.ProjectNumber
		,p.ProjectName
		,i.ItemID
		,i.ItemName
		,ISNULL((Select SUM(BillableCost) 
			from tMiscCost (nolock) where tMiscCost.ItemKey = i.ItemKey
			And tMiscCost.ProjectKey = p.ProjectKey), 0) as MiscCostAmt
		,ISNULL((Select SUM(BillableCost) 
			from tVoucherDetail (nolock)
			where tVoucherDetail.ItemKey = i.ItemKey
			And tVoucherDetail.ProjectKey = p.ProjectKey), 0) as VoucherAmt
		,ISNULL((SELECT SUM(BillableCost) from tPurchaseOrderDetail (nolock) where tPurchaseOrderDetail.ProjectKey = p.ProjectKey and tPurchaseOrderDetail.Closed = 0), 0) as OpenPOs
		,pes.Gross  -- contains all approved expenses
		From tProject p (nolock)
			inner join tProjectEstByItem pes (NOLOCK) on pes.ProjectKey = p.ProjectKey
			inner join tItem i (NOLOCK) on pes.EntityKey = i.ItemKey    -- i.e. ignore pes.ItemKey = 0 records
	where p.Active = 1
	and	  p.Closed = 0	
	and   p.CompanyKey = @CompanyKey
	and   pes.Entity = 'tItem'
	and   pes.Gross  > 0
	and   p.ProjectKey in (select ProjectKey from tAssignment (nolock) where UserKey = @UserKey)
	) As b		
where
		(MiscCostAmt + VoucherAmt) >= Gross  * (1 + @PercentOver )
Order By
		ProjectNumber, ItemID		
		
if @Value = 2
select * from
	(
	Select 
		 p.ProjectNumber
		,p.ProjectName
		,i.ItemID
		,i.ItemName
		,ISNULL((Select SUM(BillableCost) 
			from tMiscCost (nolock) where tMiscCost.ItemKey = i.ItemKey
			And tMiscCost.ProjectKey = p.ProjectKey), 0) as MiscCostAmt
		,ISNULL((Select SUM(BillableCost) 
			from tVoucherDetail (nolock)
			where tVoucherDetail.ItemKey = i.ItemKey
			And tVoucherDetail.ProjectKey = p.ProjectKey), 0) as VoucherAmt
		,ISNULL((SELECT SUM(BillableCost) from tPurchaseOrderDetail (nolock) where tPurchaseOrderDetail.ProjectKey = p.ProjectKey and tPurchaseOrderDetail.Closed = 0), 0) as OpenPOs
		,pes.Gross  -- contains all approved expenses
		From tProject p (nolock)
			inner join tProjectEstByItem pes (NOLOCK) on pes.ProjectKey = p.ProjectKey
			inner join tItem i (NOLOCK) on pes.EntityKey = i.ItemKey    -- i.e. ignore pes.ItemKey = 0 records
	where p.Active = 1
	and	  p.Closed = 0	
	and   p.CompanyKey = @CompanyKey
	and   pes.Entity = 'tItem'
	and   pes.Gross  > 0
	and   p.AccountManager = @UserKey
	) As b		
where
		(MiscCostAmt + VoucherAmt) >= Gross  * (1 + @PercentOver )
Order By
		ProjectNumber, ItemID				

if @Value = 3
select * from
	(
	Select 
		 p.ProjectNumber
		,p.ProjectName
		,i.ItemID
		,i.ItemName
		,ISNULL((Select SUM(BillableCost) 
			from tMiscCost (nolock) where tMiscCost.ItemKey = i.ItemKey
			And tMiscCost.ProjectKey = p.ProjectKey), 0) as MiscCostAmt
		,ISNULL((Select SUM(BillableCost) 
			from tVoucherDetail (nolock)
			where tVoucherDetail.ItemKey = i.ItemKey
			And tVoucherDetail.ProjectKey = p.ProjectKey), 0) as VoucherAmt
		,ISNULL((SELECT SUM(BillableCost) from tPurchaseOrderDetail (nolock) where tPurchaseOrderDetail.ProjectKey = p.ProjectKey and tPurchaseOrderDetail.Closed = 0), 0) as OpenPOs
		,pes.Gross  -- contains all approved expenses
		From tProject p (nolock)
			inner join tProjectEstByItem pes (NOLOCK) on pes.ProjectKey = p.ProjectKey
			inner join tItem i (NOLOCK) on pes.EntityKey = i.ItemKey    -- i.e. ignore pes.ItemKey = 0 records
	where p.Active = 1
	and	  p.Closed = 0
	and   p.CompanyKey = @CompanyKey
	and   pes.Entity = 'tItem'
	and   pes.Gross  > 0
	and   p.OfficeKey = @OfficeKey
	) As b		
where
		(MiscCostAmt + VoucherAmt) >= Gross  * (1 + @PercentOver )
Order By
		ProjectNumber, ItemID		

		


if @Value = 4
BEGIN



DECLARE	@SecurityGroupKey int
DECLARE @Administrator int
DECLARE @RestrictToGLCompany int
Select @RestrictToGLCompany = isnull(RestrictToGLCompany, 0) from tPreference (nolock) where CompanyKey = @CompanyKey
select @SecurityGroupKey = SecurityGroupKey, @Administrator = ISNULL(Administrator, 0) from tUser (nolock) where UserKey = @UserKey

if @Administrator = 0
	if exists(Select 1 from tRightAssigned (nolock) Where EntityKey = @SecurityGroupKey and RightKey = 90918)
		Select @Administrator = 1



select * from
	(
	Select 
		 p.ProjectNumber
		,p.ProjectName
		,i.ItemID
		,i.ItemName
		,ISNULL((Select SUM(BillableCost) 
			from tMiscCost (nolock) where tMiscCost.ItemKey = i.ItemKey
			And tMiscCost.ProjectKey = p.ProjectKey), 0) as MiscCostAmt
		,ISNULL((Select SUM(BillableCost) 
			from tVoucherDetail (nolock)
			where tVoucherDetail.ItemKey = i.ItemKey
			And tVoucherDetail.ProjectKey = p.ProjectKey), 0) as VoucherAmt
		,ISNULL((SELECT SUM(BillableCost) from tPurchaseOrderDetail (nolock) where tPurchaseOrderDetail.ProjectKey = p.ProjectKey and tPurchaseOrderDetail.Closed = 0), 0) as OpenPOs
		,pes.Gross  -- contains all approved expenses
		From tProject p (nolock)
			inner join tProjectEstByItem pes (NOLOCK) on pes.ProjectKey = p.ProjectKey
			inner join tItem i (NOLOCK) on pes.EntityKey = i.ItemKey    -- i.e. ignore pes.ItemKey = 0 records
	where p.Active = 1
	and	  p.Closed = 0	
	and   p.CompanyKey = @CompanyKey
	and   pes.Entity = 'tItem'
	and   pes.Gross  > 0
	and   (@Administrator = 1 OR p.ProjectKey in (Select ProjectKey from tAssignment (nolock) Where UserKey = @UserKey))
	and   (@RestrictToGLCompany = 0 Or p.GLCompanyKey in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey) )
	) As b		
where
		(MiscCostAmt + VoucherAmt) >= Gross  * (1 + @PercentOver )
Order By
		ProjectNumber, ItemID	

END

return 1
GO
