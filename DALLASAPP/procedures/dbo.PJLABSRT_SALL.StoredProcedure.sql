USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABSRT_SALL]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABSRT_SALL] as
Select * from PJLABSRT
order by  cpnyid, gl_acct, gl_subacct
GO
