USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BenEarnType_BenId_EarnTypeId]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenEarnType_BenId_EarnTypeId] @parm1 varchar ( 10), @parm2 varchar ( 10) as
       Select * from BenEarnType
           where BenId       LIKE  @parm1
             and EarnTypeId  LIKE  @parm2
           order by BenId,
                    EarnTypeId
GO
