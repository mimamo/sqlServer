USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_sIK0]    Script Date: 12/21/2015 16:01:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJPTDSUM_sIK0]
as
select * from PJPTDSUM
where project = 'Z'
and pjt_entity = 'Z'
and acct = 'Z'
GO
