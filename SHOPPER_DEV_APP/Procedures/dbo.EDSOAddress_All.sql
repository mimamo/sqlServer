USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOAddress_All]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOAddress_All] @Parm1 varchar(15), @Parm2 varchar(10) As Select * From SOAddress Where
CustId = @Parm1 And ShipToId Like @Parm2 Order By CustId, ShipToId
GO
