USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_DedType_DedId]    Script Date: 12/21/2015 16:00:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Deduction_DedType_DedId] @parm1 varchar ( 4), @parm2 varchar ( 1), @parm3 varchar ( 10) as
       Select * from Deduction
           where CalYr = @parm1
             and DedType  LIKE  @parm2
             and DedId    LIKE  @parm3
           order by DedId
GO
