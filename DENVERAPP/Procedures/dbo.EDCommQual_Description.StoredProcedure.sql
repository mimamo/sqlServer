USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDCommQual_Description]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCommQual_Description] @Parm1 varchar(2) As Select Description From EDCommQual
Where CommId = @Parm1
GO
