USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ShipToIdAR_Descr]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ShipToIdAR_Descr] @parm1 varchar (10), @parm2 varchar (15) as
    Select Descr from SOAddress where ShipToID = @parm1 and custid = @parm2 order by ShipToId
GO
