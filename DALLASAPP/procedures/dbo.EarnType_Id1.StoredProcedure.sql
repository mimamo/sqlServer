USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EarnType_Id1]    Script Date: 12/21/2015 13:44:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnType_Id1] @parm1 varchar ( 10) as
       Select * from EarnType
           where Id  LIKE  @parm1
             and ETType <> 'G'
           order by Id
GO
