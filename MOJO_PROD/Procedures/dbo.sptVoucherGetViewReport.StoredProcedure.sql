USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetViewReport]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptVoucherGetViewReport]

	(
		@VoucherKey int
	)

AS --Encrypt

	SELECT	* 
	FROM	vVoucherDetail (NOLOCK)
	WHERE	VoucherKey = @VoucherKey
GO
