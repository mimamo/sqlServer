USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetCCList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherGetCCList]
	(
	@CompanyKey int
	,@APAccountKey int
	,@BoughtByKey int
	,@StartDate datetime
	,@EndDate datetime
	)
AS --Encrypt

  /*
  || When     Who Rel     What
  || 09/02/11 GHL 10.547  Created for CreditCardAdd.mxml
  ||                      Gets the history of credit card charges at the left of the screen
  || 10/20/11 GHL 10.549  Added APAccountKey credit card account key
  || 10/09/12 GHL 10.561  (156394) Added BoughtByKey to handle click/security on CreditCardAdd.mxml  
  */

	SET NOCOUNT ON

	if @BoughtByKey = 0
		select @BoughtByKey = null

	-- need a temp table to figure out a project number
	-- the UI only saves projects in tVoucherDetail
	create table #voucher (VoucherKey int null
						, ProjectKey int null
						, Description varchar(500) null
						, SortOrder int identity(1,1))
	
	insert #voucher (VoucherKey, Description)
	select v.VoucherKey, v.Description
	from   tVoucher v (nolock)
	where  v.CompanyKey = @CompanyKey 
	and    isnull(v.CreditCard, 0) = 1
	and    (@StartDate is null or v.InvoiceDate >= @StartDate)
	and    (@EndDate is null or v.InvoiceDate <= @EndDate)
	and    (@BoughtByKey is null or v.BoughtByKey = @BoughtByKey)
	and    (@APAccountKey is null or v.APAccountKey = @APAccountKey)
	order by v.InvoiceDate desc
			 ,v.VoucherKey desc

	-- pick up any project on the details, because it is missing on the header
	update #voucher
	set    #voucher.ProjectKey = vd.ProjectKey
	from   tVoucherDetail vd (nolock)
	where  #voucher.VoucherKey = vd.VoucherKey
	and    vd.ProjectKey is not null
	 
	-- pick up description if missing
	update #voucher
	set    #voucher.Description = vd.ShortDescription
	from   tVoucherDetail vd (nolock)
	where  #voucher.VoucherKey = vd.VoucherKey
	and    vd.ShortDescription is not null
	and    #voucher.Description  is null

	select  v.VoucherKey
	        ,v.InvoiceNumber
	        ,v.InvoiceDate
		    ,v.VoucherTotal
			,v.BoughtByKey
			,isnull(ub.FirstName + ' ', '') + isnull(ub.LastName, '') as BoughtByName 
			,gla.AccountNumber
			,gla.AccountName
			,gla.AccountNumber + ' - ' + gla.AccountName as CreditCardFullName
			,isnull(p.ProjectNumber + ' - ', '') + isnull(p.ProjectName, '') as ProjectFullName
			,v.BoughtFrom

			,b.Description -- 2nd table
			,b.SortOrder
	from   tVoucher v (nolock)
		inner join #voucher b (nolock) on v.VoucherKey = b.VoucherKey
		left outer join tGLAccount gla (nolock) on v.APAccountKey = gla.GLAccountKey
		left outer join tUser ub (nolock) on v.BoughtByKey = ub.UserKey 		
		left outer join tProject p (nolock) on b.ProjectKey = p.ProjectKey -- must join thru 2nd table
	
	order by isnull(ub.FirstName + ' ', '') + isnull(ub.LastName, '') 
	         ,b.SortOrder

	RETURN 1
GO
