USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherUpdateViewedStatus]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherUpdateViewedStatus]
	@VoucherKey int,
	@ViewedByName varchar(250) = null -- Name of the User or Guest

AS --Encrypt

/*
|| When     Who Rel      What
|| 10/30/14 MAS 10.5.8.5	Created for platinum
*/
	
UPDATE tVoucher 
SET ViewedByName = @ViewedByName,
	DateViewedByVendor = GETDATE() 
WHERE VoucherKey = @VoucherKey
GO
