USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABSRT_INIT]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABSRT_INIT] as
select * from PJLABSRT
where
cpnyid		  = 'Z' and
gl_acct            = 'Z' and
gl_subacct         = 'Z'
GO
