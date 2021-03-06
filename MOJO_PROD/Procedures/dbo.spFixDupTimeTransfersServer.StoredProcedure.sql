USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixDupTimeTransfersServer]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixDupTimeTransfersServer]
	
AS
	/*
	GHL Creation for issue 112537
	*/

	SET NOCOUNT ON


	create table #time (TimeID int identity(1,1)
					, TimeKey uniqueidentifier null
					, TransferToKey uniqueidentifier null
					, WIPPostingInKey int null
					, ProjectKey int null
					, CompanyKey int null
					, TransferCount int null)
	
	insert #time (TimeKey, TransferToKey, WIPPostingInKey, ProjectKey, TransferCount)
	select TimeKey, TransferToKey, WIPPostingInKey, ProjectKey, 0
	from   tTime (nolock)
	where  TransferToKey is not null
	and    WIPPostingInKey >= 0 -- (no reversals where WIPPostingInKey = -99) 


   update #time
   set    #time.TransferCount = (select count(*) from tTime (nolock) where tTime.TransferFromKey = #time.TimeKey)
    
	delete #time where TransferCount <= 2

	update #time
	set    #time.CompanyKey = p.CompanyKey
	from   tProject p (nolock)
	where  #time.ProjectKey = p.ProjectKey

	declare @TimeID int
	declare @TimeKey uniqueidentifier
	declare @TransferToKey uniqueidentifier
	declare @CompanyKey int
	 
	select @TimeID = -1
	while (1=1)
	begin
		select @TimeID = min(TimeID)
		from   #time
		where  TimeID > @TimeID

		if @TimeID is null
			break

		select @TimeKey = TimeKey
		      ,@TransferToKey = TransferToKey
			  ,@CompanyKey = CompanyKey
		from  #time
		where TimeID = @TimeID

		exec spFixDupTimeTransfer @TimeKey, @CompanyKey, @TransferToKey
	end


	RETURN 1
GO
