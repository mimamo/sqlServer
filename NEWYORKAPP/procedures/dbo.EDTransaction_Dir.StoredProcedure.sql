USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDTransaction_Dir]    Script Date: 12/21/2015 16:01:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDTransaction_Dir] @Parm1 varchar(1), @Parm2 varchar(3) As Select *
From EDTransaction Where Direction = @Parm1 And Trans Like @Parm2
Order By Trans
GO
