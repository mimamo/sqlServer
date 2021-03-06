USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BenEarnType_BenId_EarnTypeId_]    Script Date: 12/21/2015 14:05:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenEarnType_BenId_EarnTypeId_] @parm1 varchar ( 10), @parm2 varchar ( 10) as
       Select *
			from BenEarnType
				left outer join EarnType
					on BenEarnType.EarnTypeId = EarnType.Id
			where BenEarnType.BenId       =     @parm1
				and BenEarnType.EarnTypeId  LIKE  @parm2
			order by BenEarnType.BenId,
                BenEarnType.EarnTypeId
GO
