USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeductContrib_ContribId_Delete]    Script Date: 12/21/2015 13:56:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[DeductContrib_ContribId_Delete] @parm1 varchar (10), @parm2 varchar (4) as
       if NOT exists (select DedId from Deduction where DedId = @parm1 and CalYr <> @parm2 and EmpleeDed = 0 and DedType in ('C','F','I','R','S','T','V'))
           Delete DeductContrib Where ContribId = @parm1
GO
