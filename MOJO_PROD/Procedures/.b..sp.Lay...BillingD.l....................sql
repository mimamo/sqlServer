USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutBillingDelete]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutBillingDelete]
	@LayoutKey int
AS

/*
|| When      Who Rel      What
|| 1/4/10    CRG 10.5.1.6 Created
*/

	DELETE	tLayoutBilling
	WHERE	LayoutKey = @LayoutKey
GO
