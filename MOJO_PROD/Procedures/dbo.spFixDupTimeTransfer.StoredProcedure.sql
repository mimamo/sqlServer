USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixDupTimeTransfer]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixDupTimeTransfer]
	(
	@TimeKey uniqueidentifier
	,@CompanyKey int = null
	,@TransferToKey uniqueidentifier = null
	)
	
AS
	/*
	GHL Creation for issue 112537
	*/

	if @TimeKey is null
		return 1

	if @CompanyKey is null Or @TransferToKey is null
		select @CompanyKey = isnull(u.OwnerCompanyKey, u.CompanyKey)
		      ,@TransferToKey = t.TransferToKey 
		from  tTime t (nolock) 
		   inner join tUser u (nolock) on t.UserKey = u.UserKey
		where t.TimeKey = @TimeKey

	if @TransferToKey is null
		return 1

	-- delete the reversals
		delete tTime
		from   tProject p (nolock)
		--select * from tTime (nolock)
		--,   tProject p (nolock)
		where  tTime.ProjectKey = p.ProjectKey
		and    p.CompanyKey = @CompanyKey
		and    tTime.TransferFromKey = @TimeKey 
		and    tTime.TransferToKey <> @TransferToKey -- wrong TransferToKey
		and    tTime.WIPPostingInKey = -99 -- was reversal

	
		-- delete the new ones that we created during transfers
		delete tTime
		from   tProject p (nolock)
		--select * from tTime (nolock)
		--,   tProject p (nolock)
		where  tTime.ProjectKey = p.ProjectKey
		and    p.CompanyKey = @CompanyKey
		and    tTime.TransferFromKey = @TimeKey 
		and    tTime.TimeKey <> @TransferToKey -- wrong TransferToKey
		and    isnull(tTime.InvoiceLineKey, 0) = 0 -- not billed yet
		and    tTime.WIPPostingInKey = 0 -- not in WIP

	RETURN 1
GO
