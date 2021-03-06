USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceOrder]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceOrder]
(
	@InvoiceKey int,
	@ParentLineKey int = 0,
	@CurrentOrder int = 0,
	@LineLevel int = 0
)

AS --Encrypt

Declare @CurrentLineKey int
Declare @ChildCount int
Declare @CurrentTreeOrder int
Declare @ChildLineLevel int

Select @CurrentLineKey = -1
Select @CurrentTreeOrder = 0
Select @ChildLineLevel = @LineLevel + 1

while 1 = 1
BEGIN

		Select @CurrentTreeOrder = @CurrentTreeOrder + 1
		Select @CurrentLineKey = MIN(InvoiceLineKey)
			from tInvoiceLine t (nolock) 
			Where t.InvoiceKey = @InvoiceKey and 
				t.ParentLineKey = @ParentLineKey and 
				t.DisplayOrder = @CurrentTreeOrder

		if @CurrentLineKey is null
		BEGIN
			Break
		END
		Else
		BEGIN

			
			Select @CurrentOrder = @CurrentOrder + 1

			Update tInvoiceLine Set InvoiceOrder = @CurrentOrder, LineLevel = @LineLevel Where InvoiceLineKey = @CurrentLineKey

			Select @ChildCount = Count(*) from tInvoiceLine t1 (nolock) Where t1.ParentLineKey = @CurrentLineKey
			if @ChildCount > 0
			BEGIN
				Exec @CurrentOrder = sptInvoiceOrder @InvoiceKey, @CurrentLineKey, @CurrentOrder, @ChildLineLevel
			END
		END
END

Return @CurrentOrder
GO
