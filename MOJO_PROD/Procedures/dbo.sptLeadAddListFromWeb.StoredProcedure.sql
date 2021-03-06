USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadAddListFromWeb]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadAddListFromWeb]
	(
	@UserLeadKey int,
	@ListName varchar(500)
	)

AS

declare @CompanyKey int,  @ListKey int

  /*
  || When     Who Rel       What
  || 06/24/10 GHL 10.531   (83877) Added DateAdded for Business Dev Report       
  */

DECLARE @DateAdded smalldatetime
SELECT @DateAdded = CONVERT(smalldatetime,  CONVERT(VARCHAR(10), GETDATE(), 101), 101)

Select @CompanyKey = CompanyKey from tUserLead (nolock) Where UserLeadKey = @UserLeadKey

if @CompanyKey is null
	return -1
	
Select @ListKey = Min(MarketingListKey) from tMarketingList (nolock) Where CompanyKey = @CompanyKey and ListName = @ListName

if @ListKey is null
BEGIN
	Insert tMarketingList(ListName, CompanyKey) Values(@ListName, @CompanyKey)
	Select @ListKey = @@Identity
	
END


if not exists(Select null from tMarketingListList (nolock) Where Entity = 'tUserLead' and EntityKey = @UserLeadKey and MarketingListKey = @ListKey)
	Insert tMarketingListList(MarketingListKey, Entity, EntityKey, DateAdded)
	Values(@ListKey, 'tUserLead', @UserLeadKey, @DateAdded)
GO
