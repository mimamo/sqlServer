USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AsmPlan_PlanId]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AsmPlan_PlanId    Script Date: 4/17/98 10:58:16 AM ******/
/****** Object:  Stored Procedure dbo.AsmPlan_PlanId    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc  [dbo].[AsmPlan_PlanId] @parm1 varchar ( 6) as
       Select * from AsmPlan
           where PlanId  LIKE  @parm1
           order by PlanId
GO
