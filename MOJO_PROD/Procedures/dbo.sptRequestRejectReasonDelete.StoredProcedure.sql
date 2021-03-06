USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestRejectReasonDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestRejectReasonDelete]
	@RequestRejectReasonKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 04/23/15  GHL 10.5.9.1 Creation for Kohls enhancement
*/

if exists(Select 1 from tRequest (NOLOCK) Where RequestRejectReasonKey = @RequestRejectReasonKey)
	return -1

	DELETE
	FROM tRequestRejectReason
	WHERE
		RequestRejectReasonKey = @RequestRejectReasonKey 

	RETURN 1
GO
