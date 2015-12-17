USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_CustShipSettings]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Header_CustShipSettings] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select B.MultiDestMeth, B.SepDestOrd From ED850Header A Inner Join CustomerEDI B On A.CustId =
B.CustId Where A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID
GO
