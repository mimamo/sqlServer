USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_CountOpen_ManualOrders]    Script Date: 12/16/2015 15:55:32 ******/
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
