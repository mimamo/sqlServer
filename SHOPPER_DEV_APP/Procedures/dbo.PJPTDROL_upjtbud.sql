USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_upjtbud]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_upjtbud] @parm1 varchar (16)   as
Update PJPTDROL
SET total_budget_amount = 0,
total_budget_units = 0
WHERE
project = @parm1
GO
