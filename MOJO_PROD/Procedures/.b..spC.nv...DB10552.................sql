USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10552]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10552]
	
AS
	

	-- since the voucher UI can handle all PO types, set VoucherType =0 for type 3,4,5
	update tVoucher
	set    VoucherType = 0
	where  VoucherType > 2
GO
