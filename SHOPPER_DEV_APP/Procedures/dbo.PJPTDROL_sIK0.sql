USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_sIK0]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJPTDROL_sIK0]
as
select * from PJPTDROL
where project = 'Z'
and acct = 'Z'
GO
