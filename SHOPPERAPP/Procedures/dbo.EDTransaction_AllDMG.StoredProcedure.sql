USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDTransaction_AllDMG]    Script Date: 12/21/2015 16:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDTransaction_All    Script Date: 5/28/99 1:17:46 PM ******/
CREATE Proc [dbo].[EDTransaction_AllDMG] @Parm1 varchar(3), @Parm2 varchar(1) As Select * From EDTransaction
Where Trans Like @Parm1 And Direction Like @Parm2 Order By Trans, Direction
GO
