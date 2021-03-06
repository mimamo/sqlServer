USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceSaveTempApplications]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceSaveTempApplications]
	(
	@Entity varchar(25) 
	,@ApplKey int
	,@EntityKey int
	,@Amount money
	,@Description varchar(500)
	,@Action varchar(50)
	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/07/10  GHL 10.536  Created for inserts of prepayments in new Client Invoice screen
||                       SP needed because of inserts of Description varchar(500) parameter
|| 10/08/10  GHL 10.536  Changed name from sptInvoiceSaveTempPrepayments to sptInvoiceSaveTempApplications
||                       because the process is the same for tInvoiceCredit
*/

	SET NOCOUNT ON

	insert #tAppl(
	        Entity
			, ApplKey 
            , EntityKey 
            , Amount 
            , Description 
            , Action		-- action to perform on the record, update, remove 
            , UpdateFlag	-- general purpose flag
			)
	values (
			@Entity
			,@ApplKey 
			,@EntityKey 
			,@Amount 
			,@Description 
			,@Action 
			,0
			)

	RETURN 1
GO
