USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherUpdateComment]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherUpdateComment]

	(
		@VoucherKey int,
		@ApprovalComments varchar(500)
	)

AS --Encrypt

	Update
		tVoucher
	Set
		ApprovalComments = @ApprovalComments
	Where
		VoucherKey = @VoucherKey
GO
