USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_DedId3]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Deduction_DedId3] @parm1 varchar ( 4), @parm2 varchar ( 10) as
       Select * from Deduction
           where CalYr = @parm1
             and Union_Cd = ''
             and DedId like @parm2
           order by DedId
GO
