USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataProductUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataProductUpdate]
	@OwnerCompanyKey int,
	@ClientProductKey int,
	@ProductName varchar(300),
	@ClientDivisionLinkID varchar(100)

AS --Encrypt

/*
|| When     Who Rel     What
|| 05/31/07 RTC 8.5    (9279) Corrected update of product division key. 
*/

declare @ClientKey int
declare @ClientDivisionKey int
	
	-- get ClientDivisionKey from ClientDivisionLinkID
	if @ClientDivisionLinkID is not null
		begin
			select @ClientDivisionKey = ClientDivisionKey
			from tClientDivision (nolock)
			where CompanyKey = @OwnerCompanyKey
			and LinkID = @ClientDivisionLinkID
		   
		if @ClientDivisionKey is null
			return -1
		end
			
	update tClientProduct
	   set ProductName = @ProductName,
	       ClientDivisionKey = @ClientDivisionKey
	 where ClientProductKey = @ClientProductKey

	RETURN 1
GO
