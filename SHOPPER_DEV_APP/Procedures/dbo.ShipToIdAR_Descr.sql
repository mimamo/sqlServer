USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ShipToIdAR_Descr]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ShipToIdAR_Descr] @parm1 varchar (10), @parm2 varchar (15) as
    Select Descr from SOAddress where ShipToID = @parm1 and custid = @parm2 order by ShipToId
GO
