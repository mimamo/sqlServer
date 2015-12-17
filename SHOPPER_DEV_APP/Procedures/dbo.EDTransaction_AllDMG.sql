USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDTransaction_AllDMG]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDTransaction_All    Script Date: 5/28/99 1:17:46 PM ******/
CREATE Proc [dbo].[EDTransaction_AllDMG] @Parm1 varchar(3), @Parm2 varchar(1) As Select * From EDTransaction
Where Trans Like @Parm1 And Direction Like @Parm2 Order By Trans, Direction
GO
