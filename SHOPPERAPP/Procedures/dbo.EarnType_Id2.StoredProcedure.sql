USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EarnType_Id2]    Script Date: 12/21/2015 16:13:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnType_Id2] @parm1 varchar ( 10) as
       Select * from EarnType
           where Id  LIKE  @parm1
             and ETType = 'G'
           order by Id
GO
