USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetChildKeys]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGetChildKeys]
	(
	@InvoiceLineKey int
	)
AS --Encrypt

    /*
    || When     Who Rel     What
    || 10/17/10 GHL 10.537  Creation to help out with layouts and invoice printing
    */

	SET NOCOUNT ON 

	create table #line(InvoiceLineKey int null)

	if isnull(@InvoiceLineKey, 0) = 0
		return 1

	declare @InvoiceKey int
	declare @ChildKey int
	
	select @InvoiceKey = InvoiceKey from tInvoiceLine (nolock) where InvoiceLineKey = @InvoiceLineKey
	 
	select @ChildKey = -1
	while (1=1)
	begin
		select @ChildKey = min(InvoiceLineKey)
		from   tInvoiceLine (nolock)
		where  InvoiceKey = @InvoiceKey 
		and    ParentLineKey = @InvoiceLineKey
		and    InvoiceLineKey > @ChildKey 

		if @ChildKey is null
			break

		insert #line(InvoiceLineKey) values (@ChildKey)

		exec sptInvoiceLineGetChildKeysRecursive @ChildKey
	end

	select * from #line

	RETURN 1
GO
