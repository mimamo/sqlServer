USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BenClass_ClassId]    Script Date: 12/21/2015 15:36:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenClass_ClassId] @parm1 varchar ( 10) as
       Select * from BenClass
           where ClassId LIKE @parm1
           order by ClassId
GO
