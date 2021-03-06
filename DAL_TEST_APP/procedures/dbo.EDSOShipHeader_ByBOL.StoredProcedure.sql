USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_ByBOL]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipHeader_ByBOL] @BOLNbr varchar(20) As
Select B.* From EDShipTicket A Inner Join SOShipHeader B On A.CpnyId = B.CpnyId And A.ShipperId =
B.ShipperId Where A.BOLNbr = @BOLNbr Order By A.CpnyId, A.ShipperId
GO
