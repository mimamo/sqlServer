USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetDetailLines]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGetDetailLines]
	(
	@InvoiceKey int
	,@ParentLineKey int
	)
AS
	SET NOCOUNT ON
	
	/*Assume at least
		
		CREATE TABLE #lines (
	     InvoiceLineKey int null
		)
		
	*/
	
	declare @ChildLineKey int
	declare @LineType int
	
	select @ChildLineKey = 0
	
	while (1=1)
	begin
		select @ChildLineKey = min(InvoiceLineKey)
		from   tInvoiceLine (nolock)
		where  InvoiceKey = @InvoiceKey
		and    ParentLineKey = @ParentLineKey
		and    InvoiceLineKey > @ChildLineKey
		
		if @ChildLineKey is null
			break
		
		select @LineType = LineType
		from   tInvoiceLine (nolock)
		where  InvoiceLineKey = @ChildLineKey
	
		-- Summary line, keep going
		if @LineType = 1		
			exec sptInvoiceLineGetDetailLines @InvoiceKey, @ChildLineKey
		
		-- Detail line
		if @LineType = 2
			insert #lines (InvoiceLineKey) values (@ChildLineKey)				
	
	end
	
	RETURN 1
GO
