USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDFOBPoint_Descr]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDFOBPoint_Descr] @FOBId varchar(15) As
Select Descr From FOBPoint Where FOBID = @FOBID
GO
