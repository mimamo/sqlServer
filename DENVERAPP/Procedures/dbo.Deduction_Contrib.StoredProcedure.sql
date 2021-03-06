USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_Contrib]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Deduction_Contrib] @parm1 varchar ( 4), @parm2 varchar ( 10), @parm3 varchar ( 10) as
       Select * from Deduction
           where CalYr     = @parm1
             and DedId     <> @parm2
             and DedId     like @parm3
             and EmpleeDed = 0
             and DedType   in ('C','F','I','R','S','T','V')
           order by DedId, CalYr
GO
