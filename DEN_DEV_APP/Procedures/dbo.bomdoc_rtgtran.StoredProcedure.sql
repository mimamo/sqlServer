USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[bomdoc_rtgtran]    Script Date: 12/21/2015 14:05:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[bomdoc_rtgtran] @RefNbr VarChar(10) As
     Select Top 1 * from rtgtran (NoLock)
         Where RefNbr = @RefNbr
GO
