USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaOrderUpdateMultiple]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaOrderUpdateMultiple]
	(
	@CompanyKey int,
	@UserKey int,
	@MediaWorksheetKey int,
	@Print int = 1 -- this is a print operation vs emailing
	)
	
AS
	SET NOCOUNT ON

/*
  || When     Who Rel      What
  || 06/02/14 GHL 10.5.8.0 Created to handle logging regquirements and media order revision
  ||                       during printing
  || 06/03/14 GHL 10.5.8.0 Added 1 sec to Printed message, so that it will be at the top on the report
  || 06/24/14 GHL 10.5.8.1 Storing now POKey in NewInt when adding a PO to a MO (used in printing)
  || 08/15/14 GHL 10.5.8.3 Do not process if the buy is cancelled
  || 10/16/14 GHL 10.5.8.4 Added Print parameter, so that we do not do any logging now when emailing 
*/
	-- this is executed anytime we print
	-- The rev # on the Media Order needs to be updated if any change of the buys has been made

	/* Done and populated in VB
	create table #po (PurchaseOrderKey int null)
	*/

	create table #poinfo (
		PurchaseOrderKey int null
		,InternalID int null
		,MediaOrderKey int null
		,CompanyMediaKey int null -- used for groupings
		,CreateMediaOrder int null
		,AppendToMediaOrderKey int null

	)

	insert #poinfo (PurchaseOrderKey, InternalID, MediaOrderKey, CompanyMediaKey)
	select #po.PurchaseOrderKey, po.InternalID
		, isnull(po.MediaOrderKey,0), isnull(po.CompanyMediaKey,0)
	from   #po
	inner join tPurchaseOrder po (nolock) on #po.PurchaseOrderKey = po.PurchaseOrderKey
	where po.Status = 4
	and   isnull(po.Cancelled, 0) = 0

	declare @TranType varchar(50)
	declare @OrderNumber varchar(30)
	declare @RetVal int
	declare @InternalID int
	declare @Action varchar(200)
	declare @Comments varchar(200)
	declare @ErrTranNo int

	declare @OneBuyPerOrder int
	declare @DoNotAppendNewBuys int
	declare @MediaOrderKey int
	declare @MediaOrderRevision int
	declare @MediaOrderRevisionDate datetime
	declare @CompanyMediaKey int
	declare @PurchaseOrderKey int

	SELECT @TranType = CASE POKind WHEN 1 THEN 'IO' WHEN 2 THEN 'BC' WHEN 4 THEN 'INT' ELSE 'IO' END
		  ,@OneBuyPerOrder = isnull(OneBuyPerOrder, 0)
		  ,@DoNotAppendNewBuys = isnull(DoNotAppendNewBuys, 0)
	FROM tMediaWorksheet (nolock)
	WHERE MediaWorksheetKey = @MediaWorksheetKey

	select @ErrTranNo = 0

	if @OneBuyPerOrder = 1 
	begin
		-- first process the PO/Buys without media order
		select @PurchaseOrderKey = -1
			
		while (1=1)
		begin
			select @PurchaseOrderKey = min(PurchaseOrderKey)
			from   #poinfo 
			where  PurchaseOrderKey > @PurchaseOrderKey
			and    MediaOrderKey = 0

			if @PurchaseOrderKey is null
				break

			select @InternalID = isnull(InternalID, 0) from  #poinfo 
			where  PurchaseOrderKey = @PurchaseOrderKey

			EXEC spGetNextTranNo @CompanyKey, @TranType, @RetVal OUTPUT, @OrderNumber OUTPUT
			select @OrderNumber = RTRIM(LTRIM(@OrderNumber))

			-- if we do not get an order number, we need to report an error
			if @RetVal <> 1
			begin
				select @ErrTranNo = 1
				-- next PO in the loop
				continue
			end

			-- the date should be the same on the media order and the log records
			select @MediaOrderRevisionDate = getutcdate()

			INSERT tMediaOrder(MediaWorksheetKey,OrderNumber,Revision, RevisionDate)
			VALUES (@MediaWorksheetKey,@OrderNumber, 0, @MediaOrderRevisionDate)
				
			SELECT @MediaOrderKey = SCOPE_IDENTITY()
				
			select @Action = 'Order Created'
			select @Comments = 'Order ' + cast(@OrderNumber as varchar(200)) + ' was created'
			INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action, ActionDate, Revision, UserKey, Comments)
			values (@CompanyKey, 'tMediaOrder', @MediaOrderKey, @Action, @MediaOrderRevisionDate, 0, @UserKey, @Comments)
				
			UPDATE tPurchaseOrder
			SET	   MediaOrderKey = @MediaOrderKey,PurchaseOrderNumber = @OrderNumber
			WHERE  PurchaseOrderKey = @PurchaseOrderKey

			-- here, store @PurchaseOrderKey in NewInt, we will need it later for the printout 
			select @Action = 'Buy Line Added'
			select @Comments = 'Buy Line ID ' + cast(@InternalID as varchar(200)) + ' was added'
			INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action, ActionDate, Revision, UserKey, NewInt, Comments)
			values (@CompanyKey, 'tMediaOrder', @MediaOrderKey, @Action, @MediaOrderRevisionDate, 0, @UserKey,@PurchaseOrderKey, @Comments)

			update #poinfo
			set    MediaOrderKey = @MediaOrderKey
			      ,CreateMediaOrder = 1
			where PurchaseOrderKey = @PurchaseOrderKey

		end -- po loop

		-- next process the PO/Buys with a media order
		-- here the only thing to do is to increase the Rev # if the Buy has changed
		select @MediaOrderKey = -1
		
		while (1=1)
		begin
			select @MediaOrderKey = min(MediaOrderKey)
			from   #poinfo 
			where  MediaOrderKey > @MediaOrderKey
			and    MediaOrderKey > 0
			and    isnull(CreateMediaOrder, 0) = 0

			if @MediaOrderKey is null
				break

			select @MediaOrderRevision = Revision
				, @MediaOrderRevisionDate = RevisionDate 
				,@OrderNumber = OrderNumber
			from tMediaOrder (nolock) where MediaOrderKey = @MediaOrderKey

			if exists (select 1 from tMediaBuyRevisionHistory (nolock)
						where Entity = 'tMediaOrder' and EntityKey = @MediaOrderKey -- for that media order 
						and ActionDate > @MediaOrderRevisionDate
						and Action like 'Buy Line%' -- must be an action which is buy line related
						)
				begin
					select @MediaOrderRevision = isnull(@MediaOrderRevision, 0) + 1
					update tMediaOrder 
						set Revision = @MediaOrderRevision
						   ,RevisionDate = getutcdate()
					where MediaOrderKey = @MediaOrderKey
				end

		end -- media order loop

	end -- 1 buy per order case
 	 
	 /* Now group by Pub  or CompanyMediaKey
	 New Media Orders are displayed <MO>

	 Do not Append New Buys
	 or @DoNotAppendNewBuys =1

	 PO     CM      MO
	 ------------------
	 PO1    CM1		MO1
     PO2    CM1		MO2
	 PO3    CM1     <MO3>
	 PO4    CM2     <MO4>
	 PO5    CM2     <MO4>

	 Append New Buys
	 or @DoNotAppendNewBuys = 0

	 PO     CM      MO
	 ------------------
	 PO1    CM1		MO1
     PO2    CM1		MO2
	 PO3    CM1     <MO2>  -- same as PO2
	 PO4    CM2     <MO3>
	 PO5    CM2     <MO3>

	 */

	if @OneBuyPerOrder = 0
	begin
		-- group by Pub or CompanyMediaKey

		if @DoNotAppendNewBuys = 0
		begin 
			-- We can append new buys to the highest PO# or MO key

			update #poinfo
			set    #poinfo.AppendToMediaOrderKey = appendto.MediaOrderKey
			from  (
					select Max(MediaOrderKey) as MediaOrderKey
					       ,CompanyMediaKey
					from  #poinfo
					group by CompanyMediaKey
				  ) as appendto
			where #poinfo.MediaOrderKey = 0
			and   #poinfo.CompanyMediaKey = appendto.CompanyMediaKey

			-- now complete the appending
			update #poinfo
			set    AppendToMediaOrderKey = isnull(AppendToMediaOrderKey, 0)

			select @MediaOrderKey = -1
			while (1=1)
			begin
				select @MediaOrderKey = min(AppendToMediaOrderKey)
				from   #poinfo
				where  AppendToMediaOrderKey > @MediaOrderKey 
				and    AppendToMediaOrderKey > 0
				
				if @MediaOrderKey is null
					break

				select @PurchaseOrderKey = -1
				while (1=1)
				begin
					select @PurchaseOrderKey = min(PurchaseOrderKey)
					from   #poinfo
					where  AppendToMediaOrderKey = @MediaOrderKey
					and    PurchaseOrderKey > @PurchaseOrderKey

					if @PurchaseOrderKey is null
						break

					select @MediaOrderRevision = Revision 
					       ,@OrderNumber = OrderNumber
					from tMediaOrder (nolock) where MediaOrderKey = @MediaOrderKey

					select @InternalID = isnull(InternalID, 0) from #poinfo 
					where  PurchaseOrderKey = @PurchaseOrderKey

					UPDATE tPurchaseOrder
					SET	   MediaOrderKey = @MediaOrderKey,PurchaseOrderNumber = @OrderNumber
					WHERE  PurchaseOrderKey = @PurchaseOrderKey

					select @Action = 'Buy Line Added'
					select @Comments = 'Buy Line ID ' + cast(@InternalID as varchar(200)) + ' was added'
					INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action, ActionDate, Revision, UserKey, NewInt, Comments)
					values (@CompanyKey, 'tMediaOrder', @MediaOrderKey, @Action, getutcdate(), @MediaOrderRevision, @UserKey, @PurchaseOrderKey, @Comments)


					-- and also update our temp table
					update #poinfo
					set    MediaOrderKey = @MediaOrderKey -- this indicates that the PO/buy has been processed
					where  PurchaseOrderKey = @PurchaseOrderKey

				end

				-- we need to increase the Rev #
				update tMediaOrder 
					set Revision = isnull(Revision, 0) + 1
					   ,RevisionDate = getutcdate()
				where MediaOrderKey = @MediaOrderKey

			end

		end -- can append

		-- now continue with the ones we could not append to existing media orders
		-- group them by Pub/CompanyMediaKey

		update #poinfo set MediaOrderKey = isnull(MediaOrderKey, 0)

		select @CompanyMediaKey = -1
		while (1=1)
		begin
			select @CompanyMediaKey = min(CompanyMediaKey)
			from   #poinfo
			where  CompanyMediaKey > @CompanyMediaKey
			and    MediaOrderKey = 0

			if @CompanyMediaKey is null
				break

			EXEC spGetNextTranNo @CompanyKey, @TranType, @RetVal OUTPUT, @OrderNumber OUTPUT
			select @OrderNumber = RTRIM(LTRIM(@OrderNumber))

			-- if we do not get an order number, we need to report an error
			if @RetVal <> 1
			begin
				select @ErrTranNo = 1
				-- next Pub/CompanyMediaKey in the loop
				continue
			end

			-- the date should be the same on the media order and the log records
			select @MediaOrderRevisionDate = getutcdate()

			INSERT tMediaOrder(MediaWorksheetKey,OrderNumber,Revision, RevisionDate)
			VALUES (@MediaWorksheetKey,@OrderNumber, 0, @MediaOrderRevisionDate)
				
			SELECT @MediaOrderKey = SCOPE_IDENTITY()
				
			select @Action = 'Order Created'
			select @Comments = 'Order ' + cast(@OrderNumber as varchar(200)) + ' was created'
			INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action, ActionDate, Revision, UserKey, Comments)
			values (@CompanyKey, 'tMediaOrder', @MediaOrderKey, @Action, @MediaOrderRevisionDate, 0, @UserKey, @Comments)
			
			select @PurchaseOrderKey = -1
				while (1=1)
				begin
					select @PurchaseOrderKey = min(PurchaseOrderKey)
					from   #poinfo
					where  CompanyMediaKey = @CompanyMediaKey
					and    PurchaseOrderKey > @PurchaseOrderKey
					and    MediaOrderKey = 0 -- not proccessed yet

					if @PurchaseOrderKey is null
						break

					select @InternalID = isnull(InternalID, 0) from #poinfo 
					where  PurchaseOrderKey = @PurchaseOrderKey

					UPDATE tPurchaseOrder
					SET	   MediaOrderKey = @MediaOrderKey,PurchaseOrderNumber = @OrderNumber
					WHERE  PurchaseOrderKey = @PurchaseOrderKey

					select @Action = 'Buy Line Added'
					select @Comments = 'Buy Line ID ' + cast(@InternalID as varchar(200)) + ' was added'
					INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action, ActionDate, Revision, UserKey, NewInt, Comments)
					values (@CompanyKey, 'tMediaOrder', @MediaOrderKey, @Action, @MediaOrderRevisionDate, 0, @UserKey, @PurchaseOrderKey, @Comments)


					update #poinfo
					set    MediaOrderKey = @MediaOrderKey -- this indicates that the PO/buy has been processed
					      ,CreateMediaOrder = 1
					where  PurchaseOrderKey = @PurchaseOrderKey

				end -- po loop

		end -- company media loop


		-- now we need to check if some Buys are dirty in the case of media orders not newly created and not appended
		-- if they are dirty, increase the revision
		select @MediaOrderKey = 0
		while (1=1)
		begin
			select @MediaOrderKey = min(MediaOrderKey)
			from   #poinfo
			where  MediaOrderKey > @MediaOrderKey
			and    AppendToMediaOrderKey = 0 -- was not appended
			and    isnull(CreateMediaOrder, 0) = 0 -- was not created

			if @MediaOrderKey is null
				break

			select @MediaOrderRevision = Revision, @MediaOrderRevisionDate = RevisionDate, @OrderNumber = OrderNumber
			from tMediaOrder (nolock) where MediaOrderKey = @MediaOrderKey

			if exists (select 1 from tMediaBuyRevisionHistory (nolock)
						where Entity = 'tMediaOrder' and EntityKey = @MediaOrderKey -- for that media order 
						and ActionDate > @MediaOrderRevisionDate
						and Action like 'Buy Line%' -- must be an action which is buy line related
						)
				begin
					select @MediaOrderRevision = isnull(@MediaOrderRevision, 0) + 1
					update tMediaOrder 
						set Revision = @MediaOrderRevision
						   ,RevisionDate = getutcdate()
					where MediaOrderKey = @MediaOrderKey
				end

		end -- media order loop
		 

	end -- @OneBuyPerOrder = 0

	-- now just log the fact that we printed

	select @MediaOrderRevisionDate = getutcdate()

	if @Print = 1
	begin
		-- just add 1 sec to make sure that this will be the last event
		select @MediaOrderRevisionDate = dateadd(s , 1, @MediaOrderRevisionDate)


		select @MediaOrderKey = 0
		while (1=1)
		begin
			select @MediaOrderKey = min(MediaOrderKey)
			from   #poinfo
			where  MediaOrderKey > @MediaOrderKey
		
			if @MediaOrderKey is null
				break

			select @MediaOrderRevision = Revision, @OrderNumber = OrderNumber
			from tMediaOrder (nolock) where MediaOrderKey = @MediaOrderKey
		
			select @Action = 'Order Printed'
			select @Comments = 'Order ' + cast(@OrderNumber as varchar(200)) + ' was printed'
			INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action, ActionDate, Revision, UserKey, Comments)
			values (@CompanyKey, 'tMediaOrder', @MediaOrderKey, @Action, @MediaOrderRevisionDate, @MediaOrderRevision, @UserKey, @Comments)
		
		end

	end

	if @ErrTranNo = 1
		RETURN -1
	else
		RETURN 1
GO
