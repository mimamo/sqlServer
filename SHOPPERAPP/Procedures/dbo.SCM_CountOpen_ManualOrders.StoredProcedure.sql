USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_CountOpen_ManualOrders]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[SCM_CountOpen_ManualOrders]
	@CpnyID		VARCHAR(10)
AS
	SELECT COUNT(DISTINCT ordnbr)
		FROM soheader JOIN sotype ON (soheader.sotypeid=sotype.sotypeid)
		WHERE soheader.status = 'O'
		and sotype.behavior = 'MO'
		and soheader.cpnyid = @CpnyId
GO
