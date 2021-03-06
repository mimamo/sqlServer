USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataDivisionInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataDivisionInsert]
	@OwnerCompanyKey int,
	@ClientID varchar(100),
	@LinkID varchar(100),
	@DivisionName varchar(300)

AS --Encrypt

/*
|| When     Who Rel     What
|| 05/31/07 RTC 8.4.3   (9279) Changed joins/where clause for performance improvement
*/

declare @ClientKey int

	-- insure the division does not already exist
	if exists (select 1 
				from tClientDivision cd (nolock) inner join tCompany c (nolock) on cd.ClientKey = c.CompanyKey
				where cd.CompanyKey = @OwnerCompanyKey
				and c.CustomerID = @ClientID
				and cd.DivisionName = @DivisionName)
			return -1
	
	-- get ClientKey from ClientID
	select @ClientKey = CompanyKey
	  from tCompany (nolock)
	 where OwnerCompanyKey = @OwnerCompanyKey
	   and CustomerID = @ClientID
	   
	if @ClientKey is null
		return -2

	insert tClientDivision
		  (CompanyKey
		  ,ClientKey
		  ,DivisionName
		  ,Active
		  ,LinkID
		  )
   values (@OwnerCompanyKey
          ,@ClientKey
          ,@DivisionName
          ,1
          ,@LinkID
	      )

	RETURN 1
GO
