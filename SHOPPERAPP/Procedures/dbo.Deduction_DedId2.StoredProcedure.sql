USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_DedId2]    Script Date: 12/21/2015 16:13:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Deduction_DedId2] @parm1 varchar ( 4), @parm2 varchar ( 10) as
       Select * from Deduction
           where CalYr = @parm1
             and DedId like @parm2
           order by DedId
GO
