USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkContPrint_ToPrintForAccessNbr]    Script Date: 12/21/2015 15:42:54 ******/
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
