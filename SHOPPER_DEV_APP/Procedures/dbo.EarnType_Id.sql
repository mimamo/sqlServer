USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnType_Id]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnType_Id] @parm1 varchar ( 10) as
       Select * from EarnType
           where Id  LIKE  @parm1
           order by Id
GO
