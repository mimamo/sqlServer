USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABSRT_SALL]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABSRT_SALL] as
Select * from PJLABSRT
order by  cpnyid, gl_acct, gl_subacct
GO
