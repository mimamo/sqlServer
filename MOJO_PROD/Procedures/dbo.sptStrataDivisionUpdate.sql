USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataDivisionUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataDivisionUpdate]
	@OwnerCompanyKey int,
	@ClientDivisionKey int,
	@LinkID varchar(100),
	@DivisionName varchar(300),
	@ClientID varchar(100)

AS --Encrypt

/*
|| When     Who Rel     What
|| 05/31/07 RTC 8.4.3   (9279) Added update of client key.
*/


declare @ClientKey int

	-- insure the division name does not already exist
	if exists (select 1 
				from tClientDivision cd (nolock) inner join tCompany c (nolock) on cd.ClientKey = c.CompanyKey
				where cd.CompanyKey = @OwnerCompanyKey
				and c.CustomerID = @ClientID
				and cd.DivisionName = @DivisionName
				and cd.LinkID <> @LinkID)
			return -1
			
	-- get ClientKey from ClientID
	select @ClientKey = CompanyKey
	  from tCompany (nolock)
	 where OwnerCompanyKey = @OwnerCompanyKey
	   and CustomerID = @ClientID
	   
	if @ClientKey is null
		return -1
		
	update tClientDivision
	   set DivisionName = @DivisionName
	      ,ClientKey = @ClientKey
	 where ClientDivisionKey = @ClientDivisionKey

	return 1
GO
