USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RptCompany_Cleanup]    Script Date: 12/21/2015 14:06:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[RptCompany_Cleanup] @parm1 smallint as
DELETE FROM RptCompany WHERE RI_ID = @parm1
GO
