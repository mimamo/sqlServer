USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceSaveTempPrepayments]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceSaveTempPrepayments]
	(
	@CheckApplKey int
	,@CheckKey int
	,@Amount money
	,@Description varchar(500)
	,@Action varchar(50)
	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/07/10  GHL 10.536  Created for inserts of prepayments in new Client Invoice screen
||                       SP needed because of inserts of Description varchar(500) parameter
*/

	SET NOCOUNT ON

	insert #tCheckAppl(
			CheckApplKey 
            , CheckKey 
            , Amount 
            , Description 
            , Action		-- action to perform on the record, update, remove 
            , UpdateFlag	-- general purpose flag
			)
	values (
			@CheckApplKey 
			,@CheckKey 
			,@Amount 
			,@Description 
			,@Action 
			,0
			)

	RETURN 1
GO
