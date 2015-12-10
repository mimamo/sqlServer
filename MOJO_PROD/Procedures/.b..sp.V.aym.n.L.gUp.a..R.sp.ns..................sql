USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVPaymentLogUpdateResponse]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sptVPaymentLogUpdateResponse]
	@VPaymentLogKey uniqueidentifier,
	@Response varchar(max)
AS

/*
|| When      Who Rel      What
|| 11/3/14   CRG 10.5.8.6 Created
*/

	UPDATE	tVPaymentLog
	SET		Response = @Response
	WHERE	VPaymentLogKey = @VPaymentLogKey
GO
