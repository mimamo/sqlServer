USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AsmPlanDet_PlanId_InvtId]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AsmPlanDet_PlanId_InvtId    Script Date: 4/17/98 10:58:16 AM ******/
/****** Object:  Stored Procedure dbo.AsmPlanDet_PlanId_InvtId    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc  [dbo].[AsmPlanDet_PlanId_InvtId] @parm1 varchar ( 6), @parm2 varchar ( 30) as
       Select * from AsmPlanDet
           where PlanId  =     @parm1
             and InvtId  LIKE  @parm2
           order by PlanId,
                    InvtId
GO
