USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherUpdateCCData]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptVoucherUpdateCCData]
	@VoucherKey int,
	@CCNumber varchar(50),
	@CCExpMonth tinyint,
	@CCExpYear int,
	@CCV varchar(50),
	@PreAuthCCExpDate smalldatetime = NULL,
	@VCardID varchar(250) = NULL
AS

/*
|| When      Who Rel      What
|| 10/15/14  CRG 10.5.8.5 Created
|| 03/11/15  CRG 10.5.9.0 Added @PreAuthCCExpDate
|| 03/30/15  CRG 10.5.9.0 Added @VCardID
*/

	UPDATE	tVoucher
	SET		CCNumber = @CCNumber,
			CCExpMonth = @CCExpMonth,
			CCExpYear = @CCExpYear,
			CCV = @CCV,
			PreAuthCCExpDate = @PreAuthCCExpDate,
			VCardID = @VCardID
	WHERE	VoucherKey = @VoucherKey
GO
