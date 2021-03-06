USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWriteOffReasonDelete]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWriteOffReasonDelete]
	@WriteOffReasonKey int

AS --Encrypt

if exists(Select 1 from tTime (NOLOCK) Where WriteOffReasonKey = @WriteOffReasonKey)
	return -1
if exists(Select 1 from tMiscCost (NOLOCK) Where WriteOffReasonKey = @WriteOffReasonKey)
	return -1
if exists(Select 1 from tVoucherDetail (NOLOCK) Where WriteOffReasonKey = @WriteOffReasonKey)
	return -1
if exists(Select 1 from tExpenseReceipt (NOLOCK) Where WriteOffReasonKey = @WriteOffReasonKey)
	return -1

	DELETE
	FROM tWriteOffReason
	WHERE
		WriteOffReasonKey = @WriteOffReasonKey 

	RETURN 1
GO
