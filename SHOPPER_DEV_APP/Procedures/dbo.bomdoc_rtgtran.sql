USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[bomdoc_rtgtran]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[bomdoc_rtgtran] @RefNbr VarChar(10) As
     Select Top 1 * from rtgtran (NoLock)
         Where RefNbr = @RefNbr
GO
