USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBuyUpdateLogUpdateError]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sptBuyUpdateLogUpdateError]
	@BuyUpdateLogKey bigint,
	@UpdateError varchar(max)
AS

/*
|| When      Who Rel      What
|| 3/27/14   CRG 10.5.7.8 Created
*/

	UPDATE	tBuyUpdateLog
	SET		UpdateError = @UpdateError
	WHERE	BuyUpdateLogKey = @BuyUpdateLogKey
GO
