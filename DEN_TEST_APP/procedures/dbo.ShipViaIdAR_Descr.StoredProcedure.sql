USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ShipViaIdAR_Descr]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ShipViaIdAR_Descr] @parm1 varchar ( 15) as
    Select Descr from ShipVia where ShipviaID = @parm1 order by ShipviaID
GO
