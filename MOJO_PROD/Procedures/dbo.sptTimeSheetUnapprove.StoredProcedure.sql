USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetUnapprove]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[sptTimeSheetUnapprove]

	(
		@TimeSheetKey int
	)

AS --Encrypt

	if exists (select 1 from tTime t (nolock) Where TimeSheetKey = @TimeSheetKey and (InvoiceLineKey is not null OR WIPPostingInKey > 0 OR WIPPostingOutKey > 0))
		return -1
		
	Update tTimeSheet
	Set Status = 1, DateApproved = NULL, DateSubmitted = NULL, ApprovedByKey = NULL
	Where TimeSheetKey = @TimeSheetKey
GO
