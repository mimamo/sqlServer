USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_CountEDIPOID]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOHeader_CountEDIPOID] @EDIPOID varchar(10) As
Select Count(*) From SOHeader Where EDIPOID = @EDIPOID And Cancelled = 0
GO
