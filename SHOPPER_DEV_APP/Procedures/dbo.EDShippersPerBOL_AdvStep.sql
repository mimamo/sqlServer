USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShippersPerBOL_AdvStep]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDShippersPerBOL_AdvStep] @BOLNbr varchar(20) As
Select A.CpnyId, A.ShipperId, A.SOTypeId, A.OrdNbr, A.SiteId, A.AdminHold, A.CreditHold,
  A.CreditChk, A.Status, A.CustId, A.NextFunctionId, A.NextFunctionClass From SOShipHeader A Inner Join EDShipTicket B
  On A.CpnyId = B.CpnyId And A.ShipperId = B.ShipperId Where B.BOLNbr = @BOLNbr
GO
