USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSTCustomer_ShipToIdDMG]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSTCustomer_ShipToIdDMG] @Parm1 varchar(15), @Parm2 varchar(17) As
Select A.ShipToId From EDSTCustomer A Inner Join SOAddress B On A.CustId = B.CustId And A.ShipToId =
B.ShipToId Where A.CustId = @Parm1 And A.EDIShipToRef = @Parm2
GO
