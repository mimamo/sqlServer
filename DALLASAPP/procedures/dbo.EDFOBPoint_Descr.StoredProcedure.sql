USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDFOBPoint_Descr]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDFOBPoint_Descr] @FOBId varchar(15) As
Select Descr From FOBPoint Where FOBID = @FOBID
GO
