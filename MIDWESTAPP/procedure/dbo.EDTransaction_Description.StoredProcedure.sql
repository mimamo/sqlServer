USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDTransaction_Description]    Script Date: 12/21/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDTransaction_Description] @Parm1 varchar(3), @Parm2 varchar(1) As Select Description
From EDTransaction Where Trans = @Parm1 And Direction = @Parm2
GO
