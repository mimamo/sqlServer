USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_sIK0]    Script Date: 12/21/2015 15:37:02 ******/
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
