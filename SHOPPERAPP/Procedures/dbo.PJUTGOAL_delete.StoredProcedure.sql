USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJUTGOAL_delete]    Script Date: 12/21/2015 16:13:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJUTGOAL_delete] @parm1 varchar (06)  as
Delete from PJUTGOAL
where fiscalno <= @parm1
GO
