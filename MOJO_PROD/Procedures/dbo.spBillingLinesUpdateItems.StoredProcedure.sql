USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingLinesUpdateItems]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingLinesUpdateItems]
	(
	@WorkTypeCustomEntity varchar(50)
	,@WorkTypeCustomEntityKey int
	)
AS --Encrypt

/*
|| When     Who Rel    What
|| 03/26/10 GHL 10.521 Creation for new layouts  
*/

	SET NOCOUNT ON

	-- restore the standard description
	update #allitems
	set    #allitems.EntityName = #allitems.StdEntityName
	      ,#allitems.Description = #allitems.StdDescription
	where  #allitems.Entity = 'tWorkType'

	if @WorkTypeCustomEntity is null
		RETURN 1
		
	-- overwrite with the custom billing item descs	
	update #allitems
	set    #allitems.EntityName = cust.Subject
	      ,#allitems.Description = cust.Description
	from   tWorkTypeCustom cust (nolock)
	where  #allitems.EntityKey = cust.WorkTypeKey
	and    #allitems.Entity = 'tWorkType'
	and    cust.Entity = @WorkTypeCustomEntity COLLATE DATABASE_DEFAULT
	and    cust.EntityKey = @WorkTypeCustomEntityKey    				
	 	
	RETURN 1
GO
