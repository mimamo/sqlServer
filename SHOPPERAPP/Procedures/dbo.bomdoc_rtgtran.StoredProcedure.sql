USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[bomdoc_rtgtran]    Script Date: 12/21/2015 16:13:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[bomdoc_rtgtran] @RefNbr VarChar(10) As
     Select Top 1 * from rtgtran (NoLock)
         Where RefNbr = @RefNbr
GO
