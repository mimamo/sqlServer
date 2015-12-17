USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOHeader_CustID_Open2]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[SOHeader_CustID_Open2] @parm1 varchar ( 15), @parm2 varchar ( 10) as
          Select * from SOHeader where custid = @parm1
          and CpnyId = @parm2
          and Status = "O"
          and UnshippedBalance > 0
          order by Ordnbr
GO
