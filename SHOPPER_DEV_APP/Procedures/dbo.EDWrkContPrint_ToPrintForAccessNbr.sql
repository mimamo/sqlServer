USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkContPrint_ToPrintForAccessNbr]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDWrkContPrint_ToPrintForAccessNbr]
	@AccessNbr Integer
AS
Select CpnyId, ShipperId from EDWrkContPrint
where AccessNbr = @AccessNbr and Selected = 1
order by ShipperId
GO
