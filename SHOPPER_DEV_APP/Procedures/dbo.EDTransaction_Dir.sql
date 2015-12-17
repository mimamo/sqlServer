USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDTransaction_Dir]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDTransaction_Dir] @Parm1 varchar(1), @Parm2 varchar(3) As Select *
From EDTransaction Where Direction = @Parm1 And Trans Like @Parm2
Order By Trans
GO
