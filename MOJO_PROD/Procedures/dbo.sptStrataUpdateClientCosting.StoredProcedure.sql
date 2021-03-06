USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataUpdateClientCosting]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataUpdateClientCosting]
	@CompanyKey int,
	@UseClientCosting int

AS --Encrypt

/*
|| When     Who	Rel     What
|| 09/13/09 MAS	10.5.	Created, default client costing settings based on the current settings used by StrataLink Client.
||					
*/

-- is client costing preferences already set up
if exists ( Select * from tPreference (nolock)
			Where CompanyKey = @CompanyKey
			and (IOUseClientCosting is not null and BCUseClientCosting is not null) )
	Return 0 -- No change
			
if @UseClientCosting < 0 or @UseClientCosting > 1
	Return -1
	

Update tPreference
-- The StrataLink Client only has one setting so we'll set both to use that default
Set IOUseClientCosting = @UseClientCosting, BCUseClientCosting = @UseClientCosting
Where CompanyKey = @CompanyKey

Return 1 -- updated
GO
