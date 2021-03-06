USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerDelete]
	@RetainerKey int,
	@UserKey int,
	@CompanyKey int

AS -- Encrypt

 /*
  || When     Who Rel       What
  || 12/22/10 GHL 10.5.3.9  (97815) Checking now invoices and billing worksheets
  || 11/06/12 GHL 10.5.6.2  Added deletion of forecast detail
  || 01/21/13 MAS 10564 Added logging
 */
 
	DECLARE @Title as varchar(200)
	DECLARE @Date smalldatetime
  
	SELECT @Date = GETUTCDATE()	

	SELECT @Title = Title	
	FROM   tRetainer (nolock)
	WHERE  RetainerKey = @RetainerKey
	
	IF EXISTS (SELECT 1 FROM tProject (NOLOCK) WHERE RetainerKey = @RetainerKey)
		RETURN -1
	IF EXISTS (SELECT 1 FROM tBilling (NOLOCK) WHERE Entity like 'Retainer%' and EntityKey = @RetainerKey)
		RETURN -1
	IF EXISTS (SELECT 1 FROM tInvoiceLine (NOLOCK) WHERE RetainerKey = @RetainerKey)
		RETURN -1

	DELETE tForecastDetail
	WHERE  Entity = 'tRetainer'
	AND    EntityKey = @RetainerKey

	DELETE
	FROM tRetainerItems
	WHERE
		RetainerKey = @RetainerKey 
		
	DELETE
	FROM tRetainer
	WHERE
		RetainerKey = @RetainerKey 

	EXEC sptActionLogInsert 'Retainer',0, @CompanyKey, 0, 'Deleted', @Date, NULL, 'Retainer deleted', @Title, NULL, @UserKey  

	RETURN 1
GO
