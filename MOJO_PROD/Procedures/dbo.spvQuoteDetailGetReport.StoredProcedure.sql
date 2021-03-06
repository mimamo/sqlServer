USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvQuoteDetailGetReport]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvQuoteDetailGetReport]

	(
		@CompanyKey int,
		@ProjectKey int = null,
		@QuoteKey int = null,
		@QuoteReplyKey int = null,
		@Status tinyint = null,
		@ReplyVendorKey int = null
	)

AS --Encrypt

Declare @sSQL as nvarchar(4000)

Select @sSQL = 'Select * from vQuoteDetail (NOLOCK) Where CompanyKey = ' + Cast(@CompanyKey as varchar) 

IF NOT @ProjectKey IS NULL
	Select @sSQL = @sSQL + ' and ProjectKey = ' + Cast(@ProjectKey as varchar)
	
IF NOT @QuoteKey IS NULL
	Select @sSQL = @sSQL + ' and QuoteKey = ' + Cast(@QuoteKey as varchar)

IF NOT @QuoteReplyKey IS NULL
	Select @sSQL = @sSQL + ' and QuoteReplyKey = ' + Cast(@QuoteReplyKey as varchar)
	
IF NOT @ReplyVendorKey IS NULL
	Select @sSQL = @sSQL + ' and ReplyVendorKey = ' + Cast(@ReplyVendorKey as varchar)
	
IF NOT @Status IS NULL
	Select @sSQL = @sSQL + ' and QuoteStatus = ' + Cast(@Status as varchar)
	
	Select @sSQL = @sSQL + ' Order By QuoteKey, QuoteReplyKey, LineNumber'
	
exec sp_executesql @sSQL
	
Return 1
GO
