USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixDupTimeTransfers]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixDupTimeTransfers]
	(
	@ProjectKey int
	)
	
AS
	SET NOCOUNT ON 
	
	/*
	GHL Creation for issue 112537
	*/

	/* To detect the dups on a server
	 
	create table #time (TimeID int identity(1,1)
					, TimeKey uniqueidentifier null
					, TransferToKey uniqueidentifier null
					, WIPPostingInKey int null
					, ProjectKey int null
					, TransferCount int null)
	
	insert #time (TimeKey, TransferToKey, WIPPostingInKey, ProjectKey, TransferCount)
	select TimeKey, TransferToKey, WIPPostingInKey, ProjectKey, 0
	from   tTime (nolock)
	where  TransferToKey is not null
	and    WIPPostingInKey >= 0 -- (no reversals where WIPPostingInKey = -99) 


   update #time
   set    #time.TransferCount = (select count(*) from tTime (nolock) where tTime.TransferFromKey = #time.TimeKey)
    
    
   select * from #time where TransferCount > 2

	*/
	
	declare @CompanyKey int

	select @CompanyKey = CompanyKey
	from   tProject (nolock)
	where  ProjectKey = @ProjectKey

	create table #time (TimeID int identity(1,1)
					, TimeKey uniqueidentifier null
					, TransferToKey uniqueidentifier null
					, WIPPostingInKey int null
					, ProjectKey int null
					, TransferCount int null)
	
	insert #time (TimeKey, TransferToKey, WIPPostingInKey, ProjectKey, TransferCount)
	select TimeKey, TransferToKey, WIPPostingInKey, ProjectKey, 0
	from   tTime (nolock)
	where  ProjectKey = @ProjectKey
	and    TransferToKey is not null
	and    WIPPostingInKey >= 0 -- (no reversals where WIPPostingInKey = -99) 

-- determine number of reversals
declare @TimeID int
declare @TimeKey uniqueidentifier
declare @Count int
select @TimeID = -1
while (1=1)
begin
	select @TimeID = min(TimeID)
	from   #time
	where  TimeID > @TimeID
	and    TransferCount = 0
    and    ProjectKey = @ProjectKey

	if @TimeID is null
		break
		
	select @TimeKey = TimeKey
	from #time where TimeID = @TimeID
	
	select @Count = count(*) from tTime (nolock) where TransferFromKey = @TimeKey
	
	if @Count = 0
		select @Count = -1
		
	update #time set TransferCount = @Count where TimeID = @TimeID 		 
	
end

-- delete where TransferCount is OK
delete #time where TransferCount <=2

--select * from #time
--return 1

-- now we are left with TransferCount > 2
declare @TransferToKey uniqueidentifier
declare @CurProjectKey int

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
		  ,@CurProjectKey = ProjectKey
	from  #time	 
	where TimeID = @TimeID
	
	if @TimeKey is not null
	begin
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

		-- delete the new ones that we created
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
		 

		   
	end	    
end




	RETURN 1
GO
